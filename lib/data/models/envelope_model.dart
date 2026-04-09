import 'package:isar/isar.dart';

part 'envelope_model.g.dart';

@collection
class Envelope {
  Id id = Isar.autoIncrement;

  /// Display name in Arabic (e.g., "أكل", "مواصلات")
  late String name;

  /// Links to Category.name - determines which transactions affect this envelope
  late String categoryName;

  /// Amount allocated to this envelope for the month
  late double allocatedAmount;

  /// Icon name from app icon set
  late String iconName;

  /// Hex color code (e.g., "#6C63FF")
  late String colorHex;

  /// Essential envelopes (rent, bills) get priority alerts
  bool isEssential = false;

  /// If true, unspent amount rolls over to next month
  bool rolloverEnabled = false;

  /// Display order in list
  int sortOrder = 0;

  /// Year of this envelope allocation
  @Index(composite: [CompositeIndex('month')])
  late int year;

  /// Month of this envelope allocation (1-12)
  late int month;

  /// Timestamp when envelope was created
  late DateTime createdAt;

  /// Get monthKey for queries (matches Transaction.monthKey format)
  String get monthKey => '$year-${month.toString().padLeft(2, '0')}';
}
