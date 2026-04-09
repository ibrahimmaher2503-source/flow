# Data Model: Core Smart Finance Features

**Feature**: 007-smart-finance-features
**Date**: 2026-04-09

## Overview

This document defines the data models for the six smart features. Three new Isar collections are introduced, and two existing models are modified.

---

## New Collections

### 1. Envelope

Virtual budget envelope for category-based spending allocation.

```dart
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

  // ===== COMPUTED (not stored) =====

  /// Get monthKey for queries (matches Transaction.monthKey format)
  String get monthKey => '$year-${month.toString().padLeft(2, '0')}';
}
```

**Indexes**:
- Composite index on `[year, month]` for monthly envelope queries

**Relationships**:
- Links to `Category` via `categoryName`
- Spent amount computed from `Transaction` queries filtered by category and monthKey

**Validation Rules**:
- `name` required, non-empty
- `categoryName` must match existing Category.name
- `allocatedAmount` >= 0
- `month` in range 1-12
- `year` >= 2020

---

### 2. TransactionTag

Metadata for transaction tags enabling autocomplete and analytics.

```dart
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
```

**Indexes**:
- Unique index on `name` for fast lookup and rename detection

**State Transitions**:
- Created: When user adds a new tag to a transaction
- Updated: `usageCount++` and `lastUsedAt` updated on each use
- Deleted: When user explicitly deletes tag (removes from all transactions)

**Validation Rules**:
- `name` required, non-empty, max 50 characters
- `name` supports Unicode (Arabic, emojis allowed)
- `usageCount` >= 0

---

### 3. Insight

Cached personalized spending insight with dismissal tracking.

```dart
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
```

**Indexes**:
- Unique index on `hash` prevents duplicate insights
- Index on `monthKey` for monthly grouping queries

**State Transitions**:
- Generated: Created with `isDismissed = false`
- Dismissed: User swipes away → `isDismissed = true`, `dismissedAt` set
- Expired: Insights from previous months auto-archived

**Validation Rules**:
- `type` must be one of defined insight types
- `priority` in range 1-3
- `hash` required, unique
- `monthKey` format: YYYY-MM

---

## Modified Collections

### 4. Transaction (Existing - Modified)

**Add field**:

```dart
/// Custom user tags for cross-category tracking
/// Example: ["رمضان", "سفر"]
List<String> tags = [];
```

**Full context** (existing fields for reference):
```dart
@collection
class Transaction {
  Id id = Isar.autoIncrement;
  late double amount;
  late String type;           // 'income' | 'expense'
  late String category;
  String? subcategory;
  String? note;
  String? merchant;
  late DateTime date;
  late int walletId;
  String source = 'manual';   // 'manual' | 'sms' | 'recurring' | 'installment'
  String? smsBody;
  int? installmentPlanId;
  bool isInterest = false;
  late DateTime createdAt;

  // NEW FIELD:
  List<String> tags = [];     // <-- ADD THIS

  @Index()
  String get monthKey => '${date.year}-${date.month.toString().padLeft(2, '0')}';
  @Index()
  String get categoryIndex => category;
  @Index()
  String get sourceIndex => source;
}
```

**Migration**: Isar handles new List field with default empty list automatically.

---

### 5. AppSettings (Existing - Modified)

**Add field**:

```dart
/// Whether envelope budgeting is enabled (replaces simple budgets)
bool envelopeBudgetingEnabled = false;
```

**Full context** (existing fields for reference):
```dart
@collection
class AppSettings {
  Id id = Isar.autoIncrement;
  String currency = 'EGP';
  String language = 'ar';
  bool smsParsingEnabled = true;
  bool notificationsEnabled = true;
  int monthStartDay = 1;
  int? defaultWallet;
  int streakDays = 0;
  DateTime? lastLogDate;
  String themeMode = 'dark';    // 'dark' | 'light' | 'system'

  // NEW FIELD:
  bool envelopeBudgetingEnabled = false;  // <-- ADD THIS
}
```

**Migration**: Isar handles new bool field with default false automatically.

---

## Computed Data Structures (Not Persisted)

These are Dart classes used for calculations and UI display, not stored in Isar.

### SafeToSpendData

