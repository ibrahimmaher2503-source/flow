# Quickstart: Core Smart Finance Features

**Feature**: 007-smart-finance-features
**Date**: 2026-04-09

## Overview

This guide provides step-by-step implementation order for the six smart features, respecting dependencies and prioritizing quick wins.

---

## Prerequisites

Before starting implementation:

1. **Ensure clean working state**
   ```bash
   git checkout 007-smart-finance-features
   flutter pub get
   flutter analyze  # Should pass
   ```

2. **Verify existing tests pass**
   ```bash
   flutter test
   ```

3. **Review existing code patterns** in:
   - `lib/providers/gamification_provider.dart` — complex computed provider
   - `lib/data/services/installment_service.dart` — service pattern
   - `lib/features/reports/widgets/category_pie_chart.dart` — fl_chart usage

---

## Implementation Order

### Phase 1: Foundation (Do First)

#### 1.1 Data Models (Day 1)

**Create new models:**

```
lib/data/models/
├── envelope_model.dart       # See data-model.md
├── transaction_tag_model.dart
└── insight_model.dart
```

**Modify existing models:**
- `transaction_model.dart` — Add `List<String> tags = [];`
- `app_settings_model.dart` — Add `bool envelopeBudgetingEnabled = false;`

**Generate Isar code:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Update IsarService:**
```dart
// lib/data/services/isar_service.dart
await Isar.open([
  // ... existing schemas
  EnvelopeSchema,
  TransactionTagSchema,
  InsightSchema,
]);
```

**Verify:** Run `flutter analyze` — no errors.

---

#### 1.2 Repositories (Day 1-2)

Create repositories following existing patterns in `lib/data/repositories/`:

```dart
// envelope_repo.dart
class EnvelopeRepository {
  final Isar isar;
  EnvelopeRepository(this.isar);

  Future<List<Envelope>> getByMonth(int year, int month) async {
    return isar.envelopes
      .filter()
      .yearEqualTo(year)
      .monthEqualTo(month)
      .sortBySortOrder()
      .findAll();
  }

  Future<Envelope?> getByCategory(String categoryName, int year, int month) async {
    return isar.envelopes
      .filter()
      .categoryNameEqualTo(categoryName)
      .yearEqualTo(year)
      .monthEqualTo(month)
      .findFirst();
  }

  Future<int> add(Envelope envelope) async {
    return isar.writeTxn(() => isar.envelopes.put(envelope));
  }

  // ... update, delete
}

// tag_repo.dart
class TagRepository {
  final Isar isar;
  TagRepository(this.isar);

  Future<List<TransactionTag>> getAllSortedByFrequency() async {
    return isar.transactionTags
      .where()
      .sortByUsageCountDesc()
      .findAll();
  }

  Future<TransactionTag?> getByName(String name) async {
    return isar.transactionTags
      .filter()
      .nameEqualTo(name)
      .findFirst();
  }

  Future<void> incrementUsage(String name) async {
    await isar.writeTxn(() async {
      final tag = await getByName(name);
      if (tag != null) {
        tag.usageCount++;
        tag.lastUsedAt = DateTime.now();
        await isar.transactionTags.put(tag);
      }
    });
  }
}

// insight_repo.dart
class InsightRepository {
  final Isar isar;
  InsightRepository(this.isar);

  Future<List<Insight>> getUndismissedForMonth(String monthKey) async {
    return isar.insights
      .filter()
      .monthKeyEqualTo(monthKey)
      .isDismissedEqualTo(false)
      .sortByPriority()
      .findAll();
  }

  Future<bool> existsByHash(String hash) async {
    return await isar.insights.filter().hashEqualTo(hash).findFirst() != null;
  }
}
```

**Register providers:**
```dart
// lib/providers/ — add to existing provider files or create new ones
final envelopeRepoProvider = Provider<EnvelopeRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return EnvelopeRepository(isar);
});
```

---

### Phase 2: P1 Feature — Safe-to-Spend (Day 2-3)

This is the highest priority and enables other features.

#### 2.1 SafeToSpendService

