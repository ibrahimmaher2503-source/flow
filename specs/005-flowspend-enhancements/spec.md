# Feature Specification: FlowSpend Enhancement Features

**Feature Branch**: `005-flowspend-enhancements`
**Created**: 2026-04-08
**Status**: Draft
**Input**: User description: "8 enhancement features for FlowSpend including AI auto-categorization, data export, recurring detection, home widget, enhanced onboarding, month comparison, daily spending limits, and gamification enhancements"

---

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Auto-Categorization of Transactions (Priority: P1)

When a user adds a transaction (manually or via SMS), the app automatically suggests the appropriate category based on the transaction description or merchant name. This is done entirely on-device without internet.

**Why this priority**: Foundation feature that enhances user experience across all transaction entry points. Reduces friction and improves accuracy of financial data. Other features (recurring detection, export) benefit from accurate categorization.

**Independent Test**: Can be fully tested by entering a transaction with a known merchant name (e.g., "ماكدونالدز") and verifying the correct category (Food & Drinks) is suggested. Delivers immediate value by reducing manual categorization effort.

**Acceptance Scenarios**:

1. **Given** a user is adding a transaction with description "شراء من كارفور", **When** they enter the description, **Then** the system suggests "سوبرماركت" (Grocery) category within 500ms
2. **Given** a user receives an SMS from a bank mentioning "فودافون", **When** the SMS is parsed, **Then** the system auto-fills "اتصالات" (Telecom) category with "تصنيف تلقائي" indicator
3. **Given** a user changes a suggested category from "طعام ومشروبات" to "ترفيه", **When** they save the transaction, **Then** the system learns this mapping for future similar descriptions
4. **Given** a user has previously corrected "Netflix" to "ترفيه" twice, **When** a new transaction mentions Netflix, **Then** the learned mapping takes priority over built-in keywords

---

### User Story 2 - Data Export (CSV and PDF) (Priority: P1)

Users can export their monthly transaction data as a CSV file (for spreadsheet analysis) or a formatted PDF report with summaries and visualizations.

**Why this priority**: High user value feature that enables users to analyze their finances outside the app, share data with accountants, or keep offline records. Independent of other features.

**Independent Test**: Can be fully tested by selecting a month, choosing export format, and verifying the exported file contains correct transaction data with Arabic headers and proper formatting.

**Acceptance Scenarios**:

1. **Given** a user has transactions for April 2026, **When** they select April and choose CSV export, **Then** the system generates a file named "FlowSpend_2026-04_transactions.csv" with Arabic headers and UTF-8 BOM
2. **Given** a user selects PDF export for a month with 50 transactions, **When** export completes, **Then** the PDF contains a header, summary box with totals, transaction table, category breakdown chart, and footer in RTL Arabic
3. **Given** a user applies filters (category: Food, wallet: Cash), **When** they export, **Then** only filtered transactions appear in the export with matching totals
4. **Given** a user taps "تصدير ومشاركة", **When** the file is ready, **Then** the system share sheet opens allowing the user to share via any app

---

### User Story 3 - Month-over-Month Comparison (Priority: P2)

Users can view a comparison between the current month and previous month in the Reports screen, highlighting spending changes and trends.

**Why this priority**: Builds on existing reports infrastructure. Provides valuable insights for budgeting decisions. Medium complexity with high user value.

**Independent Test**: Can be fully tested by navigating to Reports, viewing the comparison section with two months of data, and verifying accurate calculations of differences and trends.

**Acceptance Scenarios**:

1. **Given** a user has transactions in March and April 2026, **When** they view the comparison, **Then** they see side-by-side cards showing totals for each month with green/red arrows indicating direction
2. **Given** spending in "طعام ومشروبات" increased 40% from last month, **When** viewing change highlights, **Then** the user sees "زادت: طعام ومشروبات بنسبة 40%"
3. **Given** a category "ترفيه" had spending last month but none this month, **When** viewing highlights, **Then** the user sees this category listed as dropped
4. **Given** both months have daily spending data, **When** viewing the trend chart, **Then** the user sees two overlaid lines (solid for current, dashed for previous) showing cumulative daily spending

---

### User Story 4 - Daily Spending Limit with Alerts (Priority: P2)

Users can set a daily spending limit and receive notifications when approaching or exceeding it.

**Why this priority**: Uses existing notification infrastructure. Provides immediate behavior-change value. Helps users maintain financial discipline.

**Independent Test**: Can be fully tested by setting a daily limit, adding transactions that approach/exceed it, and verifying notifications appear at correct thresholds.

