# Contract: Daily Spending Limit Service

**Version**: 1.0.0
**Date**: 2026-04-08

## Overview

The Daily Spending Limit Service tracks daily spending against user-configured limits and triggers notifications when thresholds are reached.

---

## Service Interface

### DailyLimitService

```dart
/// Service for tracking daily spending limits
class DailyLimitService {
  /// Get today's spending (excluding excluded categories)
  Future<double> getTodaySpending();

  /// Get spending progress (0.0 to 1.0+)
  ///
  /// Returns null if limit not enabled
  Future<double?> getProgress();

  /// Check spending and trigger notifications if needed
  ///
  /// Should be called after each transaction is added
  Future<void> checkAndNotify();

  /// Get detailed status for UI display
  Future<DailyLimitStatus> getStatus();
}
```

### Data Types

```dart
/// Detailed status for dashboard indicator
class DailyLimitStatus {
  final bool isEnabled;
  final double limit;
  final double spent;
  final double remaining;
  final double progress;       // 0.0 to 1.0+ (can exceed 1.0)
  final ProgressLevel level;   // green/yellow/orange/red
  final bool warningTriggered;
  final bool exceededTriggered;

  const DailyLimitStatus({...});
}

enum ProgressLevel {
  green,   // < 50%
  yellow,  // 50% - 80%
  orange,  // 80% - 100%
  red,     // > 100%
}
```

---

## Calculation Contract

### getTodaySpending()

```dart
Future<double> getTodaySpending() async {
  final settings = await getSettings();
  final today = DateTime.now();
  final startOfDay = DateTime(today.year, today.month, today.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));

  // Get all expense transactions for today
  var transactions = await isar.transactions
    .filter()
    .typeEqualTo('expense')
    .dateGreaterThan(startOfDay)
    .dateLessThan(endOfDay)
    .findAll();

  // Exclude configured categories
  final excluded = settings.excludedCategoriesFromLimit;
  if (excluded.isNotEmpty) {
    transactions = transactions.where((t) =>
      !excluded.contains(t.category)
    ).toList();
  }

  return transactions.fold(0.0, (sum, t) => sum + t.amount);
}
```

### getProgress()

```dart
Future<double?> getProgress() async {
  final settings = await getSettings();
  if (!settings.dailyLimitEnabled || settings.dailyLimitAmount <= 0) {
    return null;
  }

  final spent = await getTodaySpending();
  return spent / settings.dailyLimitAmount;
}
```

### ProgressLevel Calculation

```dart
ProgressLevel getLevel(double progress) {
  if (progress < 0.5) return ProgressLevel.green;
  if (progress < 0.8) return ProgressLevel.yellow;
  if (progress < 1.0) return ProgressLevel.orange;
  return ProgressLevel.red;
}
```

---

## Notification Contract

### Notification Triggers

1. **Warning threshold reached**:
   - Condition: `progress >= threshold` (default 80%)
   - Frequency: Once per day
   - Check: `lastLimitWarningDate != today`

2. **Limit exceeded**:
   - Condition: `progress >= 1.0`
   - Frequency: Once per day
   - Check: `lastLimitExceededDate != today`

### Notification Messages

**Warning (Arabic)**:
```
Title: تنبيه حد المصاريف
Body: وصلت لـ 80% من حد مصاريفك اليومي
      المتبقي: 100 جنيه
```

**Exceeded (Arabic)**:
```
Title: تجاوزت الحد اليومي!
Body: تجاوزت حد المصاريف اليومي!
      المصروفات: 550 جنيه / الحد: 500 جنيه
```

### Notification Channel

```dart
const dailyLimitChannel = AndroidNotificationDetails(
  'flowspend_daily_limit',
  'حد المصاريف اليومي',
  channelDescription: 'تنبيهات حد المصاريف اليومي',
  importance: Importance.high,
  priority: Priority.high,
  icon: '@mipmap/ic_launcher',
);
```

---

## Provider Interface

```dart
/// Provider for daily limit status
final dailyLimitStatusProvider = FutureProvider<DailyLimitStatus>((ref) async {
  final service = ref.watch(dailyLimitServiceProvider);
  return service.getStatus();
});

/// Provider for progress only (for compact display)
final dailyLimitProgressProvider = FutureProvider<double?>((ref) async {
  final service = ref.watch(dailyLimitServiceProvider);
  return service.getProgress();
});
```

---

## Settings UI Contract

### Settings Section Fields

| Field | Type | Default | Validation |
|-------|------|---------|------------|
| Enabled toggle | bool | false | - |
| Limit amount | double | 0 | >= 10 EGP when enabled |
| Threshold % | double | 0.8 | 0.5 to 0.95 |
| Excluded categories | List<String> | [] | Must be valid category names |

### Settings Persistence

Updates to `AppSettings` singleton:

```dart
await isar.writeTxn(() async {
  final settings = await isar.appSettings.get(0) ?? AppSettings();
  settings.dailyLimitEnabled = enabled;
  settings.dailyLimitAmount = amount;
  settings.dailyLimitThreshold = threshold;
  settings.excludedCategoriesFromLimit = excluded;
  await isar.appSettings.put(settings);
});
```

---

## Dashboard Integration

### Progress Indicator Widget

```dart
class DailyLimitIndicator extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(dailyLimitStatusProvider);

    return statusAsync.when(
      data: (status) {
        if (!status.isEnabled) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () => showDetailsBottomSheet(context, status),
          child: ProgressBar(
            progress: status.progress,
            color: _getColor(status.level),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Color _getColor(ProgressLevel level) {
    switch (level) {
      case ProgressLevel.green: return AppColors.success;
      case ProgressLevel.yellow: return AppColors.warning;
      case ProgressLevel.orange: return AppColors.installment;
      case ProgressLevel.red: return AppColors.danger;
    }
  }
}
```

### Details Bottom Sheet

Shows when user taps the indicator:

```
┌─────────────────────────────────────┐
│  حد المصاريف اليومي                  │
├─────────────────────────────────────┤
│  المصروفات: 450 جنيه                 │
│  الحد: 500 جنيه                      │
│  المتبقي: 50 جنيه                    │
├─────────────────────────────────────┤
│  معاملات اليوم:                      │
│  • ماكدونالدز — 150 جنيه             │
│  • اوبر — 100 جنيه                   │
│  • فودافون — 200 جنيه                │
└─────────────────────────────────────┘
```

---

## Trigger Points

Call `checkAndNotify()` at these points:

1. **After transaction saved**:
   ```dart
   await transactionRepo.save(transaction);
   await dailyLimitService.checkAndNotify();
   ref.invalidate(dailyLimitStatusProvider);
   ```

2. **App startup** (to catch up if opened after transaction):
   ```dart
   // In main.dart initialization
   await dailyLimitService.checkAndNotify();
   ```

---

## Edge Cases

| Scenario | Behavior |
|----------|----------|
| Limit = 0 or not set | Feature disabled, hide indicator |
| All categories excluded | Spending = 0, always green |
| Transaction deleted | Recalculate on next check |
| Date rollover (midnight) | Reset warning/exceeded flags |
| Limit changed mid-day | Recalculate immediately |