```dart
// lib/data/services/safe_to_spend_service.dart
class SafeToSpendService {
  static SafeToSpendData calculate({
    required double totalBalance,
    required List<InstallmentPlan> upcomingInstallments,
    required List<RecurringTransaction> upcomingRecurring,
    required List<SavingsGoal> activeGoals,
    required double spentThisMonth,
    required int dayOfMonth,
    required int daysInMonth,
  }) {
    // Calculate obligations
    final installmentTotal = upcomingInstallments
      .where((p) => p.status == 'active')
      .fold(0.0, (sum, p) => sum + p.monthlyAmount);

    final recurringTotal = upcomingRecurring
      .where((r) => r.type == 'expense' && r.isActive)
      .fold(0.0, (sum, r) => sum + r.amount);

    final goalContributions = _calculateGoalContributions(activeGoals);

    final obligations = installmentTotal + recurringTotal + goalContributions;
    final safeAmount = (totalBalance - obligations).clamp(0, double.infinity);

    // Calculate velocity
    final velocity = _calculateVelocity(
      safeAmount, spentThisMonth, dayOfMonth, daysInMonth);

    return SafeToSpendData(
      safeAmount: safeAmount,
      totalBalance: totalBalance,
      upcomingInstallments: installmentTotal,
      upcomingRecurring: recurringTotal,
      unmetGoalContributions: goalContributions,
      percentOfBalance: totalBalance > 0 ? safeAmount / totalBalance : 0,
      velocity: velocity,
      breakdown: _buildBreakdown(upcomingInstallments, upcomingRecurring, activeGoals),
    );
  }
}
```

#### 2.2 SafeToSpendProvider

```dart
// lib/providers/safe_to_spend_provider.dart
final safeToSpendProvider = FutureProvider<SafeToSpendData>((ref) async {
  final wallets = await ref.watch(allWalletsProvider.future);
  final installments = await ref.watch(activeInstallmentsProvider.future);
  final recurring = await ref.watch(activeRecurringProvider.future);
  final goals = await ref.watch(activeGoalsProvider.future);
  final monthlyExpenses = await ref.watch(monthlyExpenseProvider.future);

  final now = DateTime.now();

  return SafeToSpendService.calculate(
    totalBalance: wallets.fold(0.0, (sum, w) => sum + w.balance),
    upcomingInstallments: installments,
    upcomingRecurring: recurring,
    activeGoals: goals,
    spentThisMonth: monthlyExpenses,
    dayOfMonth: now.day,
    daysInMonth: DateTime(now.year, now.month + 1, 0).day,
  );
});
```

#### 2.3 Dashboard UI

```dart
// lib/features/dashboard/widgets/safe_to_spend_card.dart
class SafeToSpendCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(safeToSpendProvider);

    return asyncData.when(
      data: (data) => _buildCard(context, data),
      loading: () => LoadingShimmer(...),
      error: (e, s) => EmptyState(...),
    );
  }

  Widget _buildCard(BuildContext context, SafeToSpendData data) {
    return GlassCard(
      onTap: () => _showBreakdown(context, data),
      child: Column(
        children: [
          Text('تقدر تصرف', style: AppTextStyles.caption),
          Text(
            CurrencyFormatter.format(data.safeAmount),
            style: AppTextStyles.displayLarge.copyWith(
              color: data.healthStatus.color,
            ),
          ),
          SpendingVelocityIndicator(velocity: data.velocity),
        ],
      ),
    );
  }
}
```

**Integrate into Dashboard screen** by replacing or augmenting existing balance display.

---

### Phase 3: P3 Feature — Transaction Tags (Day 3-4)

Tags are simple and don't depend on other features.

#### 3.1 Tag Input Widget

```dart
// lib/features/tags/widgets/tag_input_field.dart
class TagInputField extends ConsumerStatefulWidget {
  final List<String> initialTags;
  final ValueChanged<List<String>> onTagsChanged;
  // ...
}
```

#### 3.2 Integrate into Transaction Forms

Modify `add_transaction_screen.dart` and `edit_transaction_screen.dart` to include tag input.

#### 3.3 Tag Filter in Transactions Screen

Add tag filter to `filter_bar.dart`.

#### 3.4 Tag Analytics Screen

```dart
// lib/features/tags/tags_screen.dart
class TagsScreen extends ConsumerWidget {
  // List all tags with usage count and total spent
  // Tap tag → filtered transaction list
}
```

---

### Phase 4: P2 Feature — Envelope Budgeting (Day 4-6)

More complex; depends on categories and settings.

#### 4.1 EnvelopeService

See `contracts/envelope-service.md` for full interface.

#### 4.2 Settings Toggle

```dart
// In lib/features/settings/widgets/preferences_section.dart
// Add toggle for envelopeBudgetingEnabled
```

#### 4.3 Envelope Screen & Widgets

```dart
lib/features/envelopes/
├── envelopes_screen.dart
├── envelope_allocate_screen.dart
└── widgets/
    ├── envelope_card.dart          # Visual fill indicator
    ├── envelope_form_sheet.dart    # Create/edit bottom sheet
    └── envelope_summary_bar.dart   # Top summary stats
```

#### 4.4 Transaction Integration

When `envelopeBudgetingEnabled`:
- Show envelope remaining in category selector
- Warn on overage before confirming transaction

---

### Phase 5: P4 Feature — Cash Flow Forecast (Day 6-7)

Depends on historical data analysis.

#### 5.1 ForecastService

See `contracts/forecast-service.md` for algorithm.

