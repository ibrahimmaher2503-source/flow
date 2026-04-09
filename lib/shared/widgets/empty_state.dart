import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? AppColors.textMuted : AppColors.lightTextMuted;  // Enhanced muted color
    final textColor = isDark
        ? AppColors.textSecondary
        : AppColors.lightTextSecondary;
    final iconBgColor = isDark
        ? AppColors.surface.withValues(alpha: 0.5)
        : AppColors.lightSurfaceLight;
    final buttonColor = isDark ? AppColors.primary : AppColors.lightPrimary;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with subtle background and enhanced styling
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
              border: isDark
                  ? null
                  : Border.all(color: AppColors.lightBorderEnhanced),  // Enhanced border
              boxShadow: isDark
                  ? null
                  : [
                      // Subtle shadow for light mode
                      BoxShadow(
                        color: AppColors.lightShadow,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Icon(icon, size: 48, color: iconColor),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 20),
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: buttonColor,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                actionLabel!,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                  color: buttonColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
