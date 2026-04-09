import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/smart_feature_models.dart';

/// Line chart showing 3 forecast scenarios
class ForecastChart extends StatelessWidget {
  final List<ForecastDay> days;
  final ForecastScenario? selectedScenario;
  final ValueChanged<int>? onDaySelected;

  const ForecastChart({
    super.key,
    required this.days,
    this.selectedScenario,
    this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (days.isEmpty) {
      return const SizedBox.shrink();
    }

    final minY = _getMinY();
    final maxY = _getMaxY();

    return AspectRatio(
      aspectRatio: 1.6,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: _getInterval(maxY - minY),
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: isDark
                    ? AppColors.surfaceLight.withValues(alpha: 0.3)
                    : AppColors.lightSurfaceContainerHighest,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: (days.length / 5).ceilToDouble(),
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= days.length) {
                    return const SizedBox.shrink();
                  }
                  final date = days[index].date;
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${date.day}/${date.month}',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                        fontSize: 10,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 60,
                interval: _getInterval(maxY - minY),
                getTitlesWidget: (value, meta) {
                  return Text(
                    CurrencyFormatter.formatCompact(value),
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (days.length - 1).toDouble(),
          minY: minY,
          maxY: maxY,
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (spot) => isDark
                  ? AppColors.surface
                  : AppColors.lightSurface,
              tooltipRoundedRadius: 8,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final scenario = _getScenarioName(spot.barIndex);
                  final color = _getLineColor(spot.barIndex, isDark);
                  return LineTooltipItem(
                    '$scenario\n${CurrencyFormatter.format(spot.y)}',
                    TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  );
                }).toList();
              },
            ),
            touchCallback: (event, response) {
              if (event is FlTapUpEvent && response?.lineBarSpots != null) {
                final index = response!.lineBarSpots!.first.x.toInt();
                onDaySelected?.call(index);
              }
            },
          ),
          lineBarsData: _getLineBarsData(isDark),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              // Zero line
              HorizontalLine(
                y: 0,
                color: isDark
                    ? AppColors.danger.withValues(alpha: 0.5)
                    : AppColors.lightDanger.withValues(alpha: 0.5),
                strokeWidth: 2,
                dashArray: [5, 5],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<LineChartBarData> _getLineBarsData(bool isDark) {
    final showAll = selectedScenario == null;

    return [
      // Optimistic (green)
      if (showAll || selectedScenario == ForecastScenario.optimistic)
        LineChartBarData(
          spots: days.asMap().entries.map((e) {
            return FlSpot(e.key.toDouble(), e.value.optimisticBalance);
          }).toList(),
          isCurved: true,
          color: isDark ? AppColors.success : AppColors.lightSuccess,
          barWidth: selectedScenario == ForecastScenario.optimistic ? 3 : 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),

      // Realistic (primary)
      if (showAll || selectedScenario == ForecastScenario.realistic)
        LineChartBarData(
          spots: days.asMap().entries.map((e) {
            return FlSpot(e.key.toDouble(), e.value.realisticBalance);
          }).toList(),
          isCurved: true,
          color: isDark ? AppColors.primary : AppColors.lightPrimary,
          barWidth: selectedScenario == ForecastScenario.realistic ? 3 : 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),

      // Pessimistic (danger)
      if (showAll || selectedScenario == ForecastScenario.pessimistic)
        LineChartBarData(
          spots: days.asMap().entries.map((e) {
            return FlSpot(e.key.toDouble(), e.value.pessimisticBalance);
          }).toList(),
          isCurved: true,
          color: isDark ? AppColors.danger : AppColors.lightDanger,
          barWidth: selectedScenario == ForecastScenario.pessimistic ? 3 : 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
    ];
  }

  double _getMinY() {
    double min = double.infinity;
    for (final day in days) {
      if (day.optimisticBalance < min) min = day.optimisticBalance;
      if (day.realisticBalance < min) min = day.realisticBalance;
      if (day.pessimisticBalance < min) min = day.pessimisticBalance;
    }
    return (min - (min.abs() * 0.1)).floorToDouble();
  }

  double _getMaxY() {
    double max = double.negativeInfinity;
    for (final day in days) {
      if (day.optimisticBalance > max) max = day.optimisticBalance;
      if (day.realisticBalance > max) max = day.realisticBalance;
      if (day.pessimisticBalance > max) max = day.pessimisticBalance;
    }
    return (max + (max.abs() * 0.1)).ceilToDouble();
  }

  double _getInterval(double range) {
    if (range <= 1000) return 200;
    if (range <= 5000) return 1000;
    if (range <= 10000) return 2000;
    if (range <= 50000) return 10000;
    return 20000;
  }

  String _getScenarioName(int index) {
    switch (index) {
      case 0:
        return 'متفائل';
      case 1:
        return 'واقعي';
      case 2:
        return 'متشائم';
      default:
        return '';
    }
  }

  Color _getLineColor(int index, bool isDark) {
    switch (index) {
      case 0:
        return isDark ? AppColors.success : AppColors.lightSuccess;
      case 1:
        return isDark ? AppColors.primary : AppColors.lightPrimary;
      case 2:
        return isDark ? AppColors.danger : AppColors.lightDanger;
      default:
        return isDark ? AppColors.textMuted : AppColors.lightTextMuted;
    }
  }
}

/// Mini sparkline chart for dashboard card
class ForecastSparkline extends StatelessWidget {
  final List<double> data;
  final double height;
  final bool showDanger;

  const ForecastSparkline({
    super.key,
    required this.data,
    this.height = 40,
    this.showDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (data.isEmpty) {
      return SizedBox(height: height);
    }

    final lineColor = showDanger
        ? (isDark ? AppColors.danger : AppColors.lightDanger)
        : (isDark ? AppColors.primary : AppColors.lightPrimary);

    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: const LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
              spots: data.asMap().entries.map((e) {
                return FlSpot(e.key.toDouble(), e.value);
              }).toList(),
              isCurved: true,
              color: lineColor,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: lineColor.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