#### 5.2 Forecast Screen

```dart
// lib/features/forecast/forecast_screen.dart
// Uses LineChart from fl_chart
```

#### 5.3 Dashboard Mini Forecast

Add mini sparkline chart to dashboard linking to full forecast.

---

### Phase 6: P5 Feature — Smart Insights (Day 7-8)

Complex analysis; can be incrementally improved.

#### 6.1 InsightsService

See `contracts/insights-service.md` for all insight types.

**Start with 3 insight types:**
1. Spending spike (high impact)
2. Streak recognition (positive reinforcement)
3. Monthly summary (easy to generate)

Add more insight types iteratively.

#### 6.2 Dashboard Insights Carousel

```dart
// lib/features/dashboard/widgets/insights_carousel.dart
class InsightsCarousel extends ConsumerWidget {
  // Shows top 2-3 insights with swipe-to-dismiss
}
```

#### 6.3 Full Insights Screen

```dart
// lib/features/insights/insights_screen.dart
// Grouped by time period with filter chips
```

---

### Phase 7: P6 Feature — Smart Bill Reminders (Day 8-9)

Depends on Safe-to-Spend and Envelopes for full context.

#### 7.1 BillReminderService

```dart
// lib/data/services/bill_reminder_service.dart
class BillReminderService {
  Future<List<BillContext>> getUpcomingBills(int days);
  CoverageStatus checkCoverage(BillContext bill);
  Future<void> scheduleReminders();
}
```

#### 7.2 Notification Integration

Extend `NotificationService` with:
```dart
Future<void> showBillReminder(BillContext bill);
```

#### 7.3 Bill Calendar Widget

```dart
// lib/features/recurring/widgets/bill_calendar.dart
// Calendar with color-coded dots for coverage status
```

---

## Testing Strategy

### Unit Tests (for each service)

```dart
// test/services/safe_to_spend_service_test.dart
void main() {
  test('calculates safe-to-spend correctly', () {
    final result = SafeToSpendService.calculate(
      totalBalance: 10000,
      upcomingInstallments: [/* mock */],
      // ...
    );
    expect(result.safeAmount, 6000);
  });
}
```

### Widget Tests

```dart
// test/widgets/safe_to_spend_card_test.dart
// Test rendering for healthy/caution/danger states
```

### Integration Tests

```dart
// integration_test/smart_features_test.dart
// Full flow: add transaction → envelope updates → insights generate
```

---

## Route Registration

Add to `lib/core/router/app_router.dart`:

```dart
static const envelopes = '/envelopes';
static const envelopeAllocate = '/envelopes/allocate';
static const tags = '/tags';
static const forecast = '/forecast';
static const insights = '/insights';

// In route generation:
case envelopes:
  return MaterialPageRoute(builder: (_) => const EnvelopesScreen());
// ... etc
```

---

## Checklist

- [ ] Phase 1: Data models created and generated
- [ ] Phase 1: Repositories created and registered
- [ ] Phase 2: Safe-to-Spend service and provider
- [ ] Phase 2: Dashboard card with velocity indicator
- [ ] Phase 3: Tag input widget
- [ ] Phase 3: Tag filter integration
- [ ] Phase 3: Tag analytics screen
- [ ] Phase 4: Envelope service
- [ ] Phase 4: Envelope screen and cards
- [ ] Phase 4: Settings toggle
- [ ] Phase 5: Forecast service
- [ ] Phase 5: Forecast chart screen
- [ ] Phase 6: Insights service (initial 3 types)
- [ ] Phase 6: Dashboard carousel
- [ ] Phase 7: Bill reminder service
- [ ] Phase 7: Bill calendar widget
- [ ] All routes registered
- [ ] Unit tests passing
- [ ] Widget tests passing
- [ ] Manual testing complete

---

## Common Patterns Reference

### Provider Invalidation After Mutation

```dart
Future<void> addTransaction(WidgetRef ref, Transaction txn) async {
  final repo = ref.read(transactionRepoProvider);
  await repo.add(txn);

  // Invalidate dependent providers
  ref.invalidate(monthlyTransactionsProvider);
  ref.invalidate(safeToSpendProvider);
  ref.invalidate(envelopeProvider); // if envelopes affected
  ref.invalidate(insightsProvider); // trigger insight regeneration
}
```

### Arabic Month Names

```dart
String arabicMonthName(int month) {
  const months = [
    '', 'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
  ];
  return months[month];
}
```

### Theme-Aware Colors

```dart
Color getHealthColor(BuildContext context, HealthStatus status) {
  final colors = Theme.of(context).extension<AppColorScheme>()!;
  switch (status) {
    case HealthStatus.healthy: return colors.success;
    case HealthStatus.caution: return colors.warning;
    case HealthStatus.danger: return colors.danger;
  }
}
```
