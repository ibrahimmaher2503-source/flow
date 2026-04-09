import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';

class CategoryPieChart extends StatelessWidget {
  final Map<String, double> data;
  final Map<String, String> colorMap;

  const CategoryPieChart({
    super.key,
    required this.data,
    required this.colorMap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (data.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(l10n.noData,
              style: TextStyle(fontFamily: 'Cairo', color: isDark ? AppColors.textMuted : AppColors.lightTextMuted)),
        ),
      );
    }

    double total = 0;
    for (final v in data.values) {
      total += v;
    }

    final entries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: entries.take(8).map((entry) {
            final color =
                colorMap[entry.key]?.toColor ?? AppColors.primary;
            final pct =
                total > 0 ? (entry.value / total * 100) : 0.0;

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
          }).toList(),
        ),
      ),
    );
  }
}