**Acceptance Scenarios**:

1. **Given** a user sets daily limit to 500 EGP with 80% warning threshold, **When** they add transactions totaling 400 EGP, **Then** they receive notification "تنبيه: وصلت لـ 80% من حد مصاريفك اليومي"
2. **Given** a user has exceeded their 500 EGP limit by adding 550 EGP in spending, **When** the limit is exceeded, **Then** they receive notification "تجاوزت حد المصاريف اليومي! المصروفات: 550 / الحد: 500"
3. **Given** a user has excluded "فواتير" category from limit tracking, **When** they pay a 1000 EGP bill, **Then** this amount does not count toward the daily limit
4. **Given** daily limit feature is enabled, **When** user views Dashboard, **Then** a progress indicator shows current spending vs limit with color coding (green/yellow/orange/red)

---

### User Story 5 - Recurring Transaction Detection (Priority: P2)

The app analyzes transaction history to find spending patterns that repeat regularly and suggests converting them to recurring transactions.

**Why this priority**: Depends on auto-categorization for category suggestions. Reduces manual entry effort for subscriptions and bills. Medium complexity.

**Independent Test**: Can be fully tested by having 3+ similar transactions with monthly intervals, triggering detection, and verifying the suggestion appears with correct frequency and amount.

**Acceptance Scenarios**:

1. **Given** a user has paid "Netflix" 150 EGP on the 15th of each month for 3 months, **When** detection runs, **Then** a suggestion appears with description "Netflix", frequency "كل شهر", amount "~150 جنيه", and high confidence (green dot)
2. **Given** a detected pattern is shown, **When** user taps accept, **Then** a bottom sheet appears with pre-filled recurring transaction form (description, amount, category, frequency, next occurrence date)
3. **Given** a user dismisses a suggestion, **When** 3+ more matching transactions occur after dismissal, **Then** the suggestion re-appears
4. **Given** detection finds patterns with confidence below 0.4, **When** viewing suggestions, **Then** low-confidence patterns are not shown

---

### User Story 6 - Enhanced Onboarding (Priority: P3)

First-time users experience an interactive walkthrough explaining app features, privacy promises, and SMS permission with trust-building messaging.

**Why this priority**: Important for user retention but can be done after core features are complete. Affects first impression and SMS permission acceptance rate.

**Independent Test**: Can be fully tested by clearing app data, launching the app fresh, and verifying all 5 onboarding screens appear with correct content, navigation, and the final screen leads to Dashboard.

**Acceptance Scenarios**:

1. **Given** a new user launches the app for first time, **When** the app opens, **Then** they see the welcome screen with "أهلاً بيك في FlowSpend" and can swipe through 5 screens
2. **Given** user is on the Privacy Promise screen, **When** viewing the content, **Then** they see three privacy points with icons emphasizing local-only data storage
3. **Given** user is on the SMS screen, **When** they tap the SMS permission button, **Then** system permission dialog appears; if they skip, they proceed without SMS functionality
4. **Given** user completes Quick Setup with wallet name and budget, **When** they tap "يلا نبدأ", **Then** onboarding is marked complete, settings are saved, and Dashboard appears
5. **Given** user has completed onboarding before, **When** they open the app, **Then** onboarding is skipped and Dashboard appears directly

---

### User Story 7 - Gamification Enhancements (Priority: P3)

Extended gamification with weekly challenges, spending heatmap visualization, and animated budget progress rings.

**Why this priority**: Polish features that enhance engagement. Multiple sub-features that can be implemented incrementally.

**Independent Test**: Each sub-feature can be tested independently - weekly challenge by completing a challenge and verifying points; heatmap by viewing a month with varied spending; progress rings by viewing budgets with different completion levels.

**Acceptance Scenarios**:

1. **Given** it's Monday and user has spending history, **When** a new challenge is generated, **Then** a relevant challenge appears on Dashboard (e.g., "وفّر 20% من مصاريفك الأسبوع ده") with progress bar and point reward
2. **Given** user completes a weekly challenge, **When** the challenge ends, **Then** celebration animation plays and finance score points are awarded
3. **Given** user views Reports screen with monthly spending data, **When** viewing the heatmap, **Then** each day is colored based on spending level (green=low, red=high) and tapping shows details
4. **Given** user views Budget screen with category budgets, **When** budgets load, **Then** animated circular rings show percentage spent, with over-budget rings turning red with overlay

---

### User Story 8 - Android Home Screen Widget (Priority: P3)

A home screen widget showing today's spending at a glance without opening the app.

