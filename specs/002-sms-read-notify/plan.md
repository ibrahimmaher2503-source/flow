# Implementation Plan: SMS Auto-Read and Transaction Notifications

**Branch**: `002-sms-read-notify` | **Date**: 2026-04-08 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/002-sms-read-notify/spec.md`

## Summary

Implement automatic SMS reading and parsing for bank transaction messages, with instant local notifications and a quick transaction confirmation flow. This feature leverages the existing `SmsParserService` (7 Egyptian banks supported) and `NotificationService` infrastructure, adding background SMS monitoring via the `telephony` package (already in pubspec.yaml) and a confirmation screen for detected transactions.

## Technical Context

**Language/Version**: Dart 3.9.2 / Flutter
**Primary Dependencies**: telephony (0.2.0), flutter_local_notifications (17.0.0), permission_handler (11.3.0), flutter_riverpod (2.4.0), isar (3.1.0+1)
**Storage**: Isar (local-only, on-device database)
**Testing**: flutter_test
**Target Platform**: Android only (iOS does not support third-party SMS access)
**Project Type**: Mobile app (privacy-first, local-only finance tracker)
**Performance Goals**: Notification within 5 seconds of SMS arrival, 95% parse accuracy for supported banks
**Constraints**: Offline-capable, zero network transmission of SMS data, background processing when app killed
**Scale/Scope**: Single-user local app, ~50 screens total

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

No project-specific constitution configured. Using Flutter/mobile best practices:

| Gate | Status | Notes |
|------|--------|-------|
| Privacy-first architecture | ✅ PASS | All SMS data stays on-device, no network transmission |
| Existing service reuse | ✅ PASS | Extends SmsParserService and NotificationService |
| Isar model conventions | ✅ PASS | New model follows existing `@collection` patterns |
| Riverpod state management | ✅ PASS | New providers follow existing patterns |
| Arabic RTL UI | ✅ PASS | All UI text in Arabic, uses existing theme system |
| Android permissions | ✅ PASS | Uses permission_handler for SMS permission flow |

## Project Structure

### Documentation (this feature)

```text
specs/002-sms-read-notify/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
└── tasks.md             # Phase 2 output (created by /speckit.tasks)
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── constants/app_constants.dart     # Add SMS-related enums if needed
│   └── router/app_router.dart           # Add route for confirmation screen
├── data/
│   ├── models/
│   │   └── detected_sms_model.dart      # NEW: Store detected but unconfirmed transactions
│   ├── repositories/
│   │   └── detected_sms_repo.dart       # NEW: CRUD for detected SMS transactions
│   └── services/
│       ├── sms_parser_service.dart      # EXISTING: Already has bank patterns
│       ├── sms_listener_service.dart    # NEW: Background SMS listener
│       └── notification_service.dart    # EXISTING: Extend with transaction notifications
├── features/
│   ├── sms/
│   │   ├── sms_inbox_screen.dart        # EXISTING: Replace placeholder with real inbox
│   │   ├── sms_confirmation_screen.dart # NEW: Quick confirm/categorize flow
│   │   └── widgets/
│   │       ├── sms_tile.dart            # EXISTING: Enhance for detected transactions
│   │       └── sms_permission_dialog.dart # NEW: Permission explanation dialog
│   └── settings/
│       └── widgets/
│           └── preferences_section.dart # EXISTING: Already has SMS toggle
├── providers/
│   └── sms_provider.dart                # NEW: SMS state management
└── main.dart                            # Initialize SMS listener service
```

**Structure Decision**: Single Flutter mobile app structure. New files integrate with existing feature-based organization. No architectural changes needed.

## Complexity Tracking

No violations requiring justification. Implementation uses existing patterns and infrastructure.
