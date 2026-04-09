# Feature Specification: Add English Translations

**Feature Branch**: `008-english-translations`
**Created**: 2026-04-09
**Status**: Draft
**Input**: User description: "i need to add translations en for my app"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Switch Language to English (Priority: P1)

An English-speaking user opens FlowSpend and wants to use the app in English instead of Arabic. They navigate to Settings, find the language option, select English, and the entire app interface updates to display all text in English.

**Why this priority**: Core functionality - enables English speakers to use the app. Without this, the app is unusable for non-Arabic speakers.

**Independent Test**: Can be fully tested by changing language in settings and verifying all visible text changes to English across all screens.

**Acceptance Scenarios**:

1. **Given** the app is displaying in Arabic, **When** user selects English from language settings, **Then** all UI text immediately updates to English without app restart
2. **Given** English is selected, **When** user navigates through all screens, **Then** all labels, buttons, and messages display in English
3. **Given** user changes language to English, **When** user closes and reopens the app, **Then** the language preference persists and app opens in English

---

### User Story 2 - Arabic User Maintains Current Experience (Priority: P2)

An Arabic-speaking user continues using FlowSpend with the same RTL layout and Arabic text they are accustomed to. The default language remains Arabic, and the RTL text direction is preserved.

**Why this priority**: Preserves existing user experience - ensures current Arabic users are not negatively impacted by the localization changes.

**Independent Test**: Can be verified by using the app without changing language settings and confirming all Arabic text and RTL layout remain intact.

**Acceptance Scenarios**:

1. **Given** a fresh app installation, **When** user opens the app, **Then** the default language is Arabic with RTL layout
2. **Given** user is using Arabic language, **When** user navigates all screens, **Then** all existing Arabic translations remain unchanged
3. **Given** user switches from English back to Arabic, **When** language changes, **Then** RTL layout and Arabic text are restored

---

### User Story 3 - View Localized Dates and Numbers (Priority: P3)

Users see dates and number formatting appropriate to their selected language. English users see left-to-right date formats while Arabic users see Arabic-formatted dates.

**Why this priority**: Enhances usability by providing culturally appropriate formatting that complements the language selection.

**Independent Test**: Can be tested by comparing date/number displays between English and Arabic language modes.

**Acceptance Scenarios**:

1. **Given** English language is selected, **When** user views transaction dates, **Then** dates display in English format (e.g., "April 9, 2026")
2. **Given** Arabic language is selected, **When** user views dates, **Then** dates display in Arabic format
3. **Given** any language, **When** currency amounts are displayed, **Then** EGP currency formatting is maintained consistently

---

### Edge Cases

- What happens when a translation key is missing? System displays the fallback English text or key identifier.
- How does the app handle mixed-content (user-entered Arabic text in English mode)? User data displays as entered; only UI text is translated.
- What happens during language switch with unsaved form data? Language changes without affecting form state or user input.
- How does text direction change affect existing widgets? Layout adapts automatically based on locale direction.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST support at least two languages: Arabic (ar) and English (en)
- **FR-002**: System MUST provide a language selection option in the Settings screen
- **FR-003**: System MUST persist the selected language preference locally on device
- **FR-004**: System MUST update all UI text immediately when language is changed without requiring app restart
- **FR-005**: System MUST apply RTL text direction for Arabic and LTR text direction for English
- **FR-006**: System MUST set Arabic as the default language for new installations
- **FR-007**: All screens MUST display translated text for: navigation labels, buttons, headers, empty states, error messages, and descriptive text
- **FR-008**: System MUST format dates according to the selected language locale
- **FR-009**: Default category names MUST be available in both languages
- **FR-010**: Onboarding screens MUST be fully translated to English
- **FR-011**: Gamification elements (badges, achievements, finance score labels) MUST be translated
- **FR-012**: Bottom navigation labels MUST update when language changes

### Key Entities

- **Language Setting**: User preference stored in AppSettings (locale code: "ar" or "en")
- **Translation Strings**: Key-value pairs mapping string identifiers to localized text for each supported language
- **Locale Configuration**: Defines text direction (RTL/LTR) and date formatting rules per language

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of static UI text is translatable (no hardcoded visible strings remain in code)
- **SC-002**: Users can switch languages in under 3 taps from any screen
- **SC-003**: Language switch completes in under 1 second with immediate visual update
- **SC-004**: App maintains selected language across sessions with 100% reliability
- **SC-005**: All screens (15+) display correct translations without missing text or broken layouts
- **SC-006**: English speakers can complete all core tasks (add transaction, view reports, manage budgets) without encountering Arabic-only text

## Assumptions

- Currency symbol (EGP) remains consistent regardless of language selection
- User-generated content (transaction notes, custom category names, wallet names) is not translated - only system UI text
- The Cairo font family supports both Arabic and English text rendering adequately
- Additional languages beyond Arabic and English are out of scope for this feature
- Existing gamification badges and achievement names will be translated to English
- Number formatting uses standard Western Arabic numerals (0-9) in both languages