**Why this priority**: Most complex native integration. Valuable convenience feature but requires significant platform-specific work.

**Independent Test**: Can be fully tested by adding the widget to home screen, adding transactions in the app, and verifying widget updates to show correct totals and recent transactions.

**Acceptance Scenarios**:

1. **Given** user adds the FlowSpend widget to their home screen, **When** widget loads, **Then** it shows "FlowSpend" title, today's spending total, "مصروفات اليوم" label, and last 2-3 transactions
2. **Given** user adds a new transaction in the app, **When** they return to home screen, **Then** widget reflects the updated spending total
3. **Given** system theme is dark mode, **When** viewing widget, **Then** widget uses dark background variant with app primary color accents
4. **Given** user taps anywhere on the widget, **When** tap is registered, **Then** the FlowSpend app opens

---

### Edge Cases

- What happens when no transactions exist for a selected export month? Show empty state with message, disable export button
- How does auto-categorization handle completely unknown merchants? Return no suggestion, let user select manually
- What happens if user has no previous month data for comparison? Show empty state for previous month with appropriate message
- How does recurring detection handle transactions with wildly varying amounts? Fail consistency check, don't suggest as recurring
- What happens if SMS permission is permanently denied? Hide SMS-related features, show settings redirect option
- What happens when daily limit is set to 0 or very low value? Enforce minimum limit (e.g., 10 EGP)
- How does widget handle when no transactions exist today? Show "0 جنيه" with "لا يوجد معاملات اليوم"
- What happens when challenge cannot be generated (no spending history)? Show default "log daily transactions" challenge

---

## Requirements *(mandatory)*

### Functional Requirements

**Auto-Categorization (Feature 1)**
- **FR-001**: System MUST provide a built-in keyword map covering Egyptian merchants, banks, and services in Arabic and English for 10+ categories
- **FR-002**: System MUST normalize input text (lowercase, trim whitespace) before matching
- **FR-003**: System MUST persist user category corrections as learned mappings with hit count and last used date
- **FR-004**: System MUST prioritize user-learned mappings over built-in keywords
- **FR-005**: System MUST calculate and return a confidence score based on keyword match ratio
- **FR-006**: System MUST display "تصنيف تلقائي" indicator when auto-categorization is applied
- **FR-007**: System MUST debounce category suggestions by 500ms when user types transaction description

**Data Export (Feature 2)**
- **FR-008**: System MUST generate CSV files with UTF-8 BOM and Arabic column headers (التاريخ, الوصف, الفئة, المحفظة, النوع, المبلغ)
- **FR-009**: System MUST include summary row in CSV with total income, expenses, and net balance
- **FR-010**: System MUST generate RTL Arabic PDF reports with header, summary, transaction table, category breakdown, and footer
- **FR-011**: System MUST use Arabic-supporting font in PDF generation
- **FR-012**: System MUST support filtering exports by category, wallet, and transaction type
- **FR-013**: System MUST display count of matching transactions before export
- **FR-014**: System MUST open system share sheet after file generation

**Month Comparison (Feature 6)**
- **FR-015**: System MUST calculate totals, category breakdowns, and daily cumulative sums for any two months
- **FR-016**: System MUST display percentage change for each category between months
- **FR-017**: System MUST identify categories that increased most, decreased most, or appeared/disappeared
- **FR-018**: System MUST display comparison charts using horizontal bars and overlaid line graphs

**Daily Spending Limit (Feature 7)**
- **FR-019**: System MUST allow users to set daily spending limit amount and warning threshold percentage
- **FR-020**: System MUST allow users to exclude specific categories from limit tracking
- **FR-021**: System MUST calculate today's spending excluding excluded categories after each transaction
- **FR-022**: System MUST send warning notification when threshold is reached (once per day)
- **FR-023**: System MUST send exceeded notification when limit is passed (once per day)
- **FR-024**: System MUST display spending progress indicator on Dashboard with color coding

**Recurring Detection (Feature 3)**
- **FR-025**: System MUST group transactions by normalized description (lowercase, trimmed, amounts/dates stripped)
- **FR-026**: System MUST detect daily, weekly, monthly, and yearly patterns based on interval analysis
- **FR-027**: System MUST calculate confidence score (0.5 base + 0.1 per occurrence up to 0.9, +0.1 for identical amounts)
- **FR-028**: System MUST only display suggestions with confidence above 0.4
- **FR-029**: System MUST mark dismissed patterns and re-surface after 3+ new matches
- **FR-030**: System MUST run detection on app startup and after SMS transaction confirmation
- **FR-031**: System MUST pre-fill recurring transaction form from detected pattern data

