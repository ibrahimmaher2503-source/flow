import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
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

    return Row(
      children: [
        Expanded(
          child: _StatBox(
            label: 'متوسط يومي',
            value: dailyAvg.when(
              data: (v) => CurrencyFormatter.formatCompact(v),
              loading: () => '...',
              error: (_, __) => '--',
            ),
            icon: Icons.trending_down_rounded,
            color: AppColors.warning,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatBox(
            label: 'أعلى فئة',
            value: topCat.when(
              data: (v) => v ?? 'لا يوجد',
              loading: () => '...',
              error: (_, __) => '--',
            ),
            icon: Icons.category_rounded,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatBox(
            label: 'فوائد مدفوعة',
            value: interestPaid.when(
              data: (v) => CurrencyFormatter.formatCompact(v),
              loading: () => '...',
              error: (_, __) => '--',
            ),
            icon: Icons.percent_rounded,
            color: AppColors.installment,
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.12),
            color.withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
