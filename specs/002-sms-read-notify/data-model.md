# Data Model: SMS Auto-Read and Transaction Notifications

**Feature**: 002-sms-read-notify
**Date**: 2026-04-08

## Entities

### DetectedSms

Represents a bank SMS that was automatically detected and parsed, pending user confirmation.

| Field | Type | Description | Constraints |
|-------|------|-------------|-------------|
| id | int (auto) | Isar auto-increment ID | Primary key |
| amount | double | Transaction amount in EGP | Required, > 0 |
| type | String | Transaction type | 'debit' or 'credit' |
| bank | String | Source bank name | Required (CIB, NBE, BM, Vodafone, Instapay, Souhoola, Valu) |
| rawBody | String | Original SMS text | Required for debugging/re-parsing |
| timestamp | DateTime | When SMS was received | Required, indexed |
| status | String | Confirmation status | 'pending', 'confirmed', 'dismissed' |
| confirmedAt | DateTime? | When user confirmed/dismissed | Nullable |
| transactionId | String? | Linked Transaction ID if confirmed | Nullable, FK to Transaction |
| categoryId | int? | Selected category when confirming | Nullable |

**Indexes**:
- `timestamp` - For chronological listing
- `status` - For filtering pending vs confirmed
- Composite `[status, timestamp]` - For "pending transactions" queries

**Relationships**:
- Optional link to `Transaction` (created when user confirms)
- Optional link to `Category` (selected during confirmation)

### AppSettings (Existing - Extended)

The existing `AppSettings` model already has `smsParsingEnabled` and `notificationsEnabled` fields. No schema changes needed.

| Existing Field | Type | Description |
|---------------|------|-------------|
| smsParsingEnabled | bool | Whether SMS auto-detection is on |
| notificationsEnabled | bool | Whether notifications are enabled |

**New field consideration**: Could add `smsNotificationsEnabled` for granular control, but spec says FR-007 allows disabling transaction notifications separately. Current `notificationsEnabled` covers all notifications.

**Decision**: Use existing fields. `notificationsEnabled` controls all notifications including SMS transaction alerts. Users can keep SMS parsing on (for inbox display) while disabling notifications.

## State Transitions

### DetectedSms Status Flow

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│  SMS Received ──► PENDING ───┬──► CONFIRMED ──► Transaction │
│                              │                    Created   │
│                              │                              │
│                              └──► DISMISSED ──► Archived    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Status Values**:
- `pending`: SMS detected and parsed, awaiting user action
- `confirmed`: User confirmed and categorized, Transaction created
- `dismissed`: User dismissed, archived but kept for history

## Isar Schema

```dart
import 'package:isar/isar.dart';

part 'detected_sms_model.g.dart';

@collection
class DetectedSms {
  Id id = Isar.autoIncrement;

  double amount = 0;
  String type = 'debit'; // 'debit' | 'credit'
  String bank = '';
  String rawBody = '';

  @Index()
  DateTime timestamp = DateTime.now();

  @Index()
  String status = 'pending'; // 'pending' | 'confirmed' | 'dismissed'

  DateTime? confirmedAt;
  String? transactionId;
  int? categoryId;
}
```

## Validation Rules

| Field | Rule | Error Message |
|-------|------|---------------|
| amount | Must be > 0 | "Invalid transaction amount" |
| type | Must be 'debit' or 'credit' | "Invalid transaction type" |
| bank | Must be non-empty | "Bank name required" |
| rawBody | Must be non-empty | "SMS body required" |
| status | Must be valid enum value | "Invalid status" |

## Query Patterns

| Query | Purpose | Implementation |
|-------|---------|----------------|
| getPending() | Show pending transactions | `where().statusEqualTo('pending').sortByTimestampDesc()` |
| getByDateRange(start, end) | Inbox view filtering | `where().timestampBetween(start, end)` |
| getConfirmed() | History of confirmed | `where().statusEqualTo('confirmed')` |
| countPending() | Badge count | `where().statusEqualTo('pending').count()` |
| getRecent(limit) | Dashboard quick view | `where().sortByTimestampDesc().limit(limit)` |

## Migration Notes

- This is a new collection, no migration from existing data needed
- Run `flutter pub run build_runner build --delete-conflicting-outputs` after creating model
- Register `DetectedSmsSchema` in `isar_service.dart` schema list
