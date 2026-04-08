import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/installment_provider.dart';

class InstallmentSummaryCard extends ConsumerWidget {
  const InstallmentSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalDebt = ref.watch(totalDebtProvider);
    final monthlyTotal = ref.watch(monthlyInstallmentTotalProvider);
    final activePlans = ref.watch(activePlansProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg + 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  AppColors.installment.withValues(alpha: 0.15),
                  AppColors.surface.withValues(alpha: 0.9),
                ]
              : [
                  AppColors.installment.withValues(alpha: 0.08),
                  AppColors.lightSurface,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(
          color: AppColors.installment.withValues(alpha: isDark ? 0.2 : 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppColors.installment.withValues(alpha: isDark ? 0.12 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              // Icon with gradient background
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.installment.withValues(alpha: 0.25),
                      AppColors.installment.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: const Icon(
                  Icons.credit_card_rounded,
                  color: AppColors.installment,
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
                      'الأقساط',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color:
                            isDark ? Colors.white : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      'متابعة التقسيط والالتزامات',
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
                    color: AppColors.installment.withValues(alpha: 0.15),
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
                              ? AppColors.installment
                              : AppColors.textMuted,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${plans.length} نشطة',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.installment,
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
                    label: 'إجمالي الالتزامات',
                    value: totalDebt,
                    color: AppColors.installment,
                    isDark: isDark,
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.08),
                ),
                Expanded(
                  child: _StatColumn(
                    label: 'أقساط الشهر',
                    value: monthlyTotal,
                    color: AppColors.warning,
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
                child: _DebtProgress(plans: plans, isDark: isDark),
              );
            },
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
        ],
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

  const _DebtProgress({required this.plans, required this.isDark});

  @override
  Widget build(BuildContext context) {
    // Calculate average progress across all plans
    double totalProgress = 0;
    int validPlans = 0;

    for (final plan in plans) {
      if (plan.totalInstallments > 0) {
        final progress = plan.paidCount / plan.totalInstallments;
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
              'متوسط التقدم',
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
                color: AppColors.success,
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
                : Colors.black.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: AlignmentDirectional.centerStart,
            widthFactor: avgProgress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.success, AppColors.secondary],
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
