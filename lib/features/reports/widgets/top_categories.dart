import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/reports_provider.dart';
import '../../../providers/category_provider.dart';
import '../../../core/utils/extensions.dart';
import 'report_section_header.dart';

class TopCategories extends ConsumerWidget {
  const TopCategories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topCatsAsync = ref.watch(topCategoriesProvider);
    final categoriesAsync = ref.watch(allCategoriesProvider);
    final currentTotalsAsync = ref.watch(currentMonthCategoryTotalsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ReportSectionHeader(
          title: 'أعلى الفئات إنفاقاً',
          icon: Icons.leaderboard,
        ),
        topCatsAsync.when(
          data: (topCats) {
            if (topCats.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    'لا توجد مصاريف هذا الشهر',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ),
              );
            }

            // Get category colors
            final catColorMap = <String, String>{};
            final cats = categoriesAsync.valueOrNull;
            if (cats != null) {
              for (final c in cats) {
                catColorMap[c.name] = c.color;
              }
            }

            // Get total for percentage calculation
            double totalExpense = 0;
            final allTotals = currentTotalsAsync.valueOrNull;
            if (allTotals != null) {
              for (final v in allTotals.values) {
                totalExpense += v;
              }
            }

            return Column(
              children: List.generate(topCats.length, (index) {
                final entry = topCats[index];
                final catColor =
                    catColorMap[entry.key]?.toColor ?? AppColors.primary;
                final percent =
                    totalExpense > 0 ? (entry.value / totalExpense) * 100 : 0;

                return _TopCategoryItem(
                  rank: index + 1,
                  category: entry.key,
                  amount: entry.value,
                  percentage: percent.toDouble(),
                  color: catColor,
                  isDark: isDark,
                );
              }),
            );
          },
          loading: () => const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Text('$e'),
        ),
      ],
    );
  }
}

class _TopCategoryItem extends StatelessWidget {
  final int rank;
  final String category;
  final double amount;
  final double percentage;
  final Color color;
  final bool isDark;

  const _TopCategoryItem({
    required this.rank,
    required this.category,
    required this.amount,
    required this.percentage,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Rank badge colors
    final rankColors = [
      AppColors.warning, // Gold for #1
      Colors.grey.shade400, // Silver for #2
      Colors.brown.shade300, // Bronze for #3
      isDark ? AppColors.textMuted : AppColors.lightTextMuted, // Others
      isDark ? AppColors.textMuted : AppColors.lightTextMuted,
    ];
    final rankColor = rankColors[rank - 1];

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(12),
          border: isDark ? null : Border.all(color: AppColors.lightBorder),
        ),
        child: Row(
          children: [
            // Rank badge
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: rankColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Text(
                '$rank',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: rankColor,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Category color indicator
            Container(
              width: 4,
              height: 32,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            // Category name
            Expanded(
              child: Text(
                category,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ),
            // Amount and percentage
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyFormatter.format(amount),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
