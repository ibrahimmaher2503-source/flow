import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/smart_feature_models.dart';
import '../../../shared/widgets/app_card.dart';
import 'tag_chip.dart';

/// Card displaying tag analytics with spending breakdown
class TagAnalyticsCard extends StatelessWidget {
  final TagAnalytics analytics;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onRename;

  const TagAnalyticsCard({
    super.key,
    required this.analytics,
    this.onTap,
    this.onDelete,
    this.onRename,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tagColor = _getTagColor(analytics.tagName);

    return AppCard(
      variant: AppCardVariant.elevated,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              // Tag chip
              TagChip(
                label: analytics.tagName,
                colorHex: tagColor,
              ),
              const Spacer(),
              // Action menu
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  size: 20,
                ),
                onSelected: (value) {
                  if (value == 'rename') {
                    onRename?.call();
                  } else if (value == 'delete') {
                    onDelete?.call();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'rename',
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_rounded,
                          size: 18,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        const Text('تعديل الاسم'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                          color: isDark ? AppColors.danger : AppColors.lightDanger,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'حذف',
                          style: TextStyle(
                            color: isDark ? AppColors.danger : AppColors.lightDanger,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Stats row
          Row(
            children: [
              _StatItem(
                label: 'إجمالي',
                value: CurrencyFormatter.format(analytics.totalAmount),
                isDark: isDark,
              ),
              const SizedBox(width: AppSpacing.xl),
              _StatItem(
                label: 'معاملات',
                value: '${analytics.transactionCount}',
                isDark: isDark,
              ),
              const SizedBox(width: AppSpacing.xl),
              _StatItem(
                label: 'متوسط',
                value: CurrencyFormatter.format(analytics.averageAmount),
                isDark: isDark,
              ),
            ],
          ),

          // Category breakdown
          if (analytics.categoryBreakdown.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Divider(
              color: isDark
                  ? AppColors.surfaceLight
                  : AppColors.lightSurfaceContainerHighest,
              height: 1,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'التوزيع على الفئات',
              style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...analytics.categoryBreakdown.entries
                .take(3)
                .map((entry) => _CategoryRow(
                      category: entry.key,
                      amount: entry.value,
                      total: analytics.totalAmount,
                      isDark: isDark,
                    )),
          ],

          // Date range
          if (analytics.firstUsed != null) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  _formatDateRange(analytics.firstUsed!, analytics.lastUsed),
                  style: TextStyle(
                    color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _getTagColor(String name) {
    final colors = [
      '#6C63FF',
      '#2DD4BF',
      '#F59E0B',
      '#10B981',
      '#EF4444',
      '#8B5CF6',
      '#EC4899',
      '#06B6D4',
    ];
    final index = name.hashCode.abs() % colors.length;
    return colors[index];
  }

  String _formatDateRange(DateTime start, DateTime? end) {
    final startStr = '${start.day}/${start.month}/${start.year}';
    if (end == null || end == start) {
      return startStr;
    }
    final endStr = '${end.day}/${end.month}/${end.year}';
    return '$startStr - $endStr';
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _StatItem({
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final String category;
  final double amount;
  final double total;
  final bool isDark;

  const _CategoryRow({
    required this.category,
    required this.amount,
    required this.total,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total > 0 ? (amount / total * 100) : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              category,
              style: TextStyle(
                color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.surfaceLight.withValues(alpha: 0.5)
                        : AppColors.lightSurfaceContainerHigh,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: percentage / 100,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.primary : AppColors.lightPrimary,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '${percentage.round()}%',
            style: TextStyle(
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
