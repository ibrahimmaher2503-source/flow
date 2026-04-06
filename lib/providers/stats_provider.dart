import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';
import 'transaction_provider.dart';

/// Reuse monthlyTransactionsProvider to avoid duplicate DB queries
final categoryBreakdownProvider =
    FutureProvider<Map<String, double>>((ref) async {
  final transactions = await ref.watch(monthlyTransactionsProvider.future);

  final Map<String, double> breakdown = {};
  for (final t in transactions) {
    if (t.type == TransactionType.expense) {
      breakdown[t.category] = (breakdown[t.category] ?? 0) + t.amount;
    }
  }
  return breakdown;
});

final dailyAverageProvider = FutureProvider<double>((ref) async {
  final breakdown = await ref.watch(categoryBreakdownProvider.future);
  final now = DateTime.now();
  final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

  double total = 0;
  for (final v in breakdown.values) {
    total += v;
  }
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
