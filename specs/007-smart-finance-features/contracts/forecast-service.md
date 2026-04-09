# Contract: ForecastService

**Feature**: 007-smart-finance-features
**Component**: Cash Flow Forecast Service

## Purpose

Generates a 30-day financial projection showing three scenarios (optimistic, realistic, pessimistic) based on historical spending patterns and known upcoming events.

## Interface

```dart
abstract class ForecastService {
  /// Generate 30-day forecast starting from today
  ///
  /// Requires at least 1 month of history for basic forecast.
  /// Uses 3 months for optimistic/pessimistic scenarios.
  Future<ForecastData> generateForecast();

  /// Get forecast for specific date range
  Future<ForecastData> generateForecastRange(DateTime start, DateTime end);

  /// Get mini forecast for dashboard (next 7 days + month end)
  Future<MiniForecastData> getMiniForcast();

  /// Calculate safety days (days until pessimistic goes negative)
  int calculateSafetyDays(List<ForecastDay> days);

  /// Get upcoming events in next N days
  Future<List<ForecastEvent>> getUpcomingEvents(int days);
}
```

## Data Types

```dart
class ForecastData {
  final List<ForecastDay> days;          // 30 days of projections
  final ForecastSummary summary;
  final ForecastAssumptions assumptions;
  final List<ForecastWarning> warnings;
  final bool hasInsufficientData;        // < 1 month history
}

class MiniForecastData {
  final List<FlSpot> sparklinePoints;    // 7 data points for mini chart
  final double monthEndBalance;          // Realistic scenario
  final ForecastEvent? nextEvent;
  final bool hasWarning;
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
  final DateTime date;
}

enum ForecastEventType {
  income,       // Green marker
  expense,      // Orange marker
  installment,  // Red marker
  bill,         // Orange marker (from recurring)
}

class ForecastSummary {
  final double expectedMonthEndBalance;  // Realistic scenario
  final ForecastEvent? nextObligation;   // Soonest installment or bill
  final int safetyDays;                  // Days until negative
  final double currentBalance;
}

class ForecastAssumptions {
  final double dailySpendingOptimistic;
  final double dailySpendingRealistic;
  final double dailySpendingPessimistic;
  final int monthsOfHistoryUsed;
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

## Forecast Algorithm

### Step 1: Calculate Baseline

```dart
currentBalance = sum(wallet.balance for all wallets);
```

### Step 2: Calculate Daily Discretionary Spending

```dart
// Get last 3 months of transactions (or available history)
months = getLast3Months();

for each month:
  totalExpenses = sum(expense transactions)
  knownExpenses = sum(recurring expenses) + sum(installment payments)
  discretionary = totalExpenses - knownExpenses
  dailyDiscretionary = discretionary / daysInMonth

optimisticDaily = min(dailyDiscretionary across months)  // Best month
realisticDaily = avg(dailyDiscretionary across months)   // Average
pessimisticDaily = max(dailyDiscretionary across months) // Worst month
```

### Step 3: Build Daily Projections

```dart
for day in next30Days:
  // Start with previous day's balance (or current for day 0)
  balance = previousBalance

  // Add known income
  for income in recurringIncomeOnDay(day):
    balance += income.amount
    events.add(ForecastEvent(income.name, income.amount, income))

  // Subtract known expenses
  for expense in recurringExpensesOnDay(day):
    balance -= expense.amount
    events.add(ForecastEvent(expense.name, expense.amount, bill))

  for installment in installmentsDueOnDay(day):
    balance -= installment.monthlyAmount
    events.add(ForecastEvent(installment.itemName, installment.monthlyAmount, installment))

  // Subtract estimated discretionary
  optimisticBalance = balance - optimisticDaily
  realisticBalance = balance - realisticDaily
  pessimisticBalance = balance - pessimisticDaily

  days.add(ForecastDay(...))
```

### Step 4: Generate Warnings

```dart
for each day where any scenario < 0:
  if pessimisticBalance < 0:
    warnings.add(ForecastWarning(
      date: day,
      messageAr: "تنبيه: ممكن الرصيد يكون سالب يوم [date] لو المصاريف كانت عالية",
      scenario: pessimistic
    ))
  // Similar for realistic and optimistic
```

### Step 5: Calculate Safety Days

```dart
safetyDays = 0;
for day in days:
  if day.pessimisticBalance >= 0:
    safetyDays++;
  else:
    break;
```

## Event Detection

### Recurring Transactions

```dart
isOnDay(recurring, targetDate):
  if recurring.frequency == 'daily': return true
  if recurring.frequency == 'weekly':
    return targetDate.weekday == recurring.nextDueDate.weekday
  if recurring.frequency == 'monthly':
    return targetDate.day == recurring.nextDueDate.day
  if recurring.frequency == 'yearly':
    return targetDate.month == recurring.nextDueDate.month
        && targetDate.day == recurring.nextDueDate.day
```

### Installment Payments

```dart
isInstallmentDue(plan, targetDate):
  return targetDate.day == plan.dayOfMonth
      && plan.status == 'active'
      && plan.paidInstallments < plan.totalInstallments
```

## Dependencies

- `WalletRepository.getTotalBalance()`
- `TransactionRepository.getByMonthRange()` (historical spending)
- `RecurringRepository.getActive()`
- `InstallmentRepository.getActiveWithUpcomingPayment()`

## Error Handling

| Scenario | Behavior |
|----------|----------|
| No history | Set `hasInsufficientData = true`, use 0 for discretionary |
| No wallets | Return forecast with 0 balance throughout |
| < 3 months history | Use available months; flag in assumptions |
| Database error | Propagate exception |

## Caching Strategy

- Cache full forecast for 24 hours
- Invalidate on: new transaction, recurring change, installment change
- Mini forecast: Recalculate on each dashboard view (fast enough)

## UI Chart Integration

For fl_chart `LineChart`:

```dart
// Convert to FlSpot for chart
realisticSpots = days.mapIndexed((i, day) =>
  FlSpot(i.toDouble(), day.realisticBalance)
).toList();

// Event markers via extraLinesData or annotations
eventMarkers = days.expand((day) => day.events.map((e) =>
  ChartMarker(x: dayIndex, color: e.type.color)
)).toList();
```

## Arabic Labels

| Element | Arabic |
|---------|--------|
| Screen title | توقعات التدفق المالي |
| Expected month end | رصيدك المتوقع آخر الشهر |
| Next obligation | أقرب التزام |
| Safety days | أيام الأمان |
| Optimistic | متفائل |
| Realistic | واقعي |
| Pessimistic | متشائم |
| Warning prefix | تنبيه: |
| Insufficient data | محتاج بيانات 3 شهور على الأقل للتوقعات الدقيقة |
