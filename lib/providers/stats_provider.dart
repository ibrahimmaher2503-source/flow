import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/transaction_repo.dart';
import '../data/services/isar_service.dart';

final statsRepoProvider = Provider<TransactionRepo>((ref) {
  return TransactionRepo(ref.watch(isarProvider));
});

final categoryBreakdownProvider =
    FutureProvider<Map<String, double>>((ref) async {
  final now = DateTime.now();
  final repo = ref.watch(statsRepoProvider);
  final transactions = await repo.getByMonth(now.year, now.month);

  final Map<String, double> breakdown = {};
  for (final t in transactions) {
    if (t.type == 'expense') {
      breakdown[t.category] = (breakdown[t.category] ?? 0) + t.amount;
    }
  }
  return breakdown;
});

final dailyAverageProvider = FutureProvider<double>((ref) async {
  final now = DateTime.now();
  final repo = ref.watch(statsRepoProvider);
  final transactions = await repo.getByMonth(now.year, now.month);

  double total = 0;
  for (final t in transactions) {
    if (t.type == 'expense') total += t.amount;
  }

  final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
  return total / daysInMonth;
});

final topCategoryProvider = FutureProvider<String?>((ref) async {
  final breakdown = await ref.watch(categoryBreakdownProvider.future);
  if (breakdown.isEmpty) return null;

  String? topCat;
  double topAmount = 0;
  for (final entry in breakdown.entries) {
    if (entry.value > topAmount) {
      topAmount = entry.value;
      topCat = entry.key;
    }
  }
  return topCat;
});
