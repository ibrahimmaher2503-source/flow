# Data Model: FlowSpend Enhancement Features

**Date**: 2026-04-08
**Branch**: `005-flowspend-enhancements`

## Overview

This document defines the new Isar collections and modifications to existing models for the 8 enhancement features.

---

## New Collections

### 1. CategoryMapping (User-Learned Categorization)

Stores user corrections to auto-categorization suggestions for learning.

```dart
@collection
class CategoryMapping {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String keyword;           // Normalized keyword (lowercase, trimmed)

  late String categoryName;      // Target category name
  late int hitCount;             // Times this mapping was used
  late DateTime lastUsedAt;      // For prioritization
  late DateTime createdAt;
}
```

**Validation Rules**:
- `keyword` must be non-empty and unique
- `categoryName` must match an existing Category name
- `hitCount` starts at 1, increments on each match

**Indexes**:
- `keyword` (unique) - Primary lookup
- Composite index on `categoryName` - For cleanup if category deleted

---

### 2. DetectedPattern (Recurring Transaction Detection)

Stores detected recurring spending patterns.

```dart
@collection
class DetectedPattern {
  Id id = Isar.autoIncrement;

  @Index()
  late String normalizedDescription;  // Lowercase, amounts/dates stripped

  String? merchantName;               // Extracted merchant if available
  String? categoryName;               // Auto-detected category
  late double averageAmount;          // Average across occurrences
  late String frequency;              // 'daily' | 'weekly' | 'monthly' | 'yearly'
  late double confidenceScore;        // 0.0 to 1.0
  late int occurrenceCount;           // Number of matching transactions
  late DateTime lastDetectedAt;
  late DateTime nextExpectedAt;       // Calculated next occurrence

  // Status flags
  bool isAccepted = false;            // User accepted → created recurring
  bool isDismissed = false;           // User dismissed
  DateTime? dismissedAt;              // Track dismissal time for re-surface logic
  int? linkedRecurringId;             // ID of created RecurringTransaction

  late DateTime createdAt;
  late DateTime updatedAt;

  @Index()
  String get statusIndex => isDismissed ? 'dismissed' : (isAccepted ? 'accepted' : 'pending');
}
```

**Validation Rules**:
- `confidenceScore` between 0.0 and 1.0
- `frequency` must be one of: 'daily', 'weekly', 'monthly', 'yearly'
- `occurrenceCount` >= 2 (minimum for pattern detection)

**State Transitions**:
```
pending → accepted (user taps accept) → links to RecurringTransaction
pending → dismissed (user taps dismiss) → can re-surface after 3+ new matches
```

---

### 3. WeeklyChallenge (Gamification)

Stores weekly challenges and progress.

```dart
@collection
class WeeklyChallenge {
  Id id = Isar.autoIncrement;

  late String type;              // ChallengeType enum as string
  late String description;       // Arabic display text
  late double targetValue;       // Target to achieve (amount, count, percentage)
  late double currentProgress;   // Current progress toward target
  late DateTime startDate;       // Monday of the challenge week
  late DateTime endDate;         // Sunday of the challenge week
  bool isCompleted = false;
  bool pointsAwarded = false;    // Track if points already given
  late int pointsReward;         // Points awarded on completion

  late DateTime createdAt;

  @Index()
  String get weekKey => '${startDate.year}-W${_weekNumber(startDate)}';

  @Index()
  String get statusIndex => isCompleted ? 'completed' : 'active';
}
```

**Challenge Types** (stored as strings):
- `reduce_spending` - "وفّر 20% من مصاريفك الأسبوع ده"
- `no_entertainment` - "3 أيام بدون مصاريف ترفيه"
- `log_daily` - "سجّل كل معاملاتك يومياً"
- `food_under` - "خلّي مصاريف الأكل تحت X"
- `savings_target` - "حقق هدف ادخار صغير"

**Validation Rules**:
- `targetValue` must be positive
- `currentProgress` >= 0
- `startDate` must be a Monday
- `endDate` must be 6 days after startDate

---

## Modified Collections

### 4. AppSettings (Daily Spending Limit)

Extend existing singleton collection with daily limit fields.

```dart
@collection
class AppSettings {
  Id id = 0; // singleton

  // Existing fields...
  String currency = 'EGP';
  String language = 'ar';
  bool smsParsingEnabled = true;
  bool notificationsEnabled = true;
  int monthStartDay = 1;
  String defaultWallet = 'cash';
  int streakDays = 0;
  DateTime? lastLogDate;
  String themeMode = 'system';

  // NEW: Daily spending limit fields
  bool dailyLimitEnabled = false;
  double dailyLimitAmount = 0;           // 0 means no limit set
  double dailyLimitThreshold = 0.8;      // Warning at 80% default
  List<String> excludedCategoriesFromLimit = [];  // Categories to exclude
  DateTime? lastLimitWarningDate;        // Track to avoid spam (once per day)
  DateTime? lastLimitExceededDate;       // Track exceeded notification

  // NEW: Onboarding tracking
  bool onboardingCompleted = false;
}
```

