import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/reports_provider.dart';
import 'report_section_header.dart';

class SpendingAverages extends ConsumerWidget {
  const SpendingAverages({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final averagesAsync = ref.watch(spendingAveragesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ReportSectionHeader(
          title: 'متوسطات الإنفاق',
          icon: Icons.calculate_outlined,
        ),
        averagesAsync.when(
          data: (averages) => Row(
            children: [
              Expanded(
                child: _AverageCard(
                  label: 'يومي',
                  value: averages.daily,
                  icon: Icons.today,
                  color: AppColors.warning,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _AverageCard(
                  label: 'أسبوعي',
                  value: averages.weekly,
                  icon: Icons.date_range,
                  color: AppColors.secondary,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _AverageCard(
                  label: 'شهري',
                  value: averages.monthly,
                  icon: Icons.calendar_month,
                  color: AppColors.danger,
                  isDark: isDark,
                ),
              ),
            ],
          ),
          loading: () => const SizedBox(
            height: 80,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Text('$e'),
        ),
      ],
    );
  }
}

class _AverageCard extends StatelessWidget {
  final String label;
  final double value;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _AverageCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              CurrencyFormatter.format(value),
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
