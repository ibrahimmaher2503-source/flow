import 'package:isar/isar.dart';
import '../../core/constants/app_constants.dart';
import '../models/transaction_model.dart';
import '../models/recurring_transaction_model.dart';
import '../models/wallet_model.dart';

class RecurringService {
  final Isar isar;

  RecurringService(this.isar);

  /// Check and process all due recurring transactions
  Future<List<Transaction>> processDueRecurring() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final created = <Transaction>[];

    final active = await isar.recurringTransactions
        .filter()
        .isActiveEqualTo(true)
        .findAll();

    for (final recurring in active) {
      final dueDate = DateTime(
        recurring.nextDueDate.year,
        recurring.nextDueDate.month,
        recurring.nextDueDate.day,
      );

      if (dueDate.isAfter(today)) continue;

      if (recurring.autoAdd) {
        final transaction = await _createAndAdvance(recurring);
        created.add(transaction);
      }
    }

    return created;
  }

  /// Get upcoming recurring transactions within N days (excludes overdue)
  Future<List<RecurringTransaction>> getUpcoming(int days) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final cutoff = now.add(Duration(days: days));

    final active = await isar.recurringTransactions
        .filter()
        .isActiveEqualTo(true)
        .findAll();

    return active
        .where((r) {
          final due = DateTime(
              r.nextDueDate.year, r.nextDueDate.month, r.nextDueDate.day);
          return !due.isBefore(today) && !due.isAfter(cutoff);
        })
        .toList()
      ..sort((a, b) => a.nextDueDate.compareTo(b.nextDueDate));
  }

  /// Manually confirm and create a recurring transaction
  Future<Transaction> confirmRecurring(RecurringTransaction recurring) async {
    return _createAndAdvance(recurring);
  }

  /// Atomic: create transaction + update wallet + advance date in one writeTxn
  Future<Transaction> _createAndAdvance(
      RecurringTransaction recurring) async {
    // Use recurring's walletId if set, otherwise first available wallet
    int walletId;
    if (recurring.walletId != null) {
      walletId = recurring.walletId!;
    } else {
      final wallets = await isar.wallets.where().findAll();
      walletId = wallets.isNotEmpty ? wallets.first.id : 1;
    }

    final transaction = Transaction()
      ..amount = recurring.amount
      ..type = recurring.type
      ..category = recurring.category
      ..note = recurring.name
      ..date = DateTime.now()
      ..walletId = walletId
      ..source = TransactionSource.recurring
      ..createdAt = DateTime.now();

    await isar.writeTxn(() async {
      // 1. Save transaction
      await isar.transactions.put(transaction);

      // 2. Update wallet balance
      final wallet = await isar.wallets.get(walletId);
      if (wallet != null) {
        if (recurring.type == TransactionType.expense) {
          wallet.balance -= recurring.amount;
        } else {
          wallet.balance += recurring.amount;
        }
        await isar.wallets.put(wallet);
      }

      // 3. Advance next due date (atomic with above)
      _advanceNextDate(recurring);

      // 4. Check if ended
      if (recurring.endDate != null &&
          recurring.nextDueDate.isAfter(recurring.endDate!)) {
        recurring.isActive = false;
      }

      await isar.recurringTransactions.put(recurring);
    });

    return transaction;
  }

  /// Advance nextDueDate with proper day clamping for monthly/yearly
  void _advanceNextDate(RecurringTransaction recurring) {
    switch (recurring.frequency) {
      case Frequency.daily:
        recurring.nextDueDate =
            recurring.nextDueDate.add(const Duration(days: 1));
        break;
      case Frequency.weekly:
        recurring.nextDueDate =
            recurring.nextDueDate.add(const Duration(days: 7));
        break;
      case Frequency.monthly:
        final targetMonth = recurring.nextDueDate.month + 1;
        final targetYear = recurring.nextDueDate.year;
        final maxDay =
            DateTime(targetYear, targetMonth + 1, 0).day; // last day of target
        final day =
            recurring.nextDueDate.day > maxDay ? maxDay : recurring.nextDueDate.day;
        recurring.nextDueDate = DateTime(targetYear, targetMonth, day);
        break;
      case Frequency.yearly:
        final targetYear = recurring.nextDueDate.year + 1;
        final targetMonth = recurring.nextDueDate.month;
        final maxDay = DateTime(targetYear, targetMonth + 1, 0).day;
        final day =
            recurring.nextDueDate.day > maxDay ? maxDay : recurring.nextDueDate.day;
        recurring.nextDueDate = DateTime(targetYear, targetMonth, day);
        break;
    }
  }
}
