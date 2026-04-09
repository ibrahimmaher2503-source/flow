# Tasks: Add English Translations

**Input**: Design documents from `/specs/008-english-translations/`
**Prerequisites**: plan.md, spec.md, data-model.md, contracts/localization-api.md, research.md, quickstart.md

**Organization**: Tasks grouped by user story to enable independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)
- Exact file paths included in descriptions

## Path Conventions

- **Flutter mobile app**: `lib/` for source, `test/` for tests
- Localization files: `lib/l10n/`
- Config: project root (`l10n.yaml`, `pubspec.yaml`)

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Configure Flutter localization infrastructure

- [ ] T001 Add flutter_localizations SDK dependency in pubspec.yaml
- [ ] T002 Add `generate: true` to flutter section in pubspec.yaml
- [ ] T003 Create l10n.yaml configuration file in project root
- [ ] T004 Create lib/l10n/ directory structure
- [ ] T005 [P] Create lib/l10n/app_en.arb with English string keys (~200 strings)
- [ ] T006 [P] Create lib/l10n/app_ar.arb with Arabic translations (~200 strings)
- [ ] T007 Run `flutter gen-l10n` to generate AppLocalizations class
- [ ] T008 Create lib/core/extensions/context_extensions.dart with l10n extension

**Checkpoint**: Localization infrastructure ready, code generation working

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core locale management that ALL user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [ ] T009 Create lib/providers/locale_provider.dart watching AppSettings.language
- [ ] T010 Add setLanguage method to lib/data/repositories/settings_repo.dart
- [ ] T011 Update lib/app.dart to use localeProvider for MaterialApp.locale
- [ ] T012 Update lib/app.dart to add localizationsDelegates and supportedLocales
- [ ] T013 Remove hardcoded Directionality(textDirection: RTL) wrapper from lib/app.dart
- [ ] T014 Verify app builds and displays with locale from AppSettings

**Checkpoint**: Foundation ready - locale switching infrastructure complete

---

## Phase 3: User Story 1 - Switch Language to English (Priority: P1) 🎯 MVP

**Goal**: English speakers can switch language in Settings and see entire app in English

**Independent Test**: Change language in Settings → verify all visible text changes to English across all screens

### Implementation for User Story 1

#### 3.1 Language Selector UI

- [ ] T015 [US1] Add language selector dropdown/tile to lib/features/settings/widgets/preferences_section.dart
- [ ] T016 [US1] Wire language selector to setLanguage in SettingsRepo
- [ ] T017 [US1] Verify language change triggers immediate app rebuild

#### 3.2 Navigation Shell Migration

- [ ] T018 [US1] Replace hardcoded Arabic nav labels in lib/app.dart with l10n keys (nav_home, nav_transactions, nav_installments, nav_budgets, nav_settings)

#### 3.3 Settings Screen Migration

- [ ] T019 [US1] Migrate lib/features/settings/settings_screen.dart to use l10n strings
- [ ] T020 [P] [US1] Migrate lib/features/settings/widgets/preferences_section.dart to use l10n strings
- [ ] T021 [P] [US1] Migrate lib/features/settings/widgets/backup_section.dart to use l10n strings
- [ ] T022 [P] [US1] Migrate lib/features/settings/widgets/installment_providers_section.dart to use l10n strings
- [ ] T023 [P] [US1] Migrate lib/features/settings/categories_screen.dart to use l10n strings

#### 3.4 Dashboard Screen Migration

