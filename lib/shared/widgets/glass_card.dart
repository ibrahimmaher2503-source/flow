import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Premium glassmorphism card with backdrop blur effect (M3 compatible)
/// This is the standalone version with full customization options
class GlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets padding;
  final double blur;
  final Color? tint;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool enablePressAnimation;

  /// Semantic color variant for the glass tint
  final GlassCardTint colorTint;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.blur = 10,
    this.tint,
    this.borderRadius,
    this.onTap,
    this.enablePressAnimation = true,
    this.colorTint = GlassCardTint.neutral,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

/// Semantic color tints for GlassCard
enum GlassCardTint {
  neutral,
  primary,
  secondary,
  success,
  warning,
  danger,
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

  Color _getTintColor(bool isDark) {
    if (widget.tint != null) return widget.tint!;

    switch (widget.colorTint) {
      case GlassCardTint.neutral:
        return isDark ? Colors.white : AppColors.lightSurfaceContainerLow;
      case GlassCardTint.primary:
        return isDark ? AppColors.primary : AppColors.lightPrimaryContainer;
      case GlassCardTint.secondary:
        return isDark ? AppColors.secondary : AppColors.lightSecondaryContainer;
      case GlassCardTint.success:
        return isDark ? AppColors.success : AppColors.lightSuccessContainer;
      case GlassCardTint.warning:
        return isDark ? AppColors.warning : AppColors.lightWarningContainer;
      case GlassCardTint.danger:
        return isDark ? AppColors.danger : AppColors.lightDangerContainer;
    }
  }

  Color _getBorderColor(bool isDark) {
    switch (widget.colorTint) {
      case GlassCardTint.neutral:
        return isDark
            ? Colors.white.withValues(alpha: 0.2)
            : AppColors.lightBorderVariant;
      case GlassCardTint.primary:
        return isDark
            ? AppColors.primary.withValues(alpha: 0.3)
            : AppColors.lightPrimaryBorder;
      case GlassCardTint.secondary:
        return isDark
            ? AppColors.secondary.withValues(alpha: 0.3)
            : AppColors.lightSecondaryBorder;
      case GlassCardTint.success:
        return isDark
            ? AppColors.success.withValues(alpha: 0.3)
            : AppColors.lightSuccessBorder;
      case GlassCardTint.warning:
        return isDark
            ? AppColors.warning.withValues(alpha: 0.3)
            : AppColors.lightWarningBorder;
      case GlassCardTint.danger:
        return isDark
            ? AppColors.danger.withValues(alpha: 0.3)
            : AppColors.lightDangerBorder;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBorderRadius = widget.borderRadius ??
        BorderRadius.circular(AppSpacing.radiusLg);

    // M3 light mode: more frosted, less transparent
    final effectiveBlur = isDark ? widget.blur : (widget.blur * 0.6);
    final effectiveTint = _getTintColor(isDark);
    final tintAlpha = isDark
        ? (widget.colorTint == GlassCardTint.neutral ? 0.1 : 0.15)
        : (widget.colorTint == GlassCardTint.neutral ? 0.94 : 0.85);

    // M3 border
    final borderColor = _getBorderColor(isDark);

    // M3 subtle shadows - enhanced for light theme
    final shadows = isDark
        ? <BoxShadow>[]
        : AppColors.lightShadowSubtle;

    final glassContent = ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: effectiveBlur, sigmaY: effectiveBlur),
        child: Container(
          decoration: BoxDecoration(
            color: effectiveTint.withValues(alpha: tintAlpha),
            borderRadius: effectiveBorderRadius,
            border: Border.all(color: borderColor, width: 0.5),
            boxShadow: shadows,
          ),
          child: Padding(
            padding: widget.padding,
            child: widget.child,
          ),
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
