# Feature Specification: Fix SMS Reading Functionality

**Feature Branch**: `006-fix-sms-reading`
**Created**: 2026-04-09
**Status**: Draft
**Input**: User description: "read sms not working - analyze current status and make sure it works"

## Problem Analysis

The SMS reading functionality in FlowSpend is not working correctly. After thorough code analysis, the following issues have been identified:

### Current State

The app has a complete SMS reading architecture:
- `SmsListenerService` - Handles foreground and background SMS listening
- `SmsParserService` - Parses bank SMS messages (CIB, NBE, BM, Vodafone, Instapay, Souhoola, Valu)
- `DetectedSms` model - Stores parsed SMS in Isar database
- `SmsInboxScreen` and `SmsConfirmationScreen` - UI for managing detected SMS
- Android permissions declared in manifest (`RECEIVE_SMS`, `READ_SMS`)

### Identified Issues

1. **Missing Android BroadcastReceiver Configuration**
   - The telephony package requires explicit receiver registration in AndroidManifest.xml
   - Without this, background SMS messages won't trigger the handler

2. **Permission Check Logic Bug**
   - `hasPermission()` method calls `requestPhoneAndSmsPermissions` which requests permission instead of just checking status
   - This causes unwanted permission dialogs

3. **Background Handler Isar Conflict**
   - The `backgroundSmsHandler` opens a new Isar instance with only 2 schemas
   - Main app opens Isar with 10 schemas, potentially causing schema mismatch

4. **Service Initialization Issues**
   - `_isInitialized` flag prevents re-initialization but doesn't handle restart scenarios
   - If permission was granted after initial launch, listener won't start automatically

5. **Telephony Package Compatibility**
   - Version 0.2.0 may have compatibility issues with Android 12+ background restrictions
   - Need to verify package supports current Android SDK requirements

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Receive and Detect Bank SMS (Priority: P1)

As a user, when I receive a bank transaction SMS, the app should automatically detect and parse it so I can quickly convert it to a transaction.

**Why this priority**: This is the core functionality - without SMS detection working, all other SMS features are useless.

**Independent Test**: Can be fully tested by sending a test SMS from a supported bank format and verifying it appears in the SMS inbox within seconds.

**Acceptance Scenarios**:

1. **Given** SMS parsing is enabled and permission granted, **When** user receives a CIB bank SMS with "Purchase EGP 150.00", **Then** app detects and saves the SMS with amount=150, type=debit, bank=CIB
2. **Given** SMS parsing is enabled and permission granted, **When** user receives an NBE bank SMS in Arabic with "مبلغ 500 جنيه", **Then** app detects and saves the SMS with amount=500, type=debit, bank=NBE
3. **Given** SMS parsing is enabled, **When** app is in background or killed, **Then** incoming bank SMS is still detected and saved
4. **Given** SMS parsing is disabled in settings, **When** user receives a bank SMS, **Then** no SMS is detected or saved

---

### User Story 2 - Permission Request Flow (Priority: P2)

As a user, I want a clear permission request experience so I understand why the app needs SMS access and can grant it easily.

**Why this priority**: Without proper permissions, the core SMS detection won't work at all.

**Independent Test**: Can be tested by toggling the SMS setting in preferences and verifying permission dialog appears.

**Acceptance Scenarios**:

1. **Given** SMS permission not granted, **When** user enables SMS parsing in settings, **Then** app shows explanation dialog followed by system permission request
2. **Given** user denies SMS permission, **When** returning to settings, **Then** toggle remains off and shows appropriate message
3. **Given** user grants SMS permission, **When** returning to settings, **Then** toggle is on and SMS listener starts immediately
4. **Given** permission previously denied permanently, **When** user tries to enable SMS, **Then** app shows "Open Settings" button to navigate to app settings

---

### User Story 3 - SMS Notification and Quick Access (Priority: P2)

As a user, I want to be notified when a transaction SMS is detected so I can quickly confirm or dismiss it.

**Why this priority**: Notifications provide real-time awareness and quick access to confirmation.

**Independent Test**: Can be tested by receiving a bank SMS and verifying notification appears with correct information.

**Acceptance Scenarios**:

1. **Given** notifications enabled and bank SMS detected, **When** SMS is parsed successfully, **Then** notification shows amount, type (debit/credit), and bank name
2. **Given** notification is shown, **When** user taps notification, **Then** app opens directly to SMS confirmation screen for that SMS
3. **Given** notifications disabled in settings, **When** bank SMS is detected, **Then** no notification is shown but SMS is still saved

---

### User Story 4 - App Restart Resilience (Priority: P3)

As a user, I expect SMS detection to continue working after app restart without needing to reconfigure anything.

**Why this priority**: Users shouldn't need to re-enable features after every app restart.

**Independent Test**: Can be tested by enabling SMS, restarting app, and verifying SMS is still detected.

**Acceptance Scenarios**:

1. **Given** SMS parsing was enabled before app close, **When** app is launched, **Then** SMS listener automatically starts
2. **Given** SMS permission was revoked while app was closed, **When** app launches, **Then** setting shows appropriate permission message
3. **Given** app was force-stopped, **When** bank SMS arrives, **Then** background handler still receives and processes the SMS (Android-dependent)

---

### Edge Cases

- What happens when SMS body is empty or malformed? App ignores it gracefully
- How does system handle duplicate SMS messages? Each SMS saved as separate entry (timestamp differs)
- What happens when Isar database is corrupted in background handler? Error caught and logged, no crash
- How does system behave when device storage is full? Database write fails, error logged
- What happens when SMS matches multiple bank patterns? First matching pattern is used

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST properly register Android BroadcastReceiver for SMS_RECEIVED intent
- **FR-002**: System MUST handle SMS in both foreground and background/killed states
- **FR-003**: System MUST parse SMS from supported Egyptian banks (CIB, NBE, BM, Vodafone, Instapay, Souhoola, Valu)
- **FR-004**: System MUST persist detected SMS to local database with status "pending"
- **FR-005**: System MUST check permission status without triggering permission request
- **FR-006**: System MUST show local notification when bank SMS is detected (if notifications enabled)
- **FR-007**: System MUST support deep-linking from notification to confirmation screen
- **FR-008**: System MUST restart SMS listener automatically on app launch if feature is enabled
- **FR-009**: System MUST handle Isar schema compatibility between foreground and background handlers
- **FR-010**: System MUST gracefully handle permission denial scenarios

### Key Entities

- **DetectedSms**: Represents a parsed bank SMS with amount, type (debit/credit), bank name, raw body, timestamp, and status (pending/confirmed/dismissed)
- **AppSettings**: Contains `smsParsingEnabled` and `notificationsEnabled` flags that control SMS functionality

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of bank SMS from supported banks are detected within 5 seconds of receipt
- **SC-002**: Background SMS detection works when app is minimized or force-killed
- **SC-003**: Permission request flow completes successfully for users who grant permission
- **SC-004**: App restart maintains SMS parsing state without user re-configuration
- **SC-005**: Notification deep-linking opens correct SMS confirmation screen 100% of the time
- **SC-006**: Zero crashes or errors when handling malformed SMS or database issues

## Assumptions

- Users have Android devices (iOS SMS reading not supported due to platform restrictions)
- Users receive bank SMS in formats matching the supported bank patterns
- Users grant SMS permission when prompted (feature cannot work without it)
- Device allows background execution for SMS receiver
- Telephony package (v0.2.0) is compatible with target Android version or upgrade is acceptable
- Existing SMS parsing patterns correctly identify Egyptian bank messages
