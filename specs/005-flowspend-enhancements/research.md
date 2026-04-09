# Research: FlowSpend Enhancement Features

**Date**: 2026-04-08
**Branch**: `005-flowspend-enhancements`

## Overview

This document captures technical decisions and research findings for the 8 enhancement features. All clarifications from the spec are resolved with concrete implementation choices.

---

## 1. Auto-Categorization Service

### Decision: Keyword-Based Matching with User Learning

**Approach**: Two-layer system - built-in keyword map + Isar-persisted user corrections

**Rationale**:
- No external ML libraries needed (stays offline-capable)
- Fast execution (< 500ms requirement)
- User learning improves accuracy over time
- Builds on existing category system

**Alternatives Considered**:
- TensorFlow Lite on-device model: Rejected - too heavy for simple categorization, adds 10MB+ to APK
- Regex-only matching: Rejected - too rigid, can't handle variations
- External API: Rejected - violates offline-first principle

**Implementation Details**:

```dart
// Keyword map structure (in category_keywords.dart)
const Map<String, List<String>> categoryKeywords = {
  'طعام ومشروبات': [
    'ماكدونالدز', 'mcdonald', 'كنتاكي', 'kfc', 'بيتزا', 'pizza',
    'كشري', 'طلبات', 'talabat', 'المنيوز', 'elmenus', 'مطعم',
    'كافيه', 'cafe', 'starbucks', 'costa', 'بلدي', 'فول',
  ],
  'تسوق': [
    'زارا', 'zara', 'h&m', 'امازون', 'amazon', 'جوميا', 'jumia',
    'نون', 'noon', 'سوق', 'souq', 'مول', 'mall',
  ],
  'مواصلات': [
    'اوبر', 'uber', 'كريم', 'careem', 'سويفل', 'swvl',
    'مترو', 'اتوبيس', 'تاكسي', 'بنزين', 'petrol',
  ],
  'اتصالات': [
    'فودافون', 'vodafone', 'اورانج', 'orange', 'اتصالات', 'etisalat',
    'وي', 'we', 'فايبر', 'fiber', 'نت', 'internet',
  ],
  // ... continue for all 10+ categories
};
```

**Confidence Score Calculation**:
```dart
double calculateConfidence(String input, String category, int matchCount) {
  final words = input.split(RegExp(r'\s+'));
  final ratio = matchCount / words.length;
  return (ratio * 0.7 + 0.3).clamp(0.0, 1.0); // Base 0.3, up to 1.0
}
```

---

## 2. Data Export (CSV/PDF)

### Decision: Use `csv` and `pdf` Packages

**Rationale**:
- `csv` (pub.dev): Simple, well-maintained, handles UTF-8 correctly
- `pdf` (pub.dev): Pure Dart, supports Arabic RTL, no native dependencies
- Both packages are compatible with existing Flutter version

**Alternatives Considered**:
- syncfusion_flutter_xlsio: Rejected - license cost, overkill for CSV
- flutter_to_pdf: Rejected - screenshot-based, not suitable for reports
- Native platform channels: Rejected - unnecessary complexity

**PDF RTL Support**:
```dart
// Load Cairo font for Arabic support
final font = await PdfGoogleFonts.cairoRegular();
final boldFont = await PdfGoogleFonts.cairoBold();

// Set RTL direction for document
pdf.addPage(
  pw.Page(
    textDirection: pw.TextDirection.rtl,
    build: (context) => pw.Column(...),
  ),
);
```

**CSV UTF-8 BOM**:
```dart
// Add BOM for Excel Arabic compatibility
final bom = '\uFEFF';
final csvContent = bom + csv.convert(rows);
```

**Dependencies to Add**:
```yaml
dependencies:
  csv: ^6.0.0
  pdf: ^3.10.0
  printing: ^5.12.0  # Optional: PDF preview
```

---

## 3. Month-over-Month Comparison

