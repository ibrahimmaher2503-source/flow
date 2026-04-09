import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/smart_feature_models.dart';
import '../data/repositories/envelope_repo.dart';
import '../data/services/envelope_service.dart';
import '../data/services/isar_service.dart';

/// Provider for EnvelopeRepo
final envelopeRepoProvider = Provider<EnvelopeRepo>((ref) {
  return EnvelopeRepo(ref.watch(isarProvider));
});

/// Provider for EnvelopeService
final envelopeServiceProvider = Provider<EnvelopeService>((ref) {
  return EnvelopeService(ref.watch(isarProvider));
});

/// Current month's envelopes with spent amounts
final currentMonthEnvelopesProvider =
    FutureProvider<List<EnvelopeWithSpent>>((ref) async {
  final now = DateTime.now();
  return ref.watch(envelopeServiceProvider).getEnvelopesWithSpent(
        now.year,
        now.month,
      );
});

/// Envelopes for a specific month
final monthEnvelopesProvider =
    FutureProvider.family<List<EnvelopeWithSpent>, ({int year, int month})>(
        (ref, params) async {
  return ref.watch(envelopeServiceProvider).getEnvelopesWithSpent(
        params.year,
        params.month,
      );
});

/// Single envelope with spent
final envelopeWithSpentProvider =
    FutureProvider.family<EnvelopeWithSpent?, int>((ref, id) async {
  return ref.watch(envelopeServiceProvider).getEnvelopeWithSpent(id);
});

/// Envelope for a category in current month
final envelopeForCategoryProvider =
    FutureProvider.family<EnvelopeWithSpent?, String>((ref, categoryName) async {
  return ref.watch(envelopeServiceProvider).getEnvelopeForCategory(categoryName);
});

/// Monthly summary
final envelopeSummaryProvider =
    FutureProvider<EnvelopeSummary>((ref) async {
  return ref.watch(envelopeServiceProvider).getMonthlySummary();
});

/// Summary for specific month
final monthEnvelopeSummaryProvider =
    FutureProvider.family<EnvelopeSummary, ({int year, int month})>(
        (ref, params) async {
  return ref.watch(envelopeServiceProvider).getMonthlySummary(
        year: params.year,
        month: params.month,
      );
});

/// Envelopes needing attention (low/empty)
final envelopesNeedingAttentionProvider =
    FutureProvider<List<EnvelopeWithSpent>>((ref) async {
  return ref.watch(envelopeServiceProvider).getEnvelopesNeedingAttention();
});

/// Check overage for a category
final overageCheckProvider =
    FutureProvider.family<EnvelopeOverageCheck, ({String category, double amount})>(
        (ref, params) async {
  return ref.watch(envelopeServiceProvider).checkOverage(
        params.category,
        params.amount,
      );
});

/// Total allocated for current month
final totalAllocatedProvider = FutureProvider<double>((ref) async {
  final summary = await ref.watch(envelopeSummaryProvider.future);
  return summary.totalAllocated;
});

/// Total remaining for current month
final totalRemainingProvider = FutureProvider<double>((ref) async {
  final summary = await ref.watch(envelopeSummaryProvider.future);
  return summary.totalRemaining;
});

/// Helper to refresh all envelope-related providers
void refreshEnvelopes(WidgetRef ref) {
  ref.invalidate(currentMonthEnvelopesProvider);
  ref.invalidate(envelopeSummaryProvider);
  ref.invalidate(envelopesNeedingAttentionProvider);
  ref.invalidate(totalAllocatedProvider);
  ref.invalidate(totalRemainingProvider);
}
