import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class DebtTimelineChart extends StatelessWidget {
  final List<double> remainingDebt; // per month
  final List<String> labels;

  const DebtTimelineChart({
    super.key,
    required this.remainingDebt,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (remainingDebt.isEmpty) {
      return SizedBox(
        height: 180,
        child: Center(
          child: Text(l10n.noData,
              style: const TextStyle(fontFamily: 'Cairo', color: AppColors.textMuted)),
        ),
      );
    }

    double maxVal = 0;
    for (final v in remainingDebt) {
      if (v > maxVal) maxVal = v;
    }
    maxVal = maxVal * 1.2;
    if (maxVal == 0) maxVal = 1000;

    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          maxY: maxVal,
          minY: 0,
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                remainingDebt.length,
                (i) => FlSpot(i.toDouble(), remainingDebt[i]),
              ),
              isCurved: true,
              color: AppColors.installment,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.installment.withValues(alpha: 0.1),
              ),
            ),
          ],
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx >= 0 && idx < labels.length) {
                    return Text(
                      labels[idx],
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 10,
                        color: AppColors.textMuted,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: AppColors.textMuted.withValues(alpha: 0.1),
              strokeWidth: 1,
            ),
          ),
        ),
      ),
    );
  }
}
