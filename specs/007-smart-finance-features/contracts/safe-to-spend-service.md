# Contract: SafeToSpendService

**Feature**: 007-smart-finance-features
**Component**: Safe-to-Spend Calculation Service

## Purpose

Calculates the "safe-to-spend" amount — money the user can freely spend without affecting upcoming obligations. Provides spending velocity analysis.

## Interface

```dart
abstract class SafeToSpendService {
  /// Calculate safe-to-spend for current month
  ///
  /// Returns [SafeToSpendData] with:
  /// - safeAmount: Total balance minus all obligations
  /// - breakdown: Itemized list of what was subtracted
  /// - velocity: Current spending rate (slow/normal/fast)
  /// - healthStatus: Based on percentage of balance
  Future<SafeToSpendData> calculate();

  /// Get breakdown of upcoming obligations
  ///
  /// Returns list of [ObligationItem] with name, amount, dueDate, type
  Future<List<ObligationItem>> getObligations();

  /// Calculate spending velocity
  ///
  /// Compares actual spending rate to sustainable rate
  /// Returns [SpendingVelocity.fast] if spending > sustainable
  SpendingVelocity calculateVelocity(
    double safeToSpend,
    double spentThisMonth,
    int dayOfMonth,
    int daysInMonth,
  );
}
```

## Calculation Rules

### Safe-to-Spend Formula

```
Safe-to-Spend = Total Wallet Balance
              - Upcoming Installment Payments (rest of month)
              - Upcoming Recurring Expenses (rest of month)
              - Unmet Goal Contributions (monthly target - already contributed)
```

### Obligations Included

| Type | How Calculated |
|------|----------------|
| Installments | Sum of `monthlyAmount` for all active `InstallmentPlan` where payment not yet made this month |
| Recurring Expenses | Sum of `amount` for `RecurringTransaction` where `type = expense` and `nextDueDate` is in current month |
| Goal Contributions | For each `SavingsGoal` with deadline: monthly contribution needed minus amount already added this month |

### Velocity Calculation

```
sustainableRate = safeToSpend / remainingDays
actualRate = spentThisMonth / daysPassed

if actualRate > sustainableRate * 1.2 → fast
if actualRate < sustainableRate * 0.8 → slow
else → normal
```

### Health Status Thresholds

| Status | Condition |
|--------|-----------|
| healthy | safeToSpend > 30% of totalBalance |
| caution | safeToSpend between 10-30% of totalBalance |
| danger | safeToSpend < 10% of totalBalance |

## Dependencies

- `WalletRepository.getTotalBalance()`
- `InstallmentRepository.getActiveWithUpcomingPayment()`
- `RecurringRepository.getActiveExpenses()`
- `GoalRepository.getActiveWithDeadline()`
- `TransactionRepository.getByMonth()` (for spent calculation)

## Error Handling

| Scenario | Behavior |
|----------|----------|
| No wallets | Return safeAmount = 0, totalBalance = 0 |
| No obligations | Return safeAmount = totalBalance |
| Negative result | Return safeAmount = 0, set `isNegative = true` |
| Database error | Propagate exception to caller |

## Caching Strategy

- Cache result in provider
- Invalidate on: transaction add/edit/delete, installment payment, recurring change, goal update
- Provider dependency chain handles invalidation automatically

## Arabic Labels

| Field | Arabic |
|-------|--------|
| Label | تقدر تصرف |
| Fast spending | معدل صرف عالي |
| Normal spending | معدل صرف طبيعي |
| Slow spending | معدل صرف منخفض — ممتاز! |
| Warning (negative) | الالتزامات أكتر من الرصيد |
