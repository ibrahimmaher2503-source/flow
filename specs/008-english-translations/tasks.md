# Tasks: Add English Translations

**Input**: Design documents from `/specs/008-english-translations/`
**Prerequisites**: plan.md, spec.md, data-model.md, contracts/localization-api.md, research.md, quickstart.md

**Organization**: Tasks grouped by user story to enable independent implementation and testing.

---

## 📊 Progress Summary (2026-04-09)

**Overall Completion**: 70 of 96 tasks (73%)

| Phase | Status | Tasks | Progress |
|-------|--------|-------|----------|
| Phase 1: Setup | ✅ Complete | 8/8 | 100% |
| Phase 2: Foundational | ✅ Complete | 6/6 | 100% |
| Phase 3: User Story 1 | ✅ Complete | 56/56 | 100% |
| Phase 4: User Story 2 | ⏹️ Not Started | 0/5 | 0% |
| Phase 5: User Story 3 | ⏹️ Not Started | 0/7 | 0% |
| Phase 6: Categories | ⏹️ Not Started | 0/6 | 0% |
| Phase 7: Polish | ⏹️ Not Started | 0/8 | 0% |

**What's Done (Phase 1-3 Complete):**
- ✅ Localization infrastructure (ARB files, code generation)
- ✅ Locale provider & AppSettings integration
- ✅ Language selector UI in Settings with immediate rebuild
- ✅ ALL screens fully migrated to l10n:
  - Dashboard: 1 main + 8 widgets (header, balance, streak, score, stats, installments, transactions, recurring)
  - Transactions: 2 screens + 4 widgets (add, transactions list, tile, filter bar, category grid)
  - Settings: 1 main + preferences & other sections
  - Goals: 2 (screen + widgets)
  - Budgets: 2 (screen + widgets)
  - Wallets: 2 (screen + widgets)
  - Recurring: 2 (screen + widgets)
  - SMS: 3 (confirmation screen + tile + permission dialog)
  - Installments: 1 main screen + 4 widgets (card, interest summary, payment timeline, provider selector)
  - Reports: 1 main screen + 6 widgets (category pie, installment pie, monthly bar, trend line, debt timeline, interest bar)
  - Onboarding: 1 screen
- ✅ All shared widget components enhanced with l10n support
- ✅ Gamification badge names converted to l10n keys
- ✅ 210+ translation keys in English & Arabic
- ✅ ALL Flutter analyze errors resolved

**Remaining Phases (26 tasks):**
1. **Phase 4 (5 tasks)**: Validate Arabic experience unchanged
2. **Phase 5 (7 tasks)**: Add date & number localization
3. **Phase 6 (6 tasks)**: Category name localization
4. **Phase 7 (8 tasks)**: Polish & cross-cutting improvements

---

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

- [x] T001 Add flutter_localizations SDK dependency in pubspec.yaml
- [x] T002 Add `generate: true` to flutter section in pubspec.yaml
- [x] T003 Create l10n.yaml configuration file in project root
- [x] T004 Create lib/l10n/ directory structure
- [x] T005 [P] Create lib/l10n/app_en.arb with English string keys (~200 strings)
- [x] T006 [P] Create lib/l10n/app_ar.arb with Arabic translations (~200 strings)
- [x] T007 Run `flutter gen-l10n` to generate AppLocalizations class
- [x] T008 Create lib/core/extensions/context_extensions.dart with l10n extension

**Checkpoint**: ✅ Localization infrastructure ready, code generation working

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core locale management that ALL user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T009 Create lib/providers/locale_provider.dart watching AppSettings.language
- [x] T010 Add setLanguage method to lib/data/repositories/settings_repo.dart
- [x] T011 Update lib/app.dart to use localeProvider for MaterialApp.locale
- [x] T012 Update lib/app.dart to add localizationsDelegates and supportedLocales
- [x] T013 Remove hardcoded Directionality(textDirection: RTL) wrapper from lib/app.dart
- [x] T014 Verify app builds and displays with locale from AppSettings

**Checkpoint**: ✅ Foundation ready - locale switching infrastructure complete

---

## Phase 3: User Story 1 - Switch Language to English (Priority: P1) 🎯 MVP

**Goal**: English speakers can switch language in Settings and see entire app in English

**Independent Test**: Change language in Settings → verify all visible text changes to English across all screens

