import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/services/envelope_service.dart';
import '../../../providers/envelope_provider.dart';

/// Summary bar showing total envelope status
class EnvelopeSummaryBar extends ConsumerWidget {
  const EnvelopeSummaryBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final summaryAsync = ref.watch(envelopeSummaryProvider);

    return summaryAsync.when(
      loading: () => const _LoadingBar(),
      error: (e, st) => const SizedBox.shrink(),
      data: (summary) => _SummaryContent(summary: summary, isDark: isDark),
    );
  }
}

class _SummaryContent extends StatelessWidget {
  final EnvelopeSummary summary;
  final bool isDark;

  const _SummaryContent({
    required this.summary,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final healthColor = summary.isHealthy
        ? (isDark ? AppColors.success : AppColors.lightSuccess)
        : summary.overspentCount > 0
            ? (isDark ? AppColors.danger : AppColors.lightDanger)
            : (isDark ? AppColors.warning : AppColors.lightWarning);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        // Solid color - no gradients for cleaner design
        color: isDark ? AppColors.primary : AppColors.lightPrimary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.primary.withValues(alpha: 0.2)
                : AppColors.lightPrimary.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main stats row
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  label: 'المخصص',
                  value: CurrencyFormatter.formatCompact(summary.totalAllocated),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              Expanded(
                child: _StatItem(
                  label: 'المصروف',
                  value: CurrencyFormatter.formatCompact(summary.totalSpent),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              Expanded(
                child: _StatItem(
                  label: 'المتبقي',
                  value: CurrencyFormatter.formatCompact(summary.totalRemaining),
                  highlight: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Progress bar
          Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: summary.percentSpent.clamp(0.0, 1.0),
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          // Status row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(summary.percentSpent * 100).round()}% مصروف',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: healthColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    _getStatusText(summary),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getStatusText(EnvelopeSummary summary) {
    if (summary.overspentCount > 0) {
      return '${summary.overspentCount} ظرف نفد';
    }
    if (summary.warningCount > 0) {
      return '${summary.warningCount} ظرف قارب على النفاد';
    }
    return 'كل الأظرف بخير';
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _StatItem({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: highlight ? 20 : 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _LoadingBar extends StatelessWidget {
  const _LoadingBar();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceLight
            : AppColors.lightSurfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

/// Compact version for dashboard
class EnvelopeSummaryCompact extends ConsumerWidget {
  final VoidCallback? onTap;

  const EnvelopeSummaryCompact({super.key, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final summaryAsync = ref.watch(envelopeSummaryProvider);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceLight.withValues(alpha: 0.5)
              : AppColors.lightSurfaceContainerLow,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isDark
                ? AppColors.surfaceLight
                : AppColors.lightSurfaceContainerHighest,
          ),
        ),
        child: summaryAsync.when(
          loading: () => const SizedBox(
            height: 40,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (e, st) => const Text('خطأ'),
          data: (summary) => Row(
            children: [
              Icon(
                Icons.wallet_rounded,
                color: isDark ? AppColors.primary : AppColors.lightPrimary,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الأظرف',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${summary.envelopeCount} ظرف',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                CurrencyFormatter.formatCompact(summary.totalRemaining),
                style: TextStyle(
                  color: isDark ? AppColors.success : AppColors.lightSuccess,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
