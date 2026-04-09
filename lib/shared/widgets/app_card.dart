import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final Color? borderColor;
  final Color? backgroundColor;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.gradient,
    this.borderColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Light mode: premium multi-layered shadows for depth perception
    final shadows = isDark
        ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ]
        : AppColors.lightShadowSubtle;

    final defaultGradient =
        isDark ? AppColors.cardGradient : AppColors.cardGradientLight;

    final effectiveBorder = borderColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.06)
            : AppColors.lightBorderLight);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: backgroundColor != null ? null : (gradient ?? defaultGradient),
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: effectiveBorder),
          boxShadow: shadows,
        ),
        child: child,
      ),
    );
  }
}

/// Premium glassmorphism card with blur effect
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double blur;
  final Color? tint;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.blur = 12,
    this.tint,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Light mode: refined glass effect with better visibility and premium feel
    final effectiveBlur = isDark ? blur : (blur * 0.6);  // Slightly more blur for premium effect
    final effectiveTint = isDark
        ? (tint ?? AppColors.surface)
        : (tint ?? AppColors.lightSurfaceEnhanced);  // Use enhanced surface
    final effectiveTintAlpha = isDark ? 0.5 : 0.88;  // Slightly more transparent for glass feel

    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : AppColors.lightBorderEnhanced;  // Enhanced border with brand tint

    // Light mode gets premium multi-layered shadow for depth
    final shadows = isDark
        ? <BoxShadow>[]
        : AppColors.lightShadowSubtle;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: effectiveBlur, sigmaY: effectiveBlur),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: effectiveTint.withValues(alpha: effectiveTintAlpha),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
              boxShadow: shadows,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
