import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';

class MonthlyBarChart extends StatelessWidget {
  final List<double> incomeData; // last 6 months
  final List<double> expenseData;
  final List<String> labels;

  const MonthlyBarChart({
    super.key,
    required this.incomeData,
    required this.expenseData,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    double maxVal = 0;
    for (final v in [...incomeData, ...expenseData]) {
      if (v > maxVal) maxVal = v;
    }
    maxVal = maxVal * 1.2;
    if (maxVal == 0) maxVal = 1000;

    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          maxY: maxVal,
          barGroups: List.generate(
            incomeData.length,
            (i) => BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: incomeData[i],
                  color: AppColors.success,
                  width: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                BarChartRodData(
                  toY: expenseData[i],
                  color: AppColors.danger,
                  width: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
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
          gridData: const FlGridData(show: false),
        ),
      ),
    );
  }
}
