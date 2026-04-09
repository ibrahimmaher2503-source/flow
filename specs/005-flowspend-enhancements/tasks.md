# Tasks: FlowSpend Enhancement Features

**Input**: Design documents from `/specs/005-flowspend-enhancements/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: Tests NOT included in this task list. Add test tasks if explicitly requested.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Mobile (Flutter)**: `lib/` at repository root
- **Models**: `lib/data/models/`
- **Repositories**: `lib/data/repositories/`
- **Services**: `lib/data/services/`
- **Providers**: `lib/providers/`
- **Features**: `lib/features/[feature_name]/`
- **Shared Widgets**: `lib/shared/widgets/`
- **Android Native**: `android/app/src/main/`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Add new dependencies and configure project for 8 enhancement features

- [ ] T001 Add new dependencies to pubspec.yaml: csv ^6.0.0, pdf ^3.10.0, printing ^5.12.0, home_widget ^0.6.0, shared_preferences ^2.2.0
- [ ] T002 Run `flutter pub get` to install dependencies
- [ ] T003 [P] Create category keywords map in lib/core/utils/category_keywords.dart with 200+ Egyptian merchant keywords
- [ ] T004 [P] Add ChallengeType enum to lib/core/constants/app_constants.dart (reduce_spending, no_entertainment, log_daily, food_under, savings_target)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Create Isar models and repositories that multiple user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

### Data Models

- [ ] T005 [P] Create CategoryMapping Isar model in lib/data/models/category_mapping_model.dart (keyword, categoryName, hitCount, lastUsedAt, createdAt)
- [ ] T006 [P] Create DetectedPattern Isar model in lib/data/models/detected_pattern_model.dart (normalizedDescription, averageAmount, frequency, confidenceScore, status flags)
- [ ] T007 [P] Create WeeklyChallenge Isar model in lib/data/models/weekly_challenge_model.dart (type, description, targetValue, currentProgress, dates, pointsReward)
- [ ] T008 Modify AppSettings model in lib/data/models/app_settings_model.dart to add daily limit fields (dailyLimitEnabled, dailyLimitAmount, dailyLimitThreshold, excludedCategoriesFromLimit, lastLimitWarningDate, lastLimitExceededDate, onboardingCompleted)
- [ ] T009 Run `flutter pub run build_runner build --delete-conflicting-outputs` to generate Isar code

### Repositories

- [ ] T010 [P] Create CategoryMappingRepo in lib/data/repositories/category_mapping_repo.dart (save, findByKeyword, getMappingsForCategory, incrementHitCount)
- [ ] T011 [P] Create DetectedPatternRepo in lib/data/repositories/detected_pattern_repo.dart (save, getPendingSuggestions, findByDescription, markAccepted, markDismissed)
- [ ] T012 [P] Create ChallengeRepo in lib/data/repositories/challenge_repo.dart (save, getCurrentChallenge, getCompletedChallenges, updateProgress)

### Isar Service Update

- [ ] T013 Update IsarService in lib/data/services/isar_service.dart to register new schemas (CategoryMappingSchema, DetectedPatternSchema, WeeklyChallengeSchema)

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Auto-Categorization (Priority: P1) 🎯 MVP

**Goal**: Automatically suggest transaction categories based on description keywords and user learning

**Independent Test**: Enter a transaction with description "ماكدونالدز" and verify "طعام ومشروبات" is suggested within 500ms

### Implementation for User Story 1

- [ ] T014 [US1] Create AutoCategorizationService in lib/data/services/auto_categorization_service.dart implementing suggest() and recordCorrection() per contracts/auto-categorization.md
- [ ] T015 [US1] Create autoCategorizeProvider in lib/providers/auto_categorization_provider.dart (service singleton + categorySuggestionProvider.family)
- [ ] T016 [US1] Create CategorySuggestionBanner widget in lib/features/transactions/widgets/category_suggestion_banner.dart (shows "اقتراح: [category]" with accept/dismiss)
- [ ] T017 [US1] Integrate auto-categorization into add_transaction_screen.dart (debounced suggestion on description change)
- [ ] T018 [US1] Integrate auto-categorization into SMS confirmation screen lib/features/sms/sms_confirmation_screen.dart (auto-fill category with "تصنيف تلقائي" indicator)
- [ ] T019 [US1] Add learning trigger when user changes suggested category in both screens (call recordCorrection)
- [ ] T020 [US1] Run `flutter analyze` to verify no lint errors

**Checkpoint**: Auto-categorization should work independently - test with known merchants

---

## Phase 4: User Story 2 - Data Export (Priority: P1)

**Goal**: Export monthly transactions as CSV or PDF with Arabic RTL support

**Independent Test**: Select a month, choose CSV format, export and verify file opens in Excel with correct Arabic headers

### Implementation for User Story 2

- [ ] T021 [US2] Create ExportService in lib/data/services/export_service.dart implementing generateCsv(), generatePdf(), shareFile() per contracts/export-service.md
- [ ] T022 [US2] Create export_provider.dart in lib/providers/ (exportConfigProvider, exportTransactionsProvider, exportPreviewCountProvider)
- [ ] T023 [US2] Create MonthPicker widget in lib/features/export/widgets/month_picker.dart (horizontal scrollable chips for last 12 months in Arabic)
- [ ] T024 [P] [US2] Create FormatCard widget in lib/features/export/widgets/format_card.dart (CSV/PDF selection cards with icons)
- [ ] T025 [P] [US2] Create FilterSection widget in lib/features/export/widgets/filter_section.dart (expandable category, wallet, type filters)
- [ ] T026 [US2] Create ExportScreen in lib/features/export/export_screen.dart (compose widgets, preview count, export button)
- [ ] T027 [US2] Add route for ExportScreen in lib/core/router/app_router.dart
- [ ] T028 [P] [US2] Add export button to Settings screen in lib/features/settings/settings_screen.dart
- [ ] T029 [P] [US2] Add export button to Reports screen AppBar in lib/features/reports/reports_screen.dart
- [ ] T030 [US2] Run `flutter analyze` to verify no lint errors

**Checkpoint**: Export feature should work independently - test CSV and PDF generation

---

## Phase 5: User Story 3 - Month-over-Month Comparison (Priority: P2)

**Goal**: Display comparison between current and previous month spending in Reports screen

**Independent Test**: Navigate to Reports, view comparison section with 2 months of transaction data, verify accurate percentage changes

### Implementation for User Story 3

- [ ] T031 [US3] Create comparison_provider.dart in lib/providers/ with MonthComparison class (totals, categoryBreakdowns, dailyTrends, biggestIncrease/Decrease)
- [ ] T032 [US3] Create MonthComparisonSection widget in lib/features/reports/widgets/month_comparison_section.dart (side-by-side cards with totals and arrows)
- [ ] T033 [P] [US3] Create ComparisonCharts widget in lib/features/reports/widgets/comparison_charts.dart (horizontal bar chart for categories, overlaid line chart for daily trends)
- [ ] T034 [US3] Integrate MonthComparisonSection and ComparisonCharts into reports_screen.dart _GeneralReportTab
- [ ] T035 [US3] Add month picker to comparison section allowing user to change comparison months
- [ ] T036 [US3] Run `flutter analyze` to verify no lint errors

**Checkpoint**: Month comparison should display independently in Reports tab

---

## Phase 6: User Story 4 - Daily Spending Limit (Priority: P2)

**Goal**: Track daily spending against user-configured limits with notifications

**Independent Test**: Set daily limit to 100 EGP, add transactions totaling 85 EGP, verify warning notification appears

### Implementation for User Story 4

- [ ] T037 [US4] Create DailyLimitService in lib/data/services/daily_limit_service.dart implementing getTodaySpending(), getProgress(), checkAndNotify() per contracts/daily-limit.md
- [ ] T038 [US4] Add daily limit notification channel to lib/data/services/notification_service.dart (showDailyLimitWarning, showDailyLimitExceeded)
- [ ] T039 [US4] Create daily_limit_provider.dart in lib/providers/ (dailyLimitStatusProvider, dailyLimitProgressProvider)
- [ ] T040 [US4] Create DailyLimitSection widget in lib/features/settings/widgets/daily_limit_section.dart (enable toggle, amount input, threshold slider, category exclusion)
- [ ] T041 [US4] Create DailyLimitIndicator widget in lib/features/dashboard/widgets/daily_limit_indicator.dart (progress bar with color coding, tap for details bottom sheet)
- [ ] T042 [US4] Integrate DailyLimitSection into settings screen
- [ ] T043 [US4] Integrate DailyLimitIndicator into dashboard_screen.dart
- [ ] T044 [US4] Hook checkAndNotify() into transaction save flow in transaction_provider.dart
- [ ] T045 [US4] Run `flutter analyze` to verify no lint errors

**Checkpoint**: Daily limit tracking and alerts should work independently

---

## Phase 7: User Story 5 - Recurring Transaction Detection (Priority: P2)

**Goal**: Detect spending patterns and suggest converting to recurring transactions

**Independent Test**: Have 3+ similar transactions with monthly intervals, verify suggestion appears with correct frequency and amount

### Implementation for User Story 5

- [ ] T046 [US5] Create RecurringDetectionService in lib/data/services/recurring_detection_service.dart implementing analyzePatterns(), acceptPattern(), dismissPattern() per contracts/recurring-detection.md
- [ ] T047 [US5] Create detected_pattern_provider.dart in lib/providers/ (detectedPatternsProvider, pendingSuggestionsProvider, suggestionCountProvider)
- [ ] T048 [US5] Create RecurringSuggestionsCard widget in lib/features/dashboard/widgets/recurring_suggestions_card.dart (header with count badge, suggestion list with accept/dismiss, "تحليل المعاملات" button)
- [ ] T049 [US5] Create accept flow bottom sheet in RecurringSuggestionsCard (pre-filled recurring transaction form with wallet picker)
- [ ] T050 [US5] Integrate RecurringSuggestionsCard into dashboard_screen.dart (show if pending suggestions exist)
- [ ] T051 [US5] Add RecurringSuggestionsCard to recurring_screen.dart at top
- [ ] T052 [US5] Trigger pattern detection on app startup (delayed 2 seconds) in main.dart
- [ ] T053 [US5] Trigger pattern detection after SMS transaction confirmed in sms_provider.dart
- [ ] T054 [US5] Run `flutter analyze` to verify no lint errors

**Checkpoint**: Recurring detection should identify patterns and allow accepting suggestions

---

## Phase 8: User Story 6 - Enhanced Onboarding (Priority: P3)

**Goal**: 5-screen interactive walkthrough for first-time users with privacy messaging

**Independent Test**: Clear app data, launch app, verify 5 onboarding screens appear with skip button, SMS permission request works, setup saves wallet/budget

### Implementation for User Story 6

- [ ] T055 [P] [US6] Create WelcomePage widget in lib/features/onboarding/widgets/welcome_page.dart (logo animation, "أهلاً بيك في FlowSpend", subtitle)
- [ ] T056 [P] [US6] Create PrivacyPage widget in lib/features/onboarding/widgets/privacy_page.dart (shield icon, "خصوصيتك أولويتنا", 3 privacy points)
- [ ] T057 [P] [US6] Create SmsPage widget in lib/features/onboarding/widgets/sms_page.dart (phone icon, explanation, permission button, skip option)
- [ ] T058 [P] [US6] Create SetupPage widget in lib/features/onboarding/widgets/setup_page.dart (wallet name input, optional budget target)
- [ ] T059 [P] [US6] Create ReadyPage widget in lib/features/onboarding/widgets/ready_page.dart (confetti animation, "أنت جاهز!", "يلا نبدأ" button)
- [ ] T060 [US6] Rewrite OnboardingScreen in lib/features/onboarding/onboarding_screen.dart with PageView, PageController, progress dots, skip button
- [ ] T061 [US6] Implement onboarding completion logic using SharedPreferences (set onboardingCompleted flag)
- [ ] T062 [US6] Add onboarding check to main.dart (if not completed, show onboarding; else show dashboard)
- [ ] T063 [US6] Run `flutter analyze` to verify no lint errors

**Checkpoint**: Fresh install should show onboarding flow, subsequent launches skip to dashboard

---

## Phase 9: User Story 7 - Gamification Enhancements (Priority: P3)

**Goal**: Weekly challenges, spending heatmap, and animated budget progress rings

**Independent Test**: Verify weekly challenge appears on Monday, heatmap shows colored days, budget rings animate on load

### 7A: Weekly Challenges

- [ ] T064 [US7] Create ChallengeService in lib/data/services/challenge_service.dart (selectChallenge based on spending patterns, updateProgress, awardPoints)
- [ ] T065 [US7] Create challenge_provider.dart in lib/providers/ (currentChallengeProvider, challengeProgressProvider)
- [ ] T066 [US7] Create ChallengeCard widget in lib/features/dashboard/widgets/challenge_card.dart (description, progress bar, reward points, celebration animation)
- [ ] T067 [US7] Integrate ChallengeCard into dashboard_screen.dart
- [ ] T068 [US7] Add challenge generation trigger on app startup (check if Monday and no current challenge)

### 7B: Spending Heatmap

- [ ] T069 [P] [US7] Create SpendingHeatmap widget in lib/shared/widgets/spending_heatmap.dart (month grid Saturday-Friday, color-coded days, tap for details tooltip)
- [ ] T070 [US7] Add SpendingHeatmap to reports_screen.dart _GeneralReportTab as new section

### 7C: Budget Progress Rings

- [ ] T071 [P] [US7] Create ProgressRing widget in lib/shared/widgets/progress_ring.dart (CustomPainter, AnimationController, over-budget red overlay)
- [ ] T072 [US7] Create BudgetProgressRing widget in lib/features/budgets/widgets/budget_progress_ring.dart (uses ProgressRing, shows category name and "X من Y جنيه")
- [ ] T073 [US7] Update budgets_screen.dart to use BudgetProgressRing in 2-column grid layout

- [ ] T074 [US7] Run `flutter analyze` to verify no lint errors

**Checkpoint**: Dashboard shows challenge card, Reports shows heatmap, Budgets shows animated rings

---

## Phase 10: User Story 8 - Android Home Widget (Priority: P3)

**Goal**: Home screen widget showing today's spending at a glance

**Independent Test**: Add widget to home screen, add transaction in app, verify widget updates with correct spending total

### Native Android Setup

- [ ] T075 [US8] Create widget layout XML in android/app/src/main/res/layout/flowspend_widget.xml (rounded rectangle, title, spending amount, "مصروفات اليوم" label, recent transactions)
- [ ] T076 [US8] Create widget info XML in android/app/src/main/res/xml/flowspend_widget_info.xml (minWidth, minHeight, updatePeriodMillis)
- [ ] T077 [US8] Update AndroidManifest.xml in android/app/src/main/ to register widget receiver and provider

### Flutter Integration

- [ ] T078 [US8] Create WidgetSyncService in lib/data/services/widget_sync_service.dart (syncWidgetData using HomeWidget.saveWidgetData, updateWidget)
- [ ] T079 [US8] Create widget_sync_provider.dart in lib/providers/ (widgetSyncServiceProvider)
- [ ] T080 [US8] Hook widget sync into transaction save flow in transaction_provider.dart (call syncWidgetData after save)
- [ ] T081 [US8] Add theme-aware widget variants (dark/light) in widget layout XML
- [ ] T082 [US8] Run `flutter analyze` to verify no lint errors

**Checkpoint**: Widget appears on home screen and updates when transactions change

---

## Phase 11: Polish & Cross-Cutting Concerns

**Purpose**: Final cleanup and validation across all features

- [ ] T083 [P] Verify all 8 features work in both dark and light themes
- [ ] T084 [P] Verify all Arabic text displays correctly RTL across new screens/widgets
- [ ] T085 Run full `flutter analyze` and fix any remaining lint warnings
- [ ] T086 Test app startup flow (onboarding → dashboard with all new widgets)
- [ ] T087 Test transaction flow (add transaction → auto-categorize → daily limit check → widget sync → pattern detection)
- [ ] T088 Build release APK: `flutter build apk --release`
- [ ] T089 Update CLAUDE.md with new feature documentation if needed

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies - can start immediately
- **Phase 2 (Foundational)**: Depends on Phase 1 - BLOCKS all user stories
- **Phase 3-10 (User Stories)**: All depend on Phase 2 completion
- **Phase 11 (Polish)**: Depends on all desired user stories being complete

### User Story Dependencies

| Story | Dependencies | Can Run In Parallel With |
|-------|--------------|--------------------------|
| US1 (Auto-Categorization) | Phase 2 only | US2 |
| US2 (Data Export) | Phase 2 only | US1 |
| US3 (Month Comparison) | Phase 2 only | US4 |
| US4 (Daily Spending Limit) | Phase 2 only | US3 |
| US5 (Recurring Detection) | US1 (uses auto-categorization) | - |
| US6 (Enhanced Onboarding) | Phase 2 only | US7, US8 |
| US7 (Gamification) | Phase 2 only | US6, US8 |
| US8 (Home Widget) | Phase 2 only | US6, US7 |

### Critical Path

```
Phase 1 → Phase 2 → US1 → US5 (recurring depends on auto-categorization)
                  ↘ US2, US3, US4, US6, US7, US8 (can run in parallel)
