import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/recurring_transaction_model.dart';
import '../data/repositories/recurring_repo.dart';
import '../data/services/isar_service.dart';

final recurringRepoProvider = Provider<RecurringRepo>((ref) {
  return RecurringRepo(ref.watch(isarProvider));
});

final activeRecurringProvider =
    FutureProvider<List<RecurringTransaction>>((ref) async {
  return ref.watch(recurringRepoProvider).getActive();
});

void refreshRecurring(WidgetRef ref) {
  ref.invalidate(activeRecurringProvider);
}
