import 'package:isar/isar.dart';

part 'insight_model.g.dart';

@collection
class Insight {
  Id id = Isar.autoIncrement;

  /// Insight type identifier
  /// Values: spending_spike, savings_opportunity, streak, day_pattern,
  ///         category_shift, goal_progress, monthly_summary,
  ///         unusual_transaction, positive_reinforcement
  late String type;

  /// Title in Arabic (e.g., "مصاريف أكل زادت")
  late String titleAr;

  /// Full description in Arabic
  late String descriptionAr;

  /// Priority: 1 = high (red), 2 = medium (amber), 3 = low (green/info)
  late int priority;

  /// Icon name from app icon set
  String? iconName;

  /// Accent color hex (based on type/priority)
  String? colorHex;

  /// Optional navigation action (e.g., "/transactions?category=food")
  String? actionRoute;

  /// Whether user has dismissed this insight
  bool isDismissed = false;

  /// Unique hash for deduplication: hash(type + parameters)
  @Index(unique: true)
  late String hash;

  /// Month this insight applies to (for grouping)
  @Index()
  late String monthKey;

  /// When insight was generated
  late DateTime generatedAt;

  /// When insight was dismissed (if applicable)
  DateTime? dismissedAt;
}
