import 'package:isar/isar.dart';
import '../models/smart_feature_models.dart';
import '../models/wallet_model.dart';
import '../models/installment_plan_model.dart';
import '../models/recurring_transaction_model.dart';
import '../models/savings_goal_model.dart';
import '../models/transaction_model.dart';
import '../../core/constants/app_constants.dart';

/// Service for calculating Safe-to-Spend amount
class SafeToSpendService {
  final Isar isar;

  SafeToSpendService(this.isar);

  /// Calculate safe-to-spend for the current month
  Future<SafeToSpendData> calculate() async {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    // 1. Get total balance
    final wallets = await isar.wallets.where().findAll();
    final totalBalance = wallets.fold<double>(0, (sum, w) => sum + w.balance);

    // 2. Get upcoming installments this month
    final installments = await _getUpcomingInstallmentsThisMonth();
    final upcomingInstallments =
        installments.fold<double>(0, (sum, item) => sum + item.amount);

    // 3. Get upcoming recurring expenses this month
    final recurring = await _getUpcomingRecurringThisMonth();
    final upcomingRecurring =
        recurring.fold<double>(0, (sum, item) => sum + item.amount);

    // 4. Get unmet goal contributions
    final goals = await _getUnmetGoalContributions();
    final unmetGoalContributions =
        goals.fold<double>(0, (sum, item) => sum + item.amount);

    // 5. Calculate safe amount
    final totalObligations =
        upcomingInstallments + upcomingRecurring + unmetGoalContributions;
    final safeAmount = totalBalance - totalObligations;

    // 6. Calculate percent of balance
    final percentOfBalance =
        totalBalance > 0 ? safeAmount / totalBalance : 0.0;

    // 7. Calculate spending velocity
    final velocity = await _calculateSpendingVelocity(now, daysInMonth);

    // 8. Build breakdown list
    final breakdown = <ObligationItem>[
      ...installments,
      ...recurring,
      ...goals,
    ];
    breakdown.sort((a, b) {
      // Sort by due date, nulls last
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });

    return SafeToSpendData(
      safeAmount: safeAmount,
      totalBalance: totalBalance,
      upcomingInstallments: upcomingInstallments,
      upcomingRecurring: upcomingRecurring,
      unmetGoalContributions: unmetGoalContributions,
      percentOfBalance: percentOfBalance,
      velocity: velocity,
      breakdown: breakdown,
    );
  }

  /// Get upcoming installment payments for this month
  Future<List<ObligationItem>> _getUpcomingInstallmentsThisMonth() async {
    final now = DateTime.now();
    final plans = await isar.installmentPlans
        .where()
        .statusIndexEqualTo(PlanStatus.active)
        .findAll();

    final items = <ObligationItem>[];
    for (final plan in plans) {
      // Check if payment is due this month and not yet paid
      final nextPaymentNumber = plan.paidInstallments + 1;
      if (nextPaymentNumber > plan.totalInstallments) continue;

      final dueDate = DateTime(
        plan.firstPaymentDate.year,
        plan.firstPaymentDate.month + nextPaymentNumber - 1,
        plan.dayOfMonth,
      );

      // Only include if due date is this month and still in the future
      if (dueDate.year == now.year &&
          dueDate.month == now.month &&
          dueDate.day >= now.day) {
        items.add(ObligationItem(
          name: plan.itemName,
          amount: plan.monthlyAmount,
          dueDate: dueDate,
          type: ObligationType.installment,
        ));
      }
    }
    return items;
  }

