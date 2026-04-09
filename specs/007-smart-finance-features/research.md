# Research: Core Smart Finance Features

**Feature**: 007-smart-finance-features
**Date**: 2026-04-09

## Overview

This document captures technical research and decisions made during planning for the six smart features: Safe-to-Spend, Envelope Budgeting, Transaction Tags, Cash Flow Forecast, Smart Insights, and Smart Bill Reminders.

---

## 1. Safe-to-Spend Calculation Strategy

### Decision
Use a computed service that aggregates data from multiple existing providers, cached via Riverpod FutureProvider with dependency-based invalidation.

### Rationale
- Existing pattern: `gamification_provider.dart` already computes finance score from multiple data sources
- Performance: Can reuse existing `monthlyTransactionsProvider`, `recurringTransactionsProvider`, `activeGoalsProvider`
- Reactivity: Riverpod's `ref.watch()` ensures automatic recalculation when dependencies change

### Alternatives Considered
1. **Stored computed field in database** — Rejected: Would require triggers/listeners, more complex than provider pattern
2. **Real-time calculation on every UI render** — Rejected: Potentially slow with large datasets
3. **Background isolate** — Rejected: Overkill for typical <10k transactions; adds complexity

### Implementation Approach
```dart
final safeToSpendProvider = FutureProvider<SafeToSpendData>((ref) async {
  final wallets = await ref.watch(allWalletsProvider.future);
  final installments = await ref.watch(activeInstallmentsProvider.future);
  final recurring = await ref.watch(activeRecurringProvider.future);
  final goals = await ref.watch(activeGoalsProvider.future);

  return SafeToSpendService.calculate(
    totalBalance: wallets.fold(0, (sum, w) => sum + w.balance),
    upcomingInstallments: installments,
    upcomingRecurring: recurring,
    unmetGoalContributions: goals,
  );
});
```

---

## 2. Envelope Model Design

### Decision
Create a new `Envelope` Isar collection separate from `Budget`, with a category link and month/year tracking.

### Rationale
- **Separation of concerns**: Envelopes are allocations; Budgets are limits — different mental models
- **Existing Budget model** is simple (categoryName, limitAmount, period) — extending it would conflate concepts
- **Month-based tracking**: Envelopes reset monthly; need to track allocations per month
- **Rollover support**: Requires tracking previous month's remaining amount

### Alternatives Considered
1. **Extend Budget model** — Rejected: Would make Budget semantically overloaded
2. **Single Envelope replacing Budget** — Rejected: Some users may prefer simple budgets; need toggle
3. **Envelope as view on transactions** — Rejected: Need explicit allocation amounts, not just limits

### Model Structure
```dart
@collection
class Envelope {
  Id id = Isar.autoIncrement;
  late String name;           // Arabic name
  late String categoryName;   // Links to Category
  late double allocatedAmount;
  late String iconName;
  late String colorHex;
  bool isEssential = false;
  bool rolloverEnabled = false;
  int sortOrder = 0;

  @Index(composite: [CompositeIndex('month')])
  late int year;
  late int month;

  // Computed: spent amount comes from TransactionRepo query
}
```

---

## 3. Transaction Tags Implementation

### Decision
Add `tags` field (List<String>) directly to Transaction model. Create separate `TransactionTag` collection for metadata (usage count, color, last used).

### Rationale
- **Simplicity**: Tags as strings in transaction avoid complex joins
- **Autocomplete**: Separate metadata collection enables fast frequency-sorted suggestions
- **Rename/Delete**: Can query transactions by tag string, update in batch

### Alternatives Considered
1. **Tag IDs with separate collection** — Rejected: Adds complexity; strings are sufficient
2. **Embedded tag objects** — Rejected: Isar embedded objects less flexible for metadata
3. **Tags as subcategories** — Rejected: Tags are cross-category; different purpose

### Model Changes
```dart
// In Transaction model - ADD:
List<String> tags = [];

// New collection:
@collection
class TransactionTag {
  Id id = Isar.autoIncrement;
  @Index(unique: true)
  late String name;
  int usageCount = 0;
  DateTime? lastUsedAt;
  String? colorHex;  // Auto-assigned from palette
}
```

