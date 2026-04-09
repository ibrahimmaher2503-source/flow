import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/forecast_provider.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../../forecast/widgets/forecast_chart.dart';

/// Mini forecast card for dashboard showing 7-day sparkline
class ForecastMiniCard extends ConsumerWidget {
  final VoidCallback? onTap;

  const ForecastMiniCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final forecastAsync = ref.watch(forecastProvider);
    final hasDangerAsync = ref.watch(forecastDangerProvider);

    return GestureDetector(
      onTap: onTap ?? () => Navigator.pushNamed(context, '/forecast'),
      child: AppCard(
        variant: AppCardVariant.surface,
        child: forecastAsync.when(
          loading: () => const LoadingShimmer(height: 80),
          error: (e, st) => _buildError(isDark),
          data: (forecast) {
            if (forecast.days.isEmpty) {
              return _buildEmpty(isDark);
            }

            final hasDanger = hasDangerAsync.valueOrNull ?? false;
            final summary = forecast.summary;
            final sparklineData = forecast.days
                .take(7)
                .map((d) => d.realisticBalance)
                .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      Icons.show_chart_rounded,
                      color: hasDanger
                          ? (isDark ? AppColors.danger : AppColors.lightDanger)
                          : (isDark ? AppColors.primary : AppColors.lightPrimary),
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'توقعات 7 أيام',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                      size: 14,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Sparkline
                ForecastSparkline(
                  data: sparklineData,
                  height: 40,
                  showDanger: hasDanger,
                ),
                const SizedBox(height: AppSpacing.md),

                // Summary row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'نهاية الشهر',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          CurrencyFormatter.formatCompact(
                              summary.expectedMonthEndBalance),
                          style: TextStyle(
                            color: summary.expectedMonthEndBalance >= 0
                                ? (isDark
                                    ? AppColors.success
                                    : AppColors.lightSuccess)
                                : (isDark
                                    ? AppColors.danger
                                    : AppColors.lightDanger),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    if (hasDanger)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (isDark
                                  ? AppColors.danger
                                  : AppColors.lightDanger)
                              .withValues(alpha: 0.15),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: isDark
                                  ? AppColors.danger
                                  : AppColors.lightDanger,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'خطر',
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.danger
                                    : AppColors.lightDanger,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'أيام الأمان',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            summary.safetyDays >= 30
                                ? '30+'
                                : '${summary.safetyDays}',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.success
                                  : AppColors.lightSuccess,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildError(bool isDark) {
    return Row(
      children: [
        Icon(
          Icons.show_chart_rounded,
          color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          size: 20,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            'خطأ في تحميل التوقعات',
            style: TextStyle(
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty(bool isDark) {
    return Row(
      children: [
        Icon(
          Icons.show_chart_rounded,
          color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          size: 20,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'توقعات الميزانية',
                style: TextStyle(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'سجل معاملات لتفعيل التوقعات',
                style: TextStyle(
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.arrow_forward_ios_rounded,
          color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          size: 14,
        ),
      ],
    );
  }
}

/// Compact forecast warning banner
class ForecastWarningBanner extends ConsumerWidget {
  const ForecastWarningBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final forecastAsync = ref.watch(forecastProvider);

    return forecastAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, st) => const SizedBox.shrink(),
      data: (forecast) {
        if (forecast.warnings.isEmpty) return const SizedBox.shrink();

        final warning = forecast.warnings.first;
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/forecast'),
          child: Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (isDark ? AppColors.danger : AppColors.lightDanger)
                      .withValues(alpha: 0.15),
                  (isDark ? AppColors.warning : AppColors.lightWarning)
                      .withValues(alpha: 0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color: (isDark ? AppColors.danger : AppColors.lightDanger)
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.trending_down_rounded,
                  color: isDark ? AppColors.danger : AppColors.lightDanger,
                  size: 24,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    warning.messageAr,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                      fontSize: 12,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  size: 14,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
