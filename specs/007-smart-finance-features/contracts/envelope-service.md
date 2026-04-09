# Contract: EnvelopeService

**Feature**: 007-smart-finance-features
**Component**: Envelope Budgeting Service

## Purpose

Manages virtual envelope budgeting system where users allocate fixed amounts to spending categories. Tracks spending against allocations and handles monthly rollover.

## Interface

```dart
abstract class EnvelopeService {
  /// Get all envelopes for a specific month with spent amounts
  ///
  /// Returns [EnvelopeWithSpent] which includes computed spent amount
  /// from transactions in that category for that month
  Future<List<EnvelopeWithSpent>> getEnvelopesForMonth(int year, int month);

  /// Create a new envelope
  ///
  /// Returns created envelope ID
  Future<int> createEnvelope(EnvelopeCreateRequest request);

  /// Update envelope allocation or settings
  Future<void> updateEnvelope(int id, EnvelopeUpdateRequest request);

  /// Delete an envelope
  Future<void> deleteEnvelope(int id);

  /// Quick allocate income to envelopes
  ///
  /// [suggestions] map of envelopeId → suggestedAmount
  /// Returns map of envelopeId → actualAllocatedAmount
  Future<Map<int, double>> quickAllocate(
    double incomeAmount,
    Map<int, double> allocations,
  );

  /// Process monthly rollover for all envelopes
  ///
  /// Called at start of new month (or when user first opens app in new month)
  /// Creates new month's envelopes, applies rollover where enabled
  Future<void> processMonthRollover(int fromYear, int fromMonth, int toYear, int toMonth);

  /// Get allocation suggestions based on last month's spending
  Future<Map<int, double>> getSuggestedAllocations(int year, int month);

  /// Check if a transaction would exceed envelope
  ///
  /// Returns amount by which it would exceed, or 0 if within budget
  Future<double> checkOverage(String categoryName, double amount, int year, int month);

  /// Get envelope summary for month
  Future<EnvelopeSummary> getSummary(int year, int month);
}
```

## Data Types

```dart
class EnvelopeCreateRequest {
  final String name;
  final String categoryName;
  final double allocatedAmount;
  final String iconName;
  final String colorHex;
  final bool isEssential;
  final bool rolloverEnabled;
  final int year;
  final int month;
}

class EnvelopeUpdateRequest {
  final String? name;
  final double? allocatedAmount;
  final String? iconName;
  final String? colorHex;
  final bool? isEssential;
  final bool? rolloverEnabled;
  final int? sortOrder;
}

class EnvelopeSummary {
  final double totalAllocated;
  final double totalSpent;
  final double totalRemaining;
  final double walletBalance;
  final double unallocated; // walletBalance - totalAllocated
  final bool isOverAllocated; // unallocated < 0
  final int envelopeCount;
  final int emptyCount;
  final int dangerCount;
}
```

## Business Rules

### Envelope-Category Relationship
- One envelope per category per month
- Category must exist before creating envelope
- Deleting envelope does not affect category or transactions

### Spent Amount Calculation
```dart
// Spent = sum of expense transactions for category in month
spentAmount = transactions
  .where((t) => t.category == envelope.categoryName)
  .where((t) => t.type == 'expense')
  .where((t) => t.monthKey == envelope.monthKey)
  .fold(0, (sum, t) => sum + t.amount);
```

### Monthly Rollover Logic
```dart
for each envelope in previousMonth:
  if envelope.rolloverEnabled:
    remaining = allocatedAmount - spentAmount
    newEnvelope.allocatedAmount = suggestedAllocation + remaining
  else:
    newEnvelope.allocatedAmount = suggestedAllocation
```

### Allocation Suggestions
Based on last month's spending or user's historical average:
```dart
suggestedAmount = max(
  lastMonthSpent,
  avg(last3MonthsSpent),
)
```

### Overage Check
```dart
double checkOverage(category, newAmount, year, month) {
  envelope = getEnvelopeByCategory(category, year, month);
  if (envelope == null) return 0; // No envelope, no limit

  currentSpent = getSpentAmount(envelope);
  remaining = envelope.allocatedAmount - currentSpent;

  if (newAmount > remaining) {
    return newAmount - remaining; // Amount over
  }
  return 0; // Within budget
}
```

## Notification Triggers

| Condition | Notification |
|-----------|--------------|
| Envelope reaches 20% remaining | "ظرف [name] فاضل فيه 20% بس — باقي [amount] جنيه" |
| Envelope reaches 0% (empty) | "ظرف [name] خلص! حاول تتجنب مصاريف [category] لحد آخر الشهر" |
| Essential envelope < 20% | More urgent notification style |

## Dependencies

- `EnvelopeRepository` (CRUD operations)
- `TransactionRepository.getByCategoryAndMonth()` (spent calculation)
- `WalletRepository.getTotalBalance()` (unallocated calculation)
- `CategoryRepository.getByName()` (validation)
- `NotificationService` (alerts)

## Error Handling

| Scenario | Behavior |
|----------|----------|
| Category not found | Throw `CategoryNotFoundException` |
| Duplicate envelope (same category+month) | Throw `DuplicateEnvelopeException` |
| Negative allocation | Throw `InvalidAllocationException` |
| Database error | Propagate exception |

## Settings Integration

- Check `AppSettings.envelopeBudgetingEnabled` before showing envelope features
- When disabled, fall back to simple Budget display
- Envelopes persist when disabled (hidden, not deleted)
