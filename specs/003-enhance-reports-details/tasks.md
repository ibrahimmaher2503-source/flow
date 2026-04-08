# Tasks: Enhanced Reports with Comprehensive Analytics

**Input**: Design documents from `/specs/003-enhance-reports-details/`
**Prerequisites**: plan.md (required), spec.md (required for user stories)

**Status**: ✅ IMPLEMENTATION COMPLETE

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Flutter Mobile App**: `lib/` for source, `test/` for tests
- Feature-based structure: `lib/features/reports/` for reports components

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create foundational providers and utility functions needed by all report sections

- [x] T001 Create reports calculation utility functions in lib/core/utils/report_calculations.dart
- [x] T002 Create multi-month transaction query method `getByMonthRange` in lib/data/repositories/transaction_repo.dart
- [x] T003 [P] Create reports data provider file in lib/providers/reports_provider.dart

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core providers and data structures that MUST be complete before ANY user story can be implemented

**CRITICAL**: No user story work can begin until this phase is complete

- [x] T004 Implement `multiMonthTransactionsProvider` (last 6 months) in lib/providers/reports_provider.dart
- [x] T005 Implement `monthlyTotalsProvider` returning income/expense by month in lib/providers/reports_provider.dart
- [x] T006 [P] Create empty state widget for reports with helpful message in lib/features/reports/widgets/report_empty_state.dart
- [x] T007 [P] Create section header widget for report sections in lib/features/reports/widgets/report_section_header.dart

**Checkpoint**: ✅ Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - View Comprehensive Spending Trends (Priority: P1)

**Goal**: Display detailed spending trends over time with monthly patterns and comparison indicators

**Independent Test**: View the enhanced expenses report tab with historical data and verify trend visualizations display correctly with month labels and comparison percentages.

### Implementation for User Story 1

- [x] T008 [US1] Add spending trend calculation functions (monthlyTrend, percentageChange) in lib/core/utils/report_calculations.dart
- [x] T009 [US1] Implement `spendingTrendProvider` using multiMonthTransactionsProvider in lib/providers/reports_provider.dart
- [x] T010 [P] [US1] Create spending trend section widget using TrendLineChart in lib/features/reports/widgets/spending_trend_section.dart
- [x] T011 [P] [US1] Create spending averages widget (daily/weekly/monthly) in lib/features/reports/widgets/spending_averages.dart
- [x] T012 [P] [US1] Create category comparison widget (current vs previous month with %) in lib/features/reports/widgets/category_comparison.dart
- [x] T013 [P] [US1] Create top spending categories widget with ranking in lib/features/reports/widgets/top_categories.dart
- [x] T014 [US1] Integrate US1 widgets into _GeneralReportTab in lib/features/reports/reports_screen.dart

**Checkpoint**: ✅ Spending trends, averages, category comparison, and top categories visible in expenses tab

---

## Phase 4: User Story 2 - Analyze Income vs Expenses Balance (Priority: P1)

**Goal**: Display income vs expense summary with net balance and savings rate

**Independent Test**: Add both income and expense transactions, then verify balance summary displays correctly with color-coded indicators (green/red).

### Implementation for User Story 2

- [x] T015 [US2] Add balance calculation functions (netBalance, savingsRate) in lib/core/utils/report_calculations.dart
- [x] T016 [US2] Implement `incomeExpenseBalanceProvider` in lib/providers/reports_provider.dart
- [x] T017 [P] [US2] Create income vs expense summary widget with color indicators in lib/features/reports/widgets/income_expense_summary.dart
- [x] T018 [US2] Integrate income/expense summary into _GeneralReportTab (top of screen) in lib/features/reports/reports_screen.dart

**Checkpoint**: ✅ Income vs expense balance with savings rate visible at top of expenses tab

---

## Phase 5: User Story 3 - Track Budget Performance (Priority: P2)

**Goal**: Show budget vs actual spending with warning indicators for exceeded budgets

**Independent Test**: Create budgets, add expenses in those categories, verify budget vs actual comparisons display with percentage used and warning highlights.

### Implementation for User Story 3

- [x] T019 [US3] Add budget performance calculation functions (percentUsed, overage, remaining) in lib/core/utils/report_calculations.dart
- [x] T020 [US3] Implement `budgetPerformanceProvider` combining budgets with expense totals in lib/providers/reports_provider.dart
- [x] T021 [P] [US3] Create budget performance card widget showing limit/actual/percentage in lib/features/reports/widgets/budget_performance_card.dart
- [x] T022 [P] [US3] Create budget performance section widget with list of cards in lib/features/reports/widgets/budget_performance_section.dart
- [x] T023 [US3] Integrate budget performance section into _GeneralReportTab in lib/features/reports/reports_screen.dart

