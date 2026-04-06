import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/extensions.dart';
import '../../data/models/transaction_model.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/installment_provider.dart';
import '../../providers/category_provider.dart';
import '../../shared/widgets/app_card.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('التقارير'),
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelStyle:
                TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(fontFamily: 'Cairo'),
            tabs: [
              Tab(text: 'المصاريف'),
              Tab(text: 'الأقساط'),
            ],
          ),
        ),
        body: TabBarView(
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
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(monthlyTransactionsProvider);
    final categoriesAsync = ref.watch(allCategoriesProvider);

    return transactionsAsync.when(
      data: (transactions) {
        final expenses =
            transactions.where((t) => t.type == 'expense').toList();

        if (expenses.isEmpty) {
          return const Center(
            child: Text('مفيش بيانات كافية للتقارير',
                style: TextStyle(
                    fontFamily: 'Cairo', color: AppColors.textMuted)),
          );
        }

        // Category breakdown
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

        // Daily average
        final now = DateTime.now();
        final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
        final dailyAvg = totalExpense / daysInMonth;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quick stats
              Row(
                children: [
                  Expanded(
                    child: _statCard('إجمالي المصاريف',
                        CurrencyFormatter.format(totalExpense), AppColors.danger),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _statCard('متوسط يومي',
                        CurrencyFormatter.format(dailyAvg), AppColors.warning),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Pie chart
              const Text('التوزيع بالفئات',
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: sortedCategories.take(6).map((entry) {
                      final color =
                          catColorMap[entry.key]?.toColor ?? AppColors.primary;
                      final percent = totalExpense > 0
                          ? (entry.value / totalExpense * 100)
                          : 0.0;
                      return PieChartSectionData(
                        value: entry.value,
                        color: color,
                        title: '${percent.toStringAsFixed(0)}%',
                        titleStyle: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        radius: 50,
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Category list
              ...sortedCategories.map((entry) {
                final color =
                    catColorMap[entry.key]?.toColor ?? AppColors.textMuted;
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
                            style: const TextStyle(
                                fontFamily: 'Cairo', color: Colors.white)),
                      ),
                      Text(CurrencyFormatter.format(entry.value),
                          style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary)),
                      const SizedBox(width: 8),
                      Text('${percent.toStringAsFixed(1)}%',
                          style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: AppColors.textMuted)),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: AppColors.textMuted)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color)),
        ],
      ),
    );
  }
}

class _InstallmentReportTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debtByProv = ref.watch(debtByProviderProvider);
    final totalInterest = ref.watch(totalInterestPaidProvider);
    final totalDebt = ref.watch(totalDebtProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats
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
                      const Text('الالتزامات المتبقية',
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: AppColors.textMuted)),
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
                      const Text('فوائد مدفوعة',
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: AppColors.textMuted)),
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

          // Debt by provider
          const Text('التوزيع حسب المقدم',
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          const SizedBox(height: 12),
          debtByProv.when(
            data: (map) {
              if (map.isEmpty) {
                return const Center(
                  child: Text('مفيش أقساط نشطة',
                      style: TextStyle(
                          fontFamily: 'Cairo', color: AppColors.textMuted)),
                );
              }
              return Column(
                children: map.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.key,
                              style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 15,
                                  color: Colors.white)),
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
