import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/transaction_model.dart';
import '../data/repositories/transaction_repo.dart';
import '../data/services/isar_service.dart';

final transactionRepoProvider = Provider<TransactionRepo>((ref) {
  return TransactionRepo(ref.watch(isarProvider));
});

final selectedMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month);
});

final monthlyTransactionsProvider =
    FutureProvider<List<Transaction>>((ref) async {
  final repo = ref.watch(transactionRepoProvider);
  final month = ref.watch(selectedMonthProvider);
  return repo.getByMonth(month.year, month.month);
});

final recentTransactionsProvider =
    FutureProvider<List<Transaction>>((ref) async {
  final repo = ref.watch(transactionRepoProvider);
  return repo.getRecent(5);
});

final monthlyIncomeProvider = FutureProvider<double>((ref) async {
  final repo = ref.watch(transactionRepoProvider);
  final month = ref.watch(selectedMonthProvider);
  return repo.getTotalByType('income', month.year, month.month);
});

final monthlyExpenseProvider = FutureProvider<double>((ref) async {
  final repo = ref.watch(transactionRepoProvider);
  final month = ref.watch(selectedMonthProvider);
  return repo.getTotalByType('expense', month.year, month.month);
});

final transactionSearchProvider =
    FutureProvider.family<List<Transaction>, String>((ref, query) async {
  final repo = ref.watch(transactionRepoProvider);
  return repo.search(query);
});

void refreshTransactions(WidgetRef ref) {
  ref.invalidate(monthlyTransactionsProvider);
  ref.invalidate(recentTransactionsProvider);
  ref.invalidate(monthlyIncomeProvider);
  ref.invalidate(monthlyExpenseProvider);
}
