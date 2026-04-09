import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/extensions.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/installment_provider.dart';
import '../../providers/category_provider.dart';
import 'widgets/category_pie_chart.dart';
import 'widgets/installment_pie_chart.dart';
// US1 & US2 widgets
import 'widgets/income_expense_summary.dart';
import 'widgets/spending_trend_section.dart';
import 'widgets/spending_averages.dart';
import 'widgets/category_comparison.dart';
import 'widgets/top_categories.dart';
import 'widgets/report_section_header.dart';
// US3 widgets
import 'widgets/budget_performance_section.dart';
// US4 widgets
import 'widgets/payment_timeline.dart';
import 'widgets/installment_summary.dart';
import 'widgets/interest_analysis.dart';
// US5 & US6 widgets
import 'widgets/wallet_distribution.dart';
import 'widgets/source_breakdown.dart' show SourceBreakdownSection;

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.screenReports),
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            labelStyle:
                const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo'),
            tabs: [
              Tab(text: l10n.reportsTabExpenses),
              Tab(text: l10n.reportsTabInstallments),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _GeneralReportTab(),
            _InstallmentReportTab(),
          ],
        ),
      ),
    );
  }
}

class _GeneralReportTab extends ConsumerWidget {
  const _GeneralReportTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(monthlyTransactionsProvider);
    final categoriesAsync = ref.watch(allCategoriesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return transactionsAsync.when(
      data: (transactions) {
        final expenses =
            transactions.where((t) => t.type == 'expense').toList();

        // Category breakdown for pie chart
        final Map<String, double> categoryTotals = {};
        for (final t in expenses) {
          categoryTotals[t.category] =
              (categoryTotals[t.category] ?? 0) + t.amount;
        }

        final catColorMap = <String, String>{};
        final cats = categoriesAsync.valueOrNull;
        if (cats != null) {
          for (final c in cats) {
            catColorMap[c.name] = c.color;
          }
        }

        final sortedCategories = categoryTotals.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        double totalExpense = 0;
        for (final e in sortedCategories) {
          totalExpense += e.value;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // US2: Income vs Expense Summary (top of screen)
              const IncomeExpenseSummary(),
              const SizedBox(height: 24),

              // US1: Spending Trend Chart
              const SpendingTrendSection(),
              const SizedBox(height: 24),

              // US1: Spending Averages
              const SpendingAverages(),
              const SizedBox(height: 24),

              // US1: Top Categories
              const TopCategories(),
              const SizedBox(height: 24),

              // US1: Category Comparison (current vs previous month)
              const CategoryComparison(),
              const SizedBox(height: 24),

              // US3: Budget Performance
              const BudgetPerformanceSection(),
              const SizedBox(height: 24),

              // US5: Wallet Distribution
              const WalletDistribution(),
              const SizedBox(height: 24),

              // US6: Source Breakdown
              const SourceBreakdownSection(),
              const SizedBox(height: 24),

              // Existing: Category Distribution Pie Chart
              ReportSectionHeader(
                title: 'التوزيع بالفئات',
                icon: Icons.pie_chart_outline,
              ),
              if (categoryTotals.isNotEmpty) ...[
                CategoryPieChart(
                  data: categoryTotals,
                  colorMap: catColorMap,
                ),
                const SizedBox(height: 16),
                // Category breakdown list
                ...sortedCategories.map((entry) {
                  final color =
                      catColorMap[entry.key]?.toColor ??
                      (isDark ? AppColors.textMuted : AppColors.lightTextMuted);
                  final percent = totalExpense > 0
                      ? (entry.value / totalExpense * 100)
                      : 0.0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration:
                              BoxDecoration(color: color, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(entry.key,
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.lightTextPrimary)),
                        ),
                        Text(CurrencyFormatter.format(entry.value),
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.textSecondary
                                    : AppColors.lightTextSecondary)),
                        const SizedBox(width: 8),
                        Text('${percent.toStringAsFixed(1)}%',
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted)),
                      ],
                    ),
                  );
                }),
              ] else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text(
                      'لا توجد مصاريف هذا ال��هر',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
    );
  }
}

class _InstallmentReportTab extends ConsumerWidget {
  const _InstallmentReportTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debtByProv = ref.watch(debtByProviderProvider);
    final totalInterest = ref.watch(totalInterestPaidProvider);
    final totalDebt = ref.watch(totalDebtProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // US4: Installment Summary (monthly commitment, payoff date)
          const InstallmentSummary(),
          const SizedBox(height: 24),

          // US4: Payment Timeline
          const PaymentTimeline(),
          const SizedBox(height: 24),

          // US4: Interest Analysis
          const InterestAnalysis(),
          const SizedBox(height: 24),

          // Existing: Stats row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.installment.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text('الالتزامات المتبقية',
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted)),
                      totalDebt.when(
                        data: (v) => Text(CurrencyFormatter.format(v),
                            style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.installment)),
                        loading: () => const Text('...'),
                        error: (_, __) => const Text('--'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text('فوائد مدفوعة',
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted)),
                      totalInterest.when(
                        data: (v) => Text(CurrencyFormatter.format(v),
                            style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.danger)),
                        loading: () => const Text('...'),
                        error: (_, __) => const Text('--'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Existing: Provider pie chart
          Text('التوزيع حسب المقدم',
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.lightTextPrimary)),
          const SizedBox(height: 12),
          debtByProv.when(
            data: (map) => InstallmentPieChart(debtByProvider: map),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('$e'),
          ),

          const SizedBox(height: 16),

          // Existing: Debt by provider list
          debtByProv.when(
            data: (map) {
              if (map.isEmpty) {
                return Center(
                  child: Text('مفيش أقساط نشطة',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted)),
                );
              }
              return Column(
                children: map.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surface : AppColors.lightSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: isDark
                            ? null
                            : Border.all(color: AppColors.lightBorder),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.key,
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 15,
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.lightTextPrimary)),
                          Text(CurrencyFormatter.format(entry.value),
                              style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.installment)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('$e'),
          ),
        ],
      ),
    );
  }
}