```

---

## Parallel Opportunities

### Within Phase 2 (Foundational)

```
# All models can be created in parallel:
T005, T006, T007 (3 new Isar models)
T010, T011, T012 (3 repositories)

# Then sequentially:
T008 (modify AppSettings)
T009 (build_runner - depends on all models)
T013 (update IsarService - depends on build_runner)
```

### User Stories in Parallel

```
# After Phase 2 completes, these can run simultaneously:
Developer A: US1 (Auto-Categorization) + US5 (Recurring Detection)
Developer B: US2 (Data Export) + US3 (Month Comparison)
Developer C: US4 (Daily Limit) + US6 (Onboarding)
Developer D: US7 (Gamification) + US8 (Widget)
```

### Within Each User Story

```
# US2 parallel tasks:
T024 (FormatCard) || T025 (FilterSection)
T028 (Settings button) || T029 (Reports button)

# US6 parallel tasks:
T055, T056, T057, T058, T059 (all 5 page widgets)

# US7 parallel tasks:
T069 (SpendingHeatmap) || T071 (ProgressRing)
```

---

## Implementation Strategy

### MVP First (US1 Only)

1. Complete Phase 1: Setup (2 tasks)
2. Complete Phase 2: Foundational (~9 tasks)
3. Complete Phase 3: User Story 1 - Auto-Categorization (7 tasks)
4. **STOP and VALIDATE**: Test auto-categorization independently
5. Deploy/demo with single feature value

### Recommended Implementation Order

1. **Setup + Foundational** (Phase 1-2): ~13 tasks
2. **US1 + US2** (P1 priority): ~17 tasks - High value, independent
3. **US3 + US4** (P2 priority): ~15 tasks - Builds on existing
4. **US5** (P2, depends on US1): ~9 tasks - Requires auto-categorization
5. **US6 + US7 + US8** (P3 priority): ~20 tasks - Polish features

### Total Task Count

| Phase | Tasks |
|-------|-------|
| Phase 1: Setup | 4 |
| Phase 2: Foundational | 9 |
| Phase 3: US1 Auto-Categorization | 7 |
| Phase 4: US2 Data Export | 10 |
| Phase 5: US3 Month Comparison | 6 |
| Phase 6: US4 Daily Limit | 9 |
| Phase 7: US5 Recurring Detection | 9 |
| Phase 8: US6 Onboarding | 9 |
| Phase 9: US7 Gamification | 11 |
| Phase 10: US8 Widget | 8 |
| Phase 11: Polish | 7 |
| **Total** | **89** |

---

## Notes

- [P] tasks = different files, no dependencies
- [USn] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Run `flutter analyze` after each user story completion
- Run `build_runner` only once in Phase 2 (unless adding more models later)
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
