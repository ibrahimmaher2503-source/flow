# Quickstart: SMS Auto-Read and Transaction Notifications

**Feature**: 002-sms-read-notify
**Date**: 2026-04-08

## Test Scenarios

### Manual Testing on Real Device

**Prerequisites**:
- Physical Android device (emulator cannot receive real SMS)
- SIM card that can receive SMS
- Bank account with SMS notifications enabled (CIB, NBE, BM, Vodafone Cash, Instapay, Souhoola, or Valu)

### Scenario 1: First-Time Permission Flow (US4)

1. Fresh install or clear app data
2. Open app → Navigate to Settings or trigger SMS-related action
3. **Expected**: Permission dialog appears with Arabic explanation
4. Tap "Allow" → **Expected**: Permission granted, SMS toggle enabled
5. OR Tap "Deny" → **Expected**: App continues without SMS features, toggle disabled

### Scenario 2: SMS Auto-Detection (US1)

1. Grant SMS permission
2. Enable SMS parsing in Settings (should be on by default)
3. Trigger a bank transaction (make a small purchase, transfer, etc.)
4. Wait for bank SMS
5. **Expected**: Within 5 seconds, app detects and parses the SMS
6. Check SMS Inbox screen → **Expected**: Transaction appears with amount, type, bank

### Scenario 3: Transaction Notification (US2)

1. SMS permission granted, notifications enabled
2. Receive bank SMS
3. **Expected**: Notification appears with Arabic text: "تم خصم [amount] جنيه من [bank]"
4. Notification shows correct amount and bank name
5. Kill app and repeat → **Expected**: Notification still appears (background processing)

### Scenario 4: Quick Confirmation via Notification Tap (US3)

1. Receive transaction notification
2. Tap notification
3. **Expected**: App opens to confirmation screen with pre-filled data
4. **Expected**: Amount, type (debit/credit), and bank are pre-filled
5. Select category → Tap confirm
6. **Expected**: Transaction saved, appears in Transactions screen
7. Go to SMS Inbox → **Expected**: Transaction status changed to "confirmed"

### Scenario 5: Dismiss Transaction (US3)

1. Tap transaction notification
2. On confirmation screen, tap "Dismiss" or back
3. **Expected**: Transaction NOT saved to main records
4. SMS Inbox shows transaction as "dismissed"

### Scenario 6: Notifications Disabled (US2)

1. Settings → Disable notifications
2. Receive bank SMS
3. **Expected**: No notification appears
4. **Expected**: SMS still detected and appears in SMS Inbox

### Scenario 7: SMS Parsing Disabled (US4)

1. Settings → Disable SMS parsing
2. Receive bank SMS
3. **Expected**: No notification, no detection
4. SMS Inbox remains unchanged

### Scenario 8: Non-Financial SMS Ignored (US1 Edge Case)

1. SMS permission granted, parsing enabled
2. Receive non-financial SMS (personal message, promo, etc.)
3. **Expected**: No notification, SMS not in inbox
4. App does not crash or show error

### Scenario 9: App Killed Background Processing (Edge Case)

1. Grant permissions, enable all features
2. Force kill the app
3. Receive bank SMS
4. **Expected**: Notification appears even with app killed
5. Open app → **Expected**: Transaction visible in SMS Inbox

### Scenario 10: Unsupported Bank SMS (Edge Case)

1. Receive SMS from unsupported bank format
2. **Expected**: No notification, not added to inbox
3. No crash or error

## Development Testing

### Simulating Bank SMS (for testing without real transactions)

Use ADB to send test SMS:

```bash
# CIB Purchase
adb emu sms send 1234 "Purchase EGP 150.50 at Store Name"

# NBE Transaction
adb emu sms send 1234 "مبلغ 500.00 جنيه"

# BM Debit
adb emu sms send 1234 "تم خصم 200.75"

# BM Credit
adb emu sms send 1234 "تم إضافة 1000"

# Vodafone Cash
adb emu sms send 1234 "تم تحويل 300 جنيه"

# Instapay
adb emu sms send 1234 "Amount: 750.00 EGP transferred"

# Invalid (should be ignored)
adb emu sms send 1234 "Hello, this is a regular message"
```

### Unit Test Patterns

```dart
// Test SmsParserService
test('parses CIB purchase correctly', () {
  final result = SmsParserService.parse('Purchase EGP 150.50 at Store');
  expect(result?.amount, 150.50);
  expect(result?.type, 'debit');
  expect(result?.bank, 'CIB');
});

// Test notification preferences
test('respects notification disabled setting', () async {
  await settingsRepo.update(settings..notificationsEnabled = false);
  await smsListener.onNewSms(mockBankSms);
  verify(notificationService.show(any)).never;
});
```

## Verification Checklist

- [ ] SMS permission flow shows Arabic explanation
- [ ] Permission denial handled gracefully (no crash)
- [ ] Bank SMS parsed correctly (all 7 banks)
- [ ] Non-financial SMS ignored
- [ ] Notification appears within 5 seconds
- [ ] Notification text in Arabic with correct amount
- [ ] Tap notification opens confirmation screen
- [ ] Confirmation screen pre-fills data correctly
- [ ] Category selection and confirm saves transaction
- [ ] Dismiss does not save transaction
- [ ] Background processing works (app killed)
- [ ] Settings toggles respected
- [ ] No SMS data leaves device (check network)
