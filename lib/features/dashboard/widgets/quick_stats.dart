import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/stats_provider.dart';
import '../../../providers/installment_provider.dart';

class QuickStats extends ConsumerWidget {
  const QuickStats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyAvg = ref.watch(dailyAverageProvider);
    final topCat = ref.watch(topCategoryProvider);
    final interestPaid = ref.watch(totalInterestPaidProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: _QuickStatCard(
            label: 'متوسط يومي',
            value: dailyAvg.when(
              data: (v) => CurrencyFormatter.formatCompact(v),
              loading: () => '...',
              error: (_, __) => '--',
            ),
            icon: Icons.show_chart_rounded,
            color: AppColors.warning,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _QuickStatCard(
            label: 'أعلى فئة',
            value: topCat.when(
              data: (v) => v ?? 'لا يوجد',
              loading: () => '...',
              error: (_, __) => '--',
            ),
            icon: Icons.pie_chart_rounded,
            color: AppColors.accent,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _QuickStatCard(
            label: 'فوائد مدفوعة',
            value: interestPaid.when(
              data: (v) => CurrencyFormatter.formatCompact(v),
              loading: () => '...',
              error: (_, __) => '--',
            ),
            icon: Icons.percent_rounded,
            color: AppColors.installment,
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
            gradient: LinearGradient(
              colors: widget.isDark
                  ? [
                      widget.color.withValues(alpha: 0.15),
                      widget.color.withValues(alpha: 0.05),
                    ]
                  : [
                      widget.color.withValues(alpha: 0.1),
                      widget.color.withValues(alpha: 0.03),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(
              color: widget.color.withValues(
                alpha: widget.isDark ? 0.2 : 0.15,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: widget.isDark ? 0.1 : 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with gradient background
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.color.withValues(alpha: 0.25),
                      widget.color.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
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
                  color: widget.color,
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
