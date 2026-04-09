import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/smart_feature_models.dart';
import '../../../shared/widgets/app_card.dart';

/// Expandable card showing forecast assumptions
class AssumptionsCard extends StatefulWidget {
  final ForecastAssumptions assumptions;
  final bool initiallyExpanded;

  const AssumptionsCard({
    super.key,
    required this.assumptions,
    this.initiallyExpanded = false,
  });

  @override
  State<AssumptionsCard> createState() => _AssumptionsCardState();
}

class _AssumptionsCardState extends State<AssumptionsCard>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final assumptions = widget.assumptions;

    return AppCard(
      variant: AppCardVariant.outlined,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Header (always visible)
          InkWell(
            onTap: _toggleExpanded,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Icon(
                    Icons.tune_rounded,
                    color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'افتراضات التوقع',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  RotationTransition(
                    turns: Tween(begin: 0.0, end: 0.5).animate(_expandAnimation),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? AppColors.surfaceLight
                        : AppColors.lightSurfaceContainerHighest,
                  ),
                ),
              ),
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Daily spending assumptions
                  Text(
                    'المصروفات اليومية المتوقعة',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _SpendingRow(
                    label: 'متفائل',
                    amount: assumptions.dailySpendingOptimistic,
                    color: isDark ? AppColors.success : AppColors.lightSuccess,
                    isDark: isDark,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _SpendingRow(
                    label: 'واقعي',
                    amount: assumptions.dailySpendingRealistic,
                    color: isDark ? AppColors.primary : AppColors.lightPrimary,
                    isDark: isDark,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _SpendingRow(
                    label: 'متشائم',
                    amount: assumptions.dailySpendingPessimistic,
                    color: isDark ? AppColors.danger : AppColors.lightDanger,
                    isDark: isDark,
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Included recurring
                  if (assumptions.includedRecurring.isNotEmpty) ...[
                    Text(
                      'المعاملات المتكررة (${assumptions.includedRecurring.length})',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: assumptions.includedRecurring.map((name) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.surfaceLight.withValues(alpha: 0.5)
                                : AppColors.lightSurfaceContainerLow,
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: Text(
                            name,
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                              fontSize: 11,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // Included installments
                  if (assumptions.includedInstallments.isNotEmpty) ...[
                    Text(
                      'الأقساط (${assumptions.includedInstallments.length})',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: assumptions.includedInstallments.map((name) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.warning.withValues(alpha: 0.15)
                                : AppColors.lightWarning.withValues(alpha: 0.15),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: Text(
                            name,
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.warning
                                  : AppColors.lightWarning,
                              fontSize: 11,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.md),

                  // Info note
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceLight.withValues(alpha: 0.3)
                          : AppColors.lightSurfaceContainerHigh,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 14,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'بناءً على مصروفاتك في آخر 3 شهور',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpendingRow extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final bool isDark;

  const _SpendingRow({
    required this.label,
    required this.amount,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: TextStyle(
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            fontSize: 12,
          ),
        ),
        const Spacer(),
        Text(
          '${CurrencyFormatter.format(amount)}/يوم',
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
