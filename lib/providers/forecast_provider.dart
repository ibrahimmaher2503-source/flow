import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/smart_feature_models.dart';
import '../data/services/forecast_service.dart';
import '../data/services/isar_service.dart';

/// Provider for ForecastService
final forecastServiceProvider = Provider<ForecastService>((ref) {
  return ForecastService(ref.watch(isarProvider));
});

/// 30-day forecast data
final forecastProvider = FutureProvider<ForecastData>((ref) async {
  return ref.watch(forecastServiceProvider).generateForecast();
});

/// 7-day sparkline data for mini card
final forecastSparklineProvider = FutureProvider<List<double>>((ref) async {
  return ref.watch(forecastServiceProvider).getSparklineData();
});

/// Check if there's danger within 7 days
final forecastDangerProvider = FutureProvider<bool>((ref) async {
  return ref.watch(forecastServiceProvider).hasDangerWithin7Days();
});

/// Forecast for specific number of days
final customForecastProvider =
    FutureProvider.family<ForecastData, int>((ref, days) async {
  return ref.watch(forecastServiceProvider).generateForecast(days: days);
});

/// Helper to refresh forecast providers
void refreshForecast(WidgetRef ref) {
  ref.invalidate(forecastProvider);
  ref.invalidate(forecastSparklineProvider);
  ref.invalidate(forecastDangerProvider);
}
