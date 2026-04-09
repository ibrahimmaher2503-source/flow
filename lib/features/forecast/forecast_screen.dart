import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/models/smart_feature_models.dart';
import '../../providers/forecast_provider.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/loading_shimmer.dart';
import 'widgets/forecast_chart.dart';
import 'widgets/scenario_legend.dart';
import 'widgets/assumptions_card.dart';

/// Cash flow forecast screen - 30-day financial projection
class ForecastScreen extends ConsumerStatefulWidget {
  const ForecastScreen({super.key});

  @override
  ConsumerState<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends ConsumerState<ForecastScreen> {
  ForecastScenario? _selectedScenario;
  int? _selectedDayIndex;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final forecastAsync = ref.watch(forecastProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.background : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surface : AppColors.lightSurface,
        title: Text(
          'توقعات الميزانية',
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh_rounded,
              color: isDark ? AppColors.primary : AppColors.lightPrimary,
            ),
            onPressed: () {
              refreshForecast(ref);
            },
          ),
        ],
      ),
      body: forecastAsync.when(
        loading: () => _buildLoading(isDark),
        error: (e, _) => _buildError(e.toString(), isDark),
        data: (forecast) {
          if (forecast.days.isEmpty) {
            return _buildEmpty(isDark);
          }
          return _buildContent(forecast, isDark);
        },
      ),
    );
  }

  Widget _buildLoading(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const LoadingShimmer(height: 200),
          const SizedBox(height: AppSpacing.lg),
          const LoadingShimmer(height: 100),
          const SizedBox(height: AppSpacing.lg),
          const LoadingShimmer(height: 80),
        ],
      ),
    );
  }

  Widget _buildError(String error, bool isDark) {
    return Center(
      child: EmptyState(
        icon: Icons.error_outline_rounded,
        message: 'حدث خطأ',
        subtitle: error,
        variant: EmptyStateVariant.warning,
      ),
    );
  }

  Widget _buildEmpty(bool isDark) {
    return Center(
      child: EmptyState(
        icon: Icons.show_chart_rounded,
        message: 'لا توجد بيانات كافية',
        subtitle: 'سجل معاملاتك لتظهر التوقعات',
        variant: EmptyStateVariant.neutral,
      ),
    );
  }

  Widget _buildContent(ForecastData forecast, bool isDark) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(forecastProvider);
      },
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // Summary card
          _buildSummaryCard(forecast, isDark),
          const SizedBox(height: AppSpacing.lg),

          // Warnings
          if (forecast.warnings.isNotEmpty) ...[
            _buildWarnings(forecast.warnings, isDark),
            const SizedBox(height: AppSpacing.lg),
          ],

          // Chart
          AppCard(
            variant: AppCardVariant.elevated,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'توقعات 30 يوم',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ScenarioLegend(
                  selectedScenario: _selectedScenario,
                  onScenarioSelected: (scenario) {
                    setState(() => _selectedScenario = scenario);
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                ForecastChart(
                  days: forecast.days,
                  selectedScenario: _selectedScenario,
                  onDaySelected: (index) {
                    setState(() => _selectedDayIndex = index);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Selected day details
          if (_selectedDayIndex != null &&
              _selectedDayIndex! < forecast.days.length) ...[
            _buildDayDetails(forecast.days[_selectedDayIndex!], isDark),
            const SizedBox(height: AppSpacing.lg),
          ],

          // Upcoming events
          _buildUpcomingEvents(forecast.days, isDark),
          const SizedBox(height: AppSpacing.lg),

          // Assumptions
          AssumptionsCard(assumptions: forecast.assumptions),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(ForecastData forecast, bool isDark) {
    final summary = forecast.summary;
    final isPositive = summary.expectedMonthEndBalance >= 0;

    return AppCard(
      variant: AppCardVariant.filled,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'المتوقع نهاية الشهر',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      CurrencyFormatter.format(summary.expectedMonthEndBalance),
                      style: TextStyle(
                        color: isPositive
                            ? (isDark ? AppColors.success : AppColors.lightSuccess)
                            : (isDark ? AppColors.danger : AppColors.lightDanger),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isPositive
                      ? (isDark
                          ? AppColors.success.withValues(alpha: 0.15)
                          : AppColors.lightSuccess.withValues(alpha: 0.15))
                      : (isDark
                          ? AppColors.danger.withValues(alpha: 0.15)
                          : AppColors.lightDanger.withValues(alpha: 0.15)),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPositive
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  color: isPositive
                      ? (isDark ? AppColors.success : AppColors.lightSuccess)
                      : (isDark ? AppColors.danger : AppColors.lightDanger),
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              _SummaryItem(
                label: 'أيام الأمان',
                value: summary.safetyDays >= 30
                    ? '30+ يوم'
                    : '${summary.safetyDays} يوم',
                icon: Icons.shield_outlined,
                color: summary.safetyDays >= 14
                    ? (isDark ? AppColors.success : AppColors.lightSuccess)
                    : summary.safetyDays >= 7
                        ? (isDark ? AppColors.warning : AppColors.lightWarning)
                        : (isDark ? AppColors.danger : AppColors.lightDanger),
                isDark: isDark,
              ),
              const SizedBox(width: AppSpacing.lg),
              if (summary.nextObligation != null)
                _SummaryItem(
                  label: 'القادم',
                  value: summary.nextObligation!.name,
                  subValue: CurrencyFormatter.format(summary.nextObligation!.amount),
                  icon: Icons.event_rounded,
                  color: isDark ? AppColors.warning : AppColors.lightWarning,
                  isDark: isDark,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWarnings(List<ForecastWarning> warnings, bool isDark) {
    return Column(
      children: warnings.map((warning) {
        final color = warning.scenario == ForecastScenario.pessimistic
            ? (isDark ? AppColors.warning : AppColors.lightWarning)
            : (isDark ? AppColors.danger : AppColors.lightDanger);

        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: color,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  warning.messageAr,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDayDetails(ForecastDay day, bool isDark) {
    return AppCard(
      variant: AppCardVariant.outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(day.date),
                style: TextStyle(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => setState(() => _selectedDayIndex = null),
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _BalanceChip(
                label: 'متفائل',
                amount: day.optimisticBalance,
                color: isDark ? AppColors.success : AppColors.lightSuccess,
                isDark: isDark,
              ),
              const SizedBox(width: AppSpacing.sm),
              _BalanceChip(
                label: 'واقعي',
                amount: day.realisticBalance,
                color: isDark ? AppColors.primary : AppColors.lightPrimary,
                isDark: isDark,
              ),
              const SizedBox(width: AppSpacing.sm),
              _BalanceChip(
                label: 'متشائم',
                amount: day.pessimisticBalance,
                color: isDark ? AppColors.danger : AppColors.lightDanger,
                isDark: isDark,
              ),
            ],
          ),
          if (day.events.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              'الأحداث',
              style: TextStyle(
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...day.events.map((event) => _EventRow(event: event, isDark: isDark)),
          ],
        ],
      ),
    );
  }

  Widget _buildUpcomingEvents(List<ForecastDay> days, bool isDark) {
    final allEvents = <MapEntry<DateTime, ForecastEvent>>[];
    for (final day in days) {
      for (final event in day.events) {
        allEvents.add(MapEntry(day.date, event));
      }
    }

    if (allEvents.isEmpty) {
      return const SizedBox.shrink();
    }

    // Take first 5 events
    final upcomingEvents = allEvents.take(5).toList();

    return AppCard(
      variant: AppCardVariant.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الالتزامات القادمة',
            style: TextStyle(
              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...upcomingEvents.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _getEventColor(entry.value.type, isDark)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Icon(
                      _getEventIcon(entry.value.type),
                      color: _getEventColor(entry.value.type, isDark),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.value.name,
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          _formatDate(entry.key),
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
                  Text(
                    CurrencyFormatter.format(entry.value.amount),
                    style: TextStyle(
                      color: entry.value.type == ForecastEventType.income
                          ? (isDark ? AppColors.success : AppColors.lightSuccess)
                          : (isDark ? AppColors.danger : AppColors.lightDanger),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const days = ['أحد', 'إثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة', 'سبت'];
    return '${days[date.weekday % 7]} ${date.day}/${date.month}';
  }

  Color _getEventColor(ForecastEventType type, bool isDark) {
    switch (type) {
      case ForecastEventType.income:
        return isDark ? AppColors.success : AppColors.lightSuccess;
      case ForecastEventType.expense:
        return isDark ? AppColors.danger : AppColors.lightDanger;
      case ForecastEventType.installment:
        return isDark ? AppColors.warning : AppColors.lightWarning;
      case ForecastEventType.bill:
        return isDark ? AppColors.secondary : AppColors.lightSecondary;
    }
  }

  IconData _getEventIcon(ForecastEventType type) {
    switch (type) {
      case ForecastEventType.income:
        return Icons.arrow_downward_rounded;
      case ForecastEventType.expense:
        return Icons.arrow_upward_rounded;
      case ForecastEventType.installment:
        return Icons.credit_card_rounded;
      case ForecastEventType.bill:
        return Icons.receipt_long_rounded;
    }
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final String? subValue;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _SummaryItem({
    required this.label,
    required this.value,
    this.subValue,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                    fontSize: 10,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (subValue != null)
                  Text(
                    subValue!,
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceChip extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final bool isDark;

  const _BalanceChip({
    required this.label,
    required this.amount,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                fontSize: 10,
              ),
            ),
            Text(
              CurrencyFormatter.formatCompact(amount),
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventRow extends StatelessWidget {
  final ForecastEvent event;
  final bool isDark;

  const _EventRow({required this.event, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isExpense = event.type != ForecastEventType.income;
    final color = isExpense
        ? (isDark ? AppColors.danger : AppColors.lightDanger)
        : (isDark ? AppColors.success : AppColors.lightSuccess);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Icon(
            isExpense ? Icons.remove : Icons.add,
            color: color,
            size: 14,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              event.name,
              style: TextStyle(
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            CurrencyFormatter.format(event.amount),
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
