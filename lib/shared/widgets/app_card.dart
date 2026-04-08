import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final Color? borderColor;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.gradient,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.3)
        : Colors.black.withValues(alpha: 0.1);
    final borderAlpha = isDark ? 0.06 : 0.05;
    final defaultGradient =
        isDark ? AppColors.cardGradient : AppColors.cardGradientLight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient ?? defaultGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor ??
                (isDark ? Colors.white : Colors.black)
                    .withValues(alpha: borderAlpha),
          ),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
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

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.blur = 12,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Adjust blur, tint, and border based on brightness
    final effectiveBlur = isDark ? blur : (blur * 0.67); // Reduce blur in light mode
    final effectiveTint = isDark
        ? (tint ?? AppColors.surface)
        : (tint ?? AppColors.lightSurfaceLight);
    final effectiveTintAlpha = isDark ? 0.5 : 0.3;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.1);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: effectiveBlur, sigmaY: effectiveBlur),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: effectiveTint.withValues(alpha: effectiveTintAlpha),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
          ),
          child: child,
        ),
      ),
    );
  }
}