**Checkpoint**: ✅ Budget performance section visible in expenses tab with warning indicators for exceeded budgets

---

## Phase 6: User Story 4 - View Enhanced Installment Analytics (Priority: P2)

**Goal**: Detailed installment analytics with payment timeline, monthly commitment, and projected payoff

**Independent Test**: Create installment plans and verify the enhanced installment report shows timeline, monthly commitment, and interest analysis.

### Implementation for User Story 4

- [x] T024 [US4] Add `getUpcomingPayments(months)` method returning next N months payments in lib/data/services/installment_service.dart
- [x] T025 [US4] Add `getProjectedPayoffDate()` method returning final payment date in lib/data/services/installment_service.dart
- [x] T026 [US4] Add `getInterestAnalysis()` method returning total interest and percentage in lib/data/services/installment_service.dart
- [x] T027 [US4] Implement `upcomingPaymentsProvider` in lib/providers/reports_provider.dart
- [x] T028 [US4] Implement `installmentSummaryProvider` (monthly commitment, payoff date) in lib/providers/reports_provider.dart
- [x] T029 [P] [US4] Create payment timeline widget showing next 3 months in lib/features/reports/widgets/payment_timeline.dart
- [x] T030 [P] [US4] Create installment summary widget (monthly total, payoff date) in lib/features/reports/widgets/installment_summary.dart
- [x] T031 [P] [US4] Create interest analysis widget (total paid, percentage of total) in lib/features/reports/widgets/interest_analysis.dart
- [x] T032 [US4] Integrate US4 widgets into _InstallmentReportTab in lib/features/reports/reports_screen.dart

**Checkpoint**: ✅ Installment tab shows payment timeline, monthly commitment, payoff projection, and interest analysis

---

## Phase 7: User Story 5 - View Wallet Distribution Report (Priority: P3)

**Goal**: Show how money is distributed across wallets with percentages and type indicators

**Independent Test**: Have multiple wallets with balances and verify the distribution visualization displays correctly with percentages.

### Implementation for User Story 5

- [x] T033 [US5] Add wallet distribution calculation functions (percentages, typeGrouping) in lib/core/utils/report_calculations.dart
- [x] T034 [US5] Implement `walletDistributionProvider` in lib/providers/reports_provider.dart
- [x] T035 [P] [US5] Create wallet distribution widget with pie chart and list in lib/features/reports/widgets/wallet_distribution.dart
- [x] T036 [US5] Integrate wallet distribution section into _GeneralReportTab in lib/features/reports/reports_screen.dart

**Checkpoint**: ✅ Wallet distribution section visible in expenses tab with percentages and wallet type icons

---

## Phase 8: User Story 6 - View Transaction Source Analysis (Priority: P3)

**Goal**: Show transaction source breakdown (manual, SMS, recurring, installment) with counts and amounts

**Independent Test**: Have transactions from different sources and verify the source breakdown displays correctly.

### Implementation for User Story 6

- [x] T037 [US6] Add source breakdown calculation functions (countBySource, amountBySource) in lib/core/utils/report_calculations.dart
- [x] T038 [US6] Implement `sourceBreakdownProvider` in lib/providers/reports_provider.dart
- [x] T039 [P] [US6] Create source breakdown widget showing count and amount by source in lib/features/reports/widgets/source_breakdown.dart
- [x] T040 [US6] Integrate source breakdown section into _GeneralReportTab in lib/features/reports/reports_screen.dart

**Checkpoint**: ✅ Source analysis section visible showing automation effectiveness

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [x] T041 [P] Add tap navigation from summary items to detailed views in lib/features/reports/reports_screen.dart
- [x] T042 [P] Ensure all new widgets support RTL layout correctly in lib/features/reports/widgets/
- [x] T043 [P] Verify large currency amounts display without overflow in all report widgets
- [x] T044 Add loading shimmer states for async report sections in lib/features/reports/reports_screen.dart
- [x] T045 Optimize provider dependencies to prevent unnecessary rebuilds in lib/providers/reports_provider.dart
- [ ] T046 Verify 2-second load time target with 1000 transactions (requires manual testing)

---

## Summary

| Phase | Tasks | Status |
|-------|-------|--------|
| Setup | T001-T003 | ✅ Complete |
| Foundational | T004-T007 | ✅ Complete |
| US1 | T008-T014 | ✅ Complete |
| US2 | T015-T018 | ✅ Complete |
| US3 | T019-T023 | ✅ Complete |
| US4 | T024-T032 | ✅ Complete |
| US5 | T033-T036 | ✅ Complete |
| US6 | T037-T040 | ✅ Complete |
| Polish | T041-T046 | 🟡 5/6 (needs perf test) |

**Total Tasks**: 46
**Completed**: 45/46 (98%)
**Remaining**: 1 manual performance test
