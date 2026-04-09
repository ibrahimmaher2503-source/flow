import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/smart_feature_models.dart';

/// Filter chips for insights screen
class InsightFilter extends StatelessWidget {
  final InsightType? selectedType;
  final int? selectedPriority;
  final ValueChanged<InsightType?>? onTypeChanged;
  final ValueChanged<int?>? onPriorityChanged;

  const InsightFilter({
    super.key,
    this.selectedType,
    this.selectedPriority,
    this.onTypeChanged,
    this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          // All filter
          _FilterChip(
            label: 'الكل',
            isSelected: selectedType == null && selectedPriority == null,
            isDark: isDark,
            onTap: () {
              onTypeChanged?.call(null);
              onPriorityChanged?.call(null);
            },
          ),
          const SizedBox(width: AppSpacing.sm),

          // Priority filters
          _FilterChip(
            label: 'مهم',
            icon: Icons.priority_high_rounded,
            isSelected: selectedPriority == 1,
            color: isDark ? AppColors.danger : AppColors.lightDanger,
            isDark: isDark,
            onTap: () {
              onPriorityChanged?.call(selectedPriority == 1 ? null : 1);
              onTypeChanged?.call(null);
            },
          ),
          const SizedBox(width: AppSpacing.sm),

          // Type filters
          _FilterChip(
            label: 'إنفاق',
            icon: Icons.trending_up_rounded,
            isSelected: selectedType == InsightType.spendingSpike,
            isDark: isDark,
            onTap: () => onTypeChanged?.call(
              selectedType == InsightType.spendingSpike
                  ? null
                  : InsightType.spendingSpike,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          _FilterChip(
            label: 'توفير',
            icon: Icons.savings_rounded,
            isSelected: selectedType == InsightType.savingsOpportunity,
            color: isDark ? AppColors.success : AppColors.lightSuccess,
            isDark: isDark,
            onTap: () => onTypeChanged?.call(
              selectedType == InsightType.savingsOpportunity
                  ? null
                  : InsightType.savingsOpportunity,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          _FilterChip(
            label: 'Streak',
            icon: Icons.local_fire_department_rounded,
            isSelected: selectedType == InsightType.streak,
            color: isDark ? AppColors.warning : AppColors.lightWarning,
            isDark: isDark,
            onTap: () => onTypeChanged?.call(
              selectedType == InsightType.streak ? null : InsightType.streak,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          _FilterChip(
            label: 'ملخص',
            icon: Icons.summarize_rounded,
            isSelected: selectedType == InsightType.monthlySummary,
            isDark: isDark,
            onTap: () => onTypeChanged?.call(
              selectedType == InsightType.monthlySummary
                  ? null
                  : InsightType.monthlySummary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          _FilterChip(
            label: 'غير عادي',
            icon: Icons.warning_amber_rounded,
            isSelected: selectedType == InsightType.unusualTransaction,
            isDark: isDark,
            onTap: () => onTypeChanged?.call(
              selectedType == InsightType.unusualTransaction
                  ? null
                  : InsightType.unusualTransaction,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final Color? color;
  final bool isDark;
  final VoidCallback? onTap;

  const _FilterChip({
    required this.label,
    this.icon,
    required this.isSelected,
    this.color,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor =
        color ?? (isDark ? AppColors.primary : AppColors.lightPrimary);

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
              ? chipColor.withValues(alpha: 0.15)
              : (isDark
                  ? AppColors.surfaceLight.withValues(alpha: 0.3)
                  : AppColors.lightSurfaceContainerLow),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isSelected
                ? chipColor
                : (isDark
                    ? AppColors.surfaceLight
                    : AppColors.lightSurfaceContainerHighest),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: isSelected
                    ? chipColor
                    : (isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary),
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? chipColor
                    : (isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Time period filter for insights grouping
class InsightPeriodFilter extends StatelessWidget {
  final String selectedPeriod;
  final ValueChanged<String>? onPeriodChanged;

  const InsightPeriodFilter({
    super.key,
    this.selectedPeriod = 'all',
    this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        _PeriodChip(
          label: 'هذا الأسبوع',
          isSelected: selectedPeriod == 'week',
          isDark: isDark,
          onTap: () => onPeriodChanged?.call('week'),
        ),
        const SizedBox(width: AppSpacing.sm),
        _PeriodChip(
          label: 'هذا الشهر',
          isSelected: selectedPeriod == 'month',
          isDark: isDark,
          onTap: () => onPeriodChanged?.call('month'),
        ),
        const SizedBox(width: AppSpacing.sm),
        _PeriodChip(
          label: 'سابقة',
          isSelected: selectedPeriod == 'previous',
          isDark: isDark,
          onTap: () => onPeriodChanged?.call('previous'),
        ),
      ],
    );
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback? onTap;

  const _PeriodChip({
    required this.label,
    required this.isSelected,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = isDark ? AppColors.primary : AppColors.lightPrimary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor
              : (isDark
                  ? AppColors.surfaceLight.withValues(alpha: 0.3)
                  : AppColors.lightSurfaceContainerLow),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
