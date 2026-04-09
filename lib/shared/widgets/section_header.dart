import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Semantic variants for section header action buttons
enum SectionHeaderVariant {
  /// Default primary colored action
  primary,
  /// Secondary teal colored action
  secondary,
  /// Neutral text-only action
  neutral,
}

/// Reusable section header with title and optional action button
class SectionHeader extends StatefulWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;
  final IconData? actionIcon;
  final SectionHeaderVariant variant;
  final String? subtitle;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onAction,
    this.actionIcon,
    this.variant = SectionHeaderVariant.primary,
    this.subtitle,
  });

  @override
  State<SectionHeader> createState() => _SectionHeaderState();
}

class _SectionHeaderState extends State<SectionHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _SectionHeaderColors _getVariantColors(bool isDark) {
    switch (widget.variant) {
      case SectionHeaderVariant.primary:
        return _SectionHeaderColors(
          actionBgColor: isDark
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.lightPrimaryContainer,
          actionTextColor: isDark
              ? AppColors.primary
              : AppColors.lightOnPrimaryContainer,
          actionBorderColor: AppColors.lightPrimaryBorder,
        );
      case SectionHeaderVariant.secondary:
        return _SectionHeaderColors(
          actionBgColor: isDark
              ? AppColors.secondary.withValues(alpha: 0.1)
              : AppColors.lightSecondaryContainer,
          actionTextColor: isDark
              ? AppColors.secondary
              : AppColors.lightOnSecondaryContainer,
          actionBorderColor: AppColors.lightSecondaryBorder,
        );
      case SectionHeaderVariant.neutral:
        return _SectionHeaderColors(
          actionBgColor: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : AppColors.lightSurfaceContainerHigh,
          actionTextColor: isDark
              ? AppColors.textSecondary
              : AppColors.lightTextSecondary,
          actionBorderColor: AppColors.lightBorderVariant,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.lightTextPrimary;
    final subtitleColor = isDark ? AppColors.textMuted : AppColors.lightTextMuted;
    final colors = _getVariantColors(isDark);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.w600, // M3 title large
                    color: textColor,
                    letterSpacing: 0,
                    height: 1.3,
                  ),
                ),
                if (widget.subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    widget.subtitle!,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: subtitleColor,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Action button
          if (widget.actionText != null || widget.actionIcon != null)
            GestureDetector(
              onTapDown: (_) => _controller.forward(),
              onTapUp: (_) {
                _controller.reverse();
                widget.onAction?.call();
              },
              onTapCancel: () => _controller.reverse(),
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) => Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: colors.actionBgColor,
                      borderRadius: BorderRadius.circular(8), // M3 small chip
                      border: isDark
                          ? null
                          : Border.all(
                              color: colors.actionBorderColor.withValues(alpha: 0.5),
                              width: 0.5,
                            ),
                      boxShadow: isDark
                          ? null
                          : [
                              BoxShadow(
                                color: colors.actionTextColor.withValues(alpha: 0.06),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.actionText != null)
                          Text(
                            widget.actionText!,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              fontWeight: FontWeight.w500, // M3 label medium
                              color: colors.actionTextColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        if (widget.actionIcon != null) ...[
                          if (widget.actionText != null) const SizedBox(width: 4),
                          Icon(
                            widget.actionIcon,
                            size: 16,
                            color: colors.actionTextColor,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionHeaderColors {
  final Color actionBgColor;
  final Color actionTextColor;
  final Color actionBorderColor;

  const _SectionHeaderColors({
    required this.actionBgColor,
    required this.actionTextColor,
    required this.actionBorderColor,
  });
}