### Query Pattern
```dart
// Find transactions by tag
isar.transactions.filter().tagsElementEqualTo('رمضان').findAll();

// Update tag name (rename)
isar.writeTxn(() async {
  final txns = await isar.transactions.filter().tagsElementEqualTo(oldName).findAll();
  for (final txn in txns) {
    txn.tags = txn.tags.map((t) => t == oldName ? newName : t).toList();
  }
  await isar.transactions.putAll(txns);
});
```

---

## 4. Cash Flow Forecast Algorithm

### Decision
Use a day-by-day projection with three scenarios based on historical spending patterns from last 3 months.

### Rationale
- **30-day horizon**: Matches monthly budget cycle; longer is less accurate
- **Three scenarios**: Provides risk range without overwhelming complexity
- **Historical basis**: Uses actual user data rather than generic estimates
- **Known events**: Installments and recurring transactions are deterministic; discretionary spending is estimated

### Algorithm
```
1. Get current total balance across all wallets
2. Calculate average daily discretionary spending from last 3 months:
   - Total expenses - (recurring expenses + installment payments) / days
   - Optimistic: Use lowest month's average
   - Realistic: Use overall average
   - Pessimistic: Use highest month's average
3. For each day in next 30 days:
   a. Add known income (recurring income due that day)
   b. Subtract known expenses (recurring expenses, installments due that day)
   c. Subtract estimated discretionary (per scenario)
   d. Store projected balance
4. Return: daily projections, events list, warnings if any scenario goes negative
```

### Performance Consideration
- Cache forecast for 24 hours or until data changes
- Invalidate on: new transaction, installment payment, recurring change

---

## 5. Smart Insights Generation

### Decision
Generate insights on-demand (app open, transaction add, pull-to-refresh) with caching in Isar. Use hash-based deduplication.

### Rationale
- **On-demand generation**: Avoids background processing complexity
- **Caching in Isar**: Persists insights across app restarts; enables dismissal tracking
- **Hash deduplication**: Each insight type + parameters = unique hash; prevents duplicates

### Insight Types & Detection Logic

| Type | Detection | Priority |
|------|-----------|----------|
| Spending Spike | category spending > 130% of 3-month avg | High if >150%, Medium if 130-150% |
| Savings Opportunity | discretionary category consistently high 3+ months | Medium |
| Streak Recognition | transaction logged every day for 7+ days | Low (positive) |
| Day Pattern | highest spending day of week | Low |
| Category Shift | category growing >20% month-over-month for 3 months | Medium |
| Goal Progress | on track / behind schedule based on deadline | High if behind |
| Monthly Summary | generated on 1st of month | Medium |
| Unusual Transaction | amount > 3x category average | High |
| Positive Reinforcement | this month spending < last month | Low (positive) |

### Model
```dart
@collection
class Insight {
  Id id = Isar.autoIncrement;
  late String type;
  late String titleAr;
  late String descriptionAr;
  late int priority;  // 1 = high, 2 = medium, 3 = low
  String? iconName;
  String? colorHex;
  String? actionRoute;  // e.g., '/transactions?category=food'
  bool isDismissed = false;

  @Index(unique: true)
  late String hash;  // type + params hash for deduplication

  @Index()
  late String monthKey;  // YYYY-MM for monthly grouping

  late DateTime generatedAt;
}
```

---

## 6. Smart Bill Reminders Integration

### Decision
Extend existing NotificationService with contextual bill reminders. No new Isar model; compute coverage status on-the-fly.

### Rationale
- **Existing notification infrastructure**: NotificationService already handles scheduling
- **Coverage is dynamic**: Balance and envelope state change frequently; storing would be stale
- **Reminder state**: Track sent/dismissed in memory or simple SharedPreferences (not critical to persist)

