import 'package:isar/isar.dart';

part 'recurring_transaction_model.g.dart';

@collection
class RecurringTransaction {
  Id id = Isar.autoIncrement;

  late double amount;
  late String type; // 'income' | 'expense'
  late String category;
  late String name;
  late String frequency; // 'daily' | 'weekly' | 'monthly' | 'yearly'
  late DateTime nextDueDate;
  late DateTime startDate;
  DateTime? endDate;
  bool isActive = true;
  bool autoAdd = false;
}
