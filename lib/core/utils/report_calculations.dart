import '../../data/models/transaction_model.dart';
import '../../data/models/budget_model.dart';
import '../../data/models/wallet_model.dart';
import '../../data/models/installment_plan_model.dart';

/// Pure calculation functions for reports - no side effects, easily testable

// ============================================================================
// US1: Spending Trends Calculations
// ============================================================================

/// Calculate monthly totals from a list of transactions
/// Returns map of monthKey -> (income, expense)
Map<String, ({double income, double expense})> calculateMonthlyTotals(
    List<Transaction> transactions) {
  final Map<String, ({double income, double expense})> result = {};

  for (final t in transactions) {
    final key = t.monthKey;
    final current = result[key] ?? (income: 0.0, expense: 0.0);

    if (t.type == 'income') {
      result[key] = (income: current.income + t.amount, expense: current.expense);
    } else {
      result[key] = (income: current.income, expense: current.expense + t.amount);
    }
  }

  return result;
}

/// Calculate percentage change between two values
/// Returns null if previous is zero to avoid division by zero
double? calculatePercentageChange(double current, double previous) {
  if (previous == 0) return null;
  return ((current - previous) / previous) * 100;
}

/// Calculate spending trend data for chart (last N months)
/// Returns list of expense totals ordered by month (oldest first)
List<double> calculateSpendingTrend(
    Map<String, ({double income, double expense})> monthlyTotals,
    List<String> monthKeys) {
  return monthKeys.map((key) => monthlyTotals[key]?.expense ?? 0.0).toList();
}

/// Calculate daily average spending for a month
double calculateDailyAverage(double totalExpense, int daysInMonth) {
  if (daysInMonth <= 0) return 0;
  return totalExpense / daysInMonth;
}

/// Calculate weekly average spending for a month
double calculateWeeklyAverage(double totalExpense, int daysInMonth) {
  if (daysInMonth <= 0) return 0;
  return (totalExpense / daysInMonth) * 7;
}

/// Get category totals from transactions
Map<String, double> calculateCategoryTotals(List<Transaction> transactions,
    {String? type}) {
  final Map<String, double> result = {};

  for (final t in transactions) {
    if (type != null && t.type != type) continue;
    result[t.category] = (result[t.category] ?? 0) + t.amount;
  }

  return result;
}

/// Get top N categories by amount
List<MapEntry<String, double>> getTopCategories(
    Map<String, double> categoryTotals, int limit) {
  final sorted = categoryTotals.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  return sorted.take(limit).toList();
}

/// Calculate category comparison between two months
/// Returns map of category -> (current, previous, percentChange)
Map<String, ({double current, double previous, double? percentChange})>
    calculateCategoryComparison(
  Map<String, double> currentTotals,
  Map<String, double> previousTotals,
) {
  final allCategories = <String>{
    ...currentTotals.keys,
    ...previousTotals.keys,
  };

  final Map<String, ({double current, double previous, double? percentChange})>
      result = {};

  for (final cat in allCategories) {
    final current = currentTotals[cat] ?? 0;
    final previous = previousTotals[cat] ?? 0;
    final change = calculatePercentageChange(current, previous);
    result[cat] = (current: current, previous: previous, percentChange: change);
  }

  return result;
}

// ============================================================================
// US2: Income vs Expense Balance Calculations
// ============================================================================

/// Calculate net balance (income - expense)
double calculateNetBalance(double income, double expense) {
  return income - expense;
}

/// Calculate savings rate as percentage of income
/// Returns null if income is zero
double? calculateSavingsRate(double income, double expense) {
  if (income <= 0) return null;
  final savings = income - expense;
  return (savings / income) * 100;
}

/// Determine if balance is positive (surplus) or negative (deficit)
bool isSurplus(double netBalance) => netBalance >= 0;

// ============================================================================
// US3: Budget Performance Calculations
// ============================================================================

/// Budget performance data class
class BudgetPerformance {
  final int budgetId;
  final String categoryName;
  final double limitAmount;
  final double actualSpending;
  final double percentUsed;
  final double remaining;
  final bool isExceeded;
  final double? overage;

  BudgetPerformance({
    required this.budgetId,
    required this.categoryName,
    required this.limitAmount,
    required this.actualSpending,
    required this.percentUsed,
    required this.remaining,
    required this.isExceeded,
    this.overage,
  });
}

/// Calculate budget performance for a single budget
BudgetPerformance calculateBudgetPerformance(
    Budget budget, double actualSpending) {
  final percentUsed =
      budget.limitAmount > 0 ? (actualSpending / budget.limitAmount) * 100 : 0;
  final remaining = budget.limitAmount - actualSpending;
  final isExceeded = actualSpending > budget.limitAmount;
  final overage = isExceeded ? actualSpending - budget.limitAmount : null;

  return BudgetPerformance(
    budgetId: budget.id,
    categoryName: budget.categoryName,
    limitAmount: budget.limitAmount,
    actualSpending: actualSpending,
    percentUsed: percentUsed.toDouble(),
    remaining: remaining,
    isExceeded: isExceeded,
    overage: overage,
  );
}

