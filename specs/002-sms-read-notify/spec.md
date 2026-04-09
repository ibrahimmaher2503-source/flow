# Feature Specification: SMS Auto-Read and Transaction Notifications

**Feature Branch**: `002-sms-read-notify`
**Created**: 2026-04-08
**Status**: Draft
**Input**: User description: "make sure app read maagase and analysis it and app sendeing notofications will"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Automatic SMS Transaction Detection (Priority: P1)

As a FlowSpend user, I want the app to automatically read and parse incoming bank SMS messages so that my transactions are detected without manual entry.

**Why this priority**: This is the core functionality that enables automatic expense tracking. Without SMS reading, users must manually enter every transaction, which is tedious and often leads to incomplete records.

**Independent Test**: Can be fully tested by receiving a bank SMS and verifying the app detects and extracts the transaction amount, type, and source bank.

**Acceptance Scenarios**:

1. **Given** the app has SMS permission granted, **When** a bank SMS arrives from a supported bank (CIB, NBE, BM, Vodafone, Instapay, Souhoola, Valu), **Then** the app detects and parses the transaction details (amount, type, bank).

2. **Given** the app has SMS permission granted, **When** a non-financial SMS arrives, **Then** the app ignores it without any action.

3. **Given** the user has not granted SMS permission, **When** the app attempts to read SMS, **Then** the user is prompted to grant permission with a clear explanation of why it's needed.

---

### User Story 2 - Transaction Notification Alerts (Priority: P1)

As a FlowSpend user, I want to receive instant notifications when a transaction is detected from SMS so that I'm immediately aware of my spending.

**Why this priority**: Notifications provide immediate feedback and awareness of spending, which is essential for financial mindfulness and the app's value proposition.

**Independent Test**: Can be fully tested by triggering an SMS transaction detection and verifying a notification appears with the correct transaction details.

**Acceptance Scenarios**:

1. **Given** a bank SMS is successfully parsed, **When** the transaction is detected, **Then** the user receives a notification showing the amount, transaction type (debit/credit), and bank name in Arabic.

2. **Given** notifications are disabled in app settings, **When** a transaction is detected, **Then** no notification is sent but the transaction is still processed.

3. **Given** a debit transaction is detected, **When** the notification appears, **Then** it displays in a format like "تم خصم [المبلغ] جنيه من [البنك]" (Debited [amount] EGP from [bank]).

---

### User Story 3 - Quick Transaction Confirmation (Priority: P2)

As a FlowSpend user, I want to tap on a transaction notification to quickly confirm and categorize the detected transaction so that I can keep my records accurate with minimal effort.

**Why this priority**: While auto-detection is valuable, users need to verify and categorize transactions for accurate budgeting. This bridges auto-detection with accurate record-keeping.

**Independent Test**: Can be fully tested by tapping a transaction notification and verifying the app opens to a pre-filled transaction form.

**Acceptance Scenarios**:

1. **Given** a transaction notification is displayed, **When** the user taps the notification, **Then** the app opens to a transaction confirmation screen with amount, type, and bank pre-filled.

2. **Given** the user is on the confirmation screen, **When** they select a category and tap confirm, **Then** the transaction is saved to their records.

3. **Given** the user is on the confirmation screen, **When** they tap dismiss/cancel, **Then** the transaction is not saved and they return to their previous screen.

---

### User Story 4 - SMS Permission Management (Priority: P2)

As a privacy-conscious user, I want clear control over SMS reading permissions so that I understand what data the app accesses and can revoke access if needed.

**Why this priority**: Privacy is a core value of FlowSpend. Users must trust the app with their financial SMS data, which requires transparency and control.

**Independent Test**: Can be fully tested by navigating to settings and toggling SMS permissions on/off.

**Acceptance Scenarios**:

1. **Given** the user opens the app for the first time, **When** SMS reading is needed, **Then** a permission dialog explains that SMS reading is used only for transaction detection and data stays on-device.

2. **Given** the user is in app settings, **When** they view the SMS permission section, **Then** they can see the current permission status and toggle it.

3. **Given** SMS permission is revoked, **When** a bank SMS arrives, **Then** the app does not attempt to read it and no error occurs.

---

### Edge Cases

- What happens when an SMS arrives but the app is killed/not running? (Background service should handle it)
- How does the system handle malformed or partially readable SMS messages? (Silently ignore, no notification)
- What happens when multiple SMS messages arrive simultaneously? (Process sequentially, show individual notifications)
- How does the app handle SMS from an unsupported bank format? (Ignore without notification)
- What if the parsed amount is zero or negative? (Ignore as invalid)

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST request SMS read permission from the user before accessing any SMS content
- **FR-002**: System MUST listen for incoming SMS messages in the background when permission is granted
- **FR-003**: System MUST filter incoming SMS to identify financial messages from supported banks (CIB, NBE, BM, Vodafone, Instapay, Souhoola, Valu)
- **FR-004**: System MUST parse detected financial SMS to extract: amount, transaction type (debit/credit), and source bank
- **FR-005**: System MUST send a local notification immediately upon successful transaction detection
- **FR-006**: System MUST display transaction details in Arabic in the notification body
- **FR-007**: System MUST allow users to disable transaction notifications in app settings while keeping SMS reading active
- **FR-008**: System MUST open the app to a transaction confirmation screen when user taps a transaction notification
- **FR-009**: System MUST pre-fill the confirmation screen with parsed transaction data (amount, type, bank)
- **FR-010**: System MUST allow users to categorize and save confirmed transactions to local database
- **FR-011**: System MUST respect user's notification preferences and not send notifications if disabled
- **FR-012**: System MUST handle SMS reading gracefully when permission is revoked (no crashes, silent failure)
- **FR-013**: System MUST process SMS messages even when the app is in the background or killed (Android service)
- **FR-014**: System MUST NOT send any SMS data over the internet (privacy-first, local-only)

### Key Entities

- **DetectedTransaction**: Represents a parsed transaction from SMS (amount, type, bank, timestamp, raw SMS body, confirmation status)
- **NotificationPreference**: User settings for transaction notification behavior (enabled/disabled, sound, vibration)
- **SMSPermissionState**: Current state of SMS permission (granted, denied, not yet requested)

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users receive transaction notifications within 5 seconds of SMS arrival when app has permission
- **SC-002**: 95% of financial SMS messages from supported banks are correctly parsed and detected
- **SC-003**: Users can confirm or dismiss a detected transaction in under 10 seconds from notification tap
- **SC-004**: Zero SMS data is transmitted outside the device (verifiable through network monitoring)
- **SC-005**: Background SMS detection works reliably after device restart without user intervention
- **SC-006**: 80% of users who enable SMS reading keep it enabled after 1 week (indicating value and trust)

## Assumptions

- Users have Android devices (iOS does not allow SMS reading by third-party apps due to platform restrictions)
- Users receive bank transaction SMS in formats matching the existing parser patterns
- The existing `SmsParserService` patterns are sufficient for initial bank support
- The existing `NotificationService` infrastructure will be extended for transaction notifications
- Users are willing to grant SMS permission for the convenience of automatic transaction detection
- Background service execution is permitted by the device's battery optimization settings
- The app will guide users through battery optimization exceptions if needed
