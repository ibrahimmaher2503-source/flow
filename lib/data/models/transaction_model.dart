import 'package:isar/isar.dart';

part 'transaction_model.g.dart';

@collection
class Transaction {
  Id id = Isar.autoIncrement;

  late double amount;
  late String type; // 'income' | 'expense'
  late String category;
  String? subcategory;
  String? note;
  String? merchant;
  late DateTime date;
  late int walletId;
  String source = 'manual'; // 'manual' | 'sms' | 'recurring' | 'installment'
  String? smsBody;
  int? installmentPlanId;
  bool isInterest = false;
  late DateTime createdAt;

  /// Custom user tags for cross-category tracking (e.g., ["رمضان", "سفر"])
  List<String> tags = [];

  @Index()
  String get monthKey => '${date.year}-${date.month.toString().padLeft(2, '0')}';

  @Index()
  String get categoryIndex => category;

  @Index()
  String get sourceIndex => source;
}
