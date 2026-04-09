# Research: SMS Auto-Read and Transaction Notifications

**Feature**: 002-sms-read-notify
**Date**: 2026-04-08

## Research Areas

### 1. Telephony Package for Background SMS Listening

**Decision**: Use `telephony` package (already in pubspec.yaml at version 0.2.0)

**Rationale**:
- Already a project dependency, no new package needed
- Provides `Telephony.instance.listenIncomingSms()` for real-time SMS monitoring
- Supports background message handler for when app is killed
- Handles SMS permission requests via `requestSmsPermissions()`

**Alternatives Considered**:
- `flutter_sms_inbox`: Read-only, no real-time listening capability
- `sms_advanced`: Deprecated, less maintained
- Native Android code via platform channels: Unnecessary complexity

**Implementation Notes**:
```dart
// Background handler must be top-level function
@pragma('vm:entry-point')
void backgroundMessageHandler(SmsMessage message) async {
  // Process SMS in background
}

// Foreground listener
Telephony.instance.listenIncomingSms(
  onNewMessage: (SmsMessage message) { /* handle */ },
  onBackgroundMessage: backgroundMessageHandler,
);
```

### 2. Android Permissions for SMS

**Decision**: Use `permission_handler` (already at version 11.3.0) + telephony's built-in permission methods

**Rationale**:
- `permission_handler` provides unified permission API
- Telephony package can also request SMS permissions directly
- Need `RECEIVE_SMS` and `READ_SMS` permissions in AndroidManifest.xml

**Required AndroidManifest.xml additions**:
```xml
<uses-permission android:name="android.permission.RECEIVE_SMS"/>
<uses-permission android:name="android.permission.READ_SMS"/>
```

**Permission flow**:
1. Check permission status with `Permission.sms.status`
2. Show custom dialog explaining why SMS access is needed
3. Request permission with `Permission.sms.request()`
4. Handle permanent denial (open app settings)

### 3. Background Processing When App Killed

**Decision**: Use telephony's background message handler with Android BroadcastReceiver

**Rationale**:
- Telephony package registers a BroadcastReceiver that survives app termination
- Background handler runs in isolate, limited to quick operations
- For full processing, can schedule work or store for later

**Constraints**:
- Background handler must be top-level (not class method)
- Cannot access Flutter engine or UI in background
- Should store detected SMS to Isar for later processing
- Notification can be shown from background via flutter_local_notifications

### 4. Notification Deep Linking

**Decision**: Use notification payload to pass detected transaction ID, handle in notification click callback

**Rationale**:
- flutter_local_notifications supports payload parameter
- Initialize with `onDidReceiveNotificationResponse` callback
- Parse payload to get transaction ID and navigate to confirmation screen

**Implementation Notes**:
```dart
// When showing notification
await NotificationService.show(
  id: transactionId.hashCode,
  title: 'معاملة جديدة',
  body: 'تم خصم 500 جنيه من CIB',
  payload: transactionId, // Pass ID for deep linking
);

// In notification initialization
_plugin.initialize(
  settings,
  onDidReceiveNotificationResponse: (details) {
    // Navigate to confirmation screen with payload
    navigatorKey.currentState?.pushNamed(
      AppRouter.smsConfirmation,
      arguments: details.payload,
    );
  },
);
```

### 5. Isar Initialization in Background Isolate

**Decision**: Open separate Isar instance in background handler

**Rationale**:
- Background handler runs in different isolate
- Cannot share Isar instance across isolates
- Must open Isar with same schemas and path in background

**Implementation Notes**:
```dart
@pragma('vm:entry-point')
void backgroundMessageHandler(SmsMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [DetectedSmsSchema, AppSettingsSchema],
    directory: dir.path,
  );
  // Now can read settings and save detected SMS
}
```

### 6. Battery Optimization Handling

**Decision**: Document battery optimization guidance, provide settings deep link

**Rationale**:
- Android may kill background services for battery optimization
- App should work out-of-box but may miss SMS on aggressive OEMs (Xiaomi, Huawei)
- Can't programmatically disable optimization, must guide user

**User Guidance**:
- Show one-time info dialog about battery optimization
- Provide button to open device battery settings
- Store flag in AppSettings to not show again

## Resolved Clarifications

All technical decisions made based on research. No NEEDS CLARIFICATION markers remain.

## Dependencies

| Dependency | Version | Purpose | Already In Project |
|------------|---------|---------|-------------------|
| telephony | 0.2.0 | SMS listening | ✅ Yes |
| flutter_local_notifications | 17.0.0 | Transaction notifications | ✅ Yes |
| permission_handler | 11.3.0 | SMS permission flow | ✅ Yes |
| isar | 3.1.0+1 | Store detected transactions | ✅ Yes |

No new dependencies required.
