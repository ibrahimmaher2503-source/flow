import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Display metrics with icon and label in a premium badge style
class StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final IconData? icon;

  const StatBadge({
    super.key,
    required this.label,
    required this.value,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final badgeColor = color ?? (isDark ? AppColors.primary : AppColors.lightPrimary);

    // Light mode: use muted background colors based on the badge color
    final bgAlpha = isDark ? 0.1 : 0.12;
    final shadowAlpha = isDark ? 0.1 : 0.08;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: bgAlpha),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: isDark
                ? null
                : Border.all(
                    color: badgeColor.withValues(alpha: 0.25),  // Enhanced border visibility
                  ),
            boxShadow: isDark
                ? [
                    BoxShadow(
                      color: badgeColor.withValues(alpha: shadowAlpha),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    // Enhanced multi-layer shadow for light mode
                    BoxShadow(
                      color: badgeColor.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: badgeColor.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                      spreadRadius: -1,
                    ),
                  ],
          ),
          child: Icon(
            icon ?? Icons.trending_up,
            color: badgeColor,
            size: 24,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
