# Feature Specification: Core Smart Finance Features

**Feature Branch**: `007-smart-finance-features`
**Created**: 2026-04-09
**Status**: Draft
**Input**: User description: "Core Smart Features for FlowSpend: Safe-to-Spend Dashboard, Envelope Budgeting System, Cash Flow Forecast, Smart Insights Engine, Smart Bill Reminders, and Transaction Tags"

---

## Overview

This specification covers six interconnected smart features that transform FlowSpend from a transaction tracker into an intelligent financial assistant. All features operate locally without internet, maintain privacy-first principles, and integrate with existing data (transactions, budgets, goals, wallets, installments, recurring transactions).

**Features Included**:
1. Safe-to-Spend Dashboard
2. Envelope Budgeting System
3. Cash Flow Forecast
4. Smart Insights Engine
5. Smart Bill Reminders
6. Transaction Tags

---

## User Scenarios & Testing

### User Story 1 - Safe-to-Spend Dashboard (Priority: P1)

As a user, I want to see a single "safe-to-spend" number on my Dashboard that shows how much money I can freely spend without affecting my upcoming obligations, so I can make confident spending decisions without manual calculations.

**Why this priority**: This is the core value proposition — replacing mental arithmetic with an instant answer to "can I afford this?" It uses existing data and provides immediate daily value.

**Independent Test**: Can be fully tested by adding sample transactions, installments, and recurring expenses, then verifying the Dashboard shows the correct safe-to-spend amount with appropriate color coding and spending velocity indicator.

**Acceptance Scenarios**:

1. **Given** a user has a total wallet balance of 10,000 EGP and upcoming obligations totaling 4,000 EGP, **When** they open the Dashboard, **Then** they see "تقدر تصرف" (You can spend) with 6,000 EGP displayed prominently in green (above 30% of balance).

2. **Given** a user's safe-to-spend is 500 EGP (5% of balance), **When** they open the Dashboard, **Then** the safe-to-spend displays in red with a warning indicator.

3. **Given** a user has spent more than the expected rate for this point in the month, **When** they view the Dashboard, **Then** the spending velocity indicator shows red with "معدل صرف عالي" label.

4. **Given** a user taps the safe-to-spend card, **When** it expands, **Then** they see a breakdown: total balance, minus installments, minus recurring expenses, minus goal contributions, equals safe-to-spend.

5. **Given** obligations exceed wallet balance, **When** user views Dashboard, **Then** safe-to-spend shows 0 EGP with a warning message.

---

### User Story 2 - Envelope Budgeting System (Priority: P2)

As a user, I want to divide my money into virtual envelopes for different spending categories, so I can see at a glance which budgets are full, getting low, or empty, and stop overspending in specific areas.

**Why this priority**: Envelope budgeting is a proven method that builds on the existing budget system. It provides tactile visual feedback that changes user behavior.

**Independent Test**: Can be tested by creating envelopes, allocating amounts, then adding transactions to see envelope balances decrease with visual fill indicators.

**Acceptance Scenarios**:

1. **Given** a user has envelope budgeting enabled, **When** they add income, **Then** they're prompted "عايز توزع الفلوس على الظروف؟" with quick allocation to existing envelopes.

2. **Given** an envelope has 60% remaining, **When** user views envelope screen, **Then** the card displays green with a visual fill indicator showing 60% full.

3. **Given** an envelope has 15% remaining, **When** user views envelope screen, **Then** the card displays red with urgent visual styling.

4. **Given** an envelope is empty (0%), **When** user views envelope screen, **Then** the card shows grey/empty with "خلص" badge.

5. **Given** user adds a transaction that would make an envelope negative, **When** they confirm, **Then** they see a warning: "ده هيخلي ظرف [name] يتعدى بـ [amount]. متأكد؟"

6. **Given** a new month begins and rollover is enabled on an envelope, **When** the system processes month rollover, **Then** unspent amounts from last month are added to this month's allocation.

---

