import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Premium glassmorphism card with backdrop blur effect
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double blur;
  final Color? tint;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.blur = 10,
    this.tint,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBorderRadius = borderRadius ??
        BorderRadius.circular(AppSpacing.radiusLg);

    // Light mode: refined glass effect with premium feel and better visibility
    final effectiveBlur = isDark ? blur : (blur * 0.6);  // Slightly more blur for premium effect
    final effectiveTint = tint ?? (isDark ? Colors.white : AppColors.lightSurfaceEnhanced);
    final tintAlpha = isDark ? 0.1 : 0.88;  // Slightly more transparent for glass feel
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.2)
        : AppColors.lightBorderEnhanced;  // Enhanced border with brand tint

    // Light mode: premium multi-layered shadow for depth
    final shadows = isDark
        ? <BoxShadow>[]
        : AppColors.lightShadowSubtle;

    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: effectiveBlur, sigmaY: effectiveBlur),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: effectiveTint.withValues(alpha: tintAlpha),
              borderRadius: effectiveBorderRadius,
              border: Border.all(color: borderColor),
              boxShadow: shadows,
            ),
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