- [ ] T024 [US1] Migrate lib/features/dashboard/dashboard_screen.dart to use l10n strings
- [ ] T025 [P] [US1] Migrate lib/features/dashboard/widgets/dashboard_header.dart to use l10n strings
- [ ] T026 [P] [US1] Migrate lib/features/dashboard/widgets/balance_card.dart to use l10n strings
- [ ] T027 [P] [US1] Migrate lib/features/dashboard/widgets/quick_stats.dart to use l10n strings
- [ ] T028 [P] [US1] Migrate lib/features/dashboard/widgets/streak_badge.dart to use l10n strings
- [ ] T029 [P] [US1] Migrate lib/features/dashboard/widgets/finance_score_card.dart to use l10n strings
- [ ] T030 [P] [US1] Migrate lib/features/dashboard/widgets/installment_summary_card.dart to use l10n strings
- [ ] T031 [P] [US1] Migrate lib/features/dashboard/widgets/recent_transactions.dart to use l10n strings
- [ ] T032 [P] [US1] Migrate lib/features/dashboard/widgets/upcoming_recurring.dart to use l10n strings

#### 3.5 Transactions Screen Migration

- [ ] T033 [US1] Migrate lib/features/transactions/transactions_screen.dart to use l10n strings
- [ ] T034 [P] [US1] Migrate lib/features/transactions/add_transaction_screen.dart to use l10n strings
- [ ] T035 [P] [US1] Migrate lib/features/transactions/widgets/transaction_tile.dart to use l10n strings
- [ ] T036 [P] [US1] Migrate lib/features/transactions/widgets/filter_bar.dart to use l10n strings
- [ ] T037 [P] [US1] Migrate lib/features/transactions/widgets/category_grid.dart to use l10n strings
- [ ] T038 [P] [US1] Migrate lib/features/transactions/widgets/number_pad.dart to use l10n strings

#### 3.6 Budgets Screen Migration

- [ ] T039 [US1] Migrate lib/features/budgets/budgets_screen.dart to use l10n strings
- [ ] T040 [P] [US1] Migrate lib/features/budgets/widgets/budget_progress_card.dart to use l10n strings

#### 3.7 Goals Screen Migration

- [ ] T041 [US1] Migrate lib/features/goals/goals_screen.dart to use l10n strings
- [ ] T042 [P] [US1] Migrate lib/features/goals/widgets/goal_card.dart to use l10n strings

#### 3.8 Installments Screen Migration

- [ ] T043 [US1] Migrate lib/features/installments/installments_hub_screen.dart to use l10n strings
- [ ] T044 [P] [US1] Migrate lib/features/installments/add_installment_screen.dart to use l10n strings
- [ ] T045 [P] [US1] Migrate lib/features/installments/installment_details_screen.dart to use l10n strings
- [ ] T046 [P] [US1] Migrate lib/features/installments/widgets/installment_card.dart to use l10n strings
- [ ] T047 [P] [US1] Migrate lib/features/installments/widgets/interest_summary.dart to use l10n strings
- [ ] T048 [P] [US1] Migrate lib/features/installments/widgets/payment_timeline.dart to use l10n strings
- [ ] T049 [P] [US1] Migrate lib/features/installments/widgets/provider_selector.dart to use l10n strings

#### 3.9 Reports Screen Migration

- [ ] T050 [US1] Migrate lib/features/reports/reports_screen.dart to use l10n strings
- [ ] T051 [P] [US1] Migrate lib/features/reports/widgets/category_pie_chart.dart to use l10n strings
- [ ] T052 [P] [US1] Migrate lib/features/reports/widgets/installment_pie_chart.dart to use l10n strings
- [ ] T053 [P] [US1] Migrate lib/features/reports/widgets/monthly_bar_chart.dart to use l10n strings
- [ ] T054 [P] [US1] Migrate lib/features/reports/widgets/trend_line_chart.dart to use l10n strings
- [ ] T055 [P] [US1] Migrate lib/features/reports/widgets/debt_timeline_chart.dart to use l10n strings
- [ ] T056 [P] [US1] Migrate lib/features/reports/widgets/interest_bar_chart.dart to use l10n strings

#### 3.10 Recurring & Wallets Migration

