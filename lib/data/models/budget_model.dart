import 'package:isar/isar.dart';

part 'budget_model.g.dart';

@collection
class Budget {
  Id id = Isar.autoIncrement;

  late String categoryName;
  late double limitAmount;
  late String period; // 'monthly' | 'weekly'
  late DateTime startDate;
  bool isActive = true;
}
