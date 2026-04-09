# Tasks: SMS Auto-Read and Transaction Notifications

**Input**: Design documents from `/specs/002-sms-read-notify/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md

**Status**: ✅ IMPLEMENTATION COMPLETE

**Organization**: Tasks are grouped by user story to enable independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2)
- Include exact file paths in descriptions

## Path Conventions

- **Flutter app**: `lib/` for source code, `android/` for platform-specific
- File structure follows existing feature-based organization

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Android permissions and shared model/service setup

- [x] T001 Add SMS permissions to android/app/src/main/AndroidManifest.xml (RECEIVE_SMS, READ_SMS)
- [x] T002 [P] Create DetectedSms model in lib/data/models/detected_sms_model.dart per data-model.md schema
- [x] T003 Run build_runner to generate detected_sms_model.g.dart
- [x] T004 Register DetectedSmsSchema in lib/data/services/isar_service.dart schema list

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T005 Create DetectedSmsRepo in lib/data/repositories/detected_sms_repo.dart with CRUD operations (getPending, getByDateRange, save, updateStatus, countPending)
- [x] T006 Create detectedSmsRepoProvider in lib/providers/sms_provider.dart following existing repo provider pattern
- [x] T007 Add smsConfirmation route constant to lib/core/router/app_router.dart
- [x] T008 [P] Create top-level backgroundSmsHandler function in lib/data/services/sms_listener_service.dart (must be @pragma vm:entry-point)

**Checkpoint**: ✅ Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Automatic SMS Transaction Detection (Priority: P1) 🎯 MVP

**Goal**: App automatically reads and parses incoming bank SMS messages

**Independent Test**: Receive a bank SMS → Verify app detects and stores transaction with amount, type, bank

### Implementation for User Story 1

- [x] T009 [US1] Implement SmsListenerService class in lib/data/services/sms_listener_service.dart with:
  - init() method to request permissions and start listener
  - listenIncomingSms() using telephony package
  - onNewMessage callback that calls SmsParserService.parse()
  - Background handler integration for when app is killed
- [x] T010 [US1] Add method to save parsed SMS to Isar in backgroundSmsHandler (open separate Isar instance per research.md)
- [x] T011 [US1] Create smsListenerProvider in lib/providers/sms_provider.dart
- [x] T012 [US1] Create pendingTransactionsProvider (FutureProvider) in lib/providers/sms_provider.dart that calls detectedSmsRepo.getPending()
- [x] T013 [US1] Initialize SmsListenerService in lib/main.dart after Isar init (check smsParsingEnabled setting first)
- [x] T014 [US1] Update lib/features/sms/sms_inbox_screen.dart to display detected SMS from pendingTransactionsProvider
- [x] T015 [US1] Enhance lib/features/sms/widgets/sms_tile.dart to show amount, bank, type, timestamp for DetectedSms

**Checkpoint**: ✅ User Story 1 complete - SMS detection works, transactions appear in inbox

---

## Phase 4: User Story 2 - Transaction Notification Alerts (Priority: P1)

**Goal**: Instant notifications when transaction detected from SMS

**Independent Test**: Receive bank SMS → Notification appears within 5 seconds with Arabic text showing amount and bank

### Implementation for User Story 2

- [x] T016 [US2] Add showTransactionDetected method to lib/data/services/notification_service.dart with:
  - Arabic notification text: "تم خصم/إضافة [amount] جنيه من [bank]"
  - Payload parameter for detected SMS ID
- [x] T017 [US2] Update NotificationService.init() in lib/data/services/notification_service.dart to accept onNotificationTap callback
- [x] T018 [US2] Call NotificationService.showTransactionDetected() from SmsListenerService after successful parse (check notificationsEnabled setting)
- [x] T019 [US2] Call notification from backgroundSmsHandler after saving to Isar (check AppSettings.notificationsEnabled)

**Checkpoint**: ✅ User Story 2 complete - Notifications work for detected transactions

---

## Phase 5: User Story 3 - Quick Transaction Confirmation (Priority: P2)

**Goal**: Tap notification to quickly confirm and categorize detected transaction

**Independent Test**: Tap transaction notification → App opens confirmation screen with pre-filled data → Confirm saves to transactions

### Implementation for User Story 3

- [x] T020 [US3] Create lib/features/sms/sms_confirmation_screen.dart with:
  - Accept DetectedSms ID as route argument
  - Display pre-filled amount, type, bank (non-editable)
  - Category selector using existing CategoryGrid widget
  - Wallet selector dropdown
  - Confirm button and Dismiss button
- [x] T021 [US3] Register /sms-confirmation route in lib/core/router/app_router.dart with ID parameter
- [x] T022 [US3] Implement confirm logic in sms_confirmation_screen.dart:
  - Create new Transaction with parsed data + selected category
  - Update DetectedSms status to 'confirmed' with transactionId
  - Invalidate transaction providers to refresh UI
- [x] T023 [US3] Implement dismiss logic in sms_confirmation_screen.dart:
  - Update DetectedSms status to 'dismissed'
  - Navigate back without creating transaction
- [x] T024 [US3] Wire notification tap in lib/main.dart to navigate to sms_confirmation_screen with payload ID
- [x] T025 [US3] Add tap handler to sms_tile.dart in sms_inbox_screen to open confirmation screen for pending items

**Checkpoint**: ✅ User Story 3 complete - Full flow from notification to confirmed transaction

---

## Phase 6: User Story 4 - SMS Permission Management (Priority: P2)

**Goal**: Clear control over SMS reading permissions with privacy explanation

**Independent Test**: Fresh install → Permission dialog shows → Can toggle SMS in settings → Revoke permission gracefully handled

### Implementation for User Story 4

- [x] T026 [US4] Create lib/features/sms/widgets/sms_permission_dialog.dart with:
  - Arabic explanation text about privacy (data stays on device)
  - "Allow" and "Not Now" buttons
  - Uses existing theme (AppColors, AppTextStyles)
- [x] T027 [US4] Add requestSmsPermission method to SmsListenerService that shows permission dialog first, then requests system permission
- [x] T028 [US4] Update lib/features/settings/widgets/preferences_section.dart SMS toggle to:
  - Show current permission status (granted/denied)
  - Request permission when toggling on (using permission dialog)
  - Handle permanently denied state (show "Open Settings" option)
- [x] T029 [US4] Add graceful handling in SmsListenerService.init() when permission denied (just log and continue, don't crash)
- [x] T030 [US4] Show permission dialog on first app launch if smsParsingEnabled is true in lib/main.dart (one-time, store flag)

**Checkpoint**: ✅ User Story 4 complete - Permission flow works with clear privacy messaging

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Edge cases, error handling, and refinements

- [x] T031 Add error handling for malformed SMS in SmsListenerService (catch parse exceptions, log, continue)
- [x] T032 Add handling for zero/negative amounts in SmsParserService.parse() (return null)
- [x] T033 [P] Add pending transaction badge count to SMS Inbox tab in app navigation (use countPending) - N/A: SMS Inbox not in bottom nav
- [x] T034 [P] Add pull-to-refresh on sms_inbox_screen.dart
- [ ] T035 Validate all scenarios from quickstart.md manually on real device (requires real device)
- [ ] T036 Test background processing by killing app and receiving SMS (requires real device)

---

## Summary

| Phase | Tasks | Status |
|-------|-------|--------|
| Setup | T001-T004 | ✅ Complete |
| Foundational | T005-T008 | ✅ Complete |
| US1 | T009-T015 | ✅ Complete |
| US2 | T016-T019 | ✅ Complete |
| US3 | T020-T025 | ✅ Complete |
| US4 | T026-T030 | ✅ Complete |
| Polish | T031-T036 | 🟡 4/6 (needs real device testing) |

**Total Tasks**: 36
**Completed**: 34/36 (94%)
**Remaining**: 2 real device validation tasks

---

## Notes

- All SMS data stays on device - never call any network APIs with SMS content
- Background handler must be top-level function (Dart isolate requirement)
- Test on real Android device - emulator cannot receive real SMS
- Run `flutter pub run build_runner build` after T002
- Existing SmsParserService patterns cover 7 Egyptian banks
- Existing NotificationService infrastructure is extended, not replaced