### User Story 3 - Transaction Tags (Priority: P3)

As a user, I want to add custom tags to any transaction (like "رمضان", "فرح أحمد", "سفر"), so I can track spending for specific events, projects, or trips beyond my regular categories.

**Why this priority**: Tags are relatively simple to implement, highly requested for event tracking, and don't depend on other new features.

**Independent Test**: Can be tested by adding tags to transactions, then viewing the tag analytics screen to see totals per tag.

**Acceptance Scenarios**:

1. **Given** user is adding a transaction, **When** they type a tag name, **Then** they see autocomplete suggestions from previously used tags sorted by frequency.

2. **Given** user has tagged multiple transactions with "فرح", **When** they view Tag Analytics, **Then** they see total amount spent under that tag with a list of all tagged transactions.

3. **Given** user wants to filter transactions, **When** they select tag filter "رمضان", **Then** only transactions with that tag are displayed.

4. **Given** user renames a tag from "سفر" to "سفر مرسى مطروح", **When** confirmed, **Then** all transactions with the old tag name are updated to the new name.

---

### User Story 4 - Cash Flow Forecast (Priority: P4)

As a user, I want to see a 30-day forecast of my financial position based on my patterns, so I can anticipate when I might run low on money and plan ahead.

**Why this priority**: Requires historical data to be useful but provides significant planning value. Depends on having accurate recurring transaction data.

**Independent Test**: Can be tested with sample historical data to verify forecast chart displays correctly with three scenarios and event markers.

**Acceptance Scenarios**:

1. **Given** user has 3 months of transaction history, **When** they view Forecast screen, **Then** they see a line chart with optimistic (green), realistic (solid), and pessimistic (red) scenario lines.

2. **Given** an installment is due in 5 days, **When** user views Forecast, **Then** that day is marked with a red dot labeled with the installment name and amount.

3. **Given** the pessimistic scenario shows balance going negative on day 20, **When** user views Forecast, **Then** they see a warning: "تنبيه: ممكن الرصيد يكون سالب يوم [date] لو المصاريف كانت عالية"

4. **Given** user taps the assumptions card, **When** it expands, **Then** they see average daily spending, list of recurring transactions, and installments included in the calculation.

---

### User Story 5 - Smart Insights Engine (Priority: P5)

As a user, I want to receive personalized insights about my spending patterns (spikes, opportunities, streaks), so I can make better financial decisions without analyzing charts myself.

**Why this priority**: Insights are powerful but require sufficient transaction history to generate meaningful observations. Best implemented after core features are stable.

**Independent Test**: Can be tested by seeding data with specific patterns (e.g., category spike) and verifying the corresponding insight is generated.

**Acceptance Scenarios**:

1. **Given** food category spending is 50% above 3-month average, **When** insights are generated, **Then** a high-priority insight appears: "مصاريف أكل زادت — أعلى من المعتاد بنسبة 50%"

2. **Given** user has logged transactions every day for 10 days, **When** insights are generated, **Then** they see: "ممتاز! بتسجل مصاريفك كل يوم من 10 أيام — استمر كده"

3. **Given** user dismisses an insight by swiping, **When** they view Dashboard later, **Then** that insight does not reappear for the current month.

4. **Given** this month's spending is less than last month, **When** insights are generated, **Then** user sees: "مبروك! مصاريفك الشهر ده أقل من الشهر اللي فات بـ [amount] جنيه"

---

### User Story 6 - Smart Bill Reminders (Priority: P6)

As a user, I want bill reminders that tell me not just "bill is due tomorrow" but also whether I'm covered or might be short, so I can take action before problems occur.

**Why this priority**: Builds on Safe-to-Spend and Envelope features. Requires those to be functional for full context awareness.

**Independent Test**: Can be tested by creating a recurring bill, adjusting wallet balance, and verifying reminder messages match the coverage context.

**Acceptance Scenarios**:

1. **Given** a bill is due tomorrow and envelope has sufficient funds with 500 EGP remaining after, **When** reminder is sent, **Then** message is: "فاتورة [name] بكره — [amount] جنيه. الظرف مغطي وفاضل 500 بعدها."

2. **Given** a bill is due tomorrow and envelope is insufficient but wallet can cover, **When** reminder is sent, **Then** message offers to transfer between envelopes.

3. **Given** a bill is due tomorrow and no funds anywhere, **When** reminder is sent, **Then** message is urgent: "تنبيه مهم: فاتورة [name] بكره — [amount] جنيه. الرصيد الحالي مش كافي."

4. **Given** user views the bill calendar, **When** they tap a day with bills, **Then** they see list of bills due with amounts and color-coded coverage status (green/yellow/red).

---

### Edge Cases

- What happens when user has no transactions yet? → Safe-to-spend equals total balance; insights show onboarding tips instead
- What happens when all wallets are empty? → Safe-to-spend shows 0 with appropriate messaging
- What happens when a transaction is deleted that was part of envelope spending? → Envelope remaining recalculates immediately
- How does system handle a tag with special characters or emojis? → Tags support Unicode including Arabic and emojis
- What happens when forecast has no historical data? → Show message explaining 3 months of data needed for accurate forecasting; display basic projection using only known recurring items
- What happens when user disables envelope system after using it? → Existing envelopes are preserved but hidden; budget system becomes active; re-enabling shows previous envelopes
- How does system handle mid-month salary vs month-start salary? → Envelope allocation prompt triggers on any income transaction regardless of date

---

## Requirements

### Functional Requirements

**Safe-to-Spend**:
- **FR-001**: System MUST calculate safe-to-spend as total wallet balance minus (upcoming installments + upcoming recurring expenses + unmet goal contributions)
- **FR-002**: System MUST display safe-to-spend prominently on Dashboard with Arabic label "تقدر تصرف"
- **FR-003**: System MUST color-code safe-to-spend: green (>30% of balance), yellow (10-30%), red (<10%)
- **FR-004**: System MUST show spending velocity indicator with three states: high/normal/low spending rate
- **FR-005**: System MUST allow tapping safe-to-spend card to expand detailed breakdown
- **FR-006**: System MUST recalculate safe-to-spend when any relevant data changes (transactions, installments, recurring, goals)

**Envelope Budgeting**:
- **FR-007**: System MUST support creating envelopes with: name, allocated amount, icon, color, essential flag, rollover flag
- **FR-008**: System MUST track envelope spending by linking transactions to categories mapped to envelopes
- **FR-009**: System MUST display visual fill indicator on each envelope card showing percentage remaining
- **FR-010**: System MUST color-code envelopes: green (>50%), yellow (20-50%), red (<20%), grey (0%)
- **FR-011**: System MUST prompt user to allocate income to envelopes when income transaction is added
- **FR-012**: System MUST warn user when transaction would make an envelope go negative
- **FR-013**: System MUST send notifications when envelope reaches 20% or 0%
- **FR-014**: System MUST support monthly rollover of unspent amounts for envelopes with rollover enabled
- **FR-015**: System MUST allow enabling/disabling envelope system in Settings

**Transaction Tags**:
- **FR-016**: System MUST allow adding multiple tags to any transaction
- **FR-017**: System MUST provide autocomplete suggestions when typing tags, sorted by frequency
- **FR-018**: System MUST display tags as colored chips on transaction list and detail views
- **FR-019**: System MUST allow filtering transactions by one or more tags
- **FR-020**: System MUST provide tag analytics screen showing total spent per tag
- **FR-021**: System MUST allow renaming a tag (updates all transactions with that tag)
- **FR-022**: System MUST allow deleting a tag (removes tag from all transactions)
- **FR-023**: System MUST show 5 most recently used tags as quick-tap suggestions when adding transaction