- [ ] T057 [US1] Migrate lib/features/recurring/recurring_screen.dart to use l10n strings
- [ ] T058 [P] [US1] Migrate lib/features/recurring/widgets/recurring_tile.dart to use l10n strings
- [ ] T059 [US1] Migrate lib/features/wallets/wallets_screen.dart to use l10n strings
- [ ] T060 [P] [US1] Migrate lib/features/wallets/widgets/wallet_card.dart to use l10n strings

#### 3.11 SMS & Onboarding Migration

- [ ] T061 [US1] Migrate lib/features/sms/sms_inbox_screen.dart to use l10n strings
- [ ] T062 [P] [US1] Migrate lib/features/sms/sms_confirmation_screen.dart to use l10n strings
- [ ] T063 [P] [US1] Migrate lib/features/sms/widgets/sms_tile.dart to use l10n strings
- [ ] T064 [P] [US1] Migrate lib/features/sms/widgets/sms_permission_dialog.dart to use l10n strings
- [ ] T065 [US1] Migrate lib/features/onboarding/onboarding_screen.dart to use l10n strings

#### 3.12 Shared Widgets Migration

- [ ] T066 [P] [US1] Migrate lib/shared/widgets/empty_state.dart usages to pass l10n strings
- [ ] T067 [P] [US1] Migrate lib/shared/widgets/app_button.dart usages to use l10n strings
- [ ] T068 [P] [US1] Migrate lib/shared/widgets/section_header.dart usages to use l10n strings

#### 3.13 Gamification Migration

- [ ] T069 [US1] Update lib/providers/gamification_provider.dart badge names to use l10n keys
- [ ] T070 [US1] Create badge name getter that accepts context for l10n lookup

**Checkpoint**: User Story 1 complete - English speakers can use entire app in English

---

## Phase 4: User Story 2 - Arabic User Maintains Current Experience (Priority: P2)

**Goal**: Arabic users see no change in their experience; Arabic remains default with RTL

**Independent Test**: Fresh install opens in Arabic with RTL; switching back to Arabic restores everything

### Implementation for User Story 2

- [ ] T071 [US2] Verify AppSettings.language defaults to 'ar' in lib/data/models/app_settings_model.dart
- [ ] T072 [US2] Verify all Arabic strings in app_ar.arb match original hardcoded text exactly
- [ ] T073 [US2] Test RTL layout preserved when locale is 'ar' in lib/app.dart
- [ ] T074 [US2] Add integration test: fresh install defaults to Arabic
- [ ] T075 [US2] Add integration test: switching back to Arabic restores RTL layout

**Checkpoint**: User Story 2 complete - Arabic experience unchanged

---

## Phase 5: User Story 3 - View Localized Dates and Numbers (Priority: P3)

**Goal**: Dates display in locale-appropriate format (English or Arabic)

**Independent Test**: Compare date displays between English and Arabic modes

### Implementation for User Story 3

- [ ] T076 [US3] Update lib/core/utils/app_date_utils.dart formatRelative() to accept locale parameter
- [ ] T077 [US3] Update lib/core/utils/app_date_utils.dart formatDate() to use locale-aware DateFormat
- [ ] T078 [US3] Update lib/core/utils/app_date_utils.dart formatMonth() to use locale-aware DateFormat
- [ ] T079 [US3] Update lib/core/utils/app_date_utils.dart formatDayMonth() to use locale-aware DateFormat
- [ ] T080 [US3] Add English relative date strings to app_en.arb (date_today, date_yesterday, date_days_ago)
- [ ] T081 [US3] Update all AppDateUtils call sites to pass current locale from context
- [ ] T082 [US3] Verify dates display correctly in both English and Arabic modes

**Checkpoint**: User Story 3 complete - dates format correctly per locale

---

## Phase 6: Category Localization (Enhancement)

**Goal**: Default category names display in selected language

### Implementation

- [ ] T083 Add nameKey field to lib/data/models/category_model.dart (nullable String)
- [ ] T084 Run build_runner to regenerate category_model.g.dart
- [ ] T085 Update lib/data/seeds/default_categories.dart to include nameKey values
- [ ] T086 Add category_* strings to app_en.arb and app_ar.arb for all 24 default categories
- [ ] T087 Create helper function to get localized category name (checks nameKey first, falls back to name)
- [ ] T088 Update category display throughout app to use localized category name helper

