# Contract: InsightsService

**Feature**: 007-smart-finance-features
**Component**: Smart Insights Generation Service

## Purpose

Analyzes transaction data to generate personalized, actionable insights about spending patterns. Caches insights in Isar with dismissal tracking.

## Interface

```dart
abstract class InsightsService {
  /// Generate all insights for current month
  ///
  /// Checks existing cached insights, generates new ones if data changed.
  /// Returns insights sorted by priority.
  Future<List<Insight>> generateInsights();

  /// Get top N insights for dashboard display
  Future<List<Insight>> getTopInsights({int limit = 3});

  /// Get all insights grouped by time period
  Future<InsightGroups> getGroupedInsights();

  /// Mark insight as dismissed
  Future<void> dismissInsight(int insightId);

  /// Check if insights need regeneration
  Future<bool> needsRegeneration();

  /// Force regenerate all insights
  Future<void> forceRegenerate();

  /// Get insight count for badge display
  Future<int> getUndismissedCount();
}
```

## Data Types

```dart
class InsightGroups {
  final List<Insight> thisWeek;
  final List<Insight> thisMonth;
  final List<Insight> previous;
}

// Insight model defined in data-model.md
```

## Insight Generation

### Insight Types & Detection Logic

#### 1. Spending Spike (`spending_spike`)

```dart
for each category:
  thisMonthSpending = sum(expenses this month)
  avgLast3Months = avg(expenses last 3 months)

  if thisMonthSpending > avgLast3Months * 1.3:
    percentIncrease = (thisMonthSpending / avgLast3Months - 1) * 100
    priority = percentIncrease > 50 ? 1 : 2

    createInsight(
      type: 'spending_spike',
      titleAr: 'مصاريف $category زادت',
      descriptionAr: '$category الشهر ده $amount جنيه — أعلى من المعتاد بنسبة $percentIncrease%',
      priority: priority,
      actionRoute: '/transactions?category=$category',
    )
```

#### 2. Savings Opportunity (`savings_opportunity`)

```dart
discretionaryCategories = ['ترفيه', 'مطاعم', 'تسوق', 'كافيهات']

for each discretionary category:
  last3Months = getSpendingLast3Months(category)

  if all(month > avgOverall * 1.2 for month in last3Months):
    potentialSavings = avg(last3Months) * 0.2

    createInsight(
      type: 'savings_opportunity',
      titleAr: 'فرصة توفير في $category',
      descriptionAr: 'لو قللت مصاريف $category بـ 20% هتوفر ~$potentialSavings جنيه في الشهر',
      priority: 2,
      actionRoute: '/transactions?category=$category',
    )
```

#### 3. Streak Recognition (`streak`)

```dart
streakDays = appSettings.streakDays

if streakDays >= 7:
  createInsight(
    type: 'streak',
    titleAr: 'سلسلة تسجيل رائعة!',
    descriptionAr: 'ممتاز! بتسجل مصاريفك كل يوم من $streakDays أيام — استمر كده',
    priority: 3,
  )
```

#### 4. Day Pattern (`day_pattern`)

```dart
dayTotals = groupBy(transactions, (t) => t.date.weekday)
             .map((day, txns) => avg(sum(amounts)))

highestDay = dayTotals.maxBy((d) => d.value)

createInsight(
  type: 'day_pattern',
  titleAr: 'نمط الصرف الأسبوعي',
  descriptionAr: 'أكتر يوم بتصرف فيه هو ${arabicDayName(highestDay)} — متوسط $amount جنيه. حاول تخلي بالك يوم ${arabicDayName(highestDay)}',
  priority: 3,
)
```

#### 5. Category Shift (`category_shift`)

```dart
for each category:
  months = getMonthlySpending(category, last3Months)

  if isConsistentlyGrowing(months, threshold: 0.2):
    createInsight(
      type: 'category_shift',
      titleAr: '$category بتزيد',
      descriptionAr: '$category بتزيد كل شهر — من ${months.first} لـ ${months.last} في 3 شهور',
      priority: 2,
      actionRoute: '/transactions?category=$category',
    )
```

#### 6. Goal Progress (`goal_progress`)