```dart
class SafeToSpendData {
  final double safeAmount;
  final double totalBalance;
  final double upcomingInstallments;
  final double upcomingRecurring;
  final double unmetGoalContributions;
  final double percentOfBalance;
  final SpendingVelocity velocity;
  final List<ObligationItem> breakdown;

  bool get isNegative => safeAmount <= 0;
  HealthStatus get healthStatus {
    if (percentOfBalance > 0.30) return HealthStatus.healthy;
    if (percentOfBalance > 0.10) return HealthStatus.caution;
    return HealthStatus.danger;
  }
}

enum SpendingVelocity { slow, normal, fast }
enum HealthStatus { healthy, caution, danger }

class ObligationItem {
  final String name;
  final double amount;
  final DateTime? dueDate;
  final ObligationType type;
}

enum ObligationType { installment, recurring, goal }
```

### ForecastData

```dart
class ForecastData {
  final List<ForecastDay> days;
  final ForecastSummary summary;
  final ForecastAssumptions assumptions;
  final List<ForecastWarning> warnings;
}

class ForecastDay {
  final DateTime date;
  final double optimisticBalance;
  final double realisticBalance;
  final double pessimisticBalance;
  final List<ForecastEvent> events;
}

class ForecastEvent {
  final String name;
  final double amount;
  final ForecastEventType type;
}

enum ForecastEventType { income, expense, installment, bill }

class ForecastSummary {
  final double expectedMonthEndBalance;
  final ForecastEvent? nextObligation;
  final int safetyDays;  // Days until pessimistic goes negative
}

class ForecastAssumptions {
  final double dailySpendingOptimistic;
  final double dailySpendingRealistic;
  final double dailySpendingPessimistic;
  final List<String> includedRecurring;
  final List<String> includedInstallments;
}

class ForecastWarning {
  final DateTime date;
  final String messageAr;
  final ForecastScenario scenario;
}

enum ForecastScenario { optimistic, realistic, pessimistic }
```

### EnvelopeWithSpent

```dart
class EnvelopeWithSpent {
  final Envelope envelope;
  final double spentAmount;

  double get remaining => envelope.allocatedAmount - spentAmount;
  double get percentRemaining =>
    envelope.allocatedAmount > 0
      ? remaining / envelope.allocatedAmount
      : 0;

  EnvelopeStatus get status {
    if (percentRemaining <= 0) return EnvelopeStatus.empty;
    if (percentRemaining < 0.20) return EnvelopeStatus.danger;
    if (percentRemaining < 0.50) return EnvelopeStatus.warning;
    return EnvelopeStatus.healthy;
  }
}

enum EnvelopeStatus { healthy, warning, danger, empty }
```

### BillContext

```dart
class BillContext {
  final String name;
  final double amount;
  final DateTime dueDate;
  final int daysUntil;
  final CoverageStatus coverage;
  final String messageAr;
  final bool isPredicted;  // From SMS detection vs. confirmed recurring
}

enum CoverageStatus { comfortable, tight, needsTransfer, critical }
```

---

## Isar Schema Registration

Update `IsarService.open()` to include new schemas:

```dart
await Isar.open([
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
  EnvelopeSchema,
  TransactionTagSchema,
  InsightSchema,
]);
```

---

## Index Strategy

| Collection | Index | Purpose |
|------------|-------|---------|
| Envelope | `[year, month]` composite | Monthly envelope queries |
| TransactionTag | `name` unique | Fast lookup, rename detection |
| Insight | `hash` unique | Deduplication |
| Insight | `monthKey` | Monthly grouping |
| Transaction | `monthKey` (existing) | Monthly queries |
| Transaction | `categoryIndex` (existing) | Category filters |

---

## Data Integrity Rules

1. **Envelope → Category**: `categoryName` must match existing `Category.name`
2. **Transaction.tags → TransactionTag**: Tag strings should have corresponding metadata entries
3. **Insight.hash**: Must be unique; regenerating same insight should have same hash
4. **Envelope per month**: Only one envelope per `categoryName + year + month` combination

---

## Code Generation

After modifying models, run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates:
- `envelope_model.g.dart`
- `transaction_tag_model.g.dart`
- `insight_model.g.dart`
- Updated `transaction_model.g.dart`
- Updated `app_settings_model.g.dart`
