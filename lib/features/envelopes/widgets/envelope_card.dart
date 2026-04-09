import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/icon_resolver.dart';
import '../../../data/models/smart_feature_models.dart';
import '../../../shared/widgets/app_card.dart';

/// Card displaying an envelope with fill indicator
class EnvelopeCard extends StatelessWidget {
  final EnvelopeWithSpent envelope;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const EnvelopeCard({
    super.key,
    required this.envelope,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _parseColor(envelope.envelope.colorHex) ??
        (isDark ? AppColors.primary : AppColors.lightPrimary);
    final statusColor = _getStatusColor(envelope.status, isDark);

    return AppCard(
      variant: AppCardVariant.elevated,
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    // Icon
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: Icon(
                        IconResolver.resolve(envelope.envelope.iconName),
                        color: color,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    // Name and category
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                envelope.envelope.name,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.textPrimary
                                      : AppColors.lightTextPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (envelope.envelope.isEssential) ...[
                                const SizedBox(width: AppSpacing.xs),
                                Icon(
                                  Icons.star_rounded,
                                  size: 14,
                                  color: isDark
                                      ? AppColors.warning
                                      : AppColors.lightWarning,
                                ),
                              ],
                            ],
                          ),
                          Text(
                            envelope.envelope.categoryName,
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // More menu
                    if (onEdit != null || onDelete != null)
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert_rounded,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                          size: 20,
                        ),
                        onSelected: (value) {
                          if (value == 'edit') onEdit?.call();
                          if (value == 'delete') onDelete?.call();
                        },
                        itemBuilder: (context) => [
                          if (onEdit != null)
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit_rounded, size: 18),
                                  SizedBox(width: AppSpacing.sm),
                                  Text('تعديل'),
                                ],
                              ),
                            ),
                          if (onDelete != null)
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete_outline_rounded,
                                    size: 18,
                                    color: isDark
                                        ? AppColors.danger
                                        : AppColors.lightDanger,
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text(
                                    'حذف',
                                    style: TextStyle(
                                      color: isDark
                                          ? AppColors.danger
                                          : AppColors.lightDanger,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                // Amounts row
                Row(
                  children: [
                    Expanded(
                      child: _AmountColumn(
                        label: 'المخصص',
                        amount: envelope.envelope.allocatedAmount,
                        isDark: isDark,
                      ),
                    ),
                    Expanded(
                      child: _AmountColumn(
                        label: 'المصروف',
                        amount: envelope.spentAmount,
                        isDark: isDark,
                        color: statusColor,
                      ),
                    ),
                    Expanded(
                      child: _AmountColumn(
                        label: 'المتبقي',
                        amount: envelope.remaining,
                        isDark: isDark,
                        color: statusColor,
                        bold: true,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                // Progress bar
                _EnvelopeProgressBar(
                  percentSpent: envelope.percentSpent,
                  status: envelope.status,
                  isDark: isDark,
                  color: color,
                ),

                const SizedBox(height: AppSpacing.sm),

                // Status text
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _getStatusText(envelope.status),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${(envelope.percentRemaining * 100).round()}% متبقي',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Rollover indicator
          if (envelope.envelope.rolloverEnabled)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surface.withValues(alpha: 0.5)
                    : AppColors.lightSurfaceContainerHigh,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(AppSpacing.radiusLg),
                  bottomRight: Radius.circular(AppSpacing.radiusLg),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.replay_rounded,
                    size: 14,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'الترحيل مفعّل',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(EnvelopeStatus status, bool isDark) {
    switch (status) {
      case EnvelopeStatus.healthy:
        return isDark ? AppColors.success : AppColors.lightSuccess;
      case EnvelopeStatus.warning:
        return isDark ? AppColors.warning : AppColors.lightWarning;
      case EnvelopeStatus.danger:
      case EnvelopeStatus.empty:
        return isDark ? AppColors.danger : AppColors.lightDanger;
    }
  }

  String _getStatusText(EnvelopeStatus status) {
    switch (status) {
      case EnvelopeStatus.healthy:
        return 'وضع جيد';
      case EnvelopeStatus.warning:
        return 'انتبه';
      case EnvelopeStatus.danger:
        return 'قارب على النفاد';
      case EnvelopeStatus.empty:
        return 'نفد الظرف';
    }
  }

  Color? _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    try {
      final colorHex = hex.replaceFirst('#', '');
      return Color(int.parse('FF$colorHex', radix: 16));
    } catch (_) {
      return null;
    }
  }
}

class _AmountColumn extends StatelessWidget {
  final String label;
  final double amount;
  final bool isDark;
  final Color? color;
  final bool bold;

  const _AmountColumn({
    required this.label,
    required this.amount,
    required this.isDark,
    this.color,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          CurrencyFormatter.format(amount.abs()),
          style: TextStyle(
            color: color ??
                (isDark ? AppColors.textPrimary : AppColors.lightTextPrimary),
            fontSize: 14,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _EnvelopeProgressBar extends StatelessWidget {
  final double percentSpent;
  final EnvelopeStatus status;
  final bool isDark;
  final Color color;

  const _EnvelopeProgressBar({
    required this.percentSpent,
    required this.status,
    required this.isDark,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final fillPercent = percentSpent.clamp(0.0, 1.0);
    final overflowPercent = percentSpent > 1.0 ? (percentSpent - 1.0).clamp(0.0, 0.3) : 0.0;

    return Column(
      children: [
        // Main progress bar
        Stack(
          children: [
            // Background
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceLight.withValues(alpha: 0.5)
                    : AppColors.lightSurfaceContainerHigh,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            // Fill
            FractionallySizedBox(
              widthFactor: fillPercent,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: _getFillColor(),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
        // Overflow indicator
        if (overflowPercent > 0) ...[
          const SizedBox(height: 2),
          Stack(
            children: [
              Container(
                height: 3,
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.danger : AppColors.lightDanger)
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              FractionallySizedBox(
                widthFactor: overflowPercent / 0.3,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.danger : AppColors.lightDanger,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Color _getFillColor() {
    switch (status) {
      case EnvelopeStatus.healthy:
        return color;
      case EnvelopeStatus.warning:
        return isDark ? AppColors.warning : AppColors.lightWarning;
      case EnvelopeStatus.danger:
      case EnvelopeStatus.empty:
        return isDark ? AppColors.danger : AppColors.lightDanger;
    }
  }
}
