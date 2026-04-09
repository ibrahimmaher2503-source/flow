import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Semantic card variants for different use cases
enum AppCardVariant {
  /// Default surface container
  surface,
  /// Elevated with more prominent shadows
  elevated,
  /// Filled with primary container color
  filled,
  /// Outlined with visible border
  outlined,
}

class AppCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final Color? borderColor;
  final Color? backgroundColor;
  final double borderRadius;
  final AppCardVariant variant;
  final bool enableHoverEffect;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.gradient,
    this.borderColor,
    this.backgroundColor,
    this.borderRadius = 16,
    this.variant = AppCardVariant.surface,
    this.enableHoverEffect = true,
  });

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Get variant-specific styling
    final (shadows, bgColor, border) = _getVariantStyling(isDark);

    final defaultGradient =
        isDark ? AppColors.cardGradient : AppColors.cardGradientLight;

    // Determine effective colors
    final effectiveBorder = widget.borderColor ?? border;
    final effectiveBgColor = widget.backgroundColor ?? bgColor;

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: widget.padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: widget.backgroundColor != null
            ? null
            : (widget.gradient ?? (isDark ? defaultGradient : null)),
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: effectiveBorder, width: 0.5),
        boxShadow: shadows,
      ),
      child: widget.child,
    );

    if (widget.onTap == null) return card;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: widget.enableHoverEffect ? (_) => _controller.forward() : null,
      onTapUp: widget.enableHoverEffect ? (_) => _controller.reverse() : null,
      onTapCancel: widget.enableHoverEffect ? () => _controller.reverse() : null,
      child: widget.enableHoverEffect
          ? AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) => Transform.scale(
                scale: _scaleAnimation.value,
                child: card,
              ),
            )
          : card,
    );
  }

  (List<BoxShadow>, Color?, Color) _getVariantStyling(bool isDark) {
    switch (widget.variant) {
      case AppCardVariant.surface:
        return (
          isDark
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ]
              : AppColors.lightShadowSubtle,
          isDark ? null : AppColors.lightSurfaceContainerLow,
          isDark
              ? Colors.white.withValues(alpha: 0.06)
              : AppColors.lightBorderVariant,
        );

      case AppCardVariant.elevated:
        return (
          isDark
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 32,
                    offset: const Offset(0, 12),
                  ),
                ]
              : AppColors.lightShadowMediumLevel,
          isDark ? AppColors.surfaceLight : AppColors.lightSurface,
          isDark
              ? Colors.white.withValues(alpha: 0.08)
              : AppColors.lightBorderVariant,
        );

      case AppCardVariant.filled:
        return (
          isDark
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: AppColors.lightPrimary.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                  ...AppColors.lightShadowSubtle,
                ],
          isDark
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.lightPrimaryContainer,
          isDark
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.lightPrimaryBorder,
        );

      case AppCardVariant.outlined:
        return (
          <BoxShadow>[],
          isDark ? Colors.transparent : Colors.transparent,
          isDark
              ? Colors.white.withValues(alpha: 0.12)
              : AppColors.lightBorder,
        );
    }
  }
}

/// Premium glassmorphism card with blur effect (M3 compatible)
/// Supports both dark and light themes with appropriate styling
class GlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double blur;
  final Color? tint;
  final VoidCallback? onTap;
  final double borderRadius;
  final bool enablePressAnimation;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.blur = 12,
    this.tint,
    this.onTap,
    this.borderRadius = 16,
    this.enablePressAnimation = true,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // M3 light mode: refined glass effect using surface containers
    final effectiveBlur = isDark ? widget.blur : (widget.blur * 0.6);

    // Light theme uses a more solid, frosted appearance
    final effectiveTint = widget.tint ??
        (isDark ? AppColors.surface : AppColors.lightSurfaceContainerLow);
    final effectiveTintAlpha = isDark ? 0.5 : 0.94;

    // M3 border using outlineVariant - slightly more visible in light theme
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : AppColors.lightBorderVariant;

    // M3 subtle shadows - enhanced for light theme depth
    final shadows = isDark
        ? <BoxShadow>[]
        : [
            // Ambient shadow
            BoxShadow(
              color: AppColors.lightShadow,
              blurRadius: 16,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
            // Subtle inner glow for glass effect
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.5),
              blurRadius: 0,
              offset: const Offset(0, 0.5),
              spreadRadius: 0,
            ),
          ];

    final glassContent = ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: effectiveBlur, sigmaY: effectiveBlur),
        child: Container(
          padding: widget.padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: effectiveTint.withValues(alpha: effectiveTintAlpha),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(color: borderColor, width: 0.5),
            boxShadow: shadows,
          ),
          child: widget.child,
        ),
      ),
    );

    if (widget.onTap == null) return glassContent;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: widget.enablePressAnimation ? (_) => _controller.forward() : null,
      onTapUp: widget.enablePressAnimation ? (_) => _controller.reverse() : null,
      onTapCancel: widget.enablePressAnimation ? () => _controller.reverse() : null,
      child: widget.enablePressAnimation
          ? AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) => Transform.scale(
                scale: _scaleAnimation.value,
                child: glassContent,
              ),
            )
          : glassContent,
    );
  }
}