**Validation Rules**:
- `dailyLimitAmount` >= 10 EGP when enabled (minimum enforced limit)
- `dailyLimitThreshold` between 0.5 and 0.95

---

## Entity Relationships

```
Transaction (existing)
    └── categoryIndex ←→ Category.name (existing)
    └── source: 'sms' → triggers auto-categorization
    └── → detected by DetectedPattern

Category (existing)
    ← CategoryMapping.categoryName
    ← DetectedPattern.categoryName
    ← AppSettings.excludedCategoriesFromLimit[]

RecurringTransaction (existing)
    ← DetectedPattern.linkedRecurringId (optional link)

CategoryMapping (new)
    → Category.name (via categoryName)

DetectedPattern (new)
    → Category.name (via categoryName, optional)
    → RecurringTransaction (via linkedRecurringId, optional)

WeeklyChallenge (new)
    → standalone, no direct relations

AppSettings (modified)
    → Category.name[] (via excludedCategoriesFromLimit)
```

---

## Isar Service Update

Update `lib/data/services/isar_service.dart` to include new schemas:

```dart
import '../models/category_mapping_model.dart';
import '../models/detected_pattern_model.dart';
import '../models/weekly_challenge_model.dart';

class IsarService {
  static Future<Isar> open() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(
      [
        // Existing schemas
        TransactionSchema,
        CategorySchema,
        BudgetSchema,
        WalletSchema,
        RecurringTransactionSchema,
        SavingsGoalSchema,
        InstallmentProviderSchema,
        InstallmentPlanSchema,
        AppSettingsSchema,
        DetectedSmsSchema,
        // NEW schemas
        CategoryMappingSchema,
        DetectedPatternSchema,
        WeeklyChallengeSchema,
      ],
      directory: dir.path,
      name: 'flowspend',
    );
  }
}
```

---

## Migration Notes

### No Breaking Changes

All changes are additive:
- 3 new collections (empty on first run)
- New fields in AppSettings have defaults (backward compatible)
- Existing data untouched

### Isar Auto-Migration

Isar handles schema evolution automatically:
- New collections created on first access
- New fields in existing collections get default values
- No manual migration code needed

### Post-Update Steps

After modifying models, run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Query Patterns

### CategoryMapping Queries

```dart
// Find learned mapping for keyword
Future<CategoryMapping?> findMapping(String keyword) {
  return isar.categoryMappings
      .filter()
      .keywordEqualTo(keyword.toLowerCase().trim())
      .findFirst();
}

// Get all mappings for a category (for cleanup)
Future<List<CategoryMapping>> getMappingsForCategory(String category) {
  return isar.categoryMappings
      .filter()
      .categoryNameEqualTo(category)
      .findAll();
}
```

### DetectedPattern Queries

```dart
// Get pending suggestions
Future<List<DetectedPattern>> getPendingSuggestions() {
  return isar.detectedPatterns
      .filter()
      .statusIndexEqualTo('pending')
      .confidenceScoreGreaterThan(0.4)
      .sortByConfidenceScoreDesc()
      .findAll();
}

// Find pattern by description
Future<DetectedPattern?> findPattern(String normalizedDesc) {
  return isar.detectedPatterns
      .filter()
      .normalizedDescriptionEqualTo(normalizedDesc)
      .findFirst();
}
```

### WeeklyChallenge Queries

```dart
// Get current week's challenge
Future<WeeklyChallenge?> getCurrentChallenge() {
  final now = DateTime.now();
  return isar.weeklyChallenges
      .filter()
      .startDateLessThan(now)
      .endDateGreaterThan(now)
      .findFirst();
}

// Get completed challenges
Future<List<WeeklyChallenge>> getCompletedChallenges() {
  return isar.weeklyChallenges
      .filter()
      .statusIndexEqualTo('completed')
      .sortByEndDateDesc()
      .findAll();
}
```

---

## Data Retention

| Collection | Retention Policy |
|------------|------------------|
| CategoryMapping | Permanent (user learning) |
| DetectedPattern | Keep 6 months of dismissed patterns, permanent for accepted |
| WeeklyChallenge | Keep all (history for gamification display) |
| AppSettings | Permanent singleton |
