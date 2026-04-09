import 'package:isar/isar.dart';
import '../models/transaction_model.dart';
import '../models/wallet_model.dart';
import '../models/installment_plan_model.dart';
import '../models/recurring_transaction_model.dart';
import '../models/smart_feature_models.dart';

/// Service for generating cash flow forecasts
class ForecastService {
  final Isar isar;

  ForecastService(this.isar);

  /// Generate 30-day cash flow forecast
  Future<ForecastData> generateForecast({int days = 30}) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Get current total balance
    final wallets = await isar.wallets.where().findAll();
    final currentBalance =
        wallets.fold<double>(0, (sum, w) => sum + w.balance);

    // Calculate historical spending patterns
    final spendingStats = await _calculateSpendingStats();

    // Get upcoming obligations
    final upcomingInstallments = await _getUpcomingInstallments(days);
    final upcomingRecurring = await _getUpcomingRecurring(days);

    // Generate daily projections
    final forecastDays = <ForecastDay>[];
    double optimisticBalance = currentBalance;
    double realisticBalance = currentBalance;
    double pessimisticBalance = currentBalance;

    final warnings = <ForecastWarning>[];
    int safetyDays = days;
    ForecastEvent? nextObligation;

    for (int i = 0; i < days; i++) {
      final date = today.add(Duration(days: i));
      final dayEvents = <ForecastEvent>[];

      // Add installments due on this day
      for (final inst in upcomingInstallments) {
        if (_isDueOnDay(inst, date)) {
          final event = ForecastEvent(
            name: inst.itemName,
            amount: inst.monthlyAmount,
            type: ForecastEventType.installment,
          );
          dayEvents.add(event);

          // Track next obligation
          if (nextObligation == null && i > 0) {
            nextObligation = event;
          }

          // Deduct from all scenarios
          optimisticBalance -= inst.monthlyAmount;
          realisticBalance -= inst.monthlyAmount;
          pessimisticBalance -= inst.monthlyAmount;
        }
      }

      // Add recurring transactions due on this day
      for (final rec in upcomingRecurring) {
        if (_isRecurringDueOnDay(rec, date, today)) {
          final isExpense = rec.type == 'expense';
          final event = ForecastEvent(
            name: rec.name,
            amount: rec.amount,
            type: isExpense ? ForecastEventType.bill : ForecastEventType.income,
          );
          dayEvents.add(event);

          // Track next obligation
          if (nextObligation == null && i > 0 && isExpense) {
            nextObligation = event;
          }

          if (isExpense) {
            optimisticBalance -= rec.amount;
            realisticBalance -= rec.amount;
            pessimisticBalance -= rec.amount;
          } else {
            optimisticBalance += rec.amount;
            realisticBalance += rec.amount;
            pessimisticBalance += rec.amount;
          }
        }
      }

      // Apply daily spending projections (skip today)
      if (i > 0) {
        optimisticBalance -= spendingStats.dailyOptimistic;
        realisticBalance -= spendingStats.dailyRealistic;
        pessimisticBalance -= spendingStats.dailyPessimistic;
      }

      // Track warnings for negative balances
      if (pessimisticBalance < 0 && safetyDays == days) {
        safetyDays = i;
        warnings.add(ForecastWarning(
          date: date,
          messageAr: 'قد يصل رصيدك للسالب في ${_formatDateAr(date)} (أسوأ سيناريو)',
          scenario: ForecastScenario.pessimistic,
        ));
      }

      if (realisticBalance < 0 && !warnings.any((w) => w.scenario == ForecastScenario.realistic)) {
        warnings.add(ForecastWarning(
          date: date,
          messageAr: 'قد يصل رصيدك للسالب في ${_formatDateAr(date)} (السيناريو المتوقع)',
          scenario: ForecastScenario.realistic,
        ));
      }

      forecastDays.add(ForecastDay(
        date: date,
        optimisticBalance: optimisticBalance,
        realisticBalance: realisticBalance,
        pessimisticBalance: pessimisticBalance,
        events: dayEvents,
      ));
    }

    // Calculate month end balance (realistic scenario)
    final monthEnd = DateTime(now.year, now.month + 1, 0);
    final daysUntilMonthEnd = monthEnd.difference(today).inDays;
    final expectedMonthEndBalance = daysUntilMonthEnd < days
        ? forecastDays[daysUntilMonthEnd].realisticBalance
        : forecastDays.last.realisticBalance;

