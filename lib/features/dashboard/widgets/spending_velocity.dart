import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/smart_feature_models.dart';

/// A compact indicator showing spending velocity (slow/normal/fast)
/// Uses color and icon to communicate spending pace vs historical average
class SpendingVelocityIndicator extends StatelessWidget {
  final SpendingVelocity velocity;
  final bool compact;

  const SpendingVelocityIndicator({
    super.key,
    required this.velocity,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.sm : AppSpacing.md,
        vertical: compact ? AppSpacing.xs : AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(isDark),
        borderRadius: BorderRadius.circular(AppSpacing.radiusCircle),
        border: Border.all(
          color: _getBorderColor(isDark),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIcon(),
            size: compact ? 14 : 18,
            color: _getIconColor(isDark),
          ),
          if (!compact) ...[
            const SizedBox(width: AppSpacing.xs),
            Text(
              _getLabel(),
              style: TextStyle(
                color: _getTextColor(isDark),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getBackgroundColor(bool isDark) {
    switch (velocity) {
      case SpendingVelocity.slow:
        return isDark
            ? AppColors.success.withValues(alpha: 0.15)
            : AppColors.lightSuccessMuted;
      case SpendingVelocity.normal:
        return isDark
            ? AppColors.primary.withValues(alpha: 0.15)
            : AppColors.lightPrimaryMuted;
      case SpendingVelocity.fast:
        return isDark
            ? AppColors.warning.withValues(alpha: 0.15)
            : AppColors.lightWarningMuted;
    }
  }

  Color _getBorderColor(bool isDark) {
    switch (velocity) {
      case SpendingVelocity.slow:
        return isDark
            ? AppColors.success.withValues(alpha: 0.3)
            : AppColors.lightSuccessBorder;
      case SpendingVelocity.normal:
        return isDark
            ? AppColors.primary.withValues(alpha: 0.3)
            : AppColors.lightPrimaryBorder;
      case SpendingVelocity.fast:
        return isDark
            ? AppColors.warning.withValues(alpha: 0.3)
            : AppColors.lightWarningBorder;
    }
  }

  Color _getIconColor(bool isDark) {
    switch (velocity) {
      case SpendingVelocity.slow:
        return isDark ? AppColors.success : AppColors.lightSuccess;
      case SpendingVelocity.normal:
        return isDark ? AppColors.primary : AppColors.lightPrimary;
      case SpendingVelocity.fast:
        return isDark ? AppColors.warning : AppColors.lightWarning;
    }
  }

  Color _getTextColor(bool isDark) => _getIconColor(isDark);

  IconData _getIcon() {
    switch (velocity) {
      case SpendingVelocity.slow:
        return Icons.trending_down_rounded;
      case SpendingVelocity.normal:
        return Icons.trending_flat_rounded;
      case SpendingVelocity.fast:
        return Icons.trending_up_rounded;
    }
  }

  String _getLabel() {
    switch (velocity) {
      case SpendingVelocity.slow:
        return 'بطيء';
      case SpendingVelocity.normal:
        return 'عادي';
      case SpendingVelocity.fast:
        return 'سريع';
    }
  }
}