**Checkpoint**: Default categories display in selected language

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Improvements affecting multiple user stories

- [ ] T089 Audit all screens for any remaining hardcoded Arabic text
- [ ] T090 [P] Replace EdgeInsets with EdgeInsetsDirectional where directional in affected widgets
- [ ] T091 [P] Test text overflow in English mode (longer strings) across all screens
- [ ] T092 [P] Verify chevron icons flip correctly for RTL/LTR in list tiles
- [ ] T093 Verify language persists across app restart
- [ ] T094 Run full app walkthrough in English mode - all screens
- [ ] T095 Run full app walkthrough in Arabic mode - verify no regressions
- [ ] T096 Update CLAUDE.md to document localization system usage

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies - start immediately
- **Phase 2 (Foundational)**: Depends on Phase 1 - BLOCKS all user stories
- **Phase 3-5 (User Stories)**: All depend on Phase 2 completion
  - US1, US2, US3 can run in parallel after Phase 2
  - Or sequentially: P1 → P2 → P3
- **Phase 6 (Categories)**: Can run after Phase 2, parallel to user stories
- **Phase 7 (Polish)**: After all user stories complete

### User Story Dependencies

- **User Story 1 (P1)**: Depends on Phase 2 only - no other story dependencies
- **User Story 2 (P2)**: Depends on Phase 2 only - validates Arabic experience unchanged
- **User Story 3 (P3)**: Depends on Phase 2 only - date formatting enhancement

### Within Each Phase

- Tasks marked [P] can run in parallel (different files)
- Migration tasks within a screen group can run in parallel
- Run `flutter gen-l10n` after any ARB file changes

---

## Parallel Opportunities

### Phase 1 Parallel Tasks
```
T005 (app_en.arb) || T006 (app_ar.arb)
```

### Phase 3 Parallel Tasks (by screen group)
```
Dashboard widgets: T025 || T026 || T027 || T028 || T029 || T030 || T031 || T032
Transactions widgets: T034 || T035 || T036 || T037 || T038
Settings widgets: T020 || T021 || T022 || T023
Installments widgets: T044 || T045 || T046 || T047 || T048 || T049
Reports widgets: T051 || T052 || T053 || T054 || T055 || T056
```

### Phase 7 Parallel Tasks
```
T090 || T091 || T092
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (~8 tasks)
2. Complete Phase 2: Foundational (~6 tasks)
3. Complete Phase 3: User Story 1 (~56 tasks)
4. **STOP and VALIDATE**: Test English language switching end-to-end
5. Deploy/demo if ready

### Incremental Delivery

1. Setup + Foundational → Infrastructure ready
2. User Story 1 → English language support (MVP!)
3. User Story 2 → Arabic experience validation
4. User Story 3 → Date localization
5. Phase 6 → Category localization (enhancement)
6. Phase 7 → Polish

---

## Summary

| Phase | Task Count | Description |
|-------|------------|-------------|
| Phase 1: Setup | 8 | Localization infrastructure |
| Phase 2: Foundational | 6 | Locale provider, app.dart changes |
| Phase 3: US1 (P1) | 56 | English language support - all screens |
| Phase 4: US2 (P2) | 5 | Arabic experience validation |
| Phase 5: US3 (P3) | 7 | Date formatting localization |
| Phase 6: Categories | 6 | Default category localization |
| Phase 7: Polish | 8 | Cross-cutting improvements |
| **Total** | **96** | |

---

## Notes

- [P] tasks = different files, no dependencies - can run in parallel
- [US1/US2/US3] = maps task to specific user story
- Each user story is independently testable
- Commit after each logical group of tasks
- Run `flutter gen-l10n` after modifying any .arb file
- Stop at any checkpoint to validate independently