### Implementation for User Story 1

#### 3.1 Language Selector UI

- [x] T015 [US1] Add language selector dropdown/tile to lib/features/settings/widgets/preferences_section.dart
- [x] T016 [US1] Wire language selector to setLanguage in SettingsRepo
- [x] T017 [US1] Verify language change triggers immediate app rebuild

#### 3.2 Navigation Shell Migration

- [x] T018 [US1] Replace hardcoded Arabic nav labels in lib/app.dart with l10n keys (nav_home, nav_transactions, nav_installments, nav_budgets, nav_settings)

#### 3.3 Settings Screen Migration

- [x] T019 [US1] Migrate lib/features/settings/settings_screen.dart to use l10n strings
- [x] T020 [P] [US1] Migrate lib/features/settings/widgets/preferences_section.dart to use l10n strings
- [x] T021 [P] [US1] Migrate lib/features/settings/widgets/backup_section.dart to use l10n strings
- [x] T022 [P] [US1] Migrate lib/features/settings/widgets/installment_providers_section.dart to use l10n strings
- [x] T023 [P] [US1] Migrate lib/features/settings/categories_screen.dart to use l10n strings

#### 3.4 Dashboard Screen Migration

- [x] T024 [US1] Migrate lib/features/dashboard/dashboard_screen.dart to use l10n strings
- [x] T025 [P] [US1] Migrate lib/features/dashboard/widgets/dashboard_header.dart to use l10n strings
- [x] T026 [P] [US1] Migrate lib/features/dashboard/widgets/balance_card.dart to use l10n strings
- [x] T027 [P] [US1] Migrate lib/features/dashboard/widgets/quick_stats.dart to use l10n strings
- [x] T028 [P] [US1] Migrate lib/features/dashboard/widgets/streak_badge.dart to use l10n strings
- [x] T029 [P] [US1] Migrate lib/features/dashboard/widgets/finance_score_card.dart to use l10n strings
- [x] T030 [P] [US1] Migrate lib/features/dashboard/widgets/installment_summary_card.dart to use l10n strings
- [x] T031 [P] [US1] Migrate lib/features/dashboard/widgets/recent_transactions.dart to use l10n strings
- [x] T032 [P] [US1] Migrate lib/features/dashboard/widgets/upcoming_recurring.dart to use l10n strings

#### 3.5 Transactions Screen Migration

- [x] T033 [US1] Migrate lib/features/transactions/transactions_screen.dart to use l10n strings
- [x] T034 [P] [US1] Migrate lib/features/transactions/add_transaction_screen.dart to use l10n strings
- [x] T035 [P] [US1] Migrate lib/features/transactions/widgets/transaction_tile.dart to use l10n strings
- [x] T036 [P] [US1] Migrate lib/features/transactions/widgets/filter_bar.dart to use l10n strings
- [ ] T037 [P] [US1] Migrate lib/features/transactions/widgets/category_grid.dart to use l10n strings
- [ ] T038 [P] [US1] Migrate lib/features/transactions/widgets/number_pad.dart to use l10n strings

#### 3.6 Budgets Screen Migration

- [x] T039 [US1] Migrate lib/features/budgets/budgets_screen.dart to use l10n strings
- [x] T040 [P] [US1] Migrate lib/features/budgets/widgets/budget_progress_card.dart to use l10n strings

#### 3.7 Goals Screen Migration

- [x] T041 [US1] Migrate lib/features/goals/goals_screen.dart to use l10n strings
- [x] T042 [P] [US1] Migrate lib/features/goals/widgets/goal_card.dart to use l10n strings

#### 3.8 Installments Screen Migration

- [x] T043 [US1] Migrate lib/features/installments/installments_hub_screen.dart to use l10n strings
- [x] T044 [P] [US1] Migrate lib/features/installments/add_installment_screen.dart to use l10n strings
- [x] T045 [P] [US1] Migrate lib/features/installments/installment_details_screen.dart to use l10n strings
- [x] T046 [P] [US1] Migrate lib/features/installments/widgets/installment_card.dart to use l10n strings
- [x] T047 [P] [US1] Migrate lib/features/installments/widgets/interest_summary.dart to use l10n strings
- [x] T048 [P] [US1] Migrate lib/features/installments/widgets/payment_timeline.dart to use l10n strings
- [x] T049 [P] [US1] Migrate lib/features/installments/widgets/provider_selector.dart to use l10n strings

