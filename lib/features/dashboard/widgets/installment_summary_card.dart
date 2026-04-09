import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/installment_provider.dart';
import '../../../l10n/generated/app_localizations.dart';

class InstallmentSummaryCard extends ConsumerWidget {
  const InstallmentSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalDebt = ref.watch(totalDebtProvider);
    final monthlyTotal = ref.watch(monthlyInstallmentTotalProvider);
    final activePlans = ref.watch(activePlansProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    // Use M3 surface containers for light theme
    final installmentColor = isDark ? AppColors.installment : AppColors.lightInstallment;

    // T080: Navigation to installments hub
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/installments'),
      child: Container(
      padding: const EdgeInsets.all(AppSpacing.lg + 2),
      decoration: BoxDecoration(
        color: isDark ? null : AppColors.lightSurfaceContainerLow,
        gradient: isDark
            ? LinearGradient(
                colors: [
                  AppColors.installment.withValues(alpha: 0.15),
                  AppColors.surface.withValues(alpha: 0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(
          color: isDark
              ? AppColors.installment.withValues(alpha: 0.2)
              : AppColors.lightBorderVariant,
          width: 0.5,
        ),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: AppColors.installment.withValues(alpha: 0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : AppColors.lightShadowSubtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              // Icon with subtle background
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: installmentColor.withValues(alpha: isDark ? 0.2 : 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Icon(
                  Icons.credit_card_rounded,
                  color: installmentColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.installmentsTitle,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color:
                            isDark ? Colors.white : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      l10n.installmentsTrackingDesc,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),

              // Active plans badge
              activePlans.when(
                data: (plans) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs + 2,
                  ),
                  decoration: BoxDecoration(
                    color: installmentColor.withValues(alpha: isDark ? 0.15 : 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusCircle),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: plans.isNotEmpty
                              ? installmentColor
                              : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.installmentsActive(plans.length),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: installmentColor,
                        ),
                      ),
                    ],
                  ),
                ),
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg + 4),

          // Stats row
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _StatColumn(
                    label: l10n.installmentsTotalObligations,
                    value: totalDebt,
                    color: installmentColor,
                    isDark: isDark,
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : AppColors.lightBorderVariant,
                ),
                Expanded(
                  child: _StatColumn(
                    label: l10n.installmentsMonthly,
                    value: monthlyTotal,
                    color: isDark ? AppColors.warning : AppColors.lightWarning,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
          ),

          // Progress indicator
          activePlans.when(
            data: (plans) {
              if (plans.isEmpty) return const SizedBox();
              return Padding(
                padding: const EdgeInsets.only(top: AppSpacing.md),
                child: _DebtProgress(plans: plans, isDark: isDark, l10n: l10n),
              );
            },
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final AsyncValue<double> value;
  final Color color;
  final bool isDark;

  const _StatColumn({
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        value.when(
          data: (v) => Text(
            CurrencyFormatter.format(v),
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          loading: () => Container(
            width: 80,
            height: 22,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          error: (_, __) => Text(
            '--',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class _DebtProgress extends StatelessWidget {
  final List<dynamic> plans;
  final bool isDark;
  final AppLocalizations l10n;

  const _DebtProgress({required this.plans, required this.isDark, required this.l10n});

  @override
  Widget build(BuildContext context) {
    // Calculate average progress across all plans
    double totalProgress = 0;
    int validPlans = 0;

    for (final plan in plans) {
      if (plan.totalInstallments > 0) {
        final progress = plan.paidInstallments / plan.totalInstallments;
        totalProgress += progress;
        validPlans++;
      }
    }

    final avgProgress = validPlans > 0 ? totalProgress / validPlans : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.installmentsAvgProgress,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
            Text(
              '${(avgProgress * 100).toInt()}%',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.success : AppColors.lightSuccess,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : AppColors.lightSurfaceContainerHighest,
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: AlignmentDirectional.centerStart,
            widthFactor: avgProgress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [AppColors.success, AppColors.secondary]
                      : [AppColors.lightSuccess, AppColors.lightSecondary],
                ),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
