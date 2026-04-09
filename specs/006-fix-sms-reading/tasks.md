# Tasks: Fix SMS Reading Functionality

**Input**: Design documents from `/specs/006-fix-sms-reading/`
**Prerequisites**: plan.md ✓, spec.md ✓, research.md ✓, quickstart.md ✓

**Tests**: Not explicitly requested. Manual verification steps provided in quickstart.md.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3, US4)
- Include exact file paths in descriptions

## Path Conventions

- **Flutter Mobile App**: `lib/` for Dart code, `android/` for Android platform code
- Structure matches existing FlowSpend project layout

---

## Phase 1: Setup

**Purpose**: Verify prerequisites and understand current state

- [ ] T001 Verify Flutter SDK version ≥3.9.2 is installed with `flutter --version`
- [ ] T002 [P] Run `flutter pub get` to ensure dependencies are up to date
- [ ] T003 [P] Run `flutter analyze` to check for existing lint errors

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core fixes that MUST be complete for ANY SMS functionality to work

**⚠️ CRITICAL**: No user story can work until this phase is complete (BroadcastReceiver + Isar schemas)

- [ ] T004 Add BroadcastReceiver declaration to `android/app/src/main/AndroidManifest.xml` after `</activity>` tag
- [ ] T005 Add missing model imports to `lib/data/services/sms_listener_service.dart` (8 imports for Transaction, Category, Budget, Wallet, RecurringTransaction, SavingsGoal, InstallmentProvider, InstallmentPlan models)
- [ ] T006 Update Isar.open() in backgroundSmsHandler to include all 10 schemas in `lib/data/services/sms_listener_service.dart` (lines 26-30)

**Checkpoint**: Foundation ready - SMS can now be received by the BroadcastReceiver and background handler can open Isar correctly

---

## Phase 3: User Story 1 - Receive and Detect Bank SMS (Priority: P1) 🎯 MVP

**Goal**: Bank SMS messages are automatically detected, parsed, and saved to database

**Independent Test**: Send test SMS using ADB: `adb emu sms send 1234 "CIB: Purchase EGP 150.00"` and verify it appears in SMS inbox screen

### Implementation for User Story 1

- [ ] T007 [US1] Run clean build with `flutter clean && flutter pub get && flutter build apk`
- [ ] T008 [US1] Install APK on Android device/emulator
- [ ] T009 [US1] Enable SMS parsing in Settings > General > قراءة SMS toggle
- [ ] T010 [US1] Test foreground detection: Keep app open, send CIB bank SMS, verify notification appears
- [ ] T011 [US1] Test foreground detection: Verify SMS appears in SMS inbox screen with correct amount/bank
- [ ] T012 [US1] Test background detection: Minimize app, send NBE bank SMS (Arabic), verify notification appears
- [ ] T013 [US1] Test background detection: Open app, verify SMS appears in inbox with correct parsing
- [ ] T014 [US1] Test disabled state: Disable SMS parsing in settings, send SMS, verify no detection occurs

**Checkpoint**: User Story 1 complete - Bank SMS detection works in foreground and background

---

## Phase 4: User Story 2 - Permission Request Flow (Priority: P2)

**Goal**: Permission status is correctly checked without triggering unwanted dialogs

**Independent Test**: Fresh install, toggle SMS setting, verify single permission dialog appears only when enabling

### Implementation for User Story 2

- [ ] T015 [US2] Add permission_handler import to `lib/data/services/sms_listener_service.dart`
- [ ] T016 [US2] Replace hasPermission() method body to use `Permission.sms.status` instead of `_telephony.requestPhoneAndSmsPermissions` in `lib/data/services/sms_listener_service.dart` (lines 155-159)
- [ ] T017 [US2] Test permission check: Fresh install, verify toggling SMS setting shows explanation dialog then system permission request
- [ ] T018 [US2] Test permission denied: Deny permission, verify toggle remains off with appropriate message
- [ ] T019 [US2] Test permission granted: Grant permission, verify toggle is on and listener starts
- [ ] T020 [US2] Test permanent denial: Permanently deny permission, verify "Open Settings" button appears

**Checkpoint**: User Story 2 complete - Permission flow works without unwanted dialogs

---

## Phase 5: User Story 3 - SMS Notification and Quick Access (Priority: P2)

**Goal**: Notifications appear when SMS is detected and deep-link to confirmation screen

**Independent Test**: Receive bank SMS, tap notification, verify it opens confirmation screen for that specific SMS

### Implementation for User Story 3

- [ ] T021 [US3] Test notification content: Receive bank SMS, verify notification shows amount, type (debit/credit), and bank name
- [ ] T022 [US3] Test notification deep-link: Tap notification, verify SMS confirmation screen opens for correct SMS ID
- [ ] T023 [US3] Test notifications disabled: Disable notifications in settings, receive SMS, verify no notification but SMS still saved

