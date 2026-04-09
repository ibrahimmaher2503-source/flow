# Data Model: Fix SMS Reading Functionality

**Feature**: 006-fix-sms-reading
**Date**: 2026-04-09

## Overview

This is a bug fix feature. No data model changes are required. This document describes the existing entities involved in SMS reading functionality for reference.

---

## Existing Entities (No Changes)

### DetectedSms

Represents a bank SMS message that was automatically detected and parsed.

| Field | Type | Description |
|-------|------|-------------|
| id | int | Auto-increment primary key |
| amount | double | Parsed transaction amount |
| type | string | 'debit' or 'credit' |
| bank | string | Bank identifier (CIB, NBE, BM, etc.) |
| rawBody | string | Original SMS text |
| timestamp | DateTime | When SMS was received (indexed) |
| status | string | 'pending', 'confirmed', or 'dismissed' (indexed) |
| confirmedAt | DateTime? | When user confirmed (nullable) |
| transactionId | string? | UUID of created transaction (nullable) |
| categoryId | int? | Category selected by user (nullable) |

**State Transitions**:
```
pending → confirmed (user creates transaction)
pending → dismissed (user rejects SMS)
```

---

### AppSettings

Singleton settings for the app (id=0).

| Field | Type | Description |
|-------|------|-------------|
| id | int | Always 0 (singleton) |
| currency | string | Currency code (default: 'EGP') |
| language | string | Language code (default: 'ar') |
| monthStartDay | int | Budget month start day (default: 1) |
| smsParsingEnabled | bool | Enable SMS auto-detection (default: false) |
| notificationsEnabled | bool | Enable local notifications (default: true) |
| streakDays | int | Current logging streak |
| ... | ... | Other settings fields |

---

## All Isar Collections (10 Total)

These collections must ALL be registered when opening Isar:

1. **Transaction** - Main financial transaction records
2. **Category** - Expense/income categories
3. **Budget** - Monthly budget allocations
4. **Wallet** - Wallet/account definitions
5. **RecurringTransaction** - Recurring expense rules
6. **SavingsGoal** - Savings target definitions
7. **InstallmentProvider** - Installment vendor info
8. **InstallmentPlan** - Active installment agreements
9. **AppSettings** - Singleton app settings
10. **DetectedSms** - Detected bank SMS records

---

## Schema Registration Requirement

The fix requires registering all 10 schemas in the background SMS handler. This is a code-level fix, not a data model change.

**Before (broken)**:
```dart
[DetectedSmsSchema, AppSettingsSchema]  // Only 2
```

**After (fixed)**:
```dart
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
]  // All 10
```

---

## No Database Migrations Needed

Since we're only fixing how the database is opened (not changing schemas), no data migrations are required.
