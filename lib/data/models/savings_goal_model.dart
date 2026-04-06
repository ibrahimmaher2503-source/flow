import 'package:isar/isar.dart';

part 'savings_goal_model.g.dart';

@collection
class SavingsGoal {
  Id id = Isar.autoIncrement;

  late String name;
  late double targetAmount;
  late double currentAmount;
  String? icon;
  DateTime? deadline;
  late DateTime createdAt;
  bool isCompleted = false;
}
