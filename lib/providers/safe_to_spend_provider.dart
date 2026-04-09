import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/smart_feature_models.dart';
import '../data/services/safe_to_spend_service.dart';
import '../data/services/isar_service.dart';

/// Provider for SafeToSpendService
final safeToSpendServiceProvider = Provider<SafeToSpendService>((ref) {
  return SafeToSpendService(ref.watch(isarProvider));
});

/// FutureProvider for safe-to-spend calculation
/// Automatically recalculates when dependencies change
final safeToSpendProvider = FutureProvider<SafeToSpendData>((ref) async {
  final service = ref.watch(safeToSpendServiceProvider);
  return service.calculate();
});

/// Helper to refresh safe-to-spend data
/// Call this after transactions, installments, goals, or wallets change
void refreshSafeToSpend(WidgetRef ref) {
  ref.invalidate(safeToSpendProvider);
}

/// Stream-based provider for watching safe-to-spend changes (alternative)
/// Can be used for more reactive updates
final safeToSpendStreamProvider = StreamProvider<SafeToSpendData>((ref) async* {
  final service = ref.watch(safeToSpendServiceProvider);

  // Initial calculation
  yield await service.calculate();

  // Could add a periodic recalculation here if needed
  // For now, rely on manual invalidation
});
