import 'package:isar/isar.dart';

part 'wallet_model.g.dart';

@collection
class Wallet {
  Id id = Isar.autoIncrement;

  late String name;
  late String type; // 'cash' | 'bank' | 'ewallet'
  late double balance;
  late String icon;
  late String color;
  late int sortOrder;
}
