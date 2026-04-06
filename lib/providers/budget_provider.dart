import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/budget_model.dart';
import '../data/repositories/budget_repo.dart';
import '../data/services/isar_service.dart';
import 'transaction_provider.dart';

final budgetRepoProvider = Provider<BudgetRepo>((ref) {
  return BudgetRepo(ref.watch(isarProvider));
});

final activeBudgetsProvider = FutureProvider<List<Budget>>((ref) async {
  return ref.watch(budgetRepoProvider).getActive();
});

final budgetUsageProvider =
    FutureProvider.family<double, String>((ref, categoryName) async {
  final now = DateTime.now();
  final transRepo = ref.watch(transactionRepoProvider);
  final transactions = await transRepo.getByMonth(now.year, now.month);
  double total = 0;
  for (final t in transactions) {
    if (t.type == 'expense' && t.category == categoryName) {
      total += t.amount;
    }
  }
  return total;
});

void refreshBudgets(WidgetRef ref) {
  ref.invalidate(activeBudgetsProvider);
}