### Decision: New Provider with fl_chart Integration

**Rationale**:
- fl_chart already in project (0.68.0)
- Existing chart patterns in reports_screen.dart
- Provider handles computation, UI renders charts

**Data Structure**:
```dart
class MonthComparison {
  final double currentIncome;
  final double currentExpenses;
  final double previousIncome;
  final double previousExpenses;
  final Map<String, double> currentByCategory;
  final Map<String, double> previousByCategory;
  final List<DailySpending> currentDailyTrend;
  final List<DailySpending> previousDailyTrend;
  final CategoryChange? biggestIncrease;
  final CategoryChange? biggestDecrease;
  final List<String> newCategories;
  final List<String> droppedCategories;
}
```

---

## 4. Daily Spending Limit

### Decision: Extend AppSettings + Notification Channel

**Rationale**:
- AppSettings already singleton pattern (id = 0)
- NotificationService already handles channels
- Simple addition, no new collection needed

**AppSettings Extension**:
```dart
// Add to existing AppSettings model
bool dailyLimitEnabled = false;
double dailyLimitAmount = 0;
double dailyLimitThreshold = 0.8; // 80% warning
List<String> dailyLimitExcludedCategories = [];
DateTime? lastWarningDate;
DateTime? lastExceededDate;
```

**Notification Channel**:
```dart
// Add to NotificationService
static const _limitChannel = AndroidNotificationDetails(
  'flowspend_daily_limit',
  'حد المصاريف اليومي',
  channelDescription: 'تنبيهات حد المصاريف',
  importance: Importance.high,
  priority: Priority.high,
);
```

---

## 5. Recurring Transaction Detection

### Decision: Interval-Based Pattern Analysis

**Rationale**:
- Works offline with existing transaction data
- Simple algorithm that's deterministic
- No ML needed for time-based pattern detection

**Algorithm**:
```dart
List<DetectedPattern> detectPatterns(List<Transaction> transactions) {
  // 1. Group by normalized description
  final groups = groupByNormalizedDescription(transactions);

  // 2. For groups with 2+ transactions, analyze intervals
  for (final group in groups.where((g) => g.length >= 2)) {
    final intervals = calculateIntervals(group);
    final frequency = detectFrequency(intervals);

    if (frequency != null) {
      final confidence = calculateConfidence(
        occurrences: group.length,
        amountsIdentical: areAmountsIdentical(group),
      );

      if (confidence >= 0.4) {
        patterns.add(DetectedPattern(...));
      }
    }
  }

  return patterns;
}

FrequencyType? detectFrequency(List<int> intervalDays) {
  final avg = intervalDays.average;
  if (avg <= 2) return FrequencyType.daily;
  if (avg >= 5 && avg <= 9) return FrequencyType.weekly;
  if (avg >= 28 && avg <= 32) return FrequencyType.monthly;
  if (avg >= 360 && avg <= 370) return FrequencyType.yearly;
  return null;
}
```

---

## 6. Enhanced Onboarding

### Decision: PageView with 5 Screens + SharedPreferences Flag

**Rationale**:
- PageView already used in Flutter for onboarding patterns
- SharedPreferences simpler than Isar for single boolean flag
- Can save initial wallet/budget to Isar during setup

**Screen Flow**:
1. Welcome → Logo animation (Lottie already in project)
2. Privacy Promise → Shield icon + 3 privacy points
3. SMS Feature → Permission request (use permission_handler)
4. Quick Setup → Wallet name + optional budget
5. Ready → Confetti animation + start button

**Completion Flag**:
```dart
// Use SharedPreferences (simpler than Isar for single flag)
final prefs = await SharedPreferences.getInstance();
await prefs.setBool('onboarding_complete', true);
```

---

## 7. Gamification Enhancements

### 7A. Weekly Challenges

**Decision**: New Isar Collection + Service

