# Quickstart: Fix SMS Reading Functionality

**Feature**: 006-fix-sms-reading
**Date**: 2026-04-09

## Overview

This guide provides the implementation steps to fix the broken SMS reading functionality in FlowSpend.

---

## Prerequisites

- Android device or emulator (iOS not supported for SMS reading)
- Flutter SDK 3.9.2+
- Access to test SMS (can use ADB to send test messages)

---

## Changes Required

### Change 1: Add BroadcastReceiver to AndroidManifest.xml

**File**: `android/app/src/main/AndroidManifest.xml`

**Location**: Insert after the `</activity>` closing tag, before `<meta-data>`.

**Add this XML**:
```xml
<!-- SMS Receiver for background SMS detection -->
<receiver android:name="com.shounakmulay.telephony.sms.IncomingSmsReceiver"
    android:permission="android.permission.BROADCAST_SMS"
    android:exported="true">
    <intent-filter>
        <action android:name="android.provider.Telephony.SMS_RECEIVED"/>
    </intent-filter>
</receiver>
```

---

### Change 2: Fix Isar Schema List in Background Handler

**File**: `lib/data/services/sms_listener_service.dart`

**Step 2a**: Add missing imports at the top of the file (after line 9):

```dart
import '../models/transaction_model.dart';
import '../models/category_model.dart';
import '../models/budget_model.dart';
import '../models/wallet_model.dart';
import '../models/recurring_transaction_model.dart';
import '../models/savings_goal_model.dart';
import '../models/installment_provider_model.dart';
import '../models/installment_plan_model.dart';
```

**Step 2b**: Update the Isar.open() call in `backgroundSmsHandler` (around line 26-30):

**Before**:
```dart
final isar = await Isar.open(
  [DetectedSmsSchema, AppSettingsSchema],
  directory: dir.path,
  name: 'flowspend',
);
```

**After**:
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

---

### Change 3: Fix hasPermission() Method

**File**: `lib/data/services/sms_listener_service.dart`

**Step 3a**: Add import at top of file:

```dart
import 'package:permission_handler/permission_handler.dart';
```

**Step 3b**: Replace the `hasPermission()` method (around line 155-159):

**Before**:
```dart
static Future<bool> hasPermission() async {
  // Check current status without triggering request
  final status = await _telephony.requestPhoneAndSmsPermissions;
  return status ?? false;
}
```

**After**:
```dart
static Future<bool> hasPermission() async {
  final status = await Permission.sms.status;
  return status.isGranted;
}
```

---

## Verification Steps

### Step 1: Clean Build

```bash
flutter clean
flutter pub get
flutter build apk
```

### Step 2: Install and Grant Permission

1. Install app on device/emulator
2. Go to Settings > General (عام)
3. Enable "قراءة SMS" toggle
4. Grant SMS permission when prompted

### Step 3: Test Foreground Detection

1. Keep app open
2. Send test SMS: `Purchase EGP 150.00 at Store`
3. Verify notification appears
4. Check SMS inbox screen shows the detected SMS

### Step 4: Test Background Detection

1. Enable SMS parsing in settings
2. Minimize app or force-stop it
3. Send test SMS: `تم خصم مبلغ 500 جنيه من حسابك`
4. Verify notification appears
5. Open app and check SMS inbox

### Step 5: Test Notification Deep Link

1. When notification appears, tap it
2. Verify it opens the SMS confirmation screen for that specific SMS

---

## Test SMS Patterns

Use ADB to send test SMS:

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

## Troubleshooting

### SMS not detected

1. Check logcat for errors: `adb logcat -d | grep -E "SMS|Telephony|Isar"`
2. Verify BroadcastReceiver is in manifest
3. Verify SMS permission is granted in system settings
4. Verify `smsParsingEnabled` is true in app settings

### Background handler crashes

1. Check logcat: `adb logcat -d | grep "backgroundSmsHandler"`
2. Verify all 10 Isar schemas are in the open() call
3. The error will show schema mismatch if schemas don't match

### Permission dialog shows unexpectedly

1. Verify `hasPermission()` uses `Permission.sms.status`
2. Should NOT use `_telephony.requestPhoneAndSmsPermissions` for status checks

---

## Summary

| File | Changes |
|------|---------|
| `AndroidManifest.xml` | Add BroadcastReceiver declaration |
| `sms_listener_service.dart` | Add imports, fix Isar schemas, fix hasPermission() |

Total: **2 files**, **~30 lines changed**
