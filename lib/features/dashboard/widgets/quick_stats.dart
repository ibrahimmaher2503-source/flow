import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/stats_provider.dart';
import '../../../providers/installment_provider.dart';
import '../../../l10n/generated/app_localizations.dart';

class QuickStats extends ConsumerWidget {
  const QuickStats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyAvg = ref.watch(dailyAverageProvider);
    final topCat = ref.watch(topCategoryProvider);
    final interestPaid = ref.watch(totalInterestPaidProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    // M3 semantic colors for light/dark themes
    final warningColor = isDark ? AppColors.warning : AppColors.lightWarning;
    final accentColor = isDark ? AppColors.accent : AppColors.lightAccent;
    final installmentColor = isDark ? AppColors.installment : AppColors.lightInstallment;

    return Row(
      children: [
        Expanded(
          child: _QuickStatCard(
            label: l10n.dailyAverage,
            value: dailyAvg.when(
              data: (v) => CurrencyFormatter.formatCompact(v),
              loading: () => '...',
              error: (_, __) => '--',
            ),
            icon: Icons.show_chart_rounded,
            color: warningColor,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _QuickStatCard(
            label: l10n.topCategory,
            value: topCat.when(
              data: (v) => v ?? l10n.noData,
              loading: () => '...',
              error: (_, __) => '--',
            ),
            icon: Icons.pie_chart_rounded,
            color: accentColor,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _QuickStatCard(
            label: l10n.interestPaid,
            value: interestPaid.when(
              data: (v) => CurrencyFormatter.formatCompact(v),
              loading: () => '...',
              error: (_, __) => '--',
            ),
            icon: Icons.percent_rounded,
            color: installmentColor,
            isDark: isDark,
          ),
        ),
      ],
    );
  }
}

class _QuickStatCard extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _QuickStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  State<_QuickStatCard> createState() => _QuickStatCardState();
}

class _QuickStatCardState extends State<_QuickStatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    // For light theme, use surface containers with subtle accent
    final bgColor = widget.isDark
        ? widget.color.withValues(alpha: 0.12)
        : AppColors.lightSurfaceContainerLow;
    final borderColor = widget.isDark
        ? widget.color.withValues(alpha: 0.2)
        : widget.color.withValues(alpha: 0.15);
    final iconBgColor = widget.isDark
        ? widget.color.withValues(alpha: 0.2)
        : widget.color.withValues(alpha: 0.12);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.lg,
            horizontal: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: borderColor, width: 0.5),
            boxShadow: widget.isDark
                ? [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.1),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : AppColors.lightShadowSubtle,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with subtle background
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Icon(
                  widget.icon,
                  color: widget.color,
                  size: 20,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Value
              Text(
                widget.value,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: widget.isDark ? widget.color : AppColors.lightTextPrimary,
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),

              // Label
              Text(
                widget.label,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: widget.isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