### Coverage Status Calculation
```dart
enum CoverageStatus { comfortable, tight, needsTransfer, critical }

CoverageStatus checkBillCoverage(double billAmount, Envelope? envelope, double walletBalance) {
  if (envelope != null) {
    final remaining = envelope.allocatedAmount - envelope.spentAmount;
    if (remaining >= billAmount && remaining - billAmount > billAmount * 0.2) {
      return CoverageStatus.comfortable;
    } else if (remaining >= billAmount) {
      return CoverageStatus.tight;
    } else if (walletBalance >= billAmount) {
      return CoverageStatus.needsTransfer;
    }
  } else if (walletBalance >= billAmount) {
    return CoverageStatus.comfortable;
  }
  return CoverageStatus.critical;
}
```

### Reminder Schedule
- 3 days before: `showBillReminder(name, amount, coverageStatus, daysUntil: 3)`
- 1 day before: `showBillReminder(name, amount, coverageStatus, daysUntil: 1)`
- On due date: `showBillReminder(name, amount, coverageStatus, daysUntil: 0)`

---

## 7. fl_chart Usage for Forecast

### Decision
Use `LineChart` with three `LineChartBarData` series (optimistic, realistic, pessimistic) and `FlSpot` markers for events.

### Rationale
- **Already in project**: fl_chart ^0.68.0 in pubspec.yaml
- **Existing pattern**: `CategoryPieChart` shows how to style charts with app theme
- **LineChart suitable**: 30-day projection is classic line chart use case

### Implementation Sketch
```dart
LineChart(
  LineChartData(
    lineBarsData: [
      LineChartBarData(
        spots: realisticSpots,
        color: AppColors.primary,
        isCurved: true,
      ),
      LineChartBarData(
        spots: optimisticSpots,
        color: AppColors.success,
        dashArray: [5, 5],
      ),
      LineChartBarData(
        spots: pessimisticSpots,
        color: AppColors.danger,
        dashArray: [5, 5],
      ),
    ],
    lineTouchData: LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        // Show event details on tap
      ),
    ),
    // Event markers via extraLinesData or showingTooltipIndicators
  ),
)
```

---

## 8. Settings Integration

### Decision
Add `envelopeBudgetingEnabled` field to existing `AppSettings` singleton model.

### Rationale
- **Existing pattern**: AppSettings already stores feature toggles (smsParsingEnabled, notificationsEnabled)
- **No migration needed**: Isar handles new nullable/default fields gracefully

### Change
```dart
// In AppSettings model - ADD:
bool envelopeBudgetingEnabled = false;
```

---

## 9. Route Additions

### Decision
Add 4 new routes to existing `AppRouter`:

| Route | Screen | Notes |
|-------|--------|-------|
| `/envelopes` | EnvelopesScreen | Replaces /budgets when enabled |
| `/envelopes/allocate` | EnvelopeAllocateScreen | Quick income allocation |
| `/tags` | TagsScreen | Tag analytics |
| `/forecast` | ForecastScreen | 30-day projection |
| `/insights` | InsightsScreen | Full insights list |

### Implementation
```dart
// In app_router.dart
static const envelopes = '/envelopes';
static const envelopeAllocate = '/envelopes/allocate';
static const tags = '/tags';
static const forecast = '/forecast';
static const insights = '/insights';

// Route registration follows existing pattern
```

---

## 10. Database Schema Migration

### Decision
Isar handles schema changes automatically. New collections and fields with defaults are added without explicit migration.

### Changes Summary
1. **New collections**: Envelope, TransactionTag, Insight
2. **Modified collections**: Transaction (add `tags` field), AppSettings (add `envelopeBudgetingEnabled`)

### Post-change requirement
Run `flutter pub run build_runner build --delete-conflicting-outputs` after model changes.

Update `IsarService.open()` to register new schemas:
```dart
await Isar.open([
  // Existing...
  EnvelopeSchema,
  TransactionTagSchema,
  InsightSchema,
]);
```

---

## Summary

All technical decisions follow existing FlowSpend patterns:
- Riverpod for state management
- Isar for local persistence
- Repository pattern for data access
- Service layer for business logic
- Feature-based folder structure
- fl_chart for visualizations
- NotificationService for alerts

No external dependencies added. All features remain local-only and offline-capable.