**Challenge Types**:
```dart
enum ChallengeType {
  reduceSpendinG,       // "وفّر 20% من مصاريفك"
  noEntertainment,      // "3 أيام بدون ترفيه"
  logDaily,             // "سجّل كل يوم"
  foodUnder,            // "أكل تحت X"
  savingsTarget,        // "وفّر X جنيه"
}
```

**Selection Logic**:
```dart
ChallengeType selectChallenge(SpendingHistory history) {
  // Pick challenge based on user's patterns
  if (history.hasHighFoodSpending) return ChallengeType.foodUnder;
  if (history.hasHighEntertainment) return ChallengeType.noEntertainment;
  if (history.loggingStreak < 7) return ChallengeType.logDaily;
  return ChallengeType.reduceSpendinG;
}
```

### 7B. Spending Heatmap

**Decision**: Custom Widget with GridView

**Color Gradient**:
```dart
Color getHeatmapColor(double spending, double average) {
  if (spending == 0) return Colors.grey[800]!;
  final ratio = spending / average;
  if (ratio < 1.0) return Colors.green[400]!;
  if (ratio < 1.5) return Colors.yellow[600]!;
  if (ratio < 2.0) return Colors.orange[600]!;
  return Colors.red[600]!;
}
```

### 7C. Budget Progress Rings

**Decision**: CustomPainter with Animation

**Rationale**:
- Similar to percent_indicator (already in project) but custom for over-budget overlay
- Animate using AnimationController

**Over-Budget Handling**:
```dart
// Draw base ring, then overlay ring for >100%
if (percentage > 1.0) {
  // Draw red ring
  // Draw second overlay showing excess amount
}
```

---

## 8. Android Home Widget

### Decision: home_widget Package

**Rationale**:
- Official Flutter package for home widgets
- Handles SharedPreferences sync
- Works with existing architecture

**Dependencies to Add**:
```yaml
dependencies:
  home_widget: ^0.6.0
```

**Data Sync**:
```dart
// In WidgetSyncService
Future<void> syncWidgetData() async {
  final todaySpending = await calculateTodaySpending();
  final recentTransactions = await getLastTransactions(3);

  await HomeWidget.saveWidgetData('today_total', todaySpending);
  await HomeWidget.saveWidgetData('recent_txns', jsonEncode(recentTransactions));
  await HomeWidget.updateWidget(name: 'FlowSpendWidget');
}
```

**Widget Layout** (XML):
- Rounded rectangle background
- Header: "FlowSpend"
- Large amount text
- "مصروفات اليوم" label
- Recent transactions list

---

## Dependencies Summary

### Add to pubspec.yaml:

```yaml
dependencies:
  csv: ^6.0.0
  pdf: ^3.10.0
  printing: ^5.12.0
  home_widget: ^0.6.0
  shared_preferences: ^2.2.0  # For onboarding flag

dev_dependencies:
  # No new dev dependencies needed
```

### Native Changes:

**AndroidManifest.xml**:
- Add widget receiver
- Add widget provider meta-data

**New Android Resources**:
- `res/layout/flowspend_widget.xml`
- `res/xml/flowspend_widget_info.xml`

---

## Risk Assessment

| Risk | Mitigation |
|------|------------|
| PDF Arabic rendering | Test with Cairo font early; fallback to Amiri if needed |
| Widget update latency | Use WorkManager for periodic updates if SharedPrefs too slow |
| Pattern detection false positives | Require minimum confidence 0.4 and user confirmation |
| Challenge calculations expensive | Cache weekly calculations, only recalculate on transaction changes |

---

## Implementation Order (Confirmed)

1. **Auto-Categorization** - Foundation for other features
2. **Data Export** - Independent, high value
3. **Month Comparison** - Extends existing reports
4. **Daily Spending Limit** - Uses existing notifications
5. **Recurring Detection** - Uses auto-categorization
6. **Enhanced Onboarding** - After core features ready
7. **Gamification** - Polish features
8. **Home Widget** - Most complex native work
