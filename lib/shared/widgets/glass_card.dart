import 'dart:ui';
import 'package:flutter/material.dart';
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

    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: (tint ?? (isDark ? Colors.white : Colors.black))
                  .withValues(alpha: isDark ? 0.1 : 0.05),
              borderRadius: effectiveBorderRadius,
              border: Border.all(
                color: Colors.white.withValues(
                  alpha: isDark ? 0.2 : 0.3,
                ),
              ),
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