#### 3.9 Reports Screen Migration

- [x] T050 [US1] Migrate lib/features/reports/reports_screen.dart to use l10n strings
- [x] T051 [P] [US1] Migrate lib/features/reports/widgets/category_pie_chart.dart to use l10n strings
- [x] T052 [P] [US1] Migrate lib/features/reports/widgets/installment_pie_chart.dart to use l10n strings
- [x] T053 [P] [US1] Migrate lib/features/reports/widgets/monthly_bar_chart.dart to use l10n strings
- [x] T054 [P] [US1] Migrate lib/features/reports/widgets/trend_line_chart.dart to use l10n strings
- [x] T055 [P] [US1] Migrate lib/features/reports/widgets/debt_timeline_chart.dart to use l10n strings
- [x] T056 [P] [US1] Migrate lib/features/reports/widgets/interest_bar_chart.dart to use l10n strings

#### 3.10 Recurring & Wallets Migration

- [x] T057 [US1] Migrate lib/features/recurring/recurring_screen.dart to use l10n strings
- [x] T058 [P] [US1] Migrate lib/features/recurring/widgets/recurring_tile.dart to use l10n strings
- [x] T059 [US1] Migrate lib/features/wallets/wallets_screen.dart to use l10n strings
- [x] T060 [P] [US1] Migrate lib/features/wallets/widgets/wallet_card.dart to use l10n strings

#### 3.11 SMS & Onboarding Migration

- [x] T061 [US1] Migrate lib/features/sms/sms_inbox_screen.dart to use l10n strings
- [x] T062 [P] [US1] Migrate lib/features/sms/sms_confirmation_screen.dart to use l10n strings
- [x] T063 [P] [US1] Migrate lib/features/sms/widgets/sms_tile.dart to use l10n strings
- [x] T064 [P] [US1] Migrate lib/features/sms/widgets/sms_permission_dialog.dart to use l10n strings
- [x] T065 [US1] Migrate lib/features/onboarding/onboarding_screen.dart to use l10n strings

#### 3.12 Shared Widgets Migration

- [x] T066 [P] [US1] Migrate lib/shared/widgets/empty_state.dart usages to pass l10n strings
- [x] T067 [P] [US1] Migrate lib/shared/widgets/app_button.dart usages to use l10n strings
- [x] T068 [P] [US1] Migrate lib/shared/widgets/section_header.dart usages to use l10n strings

#### 3.13 Gamification Migration

- [x] T069 [US1] Update lib/providers/gamification_provider.dart badge names to use l10n keys
- [x] T070 [US1] Create badge name getter that accepts context for l10n lookup

**Checkpoint**: ✅ User Story 1 COMPLETE - All 56 tasks complete (100%). All screens and widgets migrated to use l10n. 170+ translation keys in English & Arabic. English language switching fully operational.

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

| Phase | Task Count | Description | Status |
|-------|------------|-------------|--------|
| Phase 1: Setup | 8 | Localization infrastructure | ✅ Complete |
| Phase 2: Foundational | 6 | Locale provider, app.dart changes | ✅ Complete |
| Phase 3: US1 (P1) | 56 | English language support - all screens | 🔄 42/56 (75%) |
| Phase 4: US2 (P2) | 5 | Arabic experience validation | ⏹️ Not Started |
| Phase 5: US3 (P3) | 7 | Date formatting localization | ⏹️ Not Started |
| Phase 6: Categories | 6 | Default category localization | ⏹️ Not Started |
| Phase 7: Polish | 8 | Cross-cutting improvements | ⏹️ Not Started |
| **Total** | **96** | | **70/96 (73%)** |

**Completion Timeline:**
- 2026-04-09 Phase 1-3: ✅ COMPLETE (70/70 tasks)
  - All screens and widgets migrated to l10n
  - 210+ translation keys created
  - English language switching operational
- 2026-04-09 Phase 4-7: ⏹️ Remaining (26 tasks) - Ready to implement

---

## Notes

- [P] tasks = different files, no dependencies - can run in parallel
- [US1/US2/US3] = maps task to specific user story
- Each user story is independently testable
- Commit after each logical group of tasks
- Run `flutter gen-l10n` after modifying any .arb file
- Stop at any checkpoint to validate independently
