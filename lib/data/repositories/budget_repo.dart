import 'package:isar/isar.dart';
import '../models/budget_model.dart';

class BudgetRepo {
  final Isar isar;

  BudgetRepo(this.isar);

  Future<List<Budget>> getAll() async {
    return isar.budgets.where().findAll();
  }

  Future<List<Budget>> getActive() async {
    return isar.budgets.filter().isActiveEqualTo(true).findAll();
  }

  Future<Budget?> getByCategory(String categoryName) async {
    return isar.budgets
        .filter()
        .categoryNameEqualTo(categoryName)
        .isActiveEqualTo(true)
        .findFirst();
  }

  Future<int> add(Budget budget) async {
    return isar.writeTxn(() async {
      return isar.budgets.put(budget);
    });
  }

  Future<void> update(Budget budget) async {
    await isar.writeTxn(() async {
      await isar.budgets.put(budget);
    });
  }

  Future<void> delete(int id) async {
    await isar.writeTxn(() async {
      await isar.budgets.delete(id);
    });
  }
}
