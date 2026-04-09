import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/transaction_tag_model.dart';
import '../data/models/smart_feature_models.dart';
import '../data/repositories/tag_repo.dart';
import '../data/services/tag_service.dart';
import '../data/services/isar_service.dart';

/// Provider for TagRepo
final tagRepoProvider = Provider<TagRepo>((ref) {
  return TagRepo(ref.watch(isarProvider));
});

/// Provider for TagService
final tagServiceProvider = Provider<TagService>((ref) {
  return TagService(ref.watch(isarProvider));
});

/// All tags sorted by usage
final allTagsProvider = FutureProvider<List<TransactionTag>>((ref) async {
  return ref.watch(tagRepoProvider).getAllByUsage();
});

/// All tags with analytics
final allTagAnalyticsProvider = FutureProvider<List<TagAnalytics>>((ref) async {
  return ref.watch(tagServiceProvider).getAllTagAnalytics();
});

/// Single tag analytics by name
final tagAnalyticsProvider =
    FutureProvider.family<TagAnalytics, String>((ref, tagName) async {
  return ref.watch(tagServiceProvider).getTagAnalytics(tagName);
});

/// Search tags for autocomplete
final tagSearchProvider =
    FutureProvider.family<List<TransactionTag>, String>((ref, query) async {
  return ref.watch(tagServiceProvider).searchTags(query);
});

/// Suggested tags for a category
final suggestedTagsProvider =
    FutureProvider.family<List<String>, String>((ref, category) async {
  return ref.watch(tagServiceProvider).getSuggestedTags(category);
});

/// Tag count for badge display
final tagCountProvider = FutureProvider<int>((ref) async {
  final tags = await ref.watch(allTagsProvider.future);
  return tags.length;
});

/// Helper to refresh all tag-related providers
void refreshTags(WidgetRef ref) {
  ref.invalidate(allTagsProvider);
  ref.invalidate(allTagAnalyticsProvider);
}
