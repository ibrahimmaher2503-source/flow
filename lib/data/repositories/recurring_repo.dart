import 'package:isar/isar.dart';
import '../models/recurring_transaction_model.dart';

class RecurringRepo {
  final Isar isar;

  RecurringRepo(this.isar);

  Future<List<RecurringTransaction>> getAll() async {
    return isar.recurringTransactions.where().findAll();
  }

  Future<List<RecurringTransaction>> getActive() async {
    return isar.recurringTransactions
        .filter()
        .isActiveEqualTo(true)
        .findAll();
  }

  Future<int> add(RecurringTransaction recurring) async {
    return isar.writeTxn(() async {
      return isar.recurringTransactions.put(recurring);
    });
  }

  Future<void> update(RecurringTransaction recurring) async {
    await isar.writeTxn(() async {
      await isar.recurringTransactions.put(recurring);
    });
  }

  Future<void> delete(int id) async {
    await isar.writeTxn(() async {
      await isar.recurringTransactions.delete(id);
    });
  }
}
