import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/report_calculations.dart';

class BudgetPerformanceCard extends StatelessWidget {
  final BudgetPerformance performance;

  const BudgetPerformanceCard({
    super.key,
    required this.performance,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Determine status color
    Color statusColor;
    if (performance.isExceeded) {
      statusColor = AppColors.danger;
    } else if (performance.percentUsed >= 80) {
      statusColor = AppColors.warning;
    } else {
      statusColor = AppColors.success;
    }

    final progressPercent = (performance.percentUsed / 100).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: performance.isExceeded
            ? Border.all(color: AppColors.danger.withValues(alpha: 0.5), width: 1.5)
            : (isDark ? null : Border.all(color: AppColors.lightBorder)),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: AppColors.lightShadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              // Category name
              Expanded(
                child: Text(
                  performance.categoryName,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              // Status badge
              if (performance.isExceeded)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        size: 14,
                        color: AppColors.danger,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'تجاوز',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.danger,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          LinearPercentIndicator(
            lineHeight: 10,
            percent: progressPercent,
            backgroundColor:
                (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
            progressColor: statusColor,
            barRadius: const Radius.circular(5),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 12),
          // Stats row
          Row(
            children: [
              // Spent
              Expanded(
                child: _StatItem(
                  label: 'المنفق',
                  value: CurrencyFormatter.format(performance.actualSpending),
                  color: statusColor,
                  isDark: isDark,
                ),
              ),
              // Divider
              Container(
                width: 1,
                height: 32,
                color:
                    (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
              ),
              // Limit
              Expanded(
                child: _StatItem(
                  label: 'الحد',
                  value: CurrencyFormatter.format(performance.limitAmount),
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  isDark: isDark,
                ),
              ),
              // Divider
              Container(
                width: 1,
                height: 32,
                color:
                    (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
              ),
              // Remaining or Overage
              Expanded(
                child: _StatItem(
                  label: performance.isExceeded ? 'التجاوز' : 'المتبقي',
                  value: CurrencyFormatter.format(
                    performance.isExceeded
                        ? performance.overage!
                        : performance.remaining,
                  ),
                  color: performance.isExceeded
                      ? AppColors.danger
                      : AppColors.success,
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Percentage text
          Align(
            alignment: Alignment.center,
            child: Text(
              '${performance.percentUsed.toStringAsFixed(0)}% مستخدم',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 10,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
