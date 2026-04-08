# Feature Specification: Enhanced Reports with Comprehensive Analytics

**Feature Branch**: `003-enhance-reports-details`
**Created**: 2026-04-08
**Status**: Draft
**Input**: User description: "I need to enhance all reports add more details for reports"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - View Comprehensive Spending Trends (Priority: P1)

As a user tracking my finances, I want to see detailed spending trends over time so I can understand my financial patterns and make better decisions.

**Why this priority**: Understanding spending patterns over time is the core value of enhanced reports - it transforms raw transaction data into actionable insights.

**Independent Test**: Can be fully tested by viewing the enhanced expenses report tab with historical data and verifying trend visualizations display correctly.

**Acceptance Scenarios**:

1. **Given** I have transactions from the past 3+ months, **When** I view the expenses report, **Then** I see a trend chart showing monthly spending patterns with clear month labels.
2. **Given** I am viewing spending trends, **When** I tap on a specific month in the chart, **Then** I see a breakdown of that month's expenses by category.
3. **Given** I have current month data, **When** I view the expenses report, **Then** I see comparison indicators showing if spending is up or down versus previous month (with percentage).

---

### User Story 2 - Analyze Income vs Expenses Balance (Priority: P1)

As a user managing my finances, I want to see my income versus expenses balance clearly so I can understand my net financial position each month.

**Why this priority**: Net balance (income minus expenses) is fundamental to personal finance tracking and helps users understand if they're saving or overspending.

**Independent Test**: Can be fully tested by adding both income and expense transactions, then verifying the balance summary displays correctly with visual indicators.

**Acceptance Scenarios**:

1. **Given** I have both income and expense transactions, **When** I view the expenses report, **Then** I see a summary showing total income, total expenses, and net balance with color-coded indicators (green for surplus, red for deficit).
2. **Given** I have a positive net balance, **When** I view the monthly summary, **Then** the savings rate percentage is displayed.
3. **Given** I have no income recorded, **When** I view the balance summary, **Then** the income shows as zero and the report still functions correctly.

---

### User Story 3 - Track Budget Performance (Priority: P2)

As a user with budgets set, I want to see how I'm performing against my budgets in the reports so I can identify areas where I'm overspending.

**Why this priority**: Budget tracking provides actionable guidance for spending behavior and connects existing budget data to reports for a unified view.

**Independent Test**: Can be fully tested by creating budgets, adding expenses in those categories, then verifying budget vs actual comparisons display correctly.

**Acceptance Scenarios**:

1. **Given** I have active budgets, **When** I view the expenses report, **Then** I see a budget performance section showing each budget's limit, actual spending, and percentage used.
2. **Given** I have exceeded a budget limit, **When** I view budget performance, **Then** that budget is highlighted with a warning indicator and shows the overage amount.
3. **Given** I have no budgets set, **When** I view the expenses report, **Then** the budget section displays a prompt to create budgets (not an error).

---

### User Story 4 - View Enhanced Installment Analytics (Priority: P2)

As a user with installment plans, I want detailed analytics about my installment obligations so I can plan for future payments and understand total interest costs.

**Why this priority**: Installment tracking is a key differentiator of the app, and enhanced analytics help users understand the true cost of their installment purchases.

**Independent Test**: Can be fully tested by creating installment plans and verifying the enhanced installment report shows all required metrics.

**Acceptance Scenarios**:

1. **Given** I have active installments, **When** I view the installments report, **Then** I see a timeline showing upcoming payments for the next 3 months.
2. **Given** I have multiple installments, **When** I view the report, **Then** I see total monthly commitment amount and a projection of when all installments will be paid off.
3. **Given** I have completed installments, **When** I view the report, **Then** I see historical data showing total interest paid over all time.

---

### User Story 5 - View Wallet Distribution Report (Priority: P3)

As a user with multiple wallets, I want to see how my money is distributed across wallets so I can manage my accounts effectively.

**Why this priority**: Wallet distribution gives a complete picture of where funds are located but is secondary to spending analysis.

**Independent Test**: Can be fully tested by having multiple wallets with balances and verifying the distribution visualization displays correctly.

**Acceptance Scenarios**:

1. **Given** I have multiple wallets, **When** I view reports, **Then** I see a section showing balance distribution across wallets with percentages.
2. **Given** I view wallet distribution, **When** I look at the breakdown, **Then** each wallet shows its type (cash, bank, e-wallet) with appropriate icons.

