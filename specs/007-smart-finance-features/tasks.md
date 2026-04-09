# Tasks: Core Smart Finance Features

**Input**: Design documents from `/specs/007-smart-finance-features/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story. User stories can be implemented in priority order (P1→P6) or in parallel.

## Format: `[ID] [P?] [Story?] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1-US6)
- All file paths are relative to repository root

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create new Isar models, update existing models, run code generation

- [ ] T001 [P] Create Envelope model in lib/data/models/envelope_model.dart
- [ ] T002 [P] Create TransactionTag model in lib/data/models/transaction_tag_model.dart
- [ ] T003 [P] Create Insight model in lib/data/models/insight_model.dart
- [ ] T004 [P] Add `tags` field to Transaction model in lib/data/models/transaction_model.dart
- [ ] T005 [P] Add `envelopeBudgetingEnabled` field to AppSettings model in lib/data/models/app_settings_model.dart
- [ ] T006 Run Isar code generation: `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] T007 Register new schemas (Envelope, TransactionTag, Insight) in lib/data/services/isar_service.dart
- [ ] T008 Verify build passes: `flutter analyze`

**Checkpoint**: All data models created and code generation complete

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Create repositories and provider registrations that multiple user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [ ] T009 [P] Create EnvelopeRepository in lib/data/repositories/envelope_repo.dart
- [ ] T010 [P] Create TagRepository in lib/data/repositories/tag_repo.dart
- [ ] T011 [P] Create InsightRepository in lib/data/repositories/insight_repo.dart
- [ ] T012 [P] Create computed data structures (SafeToSpendData, EnvelopeWithSpent, ForecastData, BillContext) in lib/data/models/smart_feature_models.dart
- [ ] T013 Add new routes (envelopes, envelopeAllocate, tags, forecast, insights) to lib/core/router/app_router.dart
- [ ] T014 Verify all repositories compile: `flutter analyze`

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Safe-to-Spend Dashboard (Priority: P1) 🎯 MVP

**Goal**: Display safe-to-spend amount on Dashboard showing money available after obligations

**Independent Test**: Add wallet with 10,000 EGP balance, add installment of 2,000 EGP due this month, verify Dashboard shows "تقدر تصرف" with 8,000 EGP in green

### Implementation for User Story 1

- [ ] T015 [US1] Create SafeToSpendService with calculate() method in lib/data/services/safe_to_spend_service.dart
- [ ] T016 [US1] Create safeToSpendProvider in lib/providers/safe_to_spend_provider.dart
- [ ] T017 [P] [US1] Create SpendingVelocityIndicator widget in lib/features/dashboard/widgets/spending_velocity.dart
- [ ] T018 [US1] Create SafeToSpendCard widget with expandable breakdown in lib/features/dashboard/widgets/safe_to_spend_card.dart
- [ ] T019 [US1] Integrate SafeToSpendCard into Dashboard screen replacing/augmenting balance display in lib/features/dashboard/dashboard_screen.dart
- [ ] T020 [US1] Add theme-aware colors for health status (green/yellow/red) using existing AppColors

**Checkpoint**: Safe-to-Spend displays on Dashboard with color coding and velocity indicator

---

## Phase 4: User Story 2 - Envelope Budgeting System (Priority: P2)

**Goal**: Allow users to allocate money into virtual envelopes per category with visual fill indicators

**Independent Test**: Enable envelope budgeting in settings, create envelope "أكل" with 1000 EGP, add 400 EGP food transaction, verify envelope shows 60% remaining (green)

### Implementation for User Story 2

- [ ] T021 [US2] Create EnvelopeService with CRUD and rollover logic in lib/data/services/envelope_service.dart
- [ ] T022 [US2] Create envelopeProvider and envelopeRepoProvider in lib/providers/envelope_provider.dart
- [ ] T023 [P] [US2] Create EnvelopeCard widget with fill indicator in lib/features/envelopes/widgets/envelope_card.dart
- [ ] T024 [P] [US2] Create EnvelopeFormSheet bottom sheet for create/edit in lib/features/envelopes/widgets/envelope_form_sheet.dart
- [ ] T025 [P] [US2] Create EnvelopeSummaryBar widget in lib/features/envelopes/widgets/envelope_summary_bar.dart
- [ ] T026 [US2] Create EnvelopesScreen in lib/features/envelopes/envelopes_screen.dart
- [ ] T027 [US2] Create EnvelopeAllocateScreen for quick income allocation in lib/features/envelopes/envelope_allocate_screen.dart
- [ ] T028 [US2] Add envelope toggle to settings in lib/features/settings/widgets/preferences_section.dart
- [ ] T029 [US2] Integrate envelope overage warning into transaction add flow
- [ ] T030 [US2] Add envelope notifications (20% and 0% alerts) to lib/data/services/notification_service.dart

**Checkpoint**: Users can create envelopes, see fill indicators, and receive low balance alerts

---

## Phase 5: User Story 3 - Transaction Tags (Priority: P3)

**Goal**: Allow users to add custom tags to transactions for cross-category tracking (e.g., "رمضان", "سفر")

**Independent Test**: Add transaction with tag "فرح", add second transaction with same tag, open Tags screen, verify "فرح" shows with total amount and 2 transactions

### Implementation for User Story 3

- [ ] T031 [US3] Create TagService with rename/delete logic in lib/data/services/tag_service.dart
- [ ] T032 [US3] Create tagProvider and tagRepoProvider in lib/providers/tag_provider.dart
- [ ] T033 [P] [US3] Create TagChip widget in lib/features/tags/widgets/tag_chip.dart
- [ ] T034 [P] [US3] Create TagInputField widget with autocomplete in lib/features/tags/widgets/tag_input_field.dart
- [ ] T035 [P] [US3] Create TagAnalyticsCard widget in lib/features/tags/widgets/tag_analytics_card.dart
- [ ] T036 [US3] Create TagsScreen with list and analytics in lib/features/tags/tags_screen.dart
- [ ] T037 [US3] Integrate TagInputField into add transaction screen
- [ ] T038 [US3] Integrate TagInputField into edit transaction screen
- [ ] T039 [US3] Add tag filter option to lib/features/transactions/widgets/filter_bar.dart
- [ ] T040 [US3] Display tag chips on transaction list items in lib/features/transactions/widgets/transaction_tile.dart

**Checkpoint**: Users can add, filter, and analyze transactions by tags

---

## Phase 6: User Story 4 - Cash Flow Forecast (Priority: P4)

**Goal**: Show 30-day financial projection with optimistic/realistic/pessimistic scenarios

**Independent Test**: With 3 months of transaction history, open Forecast screen, verify line chart shows 3 scenario lines and upcoming installments are marked with red dots

### Implementation for User Story 4

- [ ] T041 [US4] Create ForecastService with projection algorithm in lib/data/services/forecast_service.dart
- [ ] T042 [US4] Create forecastProvider in lib/providers/forecast_provider.dart
- [ ] T043 [P] [US4] Create ForecastChart widget using fl_chart LineChart in lib/features/forecast/widgets/forecast_chart.dart
- [ ] T044 [P] [US4] Create ScenarioLegend widget in lib/features/forecast/widgets/scenario_legend.dart
- [ ] T045 [P] [US4] Create AssumptionsCard expandable widget in lib/features/forecast/widgets/assumptions_card.dart
- [ ] T046 [US4] Create ForecastScreen with chart and summary in lib/features/forecast/forecast_screen.dart
- [ ] T047 [P] [US4] Create ForecastMiniCard sparkline widget for Dashboard in lib/features/dashboard/widgets/forecast_mini_card.dart
- [ ] T048 [US4] Integrate ForecastMiniCard into Dashboard screen
- [ ] T049 [US4] Add negative balance warning display with Arabic message

**Checkpoint**: Users can view 30-day forecast with 3 scenarios and event markers

---

## Phase 7: User Story 5 - Smart Insights Engine (Priority: P5)

**Goal**: Generate personalized insights about spending patterns (spikes, streaks, opportunities)

**Independent Test**: Seed data with food spending 50% above 3-month average, trigger insight generation, verify "مصاريف أكل زادت" insight appears on Dashboard

### Implementation for User Story 5

- [ ] T050 [US5] Create InsightsService with detection algorithms in lib/data/services/insights_service.dart
- [ ] T051 [US5] Implement spending spike detection (>30% above 3-month avg)
- [ ] T052 [US5] Implement streak recognition (7+ consecutive days logging)
- [ ] T053 [US5] Implement monthly summary generation
- [ ] T054 [US5] Implement savings opportunity detection
- [ ] T055 [US5] Implement unusual transaction detection (>3x category avg)
- [ ] T056 [US5] Implement positive reinforcement (spending down vs last month)
- [ ] T057 [US5] Create insightsProvider in lib/providers/insights_provider.dart
- [ ] T058 [P] [US5] Create InsightCard widget with swipe-to-dismiss in lib/features/insights/widgets/insight_card.dart
- [ ] T059 [P] [US5] Create InsightFilter chips widget in lib/features/insights/widgets/insight_filter.dart
- [ ] T060 [US5] Create InsightsCarousel widget for Dashboard in lib/features/dashboard/widgets/insights_carousel.dart
- [ ] T061 [US5] Create InsightsScreen with grouping (this week/month/previous) in lib/features/insights/insights_screen.dart
- [ ] T062 [US5] Integrate InsightsCarousel into Dashboard screen
- [ ] T063 [US5] Add insight generation triggers (app open, transaction add, refresh)

**Checkpoint**: Dashboard shows top insights; full insights screen displays all with filtering

---

## Phase 8: User Story 6 - Smart Bill Reminders (Priority: P6)

**Goal**: Send contextual bill reminders that include coverage status (comfortable/tight/critical)

**Independent Test**: Create recurring bill "كهرباء" due in 1 day with 500 EGP, set wallet balance to 1000 EGP, verify notification shows "فاتورة كهرباء بكره — 500 جنيه. الظرف مغطي وفاضل 500 بعدها."

### Implementation for User Story 6

- [ ] T064 [US6] Create BillReminderService with coverage calculation in lib/data/services/bill_reminder_service.dart
- [ ] T065 [US6] Create billReminderProvider in lib/providers/bill_reminder_provider.dart
- [ ] T066 [US6] Add showBillReminder() method to lib/data/services/notification_service.dart
- [ ] T067 [US6] Implement reminder scheduling (3 days, 1 day, on due date)
- [ ] T068 [P] [US6] Create BillCalendar widget with color-coded dots in lib/features/recurring/widgets/bill_calendar.dart
- [ ] T069 [US6] Integrate BillCalendar into recurring transactions screen
- [ ] T070 [US6] Add predicted bills (from SMS detection) with dashed styling
- [ ] T071 [US6] Implement contextual message generation in Arabic (4 tones)

**Checkpoint**: Users receive contextual bill reminders with coverage status

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Integration, refinement, and final touches

- [ ] T072 [P] Ensure all new screens support dark and light themes
- [ ] T073 [P] Verify RTL layout works correctly on all new screens
- [ ] T074 [P] Add Arabic labels for all new UI text
- [ ] T075 Provider invalidation: Ensure safeToSpendProvider invalidates when transactions/installments/goals change
- [ ] T076 Provider invalidation: Ensure envelopeProvider invalidates when transactions change
- [ ] T077 Provider invalidation: Ensure insightsProvider invalidates on relevant data changes
- [ ] T078 Add loading states (LoadingShimmer) to all async widgets
- [ ] T079 Add error states (EmptyState) to all async widgets
- [ ] T080 Navigation integration: Link Dashboard cards to their full screens
- [ ] T081 Final verification: Run `flutter analyze` with no errors
- [ ] T082 Manual testing: Test each user story independently per spec acceptance scenarios

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3-8)**: All depend on Foundational phase completion
  - Can proceed sequentially (P1→P2→P3→P4→P5→P6) OR
  - Can proceed in parallel if team capacity allows
- **Polish (Phase 9)**: Depends on all desired user stories being complete

### User Story Dependencies

| Story | Depends On | Notes |
|-------|-----------|-------|
| US1 (Safe-to-Spend) | Foundational only | Can start first; core feature |
| US2 (Envelopes) | Foundational only | Independent; can parallel with US1 |
| US3 (Tags) | Foundational only | Simple; can parallel with US1/US2 |
| US4 (Forecast) | Foundational only | Needs historical data; independent |
| US5 (Insights) | Foundational only | Most complex; can parallel |
| US6 (Bill Reminders) | US1 + US2 recommended | Best with Safe-to-Spend context |

### Within Each User Story

1. Service layer first (business logic)
2. Provider next (state management)
3. Widgets can be parallel (different files)
4. Screen assembly after widgets
5. Integration/notifications last

### Parallel Opportunities

**Phase 1 (all parallel):**
```
T001, T002, T003, T004, T005 → all different model files
```

**Phase 2 (all parallel):**
```
T009, T010, T011, T012 → all different repository files
```

**US1 widgets (parallel):**
```
T017 (SpendingVelocityIndicator) || T018 (SafeToSpendCard)
```

**US2 widgets (parallel):**
```
T023 (EnvelopeCard) || T024 (EnvelopeFormSheet) || T025 (EnvelopeSummaryBar)
```

**US3 widgets (parallel):**
```
T033 (TagChip) || T034 (TagInputField) || T035 (TagAnalyticsCard)
```

**US4 widgets (parallel):**
```
T043 (ForecastChart) || T044 (ScenarioLegend) || T045 (AssumptionsCard) || T047 (ForecastMiniCard)
```

**US5 widgets (parallel):**
```
T058 (InsightCard) || T059 (InsightFilter)
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (T001-T008)
2. Complete Phase 2: Foundational (T009-T014)
3. Complete Phase 3: User Story 1 - Safe-to-Spend (T015-T020)
4. **STOP and VALIDATE**: Test per acceptance scenarios
5. Deploy/demo if ready — users immediately see value

