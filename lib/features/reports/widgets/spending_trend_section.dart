import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/reports_provider.dart';
import 'trend_line_chart.dart';
import 'report_section_header.dart';

class SpendingTrendSection extends ConsumerWidget {
  const SpendingTrendSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendAsync = ref.watch(spendingTrendProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ReportSectionHeader(
          title: 'اتجاه الإنفاق',
          icon: Icons.trending_up,
        ),
        trendAsync.when(
          data: (trend) {
            if (trend.data.isEmpty ||
                trend.data.every((v) => v == 0)) {
              return Container(
                height: 180,
                alignment: Alignment.center,
                child: Text(
                  'لا توجد بيانات كافية',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  ),
                ),
              );
            }

            // Calculate month-over-month change
            double? percentChange;
            if (trend.data.length >= 2) {
              final current = trend.data[trend.data.length - 1];
              final previous = trend.data[trend.data.length - 2];
              if (previous > 0) {
                percentChange = ((current - previous) / previous) * 100;
              }
            }

            return Column(
              children: [
                TrendLineChart(
                  data: trend.data,
                  labels: trend.labels,
                  color: AppColors.danger,
                ),
                if (percentChange != null) ...[
                  const SizedBox(height: 12),
                  _buildChangeIndicator(percentChange, isDark),
                ],
              ],
            );
          },
          loading: () => const SizedBox(
            height: 180,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => SizedBox(
            height: 180,
            child: Center(child: Text('$e')),
          ),
        ),
      ],
    );
  }

  Widget _buildChangeIndicator(double percentChange, bool isDark) {
    final isIncrease = percentChange > 0;
    final color = isIncrease ? AppColors.danger : AppColors.success;
    final icon = isIncrease ? Icons.arrow_upward : Icons.arrow_downward;
    final label = isIncrease ? 'زيادة' : 'انخفاض';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            '${percentChange.abs().toStringAsFixed(1)}% $label عن الشهر السابق',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
