import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/smart_feature_models.dart';

/// Legend showing the 3 forecast scenarios with descriptions
class ScenarioLegend extends StatelessWidget {
  final ForecastScenario? selectedScenario;
  final ValueChanged<ForecastScenario?>? onScenarioSelected;
  final ForecastData? forecastData;

  const ScenarioLegend({
    super.key,
    this.selectedScenario,
    this.onScenarioSelected,
    this.forecastData,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        _ScenarioChip(
          label: 'متفائل',
          description: 'مصروفات أقل',
          color: isDark ? AppColors.success : AppColors.lightSuccess,
          isSelected: selectedScenario == ForecastScenario.optimistic,
          isDark: isDark,
          onTap: () {
            onScenarioSelected?.call(
              selectedScenario == ForecastScenario.optimistic
                  ? null
                  : ForecastScenario.optimistic,
            );
          },
        ),
        _ScenarioChip(
          label: 'واقعي',
          description: 'متوسط الإنفاق',
          color: isDark ? AppColors.primary : AppColors.lightPrimary,
          isSelected: selectedScenario == ForecastScenario.realistic,
          isDark: isDark,
          onTap: () {
            onScenarioSelected?.call(
              selectedScenario == ForecastScenario.realistic
                  ? null
                  : ForecastScenario.realistic,
            );
          },
        ),
        _ScenarioChip(
          label: 'متشائم',
          description: 'مصروفات أعلى',
          color: isDark ? AppColors.danger : AppColors.lightDanger,
          isSelected: selectedScenario == ForecastScenario.pessimistic,
          isDark: isDark,
          onTap: () {
            onScenarioSelected?.call(
              selectedScenario == ForecastScenario.pessimistic
                  ? null
                  : ForecastScenario.pessimistic,
            );
          },
        ),
      ],
    );
  }
}

class _ScenarioChip extends StatelessWidget {
  final String label;
  final String description;
  final Color color;
  final bool isSelected;
  final bool isDark;
  final VoidCallback? onTap;

  const _ScenarioChip({
    required this.label,
    required this.description,
    required this.color,
    required this.isSelected,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : (isDark
                  ? AppColors.surfaceLight.withValues(alpha: 0.3)
                  : AppColors.lightSurfaceContainerLow),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isSelected
                ? color
                : (isDark
                    ? AppColors.surfaceLight
                    : AppColors.lightSurfaceContainerHighest),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? color
                        : (isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary),
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact inline legend for smaller spaces
class ScenarioLegendCompact extends StatelessWidget {
  const ScenarioLegendCompact({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendDot(
          color: isDark ? AppColors.success : AppColors.lightSuccess,
          label: 'متفائل',
          isDark: isDark,
        ),
        const SizedBox(width: AppSpacing.lg),
        _LegendDot(
          color: isDark ? AppColors.primary : AppColors.lightPrimary,
          label: 'واقعي',
          isDark: isDark,
        ),
        const SizedBox(width: AppSpacing.lg),
        _LegendDot(
          color: isDark ? AppColors.danger : AppColors.lightDanger,
          label: 'متشائم',
          isDark: isDark,
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  final bool isDark;

  const _LegendDot({
    required this.color,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
