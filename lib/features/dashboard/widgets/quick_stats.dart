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
          child: _statBox(
            'متوسط يومي',
            dailyAvg.when(
              data: (v) => CurrencyFormatter.formatCompact(v),
              loading: () => '...',
              error: (_, __) => '--',
            ),
            Icons.trending_down,
            AppColors.warning,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _statBox(
            'أعلى فئة',
            topCat.when(
              data: (v) => v ?? 'لا يوجد',
              loading: () => '...',
              error: (_, __) => '--',
            ),
            Icons.category,
            AppColors.accent,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _statBox(
            'فوائد مدفوعة',
            interestPaid.when(
              data: (v) => CurrencyFormatter.formatCompact(v),
              loading: () => '...',
              error: (_, __) => '--',
            ),
            Icons.percent,
            AppColors.installment,
          ),
        ),
      ],
    );
  }

  Widget _statBox(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 10,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
