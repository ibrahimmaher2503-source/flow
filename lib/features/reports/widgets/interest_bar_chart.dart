import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

class InterestBarChart extends StatelessWidget {
  final double principal;
  final double interest;

  const InterestBarChart({
    super.key,
    required this.principal,
    required this.interest,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final total = principal + interest;
    if (total == 0) {
      return SizedBox(
        height: 120,
        child: Center(
          child: Text(l10n.noData,
              style: const TextStyle(fontFamily: 'Cairo', color: AppColors.textMuted)),
        ),
      );
    }

    return SizedBox(
      height: 120,
      child: BarChart(
        BarChartData(
          maxY: total * 1.1,
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: principal,
                  color: AppColors.secondary,
                  width: 30,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: interest,
                  color: AppColors.installment,
                  width: 30,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
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
                  switch (value.toInt()) {
                    case 0:
                      return Text(l10n.totalWithInterest,
                          style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              color: AppColors.textMuted));
                    case 1:
                      return Text(l10n.interestPaid,
                          style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              color: AppColors.textMuted));
                    default:
                      return const SizedBox();
                  }
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
