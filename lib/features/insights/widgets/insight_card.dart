import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/icon_resolver.dart';
import '../../../data/models/insight_model.dart';

/// Card displaying a single insight with swipe-to-dismiss
class InsightCard extends StatelessWidget {
  final Insight insight;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final bool showDismissHint;
  final bool compact;

  const InsightCard({
    super.key,
    required this.insight,
    this.onTap,
    this.onDismiss,
    this.showDismissHint = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _parseColor(insight.colorHex, isDark);

    Widget card = GestureDetector(
      onTap: onTap ?? () {
        if (insight.actionRoute != null) {
          Navigator.pushNamed(context, insight.actionRoute!);
        }
      },
      child: Container(
        padding: EdgeInsets.all(compact ? AppSpacing.md : AppSpacing.lg),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceLight.withValues(alpha: 0.5)
              : AppColors.lightSurfaceContainerLow,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: insight.priority == 1 ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: compact
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: compact ? 36 : 44,
              height: compact ? 36 : 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Icon(
                _getIcon(insight.iconName),
                color: color,
                size: compact ? 18 : 22,
              ),
            ),
            SizedBox(width: compact ? AppSpacing.md : AppSpacing.lg),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Priority badge + title row
                  Row(
                    children: [
                      if (insight.priority == 1) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: Text(
                            'مهم',
                            style: TextStyle(
                              color: color,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                      ],
                      Expanded(
                        child: Text(
                          insight.titleAr,
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                            fontSize: compact ? 13 : 14,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: compact ? 2 : AppSpacing.xs),

                  // Description
                  Text(
                    insight.descriptionAr,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                      fontSize: compact ? 11 : 12,
                      height: 1.4,
                    ),
                    maxLines: compact ? 2 : 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Time ago
                  if (!compact) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      _formatTimeAgo(insight.generatedAt),
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Action indicator
            if (insight.actionRoute != null)
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                size: 14,
              ),
          ],
        ),
      ),
    );

    // Wrap in Dismissible if onDismiss is provided
    if (onDismiss != null) {
      return Dismissible(
        key: Key('insight_${insight.id}'),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: AppSpacing.xl),
          decoration: BoxDecoration(
            color: (isDark ? AppColors.success : AppColors.lightSuccess)
                .withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Icon(
            Icons.check_rounded,
            color: isDark ? AppColors.success : AppColors.lightSuccess,
          ),
        ),
        onDismissed: (_) => onDismiss!(),
        child: card,
      );
    }

    return card;
  }

  Color _parseColor(String? hex, bool isDark) {
    if (hex == null || hex.isEmpty) {
      return isDark ? AppColors.primary : AppColors.lightPrimary;
    }
    try {
      final colorHex = hex.replaceFirst('#', '');
      return Color(int.parse('FF$colorHex', radix: 16));
    } catch (_) {
      return isDark ? AppColors.primary : AppColors.lightPrimary;
    }
  }

  IconData _getIcon(String? iconName) {
    if (iconName == null) return Icons.lightbulb_outline;
    return IconResolver.resolve(iconName);
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} يوم';
    return '${date.day}/${date.month}';
  }
}

/// Mini insight chip for compact display
class InsightChip extends StatelessWidget {
  final Insight insight;
  final VoidCallback? onTap;

  const InsightChip({
    super.key,
    required this.insight,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _parseColor(insight.colorHex, isDark);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              IconResolver.resolve(insight.iconName ?? 'lightbulb'),
              color: color,
              size: 14,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              insight.titleAr,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String? hex, bool isDark) {
    if (hex == null || hex.isEmpty) {
      return isDark ? AppColors.primary : AppColors.lightPrimary;
    }
    try {
      final colorHex = hex.replaceFirst('#', '');
      return Color(int.parse('FF$colorHex', radix: 16));
    } catch (_) {
      return isDark ? AppColors.primary : AppColors.lightPrimary;
    }
  }
}
