import 'package:isar/isar.dart';

part 'category_model.g.dart';

@collection
class Category {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String name;

  late String type; // 'income' | 'expense'
  late String icon;
  late String color;
  List<String> subcategories = [];
  bool isCustom = false;
  late int sortOrder;
}