```dart
for each active goal:
  if goal.deadline != null:
    monthsRemaining = monthsBetween(now, goal.deadline)
    amountRemaining = goal.targetAmount - goal.currentAmount
    requiredMonthly = amountRemaining / monthsRemaining

    recentMonthlyContribution = getAvgMonthlyContribution(goal)

    if recentMonthlyContribution >= requiredMonthly:
      projectedDate = calculateProjectedDate(goal)
      createInsight(
        type: 'goal_progress',
        titleAr: 'هدف ${goal.name} ماشي كويس',
        descriptionAr: 'لو كملت بالمعدل ده هتوصل لهدف ${goal.name} في $projectedDate',
        priority: 3,
      )
    else:
      shortfall = requiredMonthly - recentMonthlyContribution
      createInsight(
        type: 'goal_progress',
        titleAr: 'هدف ${goal.name} محتاج دفعة',
        descriptionAr: 'هدف ${goal.name} محتاج تزود التوفير بـ $shortfall عشان توصل في الوقت',
        priority: 1,
        actionRoute: '/goals',
      )
```

#### 7. Monthly Summary (`monthly_summary`)

```dart
// Generate on 1st of month for previous month
if today.day <= 3 && !hasMonthlyInsightForLastMonth():
  lastMonth = getLastMonthStats()

  createInsight(
    type: 'monthly_summary',
    titleAr: 'ملخص ${arabicMonthName(lastMonth)}',
    descriptionAr: 'الشهر اللي فات: دخل ${lastMonth.income}، مصاريف ${lastMonth.expenses}، وفرت ${lastMonth.savings}. أكتر category كانت ${lastMonth.topCategory} بـ ${lastMonth.topAmount}',
    priority: 2,
    actionRoute: '/reports',
  )
```

#### 8. Unusual Transaction (`unusual_transaction`)

```dart
for each transaction added today:
  categoryAvg = getAvgTransactionAmount(transaction.category, last3Months)

  if transaction.amount > categoryAvg * 3:
    createInsight(
      type: 'unusual_transaction',
      titleAr: 'معاملة كبيرة',
      descriptionAr: 'معاملة كبيرة: ${transaction.note ?? transaction.category} — ${transaction.amount} جنيه. ده أكتر من المعتاد في ${transaction.category}',
      priority: 1,
    )
```

#### 9. Positive Reinforcement (`positive_reinforcement`)

```dart
thisMonthExpenses = sum(expenses this month)
lastMonthExpenses = sum(expenses last month)

if thisMonthExpenses < lastMonthExpenses:
  savings = lastMonthExpenses - thisMonthExpenses

  createInsight(
    type: 'positive_reinforcement',
    titleAr: 'أداء ممتاز!',
    descriptionAr: 'مبروك! مصاريفك الشهر ده أقل من الشهر اللي فات بـ $savings جنيه',
    priority: 3,
  )
```

## Deduplication

```dart
String generateHash(String type, Map<String, dynamic> params) {
  final data = '$type:${jsonEncode(params)}';
  return sha256(data);
}

// Example:
hash = generateHash('spending_spike', {
  'category': 'أكل',
  'month': '2026-04',
  'percentIncrease': 45,
});
```

If insight with same hash exists and is not dismissed, skip generation.

## Regeneration Triggers

- On app open (if last generation > 24 hours)
- After adding new transaction
- On pull-to-refresh in insights screen
- On force refresh

## Dependencies

- `TransactionRepository.getByMonthRange()`
- `GoalRepository.getActive()`
- `InsightRepository` (CRUD for cached insights)
- `AppSettingsRepository.getSettings()` (streak days)

## Error Handling

| Scenario | Behavior |
|----------|----------|
| Insufficient data | Generate only applicable insights; skip data-dependent ones |
| Database error | Return cached insights if available; log error |
| Hash collision | Update existing insight if params different |

## Caching Strategy

- Store all generated insights in Isar `Insight` collection
- Query by `monthKey` for grouping
- Filter by `isDismissed = false` for active display
- Delete insights older than 3 months on cleanup

## Priority Colors

| Priority | Color | Use Case |
|----------|-------|----------|
| 1 (High) | Red/Danger | Spending spikes >50%, goals behind, critical |
| 2 (Medium) | Amber/Warning | Moderate spikes, savings opportunities |
| 3 (Low) | Green/Info | Positive reinforcement, streaks, patterns |

## Arabic Day Names

```dart
Map<int, String> arabicDays = {
  1: 'الاثنين',
  2: 'الثلاثاء',
  3: 'الأربعاء',
  4: 'الخميس',
  5: 'الجمعة',
  6: 'السبت',
  7: 'الأحد',
};
```