**Cash Flow Forecast**:
- **FR-024**: System MUST generate 30-day forecast starting from current balance
- **FR-025**: System MUST show three scenarios: optimistic (lowest spending pattern), realistic (average), pessimistic (highest spending pattern)
- **FR-026**: System MUST mark known events on forecast chart: installments (red), income (green), bills (orange)
- **FR-027**: System MUST warn if any scenario shows balance going negative
- **FR-028**: System MUST show summary: expected month-end balance, next obligation, safety days
- **FR-029**: System MUST display expandable assumptions card explaining calculation inputs

**Smart Insights**:
- **FR-030**: System MUST detect and generate spending spike insights (category >30% above 3-month average)
- **FR-031**: System MUST detect and generate savings opportunity insights for consistently high discretionary categories
- **FR-032**: System MUST detect and generate streak recognition insights (7+ consecutive days logging)
- **FR-033**: System MUST detect and generate day pattern insights (highest spending day of week)
- **FR-034**: System MUST detect and generate category shift insights (growing category month-over-month)
- **FR-035**: System MUST detect and generate goal progress insights with projected completion date
- **FR-036**: System MUST generate monthly summary insights at start of new month
- **FR-037**: System MUST detect and generate unusual transaction insights (>3x category average)
- **FR-038**: System MUST detect and generate positive reinforcement insights (spending down vs last month)
- **FR-039**: System MUST display top 2-3 insights on Dashboard with swipe-to-dismiss
- **FR-040**: System MUST provide dedicated Insights screen with grouping and filtering

**Smart Bill Reminders**:
- **FR-041**: System MUST check coverage status (envelope or wallet) for each upcoming bill
- **FR-042**: System MUST generate contextual reminder messages in four tones: comfortable, tight, need-transfer, critical
- **FR-043**: System MUST send reminders at three points: 3 days before, 1 day before, on due date
- **FR-044**: System MUST display bill calendar view with color-coded coverage dots per day
- **FR-045**: System MUST include predicted bills (from SMS detection) in calendar with distinct styling

---

### Key Entities

- **SafeToSpendData**: Calculated amount, breakdown items (installments, recurring, goals), velocity status, percentage of balance
- **Envelope**: Name (Arabic), allocated amount, icon name, color, is essential flag, rollover enabled flag, month/year
- **TransactionTag**: Name (Arabic), usage count, last used date, assigned color
- **ForecastDay**: Date, projected balance (optimistic/realistic/pessimistic), events list
- **Insight**: Type, title (Arabic), description (Arabic), priority score, icon, color, action, dismissed flag, generation hash
- **BillReminder**: Bill reference, due date, expected amount, coverage status, reminder stage, message content

---

## Success Criteria

### Measurable Outcomes

- **SC-001**: Users can see their safe-to-spend amount within 1 second of opening the Dashboard
- **SC-002**: 80% of users with active envelopes stay within their allocated amounts (measured by envelope overage rate)
- **SC-003**: Users can add tags to a transaction in under 3 taps
- **SC-004**: Users can find total spending for any tag within 10 seconds
- **SC-005**: Forecast calculations complete within 2 seconds for users with 12 months of transaction history
- **SC-006**: System generates at least 2 relevant insights per week for active users
- **SC-007**: Users receive contextual bill reminders 3 days before each due date
- **SC-008**: 90% of bill coverage assessments are accurate (tested by comparing prediction to actual available funds)

---

## Assumptions

- Users have existing transaction history for insights and forecasting to be meaningful (at least 1 month for basic, 3 months for full accuracy)
- Existing category system will map 1:1 to envelopes when envelope budgeting is enabled
- The existing notification service supports scheduling reminders at specific times
- All monetary displays use EGP currency via existing CurrencyFormatter
- Safe-to-spend calculation runs client-side with acceptable performance for typical data volumes (up to 10,000 transactions)
- Tags are free-form text without hierarchy or nesting
- Envelope allocations are manual — no automatic allocation from income unless user confirms
- SMS detection patterns (from existing feature) are reliable enough to include predicted bills in the calendar
- The existing fl_chart package will be used for forecast visualization
- Dark and light theme variants are required for all new UI components
