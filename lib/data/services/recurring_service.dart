import 'package:isar/isar.dart';
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
        final transaction = await _createTransaction(recurring);
        created.add(transaction);
        await _advanceNextDate(recurring);
      }
      // For non-autoAdd, notification would be triggered separately
    }

    return created;
  }

  /// Get upcoming recurring transactions within N days
  Future<List<RecurringTransaction>> getUpcoming(int days) async {
    final now = DateTime.now();
    final cutoff = now.add(Duration(days: days));

    final active = await isar.recurringTransactions
        .filter()
        .isActiveEqualTo(true)
        .findAll();

    return active
        .where((r) =>
            r.nextDueDate.isBefore(cutoff) || r.nextDueDate == cutoff)
        .toList()
      ..sort((a, b) => a.nextDueDate.compareTo(b.nextDueDate));
  }

  /// Manually confirm and create a recurring transaction
  Future<Transaction> confirmRecurring(RecurringTransaction recurring) async {
    final transaction = await _createTransaction(recurring);
    await _advanceNextDate(recurring);
    return transaction;
  }

  Future<Transaction> _createTransaction(
      RecurringTransaction recurring) async {
    // Use first available wallet instead of hardcoded ID
    final wallets = await isar.wallets.where().findAll();
    final walletId = wallets.isNotEmpty ? wallets.first.id : 1;

    final transaction = Transaction()
      ..amount = recurring.amount
      ..type = recurring.type
      ..category = recurring.category
      ..note = recurring.name
      ..date = DateTime.now()
      ..walletId = walletId
      ..source = 'recurring'
      ..createdAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.transactions.put(transaction);

      // Update the specific wallet used
      final wallet = await isar.wallets.get(walletId);
      if (wallet != null) {
        if (recurring.type == 'expense') {
          wallet.balance -= recurring.amount;
        } else {
          wallet.balance += recurring.amount;
        }
        await isar.wallets.put(wallet);
      }
    });

    return transaction;
  }

  Future<void> _advanceNextDate(RecurringTransaction recurring) async {
    await isar.writeTxn(() async {
      switch (recurring.frequency) {
        case 'daily':
          recurring.nextDueDate =
              recurring.nextDueDate.add(const Duration(days: 1));
          break;
        case 'weekly':
          recurring.nextDueDate =
              recurring.nextDueDate.add(const Duration(days: 7));
          break;
        case 'monthly':
          recurring.nextDueDate = DateTime(
            recurring.nextDueDate.year,
            recurring.nextDueDate.month + 1,
            recurring.nextDueDate.day,
          );
          break;
        case 'yearly':
          recurring.nextDueDate = DateTime(
            recurring.nextDueDate.year + 1,
            recurring.nextDueDate.month,
            recurring.nextDueDate.day,
          );
          break;
      }

      // Check if ended
      if (recurring.endDate != null &&
          recurring.nextDueDate.isAfter(recurring.endDate!)) {
        recurring.isActive = false;
      }

      await isar.recurringTransactions.put(recurring);
    });
  }
}