**Enhanced Onboarding (Feature 5)**
- **FR-032**: System MUST display 5 onboarding screens in sequence (Welcome, Privacy, SMS, Setup, Ready)
- **FR-033**: System MUST show skip button on every onboarding page
- **FR-034**: System MUST include SMS permission request with privacy messaging
- **FR-035**: System MUST allow users to create first wallet and set monthly budget target during setup
- **FR-036**: System MUST persist onboarding completion flag to prevent re-display

**Gamification Enhancements (Feature 8)**
- **FR-037**: System MUST generate relevant weekly challenge every Monday based on spending patterns
- **FR-038**: System MUST track challenge progress throughout the week and award points on completion
- **FR-039**: System MUST display spending heatmap with color-coded days (green to red gradient)
- **FR-040**: System MUST show day details (spending, transaction count, top category) on tap
- **FR-041**: System MUST display animated circular progress rings for category budgets
- **FR-042**: System MUST show over-budget state with red ring and overlay

**Home Screen Widget (Feature 4)**
- **FR-043**: Widget MUST display today's total spending, "مصروفات اليوم" label, and last 2-3 transactions
- **FR-044**: Widget MUST update when transactions change in the app
- **FR-045**: Widget MUST support both light and dark theme variants
- **FR-046**: Widget MUST open the app when tapped

### Key Entities

- **CategoryMapping**: Represents a user-learned mapping from description keyword to category, with hit count and last used timestamp
- **ExportConfiguration**: Represents user's export preferences including month, format (CSV/PDF), and applied filters
- **DetectedPattern**: Represents a recurring spending pattern with description, average amount, frequency, confidence score, status flags, and linked recurring transaction
- **WeeklyChallenge**: Represents a weekly challenge with type, description, target value, progress, dates, completion status, and reward points
- **DailyLimitSettings**: Represents user's daily limit configuration including amount, threshold percentage, and excluded categories
- **OnboardingProgress**: Represents the user's progress through onboarding screens and initial setup data

---

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users categorize transactions 60% faster with auto-suggestions compared to manual selection
- **SC-002**: Auto-categorization achieves 80% accuracy for common Egyptian merchants and services
- **SC-003**: Users can complete data export (select month, apply filters, generate file) in under 60 seconds
- **SC-004**: 95% of exported files open correctly in standard spreadsheet applications and PDF readers
- **SC-005**: Users understand spending trends within 10 seconds of viewing month comparison
- **SC-006**: 70% of users who set daily limits receive at least one meaningful alert per week
- **SC-007**: Recurring transaction detection identifies 80% of actual recurring payments with 3+ occurrences
- **SC-008**: 80% of users complete full onboarding flow (don't skip all screens)
- **SC-009**: SMS permission acceptance rate increases by 30% with new privacy-focused onboarding
- **SC-010**: 50% of users with widget installed check it at least once daily
- **SC-011**: Weekly challenge participation rate reaches 40% of active users
- **SC-012**: Users can complete all feature interactions using Arabic-only interface with RTL layout

---

## Assumptions

- Users have Android devices running Android 8.0+ (for widget and notification channel support)
- Arabic-supporting font is available in app assets for PDF generation
- Existing database schema can be extended with new collections without migration issues
- Users have sufficient device storage for PDF/CSV exports (typically < 1MB per export)
- Built-in keyword map will be manually curated with 200+ Egyptian merchant/service keywords
- SMS parsing service already exists and can trigger auto-categorization hooks
- Existing notification service supports creating additional notification channels
- Chart library is already available or can be added for comparison visualizations
- Widget package is compatible with current project version
- Users understand that all categorization learning stays on-device (no cloud sync)
- Widget data sync via SharedPreferences is acceptable latency-wise (sub-second updates)

---

## Implementation Order

Based on dependencies and value delivery:

1. **Feature 1** (Auto-Categorization) — Foundation that other features depend on
2. **Feature 2** (Data Export) — Independent, high user value
3. **Feature 6** (Month Comparison) — Builds on existing reports infrastructure
4. **Feature 7** (Daily Spending Limit) — Uses existing notification system
5. **Feature 3** (Recurring Detection) — Depends on Feature 1 for category suggestions
6. **Feature 5** (Enhanced Onboarding) — Can be done independently but good to have all features ready first
7. **Feature 8** (Gamification) — Polish features, do last
8. **Feature 4** (Home Widget) — Most complex native integration, do last
