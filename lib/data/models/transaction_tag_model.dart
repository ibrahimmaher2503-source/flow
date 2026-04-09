import 'package:isar/isar.dart';

part 'transaction_tag_model.g.dart';

@collection
class TransactionTag {
  Id id = Isar.autoIncrement;

  /// Tag name in Arabic (e.g., "رمضان", "سفر", "فرح أحمد")
  @Index(unique: true)
  late String name;

  /// Number of transactions using this tag (for frequency sorting)
  int usageCount = 0;

  /// Last time this tag was used (for recency sorting)
  DateTime? lastUsedAt;

  /// Auto-assigned color from palette (hex)
  String? colorHex;

  /// Timestamp when tag was first created
  late DateTime createdAt;
}
