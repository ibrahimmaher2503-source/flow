import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';
import 'transaction_provider.dart';
import 'budget_provider.dart';
import 'goal_provider.dart';
import 'installment_provider.dart';
import 'settings_provider.dart';

/// Finance Score (0-100) based on spec:
///   budget_adherence * 0.25
///   savings_rate * 0.25
///   logging_streak * 0.20
///   goal_progress * 0.15
///   debt_reduction * 0.15
final financeScoreProvider = FutureProvider<int>((ref) async {
  // Budget adherence (0-1): average of (1 - spent/limit) across active budgets
  final budgets = await ref.watch(activeBudgetsProvider.future);
  double budgetScore = 1.0;
  if (budgets.isNotEmpty) {
    double totalAdherence = 0;
    for (final b in budgets) {
      final usage = await ref.watch(budgetUsageProvider(b.categoryName).future);
      final ratio = b.limitAmount > 0 ? (usage / b.limitAmount).clamp(0.0, 2.0) : 0.0;
      totalAdherence += (1.0 - ratio).clamp(0.0, 1.0);
    }
    budgetScore = totalAdherence / budgets.length;
  }

  // Savings rate (0-1): income > 0 ? (income - expense) / income : 0
  final income = await ref.watch(monthlyIncomeProvider.future);
  final expense = await ref.watch(monthlyExpenseProvider.future);
  double savingsRate = 0;
  if (income > 0) {
    savingsRate = ((income - expense) / income).clamp(0.0, 1.0);
  }

  // Logging streak (0-1): streakDays / 30 capped at 1
  final settings = await ref.watch(appSettingsProvider.future);
  final streakScore = (settings.streakDays / 30).clamp(0.0, 1.0);

  // Goal progress (0-1): average progress across active goals
  final goals = await ref.watch(activeGoalsProvider.future);
  double goalScore = 0;
  if (goals.isNotEmpty) {
    double totalProgress = 0;
    for (final g in goals) {
      totalProgress += g.targetAmount > 0
          ? (g.currentAmount / g.targetAmount).clamp(0.0, 1.0)
          : 0;
    }
    goalScore = totalProgress / goals.length;
  }

  // Debt reduction (0-1): 1 - (remaining / total) across all plans
  final activePlans = await ref.watch(activePlansProvider.future);
  double debtScore = 1.0;
  if (activePlans.isNotEmpty) {
    double totalOriginal = 0;
    double totalRemaining = 0;
    for (final p in activePlans) {
      totalOriginal += p.totalWithInterest;
      totalRemaining += p.remainingAmount;
    }
    if (totalOriginal > 0) {
      debtScore = (1.0 - totalRemaining / totalOriginal).clamp(0.0, 1.0);
    }
  }

  final score = (budgetScore * 0.25 +
          savingsRate * 0.25 +
          streakScore * 0.20 +
          goalScore * 0.15 +
          debtScore * 0.15) *
      100;

  return score.round();
});

/// Badge definitions
class Badge {
  final String id;
  final String name;
  final String icon;
  final bool Function(BadgeContext) check;

  const Badge({
    required this.id,
    required this.name,
    required this.icon,
    required this.check,
  });
}

class BadgeContext {
  final int transactionCount;
  final int streakDays;
  final int completedGoals;
  final int completedPlans;
  final bool fullMonthBudget;
  final int monthsNoNewInstallments;

  const BadgeContext({
    required this.transactionCount,
    required this.streakDays,
    required this.completedGoals,
    required this.completedPlans,
    required this.fullMonthBudget,
    required this.monthsNoNewInstallments,
  });
}

final badges = [
  Badge(
    id: 'first_transaction',
    name: 'أول معاملة',
    icon: '🎯',
    check: (ctx) => ctx.transactionCount >= 1,
  ),
  Badge(
    id: 'streak_7',
    name: '7 أيام streak',
    icon: '🔥',
    check: (ctx) => ctx.streakDays >= 7,
  ),
  Badge(
    id: 'streak_30',
    name: '30 يوم streak',
    icon: '💪',
    check: (ctx) => ctx.streakDays >= 30,
  ),
  Badge(
    id: 'first_goal',
    name: 'أول هدف اكتمل',
    icon: '⭐',
    check: (ctx) => ctx.completedGoals >= 1,
  ),
  Badge(
    id: 'budget_month',
    name: 'ملتزم بالميزانية شهر',
    icon: '🏆',
    check: (ctx) => ctx.fullMonthBudget,
  ),
  Badge(
    id: 'first_plan_done',
    name: 'خلصت أول خطة أقساط',
    icon: '🎉',
    check: (ctx) => ctx.completedPlans >= 1,
  ),
  Badge(
    id: 'no_new_installments',
    name: 'مفيش أقساط جديدة 3 شهور',
    icon: '🛡️',
    check: (ctx) => ctx.monthsNoNewInstallments >= 3,
  ),
];

final earnedBadgesProvider = FutureProvider<List<Badge>>((ref) async {
  final settings = await ref.watch(appSettingsProvider.future);
  final transactions = await ref.watch(monthlyTransactionsProvider.future);
  final goals = await ref.watch(activeGoalsProvider.future);
  final completedPlans = await ref.watch(completedPlansProvider.future);

  final completedGoals = goals.where((g) => g.isCompleted).length;

  final ctx = BadgeContext(
    transactionCount: transactions.length,
    streakDays: settings.streakDays,
    completedGoals: completedGoals,
    completedPlans: completedPlans.length,
    fullMonthBudget: false, // simplified — would need full month check
    monthsNoNewInstallments: 0, // simplified — would need plan creation date check
  );

  return badges.where((b) => b.check(ctx)).toList();
});