**Checkpoint**: User Story 3 complete - Notifications work with correct deep-linking

---

## Phase 6: User Story 4 - App Restart Resilience (Priority: P3)

**Goal**: SMS detection continues working after app restart without reconfiguration

**Independent Test**: Enable SMS parsing, force-stop app, receive SMS, verify detection still works

### Implementation for User Story 4

- [ ] T024 [US4] Test restart persistence: Enable SMS parsing, close app, reopen, verify setting is still enabled
- [ ] T025 [US4] Test background after restart: Force-stop app, send bank SMS, verify background handler processes it
- [ ] T026 [US4] Test permission revocation: Revoke SMS permission in system settings while app closed, reopen app, verify appropriate message shown

**Checkpoint**: User Story 4 complete - App restart doesn't break SMS detection

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Final validation and cleanup

- [ ] T027 [P] Run `flutter analyze` to verify no lint errors introduced
- [ ] T028 [P] Test all 7 bank patterns using ADB SMS commands from quickstart.md
- [ ] T029 Run quickstart.md full verification steps end-to-end
- [ ] T030 Check logcat for any errors: `adb logcat -d | grep -E "SMS|Telephony|Isar|Flutter"`

---

## Dependencies & Execution Order

### Phase Dependencies

```
Phase 1: Setup
    ↓
Phase 2: Foundational (BroadcastReceiver + Isar schemas)
    ↓
    ├──→ Phase 3: User Story 1 (SMS Detection) 🎯 MVP
    ├──→ Phase 4: User Story 2 (Permission Flow)
    ├──→ Phase 5: User Story 3 (Notifications)
    └──→ Phase 6: User Story 4 (Restart Resilience)
              ↓
         Phase 7: Polish
```

### User Story Dependencies

| User Story | Depends On | Can Start After |
|------------|------------|-----------------|
| US1 (SMS Detection) | Phase 2 Foundational | T006 complete |
| US2 (Permission Flow) | Phase 2 Foundational | T006 complete |
| US3 (Notifications) | US1 working | T014 complete |
| US4 (Restart Resilience) | US1 working | T014 complete |

### Parallel Opportunities

Within Phase 1 (Setup):
- T002 and T003 can run in parallel

Within Phase 2 (Foundational):
- T005 and T004 can run in parallel (different files)
- T006 must wait for T005 (same file)

User Stories 1 and 2:
- Can be implemented in parallel (different concerns)
- US3 and US4 should wait for US1 baseline to work

Within Phase 7 (Polish):
- T027 and T028 can run in parallel

---

## Parallel Example: Foundational Phase

```bash
# These tasks can run in parallel (different files):
Task: "Add BroadcastReceiver declaration to android/app/src/main/AndroidManifest.xml"
Task: "Add missing model imports to lib/data/services/sms_listener_service.dart"

# This task must wait for imports to complete (same file):
Task: "Update Isar.open() in backgroundSmsHandler to include all 10 schemas"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (T001-T003)
2. Complete Phase 2: Foundational (T004-T006) **← Critical fixes**
3. Complete Phase 3: User Story 1 (T007-T014) **← Core SMS detection**
4. **STOP and VALIDATE**: Test SMS detection works in foreground and background
5. If working → MVP complete, can deploy

### Incremental Delivery

1. **MVP**: Setup → Foundational → US1 (SMS Detection works!)
2. **+Permissions**: Add US2 (No unwanted permission dialogs)
3. **+Notifications**: Add US3 (Deep-linking works)
4. **+Resilience**: Add US4 (Restart doesn't break anything)
5. **Polish**: Final validation and cleanup

### Files Modified Summary

| File | Tasks | Changes |
|------|-------|---------|
| `android/app/src/main/AndroidManifest.xml` | T004 | +7 lines (BroadcastReceiver) |
| `lib/data/services/sms_listener_service.dart` | T005, T006, T015, T016 | +8 imports, ~15 lines changed |

**Total**: 2 files, ~30 lines changed

---

## Test SMS Commands Reference

```bash
# CIB Bank (English)
adb emu sms send 1234 "CIB: Purchase EGP 150.00 at Store Name"

# NBE Bank (Arabic)
adb emu sms send 1234 "NBE: تم خصم مبلغ 500 جنيه من حسابك"

# BM Bank (Arabic)
adb emu sms send 1234 "BM: تم خصم 200 جنيه"

# Vodafone Cash (Arabic)
adb emu sms send 1234 "Vodafone: تم تحويل 100 جنيه"

# Instapay (English)
adb emu sms send 1234 "Instapay: Amount: 300 EGP transferred successfully"
```

---

## Notes

- [P] tasks = different files, no dependencies
- [US#] label maps task to specific user story for traceability
- Phase 2 is CRITICAL - all other phases depend on these fixes
- Manual testing required on Android device/emulator
- No automated tests in scope (use ADB + manual verification per quickstart.md)
- Commit after each phase completion for easy rollback
