import 'package:isar/isar.dart';
import '../models/savings_goal_model.dart';

class GoalRepo {
  final Isar isar;

  GoalRepo(this.isar);

  Future<List<SavingsGoal>> getAll() async {
    return isar.savingsGoals.where().findAll();
  }

  Future<List<SavingsGoal>> getActive() async {
    return isar.savingsGoals.filter().isCompletedEqualTo(false).findAll();
  }

  Future<List<SavingsGoal>> getCompleted() async {
    return isar.savingsGoals.filter().isCompletedEqualTo(true).findAll();
  }

  Future<int> add(SavingsGoal goal) async {
    return isar.writeTxn(() async {
      return isar.savingsGoals.put(goal);
    });
  }

  Future<void> update(SavingsGoal goal) async {
    await isar.writeTxn(() async {
      await isar.savingsGoals.put(goal);
    });
  }

  Future<void> addContribution(int goalId, double amount) async {
    await isar.writeTxn(() async {
      final goal = await isar.savingsGoals.get(goalId);
      if (goal != null) {
        goal.currentAmount += amount;
        if (goal.currentAmount >= goal.targetAmount) {
          goal.isCompleted = true;
        }
        await isar.savingsGoals.put(goal);
      }
    });
  }

  Future<void> delete(int id) async {
    await isar.writeTxn(() async {
      await isar.savingsGoals.delete(id);
    });
  }
}
