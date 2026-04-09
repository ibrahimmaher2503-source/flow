import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/insight_model.dart';
import '../data/repositories/insight_repo.dart';
import '../data/services/insights_service.dart';
import '../data/services/isar_service.dart';

/// Provider for InsightRepo
final insightRepoProvider = Provider<InsightRepo>((ref) {
  return InsightRepo(ref.watch(isarProvider));
});

/// Provider for InsightsService
final insightsServiceProvider = Provider<InsightsService>((ref) {
  return InsightsService(ref.watch(isarProvider));
});

/// Active (non-dismissed) insights
final activeInsightsProvider = FutureProvider<List<Insight>>((ref) async {
  return ref.watch(insightRepoProvider).getActive();
});

/// Top insights for dashboard (limited)
final topInsightsProvider = FutureProvider<List<Insight>>((ref) async {
  return ref.watch(insightRepoProvider).getTopActive(limit: 5);
});

/// High priority (urgent) insights
final urgentInsightsProvider = FutureProvider<List<Insight>>((ref) async {
  return ref.watch(insightRepoProvider).getHighPriority();
});

/// Insights for a specific month
final monthInsightsProvider =
    FutureProvider.family<List<Insight>, String>((ref, monthKey) async {
  return ref.watch(insightRepoProvider).getActiveByMonth(monthKey);
});

/// Insights by type
final insightsByTypeProvider =
    FutureProvider.family<List<Insight>, String>((ref, type) async {
  return ref.watch(insightRepoProvider).getByType(type);
});

/// Count of active insights
final activeInsightsCountProvider = FutureProvider<int>((ref) async {
  return ref.watch(insightRepoProvider).getActiveCount();
});

/// Count of high priority insights
final urgentInsightsCountProvider = FutureProvider<int>((ref) async {
  return ref.watch(insightRepoProvider).getHighPriorityCount();
});

/// Generate new insights
final generateInsightsProvider = FutureProvider<List<Insight>>((ref) async {
  return ref.watch(insightsServiceProvider).generateInsights();
});

/// Dismissed insights
final dismissedInsightsProvider = FutureProvider<List<Insight>>((ref) async {
  return ref.watch(insightRepoProvider).getDismissed();
});

/// Helper to refresh insights providers
void refreshInsights(WidgetRef ref) {
  ref.invalidate(activeInsightsProvider);
  ref.invalidate(topInsightsProvider);
  ref.invalidate(urgentInsightsProvider);
  ref.invalidate(activeInsightsCountProvider);
  ref.invalidate(urgentInsightsCountProvider);
  ref.invalidate(dismissedInsightsProvider);
}

/// Dismiss an insight and refresh
Future<void> dismissInsight(WidgetRef ref, int insightId) async {
  await ref.read(insightRepoProvider).dismiss(insightId);
  refreshInsights(ref);
}

/// Undismiss an insight and refresh
Future<void> undismissInsight(WidgetRef ref, int insightId) async {
  await ref.read(insightRepoProvider).undismiss(insightId);
  refreshInsights(ref);
}

/// Generate insights and refresh
Future<void> triggerInsightGeneration(WidgetRef ref) async {
  await ref.read(insightsServiceProvider).generateInsights();
  refreshInsights(ref);
}
