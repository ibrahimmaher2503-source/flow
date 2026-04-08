import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/transaction_model.dart';
import '../core/utils/report_calculations.dart';
import 'transaction_provider.dart';
import 'budget_provider.dart';
import 'wallet_provider.dart';
import 'installment_provider.dart';

// ============================================================================
// Phase 2: Foundational Providers
// ============================================================================

/// Generate month keys for the last 6 months
final monthKeysProvider = Provider<List<String>>((ref) {
  return generateMonthKeys(6);
});

/// Fetch transactions for last 6 months
final multiMonthTransactionsProvider =
    FutureProvider<List<Transaction>>((ref) async {
  final repo = ref.watch(transactionRepoProvider);
  final monthKeys = ref.watch(monthKeysProvider);
  return repo.getByMonthRange(monthKeys);
});

/// Calculate monthly totals (income/expense) for last 6 months
final monthlyTotalsProvider =
    FutureProvider<Map<String, ({double income, double expense})>>((ref) async {
  final transactions = await ref.watch(multiMonthTransactionsProvider.future);
  return calculateMonthlyTotals(transactions);
});

// ============================================================================
// US1: Spending Trends Providers
// ============================================================================

/// Spending trend data for chart (last 6 months expenses)
final spendingTrendProvider =
    FutureProvider<({List<double> data, List<String> labels})>((ref) async {
  final monthlyTotals = await ref.watch(monthlyTotalsProvider.future);
  final monthKeys = ref.watch(monthKeysProvider);

  final data = calculateSpendingTrend(monthlyTotals, monthKeys);
  final labels = monthKeys.map((k) => monthKeyToArabicLabel(k)).toList();

  return (data: data, labels: labels);
});

/// Current month spending averages
final spendingAveragesProvider =
    FutureProvider<({double daily, double weekly, double monthly})>((ref) async {
  final expense = await ref.watch(monthlyExpenseProvider.future);
  final now = DateTime.now();
  final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

  return (
    daily: calculateDailyAverage(expense, daysInMonth),
    weekly: calculateWeeklyAverage(expense, daysInMonth),
    monthly: expense,
  );
});

/// Category totals for current month (expenses only)
final currentMonthCategoryTotalsProvider =
    FutureProvider<Map<String, double>>((ref) async {
  final transactions = await ref.watch(monthlyTransactionsProvider.future);
  return calculateCategoryTotals(transactions, type: 'expense');
});

/// Category totals for previous month (expenses only)
final previousMonthCategoryTotalsProvider =
    FutureProvider<Map<String, double>>((ref) async {
  final repo = ref.watch(transactionRepoProvider);
  final now = DateTime.now();
  final prevMonth = DateTime(now.year, now.month - 1, 1);
  final transactions =
      await repo.getByMonth(prevMonth.year, prevMonth.month);
  return calculateCategoryTotals(transactions, type: 'expense');
});

/// Category comparison (current vs previous month)
final categoryComparisonProvider = FutureProvider<
    Map<String, ({double current, double previous, double? percentChange})>>(
    (ref) async {
  final current = await ref.watch(currentMonthCategoryTotalsProvider.future);
  final previous = await ref.watch(previousMonthCategoryTotalsProvider.future);
  return calculateCategoryComparison(current, previous);
});

/// Top 5 spending categories
final topCategoriesProvider =
    FutureProvider<List<MapEntry<String, double>>>((ref) async {
  final categoryTotals =
      await ref.watch(currentMonthCategoryTotalsProvider.future);
  return getTopCategories(categoryTotals, 5);
});

// ============================================================================
// US2: Income vs Expense Balance Providers
// ============================================================================