/// Calculate performance for all budgets
List<BudgetPerformance> calculateAllBudgetPerformance(
  List<Budget> budgets,
  Map<String, double> categorySpending,
) {
  return budgets.map((budget) {
    final spending = categorySpending[budget.categoryName] ?? 0;
    return calculateBudgetPerformance(budget, spending);
  }).toList();
}

// ============================================================================
// US4: Installment Analytics Calculations
// ============================================================================

/// Upcoming payment data class
class UpcomingPayment {
  final int planId;
  final String itemName;
  final double amount;
  final DateTime dueDate;
  final int installmentNumber;
  final int totalInstallments;

  UpcomingPayment({
    required this.planId,
    required this.itemName,
    required this.amount,
    required this.dueDate,
    required this.installmentNumber,
    required this.totalInstallments,
  });
}

/// Calculate total monthly installment commitment
double calculateMonthlyCommitment(List<InstallmentPlan> activePlans) {
  double total = 0;
  for (final plan in activePlans) {
    total += plan.monthlyAmount;
  }
  return total;
}

/// Calculate projected payoff date (when last installment completes)
DateTime? calculateProjectedPayoffDate(List<InstallmentPlan> activePlans) {
  if (activePlans.isEmpty) return null;

  DateTime? latestDate;

  for (final plan in activePlans) {
    final payoffDate = DateTime(
      plan.firstPaymentDate.year,
      plan.firstPaymentDate.month + plan.totalInstallments - 1,
      plan.dayOfMonth,
    );

    if (latestDate == null || payoffDate.isAfter(latestDate)) {
      latestDate = payoffDate;
    }
  }

  return latestDate;
}

/// Calculate interest analysis
({double totalInterest, double interestPercentage}) calculateInterestAnalysis(
    List<InstallmentPlan> plans) {
  double totalOriginal = 0;
  double totalWithInterest = 0;

  for (final plan in plans) {
    totalOriginal += plan.originalPrice;
    totalWithInterest += plan.totalWithInterest;
  }

  final totalInterest = totalWithInterest - totalOriginal;
  final percentage =
      totalOriginal > 0 ? (totalInterest / totalOriginal) * 100 : 0.0;

  return (totalInterest: totalInterest, interestPercentage: percentage);
}

// ============================================================================
// US5: Wallet Distribution Calculations
// ============================================================================

/// Wallet balance with percentage
class WalletBalance {
  final int walletId;
  final String name;
  final String type;
  final double balance;
  final double percentage;

  WalletBalance({
    required this.walletId,
    required this.name,
    required this.type,
    required this.balance,
    required this.percentage,
  });
}

/// Calculate wallet distribution with percentages
List<WalletBalance> calculateWalletDistribution(List<Wallet> wallets) {
  double totalBalance = 0;
  for (final w in wallets) {
    totalBalance += w.balance;
  }

  return wallets.map((w) {
    final percentage = totalBalance > 0 ? (w.balance / totalBalance) * 100 : 0;
    return WalletBalance(
      walletId: w.id,
      name: w.name,
      type: w.type,
      balance: w.balance,
      percentage: percentage.toDouble(),
    );
  }).toList();
}

// ============================================================================
// US6: Transaction Source Analysis Calculations
// ============================================================================

/// Source breakdown data
class SourceBreakdown {
  final String source;
  final int count;
  final double amount;
  final double percentageOfTotal;

  SourceBreakdown({
    required this.source,
    required this.count,
    required this.amount,
    required this.percentageOfTotal,
  });
}

/// Calculate transaction source breakdown
List<SourceBreakdown> calculateSourceBreakdown(List<Transaction> transactions) {
  final Map<String, ({int count, double amount})> sourceData = {};
  double totalAmount = 0;

  for (final t in transactions) {
    if (t.type != 'expense') continue;

    final current = sourceData[t.source] ?? (count: 0, amount: 0.0);
    sourceData[t.source] = (
      count: current.count + 1,
      amount: current.amount + t.amount,
    );
    totalAmount += t.amount;
  }

  return sourceData.entries.map((entry) {
    final percentage =
        totalAmount > 0 ? (entry.value.amount / totalAmount) * 100 : 0;
    return SourceBreakdown(
      source: entry.key,
      count: entry.value.count,
      amount: entry.value.amount,
      percentageOfTotal: percentage.toDouble(),
    );
  }).toList()
    ..sort((a, b) => b.amount.compareTo(a.amount));
}

// ============================================================================
// Utility: Month Key Generation
// ============================================================================

/// Generate list of month keys for last N months (oldest first)
List<String> generateMonthKeys(int months, {DateTime? from}) {
  final now = from ?? DateTime.now();
  final List<String> keys = [];

  for (int i = months - 1; i >= 0; i--) {
    final date = DateTime(now.year, now.month - i, 1);
    keys.add('${date.year}-${date.month.toString().padLeft(2, '0')}');
  }

  return keys;
}

/// Get Arabic month name abbreviation
String getArabicMonthAbbr(int month) {
  const months = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];
  return months[(month - 1) % 12];
}

/// Convert month key to Arabic label
String monthKeyToArabicLabel(String monthKey) {
  final parts = monthKey.split('-');
  if (parts.length != 2) return monthKey;
  final month = int.tryParse(parts[1]) ?? 1;
  return getArabicMonthAbbr(month);
}
