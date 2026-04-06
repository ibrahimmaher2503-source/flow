import 'package:isar/isar.dart';

part 'installment_provider_model.g.dart';

@collection
class InstallmentProvider {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String name;

  late String icon;
  late String color;
  double? creditLimit;
  late DateTime createdAt;
}