  /// Get upcoming recurring expense transactions for this month
  Future<List<ObligationItem>> _getUpcomingRecurringThisMonth() async {
    final now = DateTime.now();
    final monthEnd = DateTime(now.year, now.month + 1, 0);

    final recurringList = await isar.recurringTransactions
        .filter()
        .isActiveEqualTo(true)
        .typeEqualTo('expense')
        .findAll();

    final items = <ObligationItem>[];
    for (final rec in recurringList) {
      // Check if next due date is in current month and still upcoming
      if (rec.nextDueDate.isAfter(now.subtract(const Duration(days: 1))) &&
          rec.nextDueDate.isBefore(monthEnd.add(const Duration(days: 1)))) {
        items.add(ObligationItem(
          name: rec.name,
          amount: rec.amount,
          dueDate: rec.nextDueDate,
          type: ObligationType.recurring,
        ));
      }
    }
    return items;
  }

  /// Calculate suggested monthly contribution for goals
  Future<List<ObligationItem>> _getUnmetGoalContributions() async {
    final goals = await isar.savingsGoals
        .filter()
        .isCompletedEqualTo(false)
        .findAll();

    final now = DateTime.now();
    final items = <ObligationItem>[];

    for (final goal in goals) {
      if (goal.deadline == null) continue;

      final remaining = goal.targetAmount - goal.currentAmount;
      if (remaining <= 0) continue;

      // Calculate months until deadline
      final monthsRemaining = _monthsBetween(now, goal.deadline!);
      if (monthsRemaining <= 0) {
        // Goal is overdue
        items.add(ObligationItem(
          name: '${goal.name} (متأخر)',
          amount: remaining,
          dueDate: goal.deadline,
          type: ObligationType.goal,
        ));
      } else {
        // Monthly contribution needed
        final monthlyContribution = remaining / monthsRemaining;
        items.add(ObligationItem(
          name: goal.name,
          amount: monthlyContribution,
          dueDate: null, // Monthly contribution, no specific date
          type: ObligationType.goal,
        ));
      }
    }
    return items;
  }

  /// Calculate spending velocity based on current month's spending rate
  Future<SpendingVelocity> _calculateSpendingVelocity(
      DateTime now, int daysInMonth) async {
    final monthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    final dayOfMonth = now.day;

    // Get expenses for current month
    final expenses = await isar.transactions
        .filter()
        .monthKeyEqualTo(monthKey)
        .typeEqualTo('expense')
        .findAll();

    final currentMonthTotal =
        expenses.fold<double>(0, (sum, t) => sum + t.amount);

    // Daily average for current month so far
    final currentDailyAvg =
        dayOfMonth > 0 ? currentMonthTotal / dayOfMonth : 0.0;

    // Get last 3 months average daily spending
    final historicalDailyAvg = await _getHistoricalDailyAverage(3);

    if (historicalDailyAvg <= 0) {
      return SpendingVelocity.normal; // No historical data
    }

    final ratio = currentDailyAvg / historicalDailyAvg;

    if (ratio < 0.8) {
      return SpendingVelocity.slow;
    } else if (ratio > 1.2) {
      return SpendingVelocity.fast;
    } else {
      return SpendingVelocity.normal;
    }
  }

  /// Get historical daily spending average from past N months
  Future<double> _getHistoricalDailyAverage(int months) async {
    final now = DateTime.now();
    double totalSpent = 0;
    int totalDays = 0;

    for (int i = 1; i <= months; i++) {
      final targetMonth = DateTime(now.year, now.month - i, 1);
      final monthKey =
          '${targetMonth.year}-${targetMonth.month.toString().padLeft(2, '0')}';
      final daysInMonth = DateTime(targetMonth.year, targetMonth.month + 1, 0).day;

      final expenses = await isar.transactions
          .filter()
          .monthKeyEqualTo(monthKey)
          .typeEqualTo('expense')
          .findAll();

      final monthTotal = expenses.fold<double>(0, (sum, t) => sum + t.amount);
      if (monthTotal > 0) {
        totalSpent += monthTotal;
        totalDays += daysInMonth;
      }
    }

    return totalDays > 0 ? totalSpent / totalDays : 0;
  }

  int _monthsBetween(DateTime from, DateTime to) {
    return (to.year - from.year) * 12 + (to.month - from.month);
  }
}
