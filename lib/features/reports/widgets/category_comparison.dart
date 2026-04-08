import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/reports_provider.dart';
import '../../../providers/category_provider.dart';
import '../../../core/utils/extensions.dart';
import 'report_section_header.dart';

class CategoryComparison extends ConsumerWidget {
  const CategoryComparison({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comparisonAsync = ref.watch(categoryComparisonProvider);
    final categoriesAsync = ref.watch(allCategoriesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ReportSectionHeader(
          title: 'مقارنة بالشهر السابق',
          icon: Icons.compare_arrows,
        ),
        comparisonAsync.when(
          data: (comparison) {
            if (comparison.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    'لا توجد بيانات للمقارنة',
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

            // Sort by current month amount (highest first)
            final sortedEntries = comparison.entries.toList()
              ..sort((a, b) => b.value.current.compareTo(a.value.current));

            // Show top 5 categories
            final topEntries = sortedEntries.take(5).toList();

            return Column(
              children: topEntries.map((entry) {
                final catColor =
                    catColorMap[entry.key]?.toColor ?? AppColors.primary;
                return _ComparisonRow(
                  category: entry.key,
                  current: entry.value.current,
                  previous: entry.value.previous,
                  percentChange: entry.value.percentChange,
                  color: catColor,
                  isDark: isDark,
                );
              }).toList(),
            );
          },
          loading: () => const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Text('$e'),
        ),
      ],
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  final String category;
  final double current;
  final double previous;
  final double? percentChange;
  final Color color;
  final bool isDark;

  const _ComparisonRow({
    required this.category,
    required this.current,
    required this.previous,
    required this.percentChange,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final changeColor = percentChange == null
        ? (isDark ? AppColors.textMuted : AppColors.lightTextMuted)
        : (percentChange! > 0 ? AppColors.danger : AppColors.success);

    final changeIcon = percentChange == null
        ? Icons.remove
        : (percentChange! > 0 ? Icons.arrow_upward : Icons.arrow_downward);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(12),
          border: isDark ? null : Border.all(color: AppColors.lightBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
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
                  Text(
                    'السابق: ${CurrencyFormatter.format(previous)}',
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
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyFormatter.format(current),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(changeIcon, size: 12, color: changeColor),
                    const SizedBox(width: 2),
                    Text(
                      percentChange != null
                          ? '${percentChange!.abs().toStringAsFixed(1)}%'
                          : 'جديد',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: changeColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
