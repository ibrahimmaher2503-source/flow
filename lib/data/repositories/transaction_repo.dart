import 'package:isar/isar.dart';
import '../models/transaction_model.dart';

class TransactionRepo {
  final Isar isar;

  TransactionRepo(this.isar);

  Future<List<Transaction>> getAll() async {
    return isar.transactions.where().sortByDateDesc().findAll();
  }

  Future<List<Transaction>> getByMonth(int year, int month) async {
    final monthKey = '$year-${month.toString().padLeft(2, '0')}';
    return isar.transactions
        .where()
        .monthKeyEqualTo(monthKey)
        .sortByDateDesc()
        .findAll();
  }

  Future<List<Transaction>> getByCategory(String category) async {
    return isar.transactions
        .where()
        .categoryIndexEqualTo(category)
        .sortByDateDesc()
        .findAll();
  }

  Future<List<Transaction>> getBySource(String source) async {
    return isar.transactions
        .where()
        .sourceIndexEqualTo(source)
        .sortByDateDesc()
        .findAll();
  }

  Future<List<Transaction>> getByWallet(int walletId) async {
    return isar.transactions
        .filter()
        .walletIdEqualTo(walletId)
        .sortByDateDesc()
        .findAll();
  }

  Future<List<Transaction>> getRecent(int limit) async {
    return isar.transactions
        .where()
        .sortByDateDesc()
        .limit(limit)
        .findAll();
  }

  Future<List<Transaction>> search(String query, {int limit = 100}) async {
    return isar.transactions
        .filter()
        .noteContains(query, caseSensitive: false)
        .or()
        .categoryContains(query, caseSensitive: false)
        .or()
        .merchantContains(query, caseSensitive: false)
        .sortByDateDesc()
        .limit(limit)
        .findAll();
  }

  Future<int> add(Transaction transaction) async {
    return isar.writeTxn(() async {
      return isar.transactions.put(transaction);
    });
  }

  Future<void> update(Transaction transaction) async {
    await isar.writeTxn(() async {
      await isar.transactions.put(transaction);
    });
  }

  Future<void> delete(int id) async {
    await isar.writeTxn(() async {
      await isar.transactions.delete(id);
    });
  }

  Future<double> getTotalByType(String type, int year, int month) async {
    final monthKey = '$year-${month.toString().padLeft(2, '0')}';
    final transactions = await isar.transactions
        .where()
        .monthKeyEqualTo(monthKey)
        .filter()
        .typeEqualTo(type)
        .findAll();
    double total = 0;
    for (final t in transactions) {
      total += t.amount;
    }
    return total;
  }

  /// Get transactions for a range of months
  /// [monthKeys] should be in format 'YYYY-MM'
  Future<List<Transaction>> getByMonthRange(List<String> monthKeys) async {
    if (monthKeys.isEmpty) return [];

    // Use filter to match any of the month keys
    final List<Transaction> results = [];
    for (final key in monthKeys) {
      final monthTransactions = await isar.transactions
          .where()
          .monthKeyEqualTo(key)
          .findAll();
      results.addAll(monthTransactions);
    }

    // Sort by date descending
    results.sort((a, b) => b.date.compareTo(a.date));
    return results;
  }

  /// Get transaction count and total by source for a specific month
  Future<Map<String, ({int count, double amount})>> getBySourceForMonth(
      int year, int month) async {
    final monthKey = '$year-${month.toString().padLeft(2, '0')}';
    final transactions = await isar.transactions
        .where()
        .monthKeyEqualTo(monthKey)
        .findAll();

    final Map<String, ({int count, double amount})> result = {};
    for (final t in transactions) {
      final current = result[t.source] ?? (count: 0, amount: 0.0);
      result[t.source] = (
        count: current.count + 1,
        amount: current.amount + t.amount,
      );
    }
    return result;
  }
}