### Incremental Delivery

| Increment | Stories Included | New Value Delivered |
|-----------|------------------|---------------------|
| MVP | US1 | Safe-to-spend on Dashboard |
| +1 | US1 + US3 | + Transaction tags |
| +2 | US1 + US3 + US2 | + Envelope budgeting |
| +3 | US1-US4 | + Cash flow forecast |
| +4 | US1-US5 | + Smart insights |
| Full | US1-US6 | + Smart bill reminders |

### Suggested Daily Breakdown (Solo Developer)

| Day | Tasks | Deliverable |
|-----|-------|-------------|
| 1 | T001-T014 | Foundation complete |
| 2 | T015-T020 | US1 Safe-to-Spend MVP |
| 3 | T031-T040 | US3 Tags |
| 4-5 | T021-T030 | US2 Envelopes |
| 6 | T041-T049 | US4 Forecast |
| 7-8 | T050-T063 | US5 Insights |
| 9 | T064-T071 | US6 Bill Reminders |
| 10 | T072-T082 | Polish & Testing |

---

## Summary

| Category | Count |
|----------|-------|
| Total Tasks | 82 |
| Setup Tasks | 8 |
| Foundational Tasks | 6 |
| US1 Tasks | 6 |
| US2 Tasks | 10 |
| US3 Tasks | 10 |
| US4 Tasks | 9 |
| US5 Tasks | 14 |
| US6 Tasks | 8 |
| Polish Tasks | 11 |
| Parallelizable Tasks | 34 |

---

## Notes

- [P] tasks = different files, no dependencies on incomplete tasks in same phase
- [USn] label maps task to specific user story for traceability
- Each user story is independently completable and testable
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- All Arabic text uses existing AppTextStyles and Cairo font
- All new UI follows existing AppCard/GlassCard patterns
