import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Semantic variants for stat badges
enum StatBadgeVariant {
  /// Default primary styling
  primary,
  /// Secondary teal styling
  secondary,
  /// Success green styling (for positive stats)
  success,
  /// Warning amber styling (for attention stats)
  warning,
  /// Danger red styling (for negative stats)
  danger,
  /// Neutral gray styling
  neutral,
}

/// Display metrics with icon and label in a premium badge style
class StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final IconData? icon;
  final StatBadgeVariant variant;
  final VoidCallback? onTap;

  const StatBadge({
    super.key,
    required this.label,
    required this.value,
    this.color,
    this.icon,
    this.variant = StatBadgeVariant.primary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = _getVariantColors(isDark);

    // Use custom color if provided, otherwise use variant colors
    final effectiveColor = color ?? colors.accentColor;
    final effectiveBgColor = color != null
        ? color!.withValues(alpha: isDark ? 0.1 : 0.15)
        : colors.containerColor;
    final effectiveBorderColor = color != null
        ? color!.withValues(alpha: isDark ? 0.2 : 0.25)
        : colors.borderColor;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon container
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: effectiveBgColor,
            borderRadius: BorderRadius.circular(12), // M3 standard
            border: isDark
                ? null
                : Border.all(
                    color: effectiveBorderColor,
                    width: 0.5,
                  ),
            boxShadow: isDark
                ? [
                    BoxShadow(
                      color: effectiveColor.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: effectiveColor.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                    ...AppColors.lightShadowSubtle.map((s) => BoxShadow(
                          color: s.color.withValues(alpha: 0.5),
                          blurRadius: s.blurRadius * 0.5,
                          offset: s.offset,
                        )),
                  ],
          ),
          child: Icon(
            icon ?? Icons.trending_up,
            color: effectiveColor,
            size: 24,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Value
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 18,
            fontWeight: FontWeight.w600, // M3 title medium
            color: isDark ? Colors.white : AppColors.lightTextPrimary,
            letterSpacing: 0,
            height: 1.2,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),

        // Label
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            letterSpacing: 0.4, // M3 body small
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );

    if (onTap == null) return content;

    return _TappableStatBadge(onTap: onTap!, child: content);
  }

  _StatBadgeColors _getVariantColors(bool isDark) {
    switch (variant) {
      case StatBadgeVariant.primary:
        return _StatBadgeColors(
          accentColor: isDark ? AppColors.primary : AppColors.lightPrimary,
          containerColor: isDark
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.lightPrimaryMuted,
          borderColor: AppColors.lightPrimaryBorder,
        );
      case StatBadgeVariant.secondary:
        return _StatBadgeColors(
          accentColor: isDark ? AppColors.secondary : AppColors.lightSecondary,
          containerColor: isDark
              ? AppColors.secondary.withValues(alpha: 0.1)
              : AppColors.lightSecondaryMuted,
          borderColor: AppColors.lightSecondaryBorder,
        );
      case StatBadgeVariant.success:
        return _StatBadgeColors(
          accentColor: isDark ? AppColors.success : AppColors.lightSuccess,
          containerColor: isDark
              ? AppColors.success.withValues(alpha: 0.1)
              : AppColors.lightSuccessMuted,
          borderColor: AppColors.lightSuccessBorder,
        );
      case StatBadgeVariant.warning:
        return _StatBadgeColors(
          accentColor: isDark ? AppColors.warning : AppColors.lightWarning,
          containerColor: isDark
              ? AppColors.warning.withValues(alpha: 0.1)
              : AppColors.lightWarningMuted,
          borderColor: AppColors.lightWarningBorder,
        );
      case StatBadgeVariant.danger:
        return _StatBadgeColors(
          accentColor: isDark ? AppColors.danger : AppColors.lightDanger,
          containerColor: isDark
              ? AppColors.danger.withValues(alpha: 0.1)
              : AppColors.lightDangerMuted,
          borderColor: AppColors.lightDangerBorder,
        );
      case StatBadgeVariant.neutral:
        return _StatBadgeColors(
          accentColor: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
          containerColor: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : AppColors.lightSurfaceContainerHigh,
          borderColor: AppColors.lightBorderVariant,
        );
    }
  }
}

class _StatBadgeColors {
  final Color accentColor;
  final Color containerColor;
  final Color borderColor;

  const _StatBadgeColors({
    required this.accentColor,
    required this.containerColor,
    required this.borderColor,
  });
}

class _TappableStatBadge extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;

  const _TappableStatBadge({
    required this.onTap,
    required this.child,
  });

  @override
  State<_TappableStatBadge> createState() => _TappableStatBadgeState();
}

class _TappableStatBadgeState extends State<_TappableStatBadge>
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: widget.child,
        ),
      ),
    );
  }
}
