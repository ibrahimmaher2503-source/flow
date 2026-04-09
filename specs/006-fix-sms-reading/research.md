# Research: Fix SMS Reading Functionality

**Feature**: 006-fix-sms-reading
**Date**: 2026-04-09

## Research Questions

1. What AndroidManifest configuration does the telephony package require?
2. How should Isar schemas be handled in background isolates?
3. How to check SMS permission status without triggering a request?

---

## 1. Telephony Package AndroidManifest Requirements

### Decision
Add BroadcastReceiver declaration for `IncomingSmsReceiver` with explicit `android:exported="true"` for Android 12+ compatibility.

### Rationale
- The telephony package (v0.2.0) relies on Android's BroadcastReceiver system to capture SMS_RECEIVED intents
- Without the receiver declaration, the OS has no way to deliver SMS events to the app
- Android 12+ (API 31+) requires `android:exported` attribute on all components with intent-filters

### Required Configuration

```xml
<receiver android:name="com.shounakmulay.telephony.sms.IncomingSmsReceiver"
    android:permission="android.permission.BROADCAST_SMS"
    android:exported="true">
    <intent-filter>
        <action android:name="android.provider.Telephony.SMS_RECEIVED"/>
    </intent-filter>
</receiver>
```

### Alternatives Considered

| Alternative | Why Rejected |
|-------------|--------------|
| Use another SMS package | telephony is well-maintained; issue is configuration, not the package |
| Native Android code | Unnecessary complexity; telephony package works when configured correctly |
| Foreground-only listening | Doesn't meet requirement for background/killed state detection |

---

## 2. Isar Background Isolate Schema Handling

### Decision
The background handler must open Isar with ALL 10 schemas, matching the main app configuration.

### Rationale
- Isar validates schema consistency when opening a database by name
- If schemas don't match, Isar throws an error or creates an incompatible instance
- The background handler runs in a separate Dart isolate and must independently open Isar

### All 10 Required Schemas

```dart
final isar = await Isar.open(
  [
    TransactionSchema,
    CategorySchema,
    BudgetSchema,
    WalletSchema,
    RecurringTransactionSchema,
    SavingsGoalSchema,
    InstallmentProviderSchema,
    InstallmentPlanSchema,
    AppSettingsSchema,
    DetectedSmsSchema,
  ],
  directory: dir.path,
  name: 'flowspend',
);
```

### Alternatives Considered

| Alternative | Why Rejected |
|-------------|--------------|
| Use a separate database name | Would duplicate data and complicate sync |
| Shared preferences for background | Can't share complex state; Isar is needed for consistency |
| Send SMS to foreground via platform channels | Doesn't work when app is killed |

---

## 3. Permission Status Check Without Request

### Decision
Replace telephony's `requestPhoneAndSmsPermissions` with `permission_handler`'s `Permission.sms.status` for status-only checks.

### Rationale
- `_telephony.requestPhoneAndSmsPermissions` always shows the system permission dialog
- The `permission_handler` package provides separate methods for checking vs requesting
- The settings UI already uses `permission_handler` correctly (`Permission.sms.status`)

### Correct Implementation

```dart
import 'package:permission_handler/permission_handler.dart';

static Future<bool> hasPermission() async {
  final status = await Permission.sms.status;
  return status.isGranted;
}
```

### permission_handler API Reference

| Method | Purpose |
|--------|---------|
| `Permission.sms.status` | Get current status (no dialog) |
| `Permission.sms.request()` | Request permission (shows dialog) |
| `status.isGranted` | Check if granted |
| `status.isDenied` | Check if denied |
| `status.isPermanentlyDenied` | Check if permanently denied |

### Alternatives Considered

| Alternative | Why Rejected |
|-------------|--------------|
| Keep using telephony's method | Triggers unwanted permission dialogs |
| Cache permission state locally | Stale if user changes in system settings |
| Skip status checks | Can't provide good UX for permission states |

---

## 4. Existing Code Analysis

### Files Requiring Changes

| File | Issue | Lines Affected |
|------|-------|---------------|
| `android/app/src/main/AndroidManifest.xml` | Missing BroadcastReceiver | +7 lines (insert after </activity>) |
| `lib/data/services/sms_listener_service.dart` | Schema mismatch + hasPermission bug | Lines 4-9 (imports), 26-30 (schemas), 155-159 (hasPermission) |

### Current Background Handler Schema List (BROKEN)

```dart
// Line 26-30 - Only 2 schemas
final isar = await Isar.open(
  [DetectedSmsSchema, AppSettingsSchema],
  directory: dir.path,
  name: 'flowspend',
);
```

### Current hasPermission Method (BROKEN)

```dart
// Line 155-159 - Triggers request
static Future<bool> hasPermission() async {
  final status = await _telephony.requestPhoneAndSmsPermissions;
  return status ?? false;
}
```

---

## 5. Testing Strategy

### Manual Testing Required

1. **Fresh install**: Verify permission request flow works
2. **Enable SMS parsing**: Toggle in settings should request permission
3. **Receive test SMS**: Send SMS matching bank patterns
4. **Background detection**: Minimize/kill app, send SMS, verify detection
5. **Notification tap**: Verify deep link to confirmation screen

### Test SMS Patterns (Egyptian Banks)

| Bank | Test Message |
|------|--------------|
| CIB | "Purchase EGP 150.00 at Store" |
| NBE | "تم خصم مبلغ 500 جنيه من حسابك" |
| BM | "تم خصم 200 جنيه" |
| Vodafone | "تم تحويل 100 جنيه" |
| Instapay | "Amount: 300 EGP transferred" |

---

## Summary

All NEEDS CLARIFICATION items have been resolved:

| Question | Resolution |
|----------|------------|
| AndroidManifest config | Add IncomingSmsReceiver with intent-filter |
| Isar schema handling | Use all 10 schemas in background handler |
| Permission check | Use permission_handler's status property |

The implementation requires changes to exactly 2 files with minimal risk.
