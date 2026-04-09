import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/smart_feature_models.dart';
import '../../../providers/safe_to_spend_provider.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import 'spending_velocity.dart';

/// Dashboard card showing safe-to-spend amount with expandable breakdown
class SafeToSpendCard extends ConsumerStatefulWidget {
  const SafeToSpendCard({super.key});

  @override
  ConsumerState<SafeToSpendCard> createState() => _SafeToSpendCardState();
}

class _SafeToSpendCardState extends ConsumerState<SafeToSpendCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _expandController.forward();
      } else {
        _expandController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final safeToSpendAsync = ref.watch(safeToSpendProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return safeToSpendAsync.when(
      loading: () => const _LoadingCard(),
      error: (error, stack) => _ErrorCard(error: error.toString()),
      data: (data) => _buildCard(context, data, isDark),
    );
  }

  Widget _buildCard(BuildContext context, SafeToSpendData data, bool isDark) {
    final healthColor = _getHealthColor(data.healthStatus, isDark);
    final healthBgColor = _getHealthBgColor(data.healthStatus, isDark);

    return AppCard(
      variant: AppCardVariant.elevated,
      onTap: _toggleExpanded,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Main content
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    // Icon container
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: healthBgColor,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: Icon(
                        _getHealthIcon(data.healthStatus),
                        color: healthColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    // Title and subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تقدر تصرف',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _getHealthLabel(data.healthStatus),
                            style: TextStyle(
                              color: healthColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Velocity indicator
                    SpendingVelocityIndicator(
                      velocity: data.velocity,
                      compact: true,
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                // Safe amount
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      CurrencyFormatter.format(data.safeAmount.abs()),
                      style: TextStyle(
                        color: data.isNegative
                            ? (isDark ? AppColors.danger : AppColors.lightDanger)
                            : (isDark ? AppColors.textPrimary : AppColors.lightTextPrimary),
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (data.isNegative) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.danger.withValues(alpha: 0.15)
                              : AppColors.lightDangerMuted,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Text(
                          'سالب',
                          style: TextStyle(
                            color: isDark ? AppColors.danger : AppColors.lightDanger,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                // Summary row
                Row(
                  children: [
                    _SummaryChip(
                      label: 'من ${CurrencyFormatter.formatCompact(data.totalBalance)}',
                      isDark: isDark,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _SummaryChip(
                      label: '${(data.percentOfBalance * 100).round()}% متاح',
                      isDark: isDark,
                      highlighted: true,
                      status: data.healthStatus,
                    ),
                  ],
                ),

                // Expand indicator
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isExpanded ? 'إخفاء التفاصيل' : 'عرض التفاصيل',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Expandable breakdown
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: _BreakdownSection(
              data: data,
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }

  Color _getHealthColor(HealthStatus status, bool isDark) {
    switch (status) {
      case HealthStatus.healthy:
        return isDark ? AppColors.success : AppColors.lightSuccess;
      case HealthStatus.caution:
        return isDark ? AppColors.warning : AppColors.lightWarning;
      case HealthStatus.danger:
        return isDark ? AppColors.danger : AppColors.lightDanger;
    }
  }

  Color _getHealthBgColor(HealthStatus status, bool isDark) {
    switch (status) {
      case HealthStatus.healthy:
        return isDark
            ? AppColors.success.withValues(alpha: 0.15)
            : AppColors.lightSuccessMuted;
      case HealthStatus.caution:
        return isDark
            ? AppColors.warning.withValues(alpha: 0.15)
            : AppColors.lightWarningMuted;
      case HealthStatus.danger:
        return isDark
            ? AppColors.danger.withValues(alpha: 0.15)
            : AppColors.lightDangerMuted;
    }
  }

  IconData _getHealthIcon(HealthStatus status) {
    switch (status) {
      case HealthStatus.healthy:
        return Icons.check_circle_outline_rounded;
      case HealthStatus.caution:
        return Icons.warning_amber_rounded;
      case HealthStatus.danger:
        return Icons.error_outline_rounded;
    }
  }

  String _getHealthLabel(HealthStatus status) {
    switch (status) {
      case HealthStatus.healthy:
        return 'وضع مريح';
      case HealthStatus.caution:
        return 'انتبه للمصروفات';
      case HealthStatus.danger:
        return 'احذر - ميزانية ضيقة';
    }
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final bool isDark;
  final bool highlighted;
  final HealthStatus? status;

  const _SummaryChip({
    required this.label,
    required this.isDark,
    this.highlighted = false,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    if (highlighted && status != null) {
      switch (status!) {
        case HealthStatus.healthy:
          bgColor = isDark
              ? AppColors.success.withValues(alpha: 0.15)
              : AppColors.lightSuccessMuted;
          textColor = isDark ? AppColors.success : AppColors.lightSuccess;
          break;
        case HealthStatus.caution:
          bgColor = isDark
              ? AppColors.warning.withValues(alpha: 0.15)
              : AppColors.lightWarningMuted;
          textColor = isDark ? AppColors.warning : AppColors.lightWarning;
          break;
        case HealthStatus.danger:
          bgColor = isDark
              ? AppColors.danger.withValues(alpha: 0.15)
              : AppColors.lightDangerMuted;
          textColor = isDark ? AppColors.danger : AppColors.lightDanger;
          break;
      }
    } else {
      bgColor = isDark
          ? AppColors.surfaceLight.withValues(alpha: 0.5)
          : AppColors.lightSurfaceContainerHigh;
      textColor = isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _BreakdownSection extends StatelessWidget {
  final SafeToSpendData data;
  final bool isDark;

  const _BreakdownSection({
    required this.data,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (data.breakdown.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Center(
          child: Text(
            'لا توجد التزامات هذا الشهر',
            style: TextStyle(
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surface.withValues(alpha: 0.3)
            : AppColors.lightSurfaceContainerHigh,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppSpacing.radiusLg),
          bottomRight: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Text(
              'الالتزامات',
              style: TextStyle(
                color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...data.breakdown.map((item) => _BreakdownItem(
                item: item,
                isDark: isDark,
              )),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}

class _BreakdownItem extends StatelessWidget {
  final ObligationItem item;
  final bool isDark;

  const _BreakdownItem({
    required this.item,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          // Type icon
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: _getTypeColor(isDark).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(
              _getTypeIcon(),
              color: _getTypeColor(isDark),
              size: 16,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Name and due date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (item.dueDate != null)
                  Text(
                    _formatDueDate(item.dueDate!),
                    style: TextStyle(
                      color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          // Amount
          Text(
            CurrencyFormatter.format(item.amount),
            style: TextStyle(
              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(bool isDark) {
    switch (item.type) {
      case ObligationType.installment:
        return isDark ? AppColors.installment : AppColors.lightInstallment;
      case ObligationType.recurring:
        return isDark ? AppColors.warning : AppColors.lightWarning;
      case ObligationType.goal:
        return isDark ? AppColors.secondary : AppColors.lightSecondary;
    }
  }

  IconData _getTypeIcon() {
    switch (item.type) {
      case ObligationType.installment:
        return Icons.credit_card_rounded;
      case ObligationType.recurring:
        return Icons.repeat_rounded;
      case ObligationType.goal:
        return Icons.flag_rounded;
    }
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) {
      return 'اليوم';
    } else if (difference == 1) {
      return 'بكره';
    } else if (difference < 7) {
      return 'بعد $difference أيام';
    } else {
      return '${date.day}/${date.month}';
    }
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      child: LoadingShimmer(
        height: 180,
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String error;

  const _ErrorCard({required this.error});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: isDark ? AppColors.danger : AppColors.lightDanger,
              size: 32,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'خطأ في حساب المبلغ المتاح',
              style: TextStyle(
                color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