    return ForecastData(
      days: forecastDays,
      summary: ForecastSummary(
        expectedMonthEndBalance: expectedMonthEndBalance,
        nextObligation: nextObligation,
        safetyDays: safetyDays,
      ),
      assumptions: ForecastAssumptions(
        dailySpendingOptimistic: spendingStats.dailyOptimistic,
        dailySpendingRealistic: spendingStats.dailyRealistic,
        dailySpendingPessimistic: spendingStats.dailyPessimistic,
        includedRecurring: upcomingRecurring.map((r) => r.name).toList(),
        includedInstallments: upcomingInstallments.map((i) => i.itemName).toList(),
      ),
      warnings: warnings,
    );
  }

  /// Calculate daily spending statistics from last 3 months
  Future<_SpendingStats> _calculateSpendingStats() async {
    final now = DateTime.now();
    final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);

    final transactions = await isar.transactions
        .filter()
        .typeEqualTo('expense')
        .dateGreaterThan(threeMonthsAgo)
        .findAll();

    if (transactions.isEmpty) {
      return const _SpendingStats(
        dailyOptimistic: 0,
        dailyRealistic: 0,
        dailyPessimistic: 0,
      );
    }

    // Group by day
    final dailyTotals = <String, double>{};
    for (final t in transactions) {
      final key = '${t.date.year}-${t.date.month}-${t.date.day}';
      dailyTotals[key] = (dailyTotals[key] ?? 0) + t.amount;
    }

    if (dailyTotals.isEmpty) {
      return const _SpendingStats(
        dailyOptimistic: 0,
        dailyRealistic: 0,
        dailyPessimistic: 0,
      );
    }

    final values = dailyTotals.values.toList()..sort();
    final average = values.fold<double>(0, (sum, v) => sum + v) / values.length;

    // Percentiles for scenarios
    final p25Index = (values.length * 0.25).floor().clamp(0, values.length - 1);
    final p75Index = (values.length * 0.75).floor().clamp(0, values.length - 1);

    return _SpendingStats(
      dailyOptimistic: values[p25Index], // 25th percentile (lower spending)
      dailyRealistic: average,
      dailyPessimistic: values[p75Index], // 75th percentile (higher spending)
    );
  }

  /// Get upcoming installment payments
  Future<List<InstallmentPlan>> _getUpcomingInstallments(int days) async {
    final installments = await isar.installmentPlans
        .filter()
        .statusEqualTo('active')
        .findAll();

    return installments;
  }

  /// Get upcoming recurring transactions
  Future<List<RecurringTransaction>> _getUpcomingRecurring(int days) async {
    final recurring = await isar.recurringTransactions
        .filter()
        .isActiveEqualTo(true)
        .findAll();

    return recurring;
  }

  /// Check if installment is due on a specific day
  bool _isDueOnDay(InstallmentPlan installment, DateTime date) {
    return date.day == installment.dayOfMonth;
  }

  /// Check if recurring transaction is due on a specific day
  bool _isRecurringDueOnDay(RecurringTransaction rec, DateTime date, DateTime today) {
    switch (rec.frequency) {
      case 'daily':
        return true;
      case 'weekly':
        return date.weekday == rec.nextDueDate.weekday;
      case 'monthly':
        return date.day == rec.nextDueDate.day;
      case 'yearly':
        return date.day == rec.nextDueDate.day &&
            date.month == rec.nextDueDate.month;
      default:
        return false;
    }
  }

  /// Format date in Arabic
  String _formatDateAr(DateTime date) {
    const days = ['الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    return '${days[date.weekday % 7]} ${date.day} ${months[date.month - 1]}';
  }

  /// Get sparkline data for mini card (7-day summary)
  Future<List<double>> getSparklineData() async {
    final forecast = await generateForecast(days: 7);
    return forecast.days.map((d) => d.realisticBalance).toList();
  }

  /// Check if forecast shows danger (negative balance within 7 days)
  Future<bool> hasDangerWithin7Days() async {
    final forecast = await generateForecast(days: 7);
    return forecast.days.any((d) => d.pessimisticBalance < 0);
  }
}

class _SpendingStats {
  final double dailyOptimistic;
  final double dailyRealistic;
  final double dailyPessimistic;

  const _SpendingStats({
    required this.dailyOptimistic,
    required this.dailyRealistic,
    required this.dailyPessimistic,
  });
}
