import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/detected_sms_repo.dart';
import '../data/models/detected_sms_model.dart';
import '../data/services/isar_service.dart';

// Repository provider
final detectedSmsRepoProvider = Provider<DetectedSmsRepo>((ref) {
  final isar = ref.watch(isarProvider);
  return DetectedSmsRepo(isar);
});

// Pending SMS transactions provider
final pendingTransactionsProvider = FutureProvider<List<DetectedSms>>((ref) async {
  final repo = ref.watch(detectedSmsRepoProvider);
  return repo.getPending();
});

// All detected SMS provider (for inbox)
final allDetectedSmsProvider = FutureProvider<List<DetectedSms>>((ref) async {
  final repo = ref.watch(detectedSmsRepoProvider);
  return repo.getAll();
});

// Pending count provider (for badge)
final pendingCountProvider = FutureProvider<int>((ref) async {
  final repo = ref.watch(detectedSmsRepoProvider);
  return repo.countPending();
});

// Single SMS provider by ID
final detectedSmsByIdProvider = FutureProvider.family<DetectedSms?, int>((ref, id) async {
  final repo = ref.watch(detectedSmsRepoProvider);
  return repo.getById(id);
});

// Helper function to refresh all SMS providers
void refreshSmsProviders(WidgetRef ref) {
  ref.invalidate(pendingTransactionsProvider);
  ref.invalidate(allDetectedSmsProvider);
  ref.invalidate(pendingCountProvider);
}
