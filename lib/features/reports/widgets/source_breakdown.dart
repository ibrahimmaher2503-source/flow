import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/report_calculations.dart' as calc;
import '../../../providers/reports_provider.dart';
import 'report_section_header.dart';

class SourceBreakdownSection extends ConsumerWidget {
  const SourceBreakdownSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breakdownAsync = ref.watch(sourceBreakdownProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ReportSectionHeader(
          title: 'مصادر المعاملات',
          icon: Icons.source_outlined,
        ),
        breakdownAsync.when(
          data: (breakdown) {
            if (breakdown.isEmpty) {
              return _EmptyBreakdown(isDark: isDark);
            }

            // Calculate total transactions
            final totalCount =
                breakdown.fold<int>(0, (sum, s) => sum + s.count);
            final autoCount = breakdown
                .where((s) => s.source != 'manual')
                .fold<int>(0, (sum, s) => sum + s.count);
            final autoPercentage =
                totalCount > 0 ? (autoCount / totalCount) * 100 : 0;

            return Column(
              children: [
                // Automation summary
                if (autoCount > 0) ...[
                  _AutomationSummary(
                    autoPercentage: autoPercentage.toDouble(),
                    autoCount: autoCount,
                    totalCount: totalCount,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                ],
                // Source list
                ...breakdown.map((source) => _SourceItem(
                      source: source,
                      isDark: isDark,
                    )),
              ],
            );
          },
          loading: () => const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Center(child: Text('$e')),
        ),
      ],
    );
  }
}

class _EmptyBreakdown extends StatelessWidget {
  final bool isDark;

  const _EmptyBreakdown({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.textMuted : AppColors.lightTextMuted)
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          'لا توجد مصاريف هذا الشهر',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
      ),
    );
  }
}

class _AutomationSummary extends StatelessWidget {
  final double autoPercentage;
  final int autoCount;
  final int totalCount;
  final bool isDark;

  const _AutomationSummary({
    required this.autoPercentage,
    required this.autoCount,
    required this.totalCount,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final color = autoPercentage >= 50 ? AppColors.success : AppColors.secondary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.1),
            color.withValues(alpha: 0.05),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_awesome,
              size: 24,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'معدل الأتمتة',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  ),
                ),
                Text(
                  '${autoPercentage.toStringAsFixed(0)}% من معاملاتك تلقائية',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$autoCount',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                'من $totalCount',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11,
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SourceItem extends StatelessWidget {
  final calc.SourceBreakdown source;
  final bool isDark;

  const _SourceItem({
    required this.source,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final sourceInfo = _getSourceInfo(source.source);

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
            // Source icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: sourceInfo.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                sourceInfo.icon,
                size: 20,
                color: sourceInfo.color,
              ),
            ),
            const SizedBox(width: 12),
            // Source info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sourceInfo.label,
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
                    '${source.count} معاملة',
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
            // Amount and percentage
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyFormatter.format(source.amount),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: sourceInfo.color,
                  ),
                ),
                Text(
                  '${source.percentageOfTotal.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ({IconData icon, String label, Color color}) _getSourceInfo(String source) {
    switch (source.toLowerCase()) {
      case 'manual':
        return (
          icon: Icons.edit_outlined,
          label: 'يدوي',
          color: AppColors.primary,
        );
      case 'sms':
        return (
          icon: Icons.sms_outlined,
          label: 'رسائل SMS',
          color: AppColors.secondary,
        );
      case 'recurring':
        return (
          icon: Icons.repeat,
          label: 'متكرر',
          color: AppColors.warning,
        );
      case 'installment':
        return (
          icon: Icons.credit_card,
          label: 'أقساط',
          color: AppColors.installment,
        );
      default:
        return (
          icon: Icons.help_outline,
          label: source,
          color: AppColors.textMuted,
        );
    }
  }
}