/// Income vs expense summary for current month
final incomeExpenseBalanceProvider = FutureProvider<({
  double income,
  double expense,
  double netBalance,
  double? savingsRate,
  bool isSurplus,
})>((ref) async {
  final income = await ref.watch(monthlyIncomeProvider.future);
  final expense = await ref.watch(monthlyExpenseProvider.future);
  final net = calculateNetBalance(income, expense);
  final savings = calculateSavingsRate(income, expense);

  return (
    income: income,
    expense: expense,
    netBalance: net,
    savingsRate: savings,
    isSurplus: isSurplus(net),
  );
});

// ============================================================================
// US3: Budget Performance Providers
// ============================================================================

/// Budget performance for all active budgets
final budgetPerformanceProvider =
    FutureProvider<List<BudgetPerformance>>((ref) async {
  final budgets = await ref.watch(activeBudgetsProvider.future);
  final categoryTotals =
      await ref.watch(currentMonthCategoryTotalsProvider.future);
  return calculateAllBudgetPerformance(budgets, categoryTotals);
});

/// Count of exceeded budgets
final exceededBudgetsCountProvider = FutureProvider<int>((ref) async {
  final performance = await ref.watch(budgetPerformanceProvider.future);
  return performance.where((p) => p.isExceeded).length;
});

// ============================================================================
// US4: Installment Analytics Providers
// ============================================================================

/// Upcoming payments for next 3 months
final upcomingPaymentsProvider =
    FutureProvider<List<UpcomingPayment>>((ref) async {
  final service = ref.watch(installmentServiceProvider);
  return service.getUpcomingPayments(3);
});

/// Installment summary (monthly commitment, payoff date)
final installmentSummaryProvider = FutureProvider<({
  double monthlyCommitment,
  DateTime? payoffDate,
  int activePlansCount,
})>((ref) async {
  final plans = await ref.watch(activePlansProvider.future);
  final commitment = calculateMonthlyCommitment(plans);
  final payoffDate = calculateProjectedPayoffDate(plans);

  return (
    monthlyCommitment: commitment,
    payoffDate: payoffDate,
    activePlansCount: plans.length,
  );
});

/// Interest analysis
final interestAnalysisProvider =
    FutureProvider<({double totalInterest, double interestPercentage})>(
        (ref) async {
  final activePlans = await ref.watch(activePlansProvider.future);
  final completedPlans = await ref.watch(completedPlansProvider.future);
  final allPlans = [...activePlans, ...completedPlans];
  return calculateInterestAnalysis(allPlans);
});

// ============================================================================
// US5: Wallet Distribution Providers
// ============================================================================

/// Wallet distribution with percentages
final walletDistributionProvider =
    FutureProvider<List<WalletBalance>>((ref) async {
  final wallets = await ref.watch(walletsProvider.future);
  return calculateWalletDistribution(wallets);
});

// ============================================================================
// US6: Source Analysis Providers
// ============================================================================

/// Transaction source breakdown for current month
final sourceBreakdownProvider =
    FutureProvider<List<SourceBreakdown>>((ref) async {
  final transactions = await ref.watch(monthlyTransactionsProvider.future);
  return calculateSourceBreakdown(transactions);
});

// ============================================================================
// Refresh Helper
// ============================================================================

void refreshReports(WidgetRef ref) {
  ref.invalidate(multiMonthTransactionsProvider);
  ref.invalidate(monthlyTotalsProvider);
  ref.invalidate(spendingTrendProvider);
  ref.invalidate(spendingAveragesProvider);
  ref.invalidate(currentMonthCategoryTotalsProvider);
  ref.invalidate(previousMonthCategoryTotalsProvider);
  ref.invalidate(categoryComparisonProvider);
  ref.invalidate(topCategoriesProvider);
  ref.invalidate(incomeExpenseBalanceProvider);
  ref.invalidate(budgetPerformanceProvider);
  ref.invalidate(upcomingPaymentsProvider);
  ref.invalidate(installmentSummaryProvider);
  ref.invalidate(interestAnalysisProvider);
  ref.invalidate(walletDistributionProvider);
  ref.invalidate(sourceBreakdownProvider);
}
