# Quickstart: FlowSpend Enhancement Features

**Date**: 2026-04-08
**Branch**: `005-flowspend-enhancements`

## Prerequisites

- Flutter SDK 3.9.2+
- Dart 3.9.2+
- Android Studio or VS Code with Flutter extension
- Android emulator or device (Android 8.0+)

## Setup

### 1. Clone and Switch Branch

```bash
git checkout 005-flowspend-enhancements
```

### 2. Install New Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  csv: ^6.0.0
  pdf: ^3.10.0
  printing: ^5.12.0
  home_widget: ^0.6.0
  shared_preferences: ^2.2.0
```

Then run:

```bash
flutter pub get
```

### 3. Generate Isar Code

After creating new Isar models:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Or watch mode during development:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

---

## Implementation Order

Follow this sequence for best results:

| # | Feature | Dependencies | Est. Time |
|---|---------|--------------|-----------|
| 1 | Auto-Categorization | None | 4-6 hours |
| 2 | Data Export | None | 6-8 hours |
| 3 | Month Comparison | fl_chart (existing) | 4-6 hours |
| 4 | Daily Spending Limit | Notifications (existing) | 4-5 hours |
| 5 | Recurring Detection | Auto-Categorization | 5-7 hours |
| 6 | Enhanced Onboarding | SharedPreferences | 4-6 hours |
| 7 | Gamification | Reports, Budget screens | 8-10 hours |
| 8 | Home Widget | home_widget package | 6-8 hours |

---

## Feature 1: Auto-Categorization

### Files to Create

```
lib/core/utils/category_keywords.dart
lib/data/models/category_mapping_model.dart
lib/data/repositories/category_mapping_repo.dart
lib/data/services/auto_categorization_service.dart
lib/providers/auto_categorization_provider.dart
lib/features/transactions/widgets/category_suggestion_banner.dart
```

### Key Steps

1. Create `CategoryMapping` Isar model
2. Run `build_runner`
3. Create keyword map with 200+ Egyptian merchants
4. Implement matching algorithm
5. Add provider with caching
6. Integrate into SMS confirmation screen
7. Add debounced suggestion banner to add transaction screen

### Test Command

```bash
flutter test test/services/auto_categorization_service_test.dart
```

---

## Feature 2: Data Export

### Files to Create

```
lib/data/services/export_service.dart
lib/providers/export_provider.dart
lib/features/export/export_screen.dart
lib/features/export/widgets/month_picker.dart
lib/features/export/widgets/format_card.dart
lib/features/export/widgets/filter_section.dart
```

### Key Steps

1. Add route to `app_router.dart`
2. Create ExportService with CSV/PDF generation
3. Add Cairo font loading for PDF
4. Create export screen UI
5. Add export button to Settings and Reports screens
6. Test with share_plus for system share sheet

### Test Arabic PDF

```dart
// Verify RTL rendering
final pdf = pw.Document();
pdf.addPage(pw.Page(
  textDirection: pw.TextDirection.rtl,
  build: (context) => pw.Text('مرحبا', style: pw.TextStyle(font: cairoFont)),
));
```

---

## Feature 3: Month Comparison

### Files to Create

```
lib/providers/comparison_provider.dart
lib/features/reports/widgets/month_comparison_section.dart
lib/features/reports/widgets/comparison_charts.dart
```

### Key Steps

1. Create comparison provider with monthly data aggregation
2. Add comparison section to reports_screen.dart
3. Implement side-by-side cards
4. Add fl_chart bar chart for category comparison
5. Add fl_chart line chart for daily trend overlay

### Chart Pattern

Use existing patterns from `trend_line_chart.dart` and `monthly_bar_chart.dart`.

---

## Feature 4: Daily Spending Limit

### Files to Create/Modify

```
lib/data/models/app_settings_model.dart (MODIFY - add fields)
lib/data/services/daily_limit_service.dart
lib/providers/daily_limit_provider.dart
lib/features/settings/widgets/daily_limit_section.dart
lib/features/dashboard/widgets/daily_limit_indicator.dart
lib/data/services/notification_service.dart (MODIFY - add channel)
```

### Key Steps

1. Add fields to AppSettings model
2. Run `build_runner`
3. Create DailyLimitService
4. Add notification channel to NotificationService
5. Create settings UI section
6. Add progress indicator to Dashboard
7. Hook into transaction save flow

---

## Feature 5: Recurring Detection

### Files to Create

```
lib/data/models/detected_pattern_model.dart
lib/data/repositories/detected_pattern_repo.dart
lib/data/services/recurring_detection_service.dart
lib/providers/detected_pattern_provider.dart
lib/features/dashboard/widgets/recurring_suggestions_card.dart
```

### Key Steps

1. Create DetectedPattern Isar model
2. Run `build_runner`
3. Implement pattern detection algorithm
4. Create provider with startup trigger
5. Add suggestions card to Dashboard
6. Add accept flow with bottom sheet
7. Integrate with auto-categorization for category suggestions

---

## Feature 6: Enhanced Onboarding

### Files to Create/Modify

```
lib/features/onboarding/onboarding_screen.dart (MODIFY)
lib/features/onboarding/widgets/welcome_page.dart
lib/features/onboarding/widgets/privacy_page.dart
lib/features/onboarding/widgets/sms_page.dart
lib/features/onboarding/widgets/setup_page.dart
lib/features/onboarding/widgets/ready_page.dart
```

### Key Steps

1. Create 5 page widgets
2. Implement PageView with PageController
3. Add progress dots indicator
4. Add skip button logic
5. Implement SMS permission request
6. Save wallet/budget from setup page
7. Set completion flag in SharedPreferences
8. Check flag in main.dart to skip if completed

---

## Feature 7: Gamification Enhancements

### Files to Create

```
lib/data/models/weekly_challenge_model.dart
lib/data/repositories/challenge_repo.dart
lib/data/services/challenge_service.dart
lib/providers/challenge_provider.dart
lib/features/dashboard/widgets/challenge_card.dart
lib/shared/widgets/spending_heatmap.dart
lib/shared/widgets/progress_ring.dart
lib/features/budgets/widgets/budget_progress_ring.dart
```

### Key Steps

1. Create WeeklyChallenge Isar model
2. Run `build_runner`
3. Implement challenge selection logic
4. Add challenge card to Dashboard
5. Create spending heatmap widget
6. Add heatmap to Reports screen
7. Create animated progress ring widget
8. Replace/enhance budget progress cards

---

## Feature 8: Android Home Widget

### Files to Create

```
lib/data/services/widget_sync_service.dart
lib/providers/widget_sync_provider.dart
android/app/src/main/res/layout/flowspend_widget.xml
android/app/src/main/res/xml/flowspend_widget_info.xml
android/app/src/main/AndroidManifest.xml (MODIFY)
```

### Key Steps

1. Add home_widget to pubspec.yaml
2. Create widget layout XML
3. Create widget info XML
4. Register receiver in AndroidManifest.xml
5. Create WidgetSyncService
6. Hook sync into transaction save flow
7. Test on real device (widgets don't work well in emulator)

---

## Verification Commands

After each feature:

```bash
# Lint check
flutter analyze

# Run all tests
flutter test

# Build APK to verify no compilation errors
flutter build apk --debug
```

---

## Common Issues

### Isar "Schema not found"

```bash
# Regenerate Isar code
flutter pub run build_runner build --delete-conflicting-outputs
```

### PDF Arabic text not rendering

Ensure Cairo font is loaded:
```dart
final font = await PdfGoogleFonts.cairoRegular();
```

### Widget not updating

Make sure to call:
```dart
await HomeWidget.updateWidget(name: 'FlowSpendWidget');
```

### Provider not refreshing

Use `ref.invalidate()` after mutations:
```dart
await transactionRepo.save(transaction);
ref.invalidate(dailyLimitStatusProvider);
```

---

## Resources

- [Spec](./spec.md) - Feature requirements
- [Research](./research.md) - Technical decisions
- [Data Model](./data-model.md) - Isar collections
- [Contracts](./contracts/) - Service interfaces
- [CLAUDE.md](../../CLAUDE.md) - Project architecture guide