---

### User Story 6 - View Transaction Source Analysis (Priority: P3)

As a user, I want to see where my transactions come from (manual, SMS, recurring, installment) so I can understand my data sources and automation effectiveness.

**Why this priority**: Source analysis helps users understand how much of their tracking is automated vs manual, useful for power users but not essential.

**Independent Test**: Can be fully tested by having transactions from different sources and verifying the source breakdown displays correctly.

**Acceptance Scenarios**:

1. **Given** I have transactions from multiple sources, **When** I view the expenses report, **Then** I see a source breakdown showing count and amount by source type.
2. **Given** I have SMS-detected transactions, **When** I view source analysis, **Then** I see how much of my expense tracking is automated.

---

### Edge Cases

- What happens when there is no data for the selected month? → Show empty state with helpful message encouraging user to add transactions.
- How does the system handle months with only income or only expenses? → Display available data, show zero for missing type with appropriate formatting.
- What happens when viewing reports with very large amounts? → Currency formatting handles large numbers gracefully without overflow.
- How does the system handle incomplete installment data? → Skip incomplete records, show available data with accurate totals.
- What happens when budgets exist but have no matching expense categories? → Show budget at 0% used with full limit available.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST display a month-over-month spending trend chart showing at least the last 6 months of expense data.
- **FR-002**: System MUST show income vs expense summary with total income, total expenses, net balance, and savings rate percentage.
- **FR-003**: System MUST display category-wise expense comparison between current and previous month with percentage change indicators.
- **FR-004**: System MUST show budget performance for all active budgets including limit, actual spending, percentage used, and remaining amount.
- **FR-005**: System MUST highlight budgets that have exceeded their limit with visual warning indicators.
- **FR-006**: System MUST display a payment timeline showing upcoming installment payments for the next 3 months.
- **FR-007**: System MUST calculate and display total monthly installment commitment amount.
- **FR-008**: System MUST show projected payoff date for all installments (when the last installment will be completed).
- **FR-009**: System MUST display wallet balance distribution with percentages and wallet type indicators.
- **FR-010**: System MUST show transaction source breakdown (manual, SMS, recurring, installment) with counts and amounts.
- **FR-011**: System MUST maintain the existing tab structure (expenses, installments) while adding new report sections within each tab.
- **FR-012**: System MUST allow users to navigate to detailed views by tapping on summary items (e.g., tap category to see transactions).
- **FR-013**: System MUST display daily, weekly, and monthly spending averages in the expenses report.
- **FR-014**: System MUST show top spending categories with ranking and amount.
- **FR-015**: System MUST display interest analysis showing total interest paid and interest as percentage of total installment costs.

### Key Entities

- **Transaction**: Financial movement (income/expense) with amount, category, date, source, and optional merchant.
- **Budget**: Spending limit per category with period (monthly/weekly) and active status.
- **InstallmentPlan**: Debt obligation with payment schedule, provider, interest details, and progress tracking.
- **Wallet**: Account container (cash/bank/e-wallet) with balance and identification.
- **Category**: Classification for transactions with name, icon, and color.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can view their spending trends for the past 6 months within 2 seconds of opening the reports screen.
- **SC-002**: Users can identify their top 3 spending categories at a glance without scrolling.
- **SC-003**: Users can determine if they are over or under budget in each category with a single view.
- **SC-004**: Users can see their total installment obligations and next payment date within the installments report tab.
- **SC-005**: Users can understand their net financial position (income vs expenses) with clear visual indicators.
- **SC-006**: All report data displays correctly in RTL layout for Arabic users.
- **SC-007**: Reports remain readable and functional on various screen sizes without horizontal scrolling.

## Assumptions

- Users have existing transaction data to populate reports; new users see appropriate empty states with guidance.
- The existing pie chart widgets (CategoryPieChart, InstallmentPieChart) will be reused and extended as needed.
- Month selection uses the existing selectedMonthProvider for consistency with other screens.
- Performance is acceptable with typical user data volumes (up to 1000 transactions per month).
- The existing dark theme styling (AppColors, AppTextStyles) applies to all new report components.
- Currency formatting uses existing CurrencyFormatter (EGP) throughout.
- All new report sections scroll within the existing SingleChildScrollView pattern.
