# Contract: Recurring Transaction Detection Service

**Version**: 1.0.0
**Date**: 2026-04-08

## Overview

The Recurring Detection Service analyzes transaction history to identify spending patterns and suggests converting them to recurring transactions.

---

## Service Interface

### RecurringDetectionService

```dart
/// Service for detecting recurring transaction patterns
class RecurringDetectionService {
  /// Analyze all transactions and detect patterns
  ///
  /// Returns list of detected patterns sorted by confidence (descending)
  Future<List<DetectedPattern>> analyzePatterns();

  /// Run detection for a specific normalized description
  ///
  /// Used for incremental updates after new transactions
  Future<DetectedPattern?> analyzeDescription(String normalizedDescription);

  /// Accept a detected pattern and create recurring transaction
  ///
  /// Returns the created RecurringTransaction ID
  Future<int> acceptPattern(DetectedPattern pattern, {
    required int walletId,
    String? categoryOverride,
  });

  /// Dismiss a pattern
  Future<void> dismissPattern(DetectedPattern pattern);

  /// Check if dismissed pattern should re-surface
  ///
  /// Returns true if 3+ new matches since dismissal
  Future<bool> shouldResurface(DetectedPattern pattern);
}
```

---

## Detection Algorithm Contract

### Input

- All transactions from Isar database

### Processing Steps

1. **Normalize descriptions**:
   ```dart
   String normalize(String desc) {
     return desc
       .toLowerCase()
       .trim()
       .replaceAll(RegExp(r'[\d.,]+'), '')  // Remove numbers
       .replaceAll(RegExp(r'\s+'), ' ');    // Collapse whitespace
   }
   ```

2. **Group by normalized description**:
   - Minimum group size: 2 transactions

3. **Calculate intervals**:
   ```dart
   List<int> getIntervals(List<Transaction> sorted) {
     final intervals = <int>[];
     for (var i = 1; i < sorted.length; i++) {
       final days = sorted[i].date.difference(sorted[i-1].date).inDays;
       intervals.add(days);
     }
     return intervals;
   }
   ```

4. **Detect frequency**:
   ```dart
   FrequencyType? detectFrequency(List<int> intervals) {
     final avg = intervals.average;
     final stdDev = intervals.standardDeviation;

     // Reject if too much variance (stdDev > 30% of avg)
     if (stdDev > avg * 0.3) return null;

     if (avg <= 2) return FrequencyType.daily;
     if (avg >= 5 && avg <= 9) return FrequencyType.weekly;
     if (avg >= 28 && avg <= 32) return FrequencyType.monthly;
     if (avg >= 360 && avg <= 370) return FrequencyType.yearly;
     return null;
   }
   ```

5. **Check amount consistency**:
   ```dart
   bool areAmountsConsistent(List<double> amounts) {
     final avg = amounts.average;
     return amounts.every((a) => (a - avg).abs() / avg <= 0.05); // 5% tolerance
   }
   ```

6. **Calculate confidence**:
   ```dart
   double calculateConfidence(int occurrences, bool amountsIdentical) {
     // Base: 0.5 for 2 occurrences
     // +0.1 for each additional (up to 0.9)
     // +0.1 bonus for identical amounts
     double score = 0.5 + (occurrences - 2) * 0.1;
     if (amountsIdentical) score += 0.1;
     return score.clamp(0.0, 1.0);
   }
   ```

### Output Filtering

- Only return patterns with `confidence >= 0.4`
- Exclude patterns where `isDismissed == true` unless re-surface condition met
- Exclude patterns where `isAccepted == true`

---

## Frequency Types

```dart
enum FrequencyType {
  daily,    // Every 1-2 days
  weekly,   // Every 5-9 days
  monthly,  // Every 28-32 days
  yearly,   // Every 360-370 days
}

// Arabic display names
const frequencyNames = {
  FrequencyType.daily: 'يومي',
  FrequencyType.weekly: 'أسبوعي',
  FrequencyType.monthly: 'شهري',
  FrequencyType.yearly: 'سنوي',
};
```

---

## Provider Interface

```dart
/// Provider for detected patterns
final detectedPatternsProvider = FutureProvider<List<DetectedPattern>>((ref) async {
  final service = ref.watch(recurringDetectionServiceProvider);
  return service.analyzePatterns();
});

/// Provider for pending suggestions only (filtered)
final pendingSuggestionsProvider = FutureProvider<List<DetectedPattern>>((ref) async {
  final patterns = await ref.watch(detectedPatternsProvider.future);
  return patterns.where((p) =>
    !p.isAccepted && !p.isDismissed && p.confidenceScore >= 0.4
  ).toList();
});

/// Provider for suggestion count (for badge display)
final suggestionCountProvider = FutureProvider<int>((ref) async {
  final suggestions = await ref.watch(pendingSuggestionsProvider.future);
  return suggestions.length;
});
```

---

## Trigger Points

1. **App startup** (after 2-second delay):
   ```dart
   Future.delayed(const Duration(seconds: 2), () {
     ref.invalidate(detectedPatternsProvider);
   });
   ```

2. **After SMS transaction confirmed**:
   ```dart
   // In SMS confirmation flow
   await saveTransaction(transaction);
   ref.invalidate(detectedPatternsProvider);
   ```

3. **Manual refresh** (user taps "تحليل المعاملات"):
   ```dart
   ref.invalidate(detectedPatternsProvider);
   ```

---

## Accept Flow

When user accepts a detected pattern:

1. Show bottom sheet with pre-filled form:
   - Description: `pattern.normalizedDescription`
   - Amount: `pattern.averageAmount`
   - Category: `pattern.categoryName` (from auto-categorizer)
   - Frequency: `pattern.frequency`
   - Start date: `pattern.nextExpectedAt`

2. User selects wallet and confirms

3. Create `RecurringTransaction`:
   ```dart
   final recurring = RecurringTransaction()
     ..description = form.description
     ..amount = form.amount
     ..category = form.category
     ..frequency = form.frequency
     ..startDate = form.startDate
     ..walletId = form.walletId
     ..isActive = true;
   ```

4. Link pattern:
   ```dart
   pattern.isAccepted = true;
   pattern.linkedRecurringId = recurring.id;
   await isar.detectedPatterns.put(pattern);
   ```

---

## Dismiss Flow

When user dismisses a pattern:

```dart
pattern.isDismissed = true;
pattern.dismissedAt = DateTime.now();
await isar.detectedPatterns.put(pattern);
```

---

## Re-surface Logic

Check periodically (e.g., during pattern analysis):

```dart
Future<bool> shouldResurface(DetectedPattern pattern) async {
  if (!pattern.isDismissed) return false;

  // Count transactions matching this description since dismissal
  final newMatches = await isar.transactions
    .filter()
    .dateGreaterThan(pattern.dismissedAt!)
    .findAll()
    .then((txns) => txns.where((t) =>
      normalize(t.note ?? '') == pattern.normalizedDescription
    ).length);

  return newMatches >= 3;
}
```

---

## Confidence Indicators (UI)

| Confidence | Color | Label |
|------------|-------|-------|
| 0.7 - 1.0 | Green | ثقة عالية |
| 0.5 - 0.7 | Yellow | ثقة متوسطة |
| 0.4 - 0.5 | Orange | ثقة منخفضة |

---

## Performance Requirements

- Full analysis: < 5 seconds for 1000 transactions
- Incremental analysis: < 500ms per description
- Memory: Patterns cached in provider after first load
