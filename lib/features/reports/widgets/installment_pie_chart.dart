import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class InstallmentPieChart extends StatelessWidget {
  final Map<String, double> debtByProvider;

  const InstallmentPieChart({
    super.key,
    required this.debtByProvider,
  });

  static const _providerColors = [
    AppColors.installment,
    AppColors.accent,
    AppColors.primary,
    Color(0xFFA855F7),
    AppColors.success,
    AppColors.danger,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (debtByProvider.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(l10n.emptyInstallments,
              style: TextStyle(fontFamily: 'Cairo', color: isDark ? AppColors.textMuted : AppColors.lightTextMuted)),
        ),
      );
    }

    double total = 0;
    for (final v in debtByProvider.values) {
      total += v;
    }

    final entries = debtByProvider.entries.toList();

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: List.generate(entries.length, (i) {
            final entry = entries[i];
            final color = _providerColors[i % _providerColors.length];
            final pct = total > 0 ? (entry.value / total * 100) : 0.0;

            return PieChartSectionData(
              value: entry.value,
              color: color,
              title: pct >= 5 ? '${pct.toStringAsFixed(0)}%' : '',
              titleStyle: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              radius: 50,
            );
          }),
        ),
      ),
    );
  }
}
