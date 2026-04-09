# Data Model: Add English Translations

**Feature**: 008-english-translations
**Date**: 2026-04-09

## Entity Changes

### AppSettings (Existing - Modified)

The `language` field already exists but is not actively used. It will now drive the app locale.

| Field | Type | Description | Validation |
|-------|------|-------------|------------|
| language | String | Locale code ("ar" or "en") | Must be "ar" or "en"; defaults to "ar" |

**Behavior**:
- On app launch, read `language` from AppSettings
- When user changes language in Settings, update `language` and persist
- App rebuilds with new locale immediately

### CategoryModel (Existing - Modified)

Add optional `nameKey` field for localizable default categories.

| Field | Type | Description | Validation |
|-------|------|-------------|------------|
| nameKey | String? | Localization key (e.g., "category_food") | Optional; null for user-created categories |

**Display Logic**:
```
if (category.nameKey != null) {
  display = AppLocalizations.of(context).[nameKey]
} else {
  display = category.name  // User-created, show as-is
}
```

## New Entities

### Locale (Flutter Built-in)

Not stored in database. Derived from AppSettings.language at runtime.

| Property | Type | Description |
|----------|------|-------------|
| languageCode | String | "ar" or "en" |

### Translation Strings (ARB Files)

Not database entities. Stored as JSON-like ARB files at compile time.

**File**: `lib/l10n/app_ar.arb` (Arabic - existing strings)
**File**: `lib/l10n/app_en.arb` (English - new translations)

**String Categories**:
| Prefix | Purpose | Examples |
|--------|---------|----------|
| `nav_` | Navigation labels | nav_home, nav_transactions |
| `screen_` | Screen titles | screen_settings, screen_reports |
| `button_` | Button labels | button_save, button_cancel |
| `label_` | Form labels | label_amount, label_category |
| `error_` | Error messages | error_generic, error_required |
| `empty_` | Empty state messages | empty_transactions, empty_goals |
| `badge_` | Badge names | badge_first_transaction, badge_streak_7 |
| `category_` | Default category names | category_food, category_transport |
| `date_` | Relative date strings | date_today, date_yesterday |
| `onboarding_` | Onboarding content | onboarding_welcome_title |

## State Relationships

```
┌─────────────────┐
│   AppSettings   │
│   (Isar DB)     │
│  language: "en" │
└────────┬────────┘
         │ read on launch / write on change
         ▼
┌─────────────────┐
│  localeProvider │
│   (Riverpod)    │
│  Locale('en')   │
└────────┬────────┘
         │ watch
         ▼
┌─────────────────┐      ┌─────────────────┐
│   MaterialApp   │ ───► │ AppLocalizations│
│  locale: en     │      │ generated class │
└─────────────────┘      └─────────────────┘
```

## Migration Notes

### Existing Data Compatibility

1. **AppSettings.language**: Already exists with default "ar". No migration needed.
2. **CategoryModel.nameKey**: New nullable field. Existing categories retain null nameKey.

### Default Category Migration

When the app initializes default categories (first launch), assign `nameKey` values:

| Current Arabic Name | nameKey |
|---------------------|---------|
| اكل وشرب | category_food |
| مواصلات | category_transport |
| فواتير | category_bills |
| صحة | category_health |
| ترفيه | category_entertainment |
| ملابس | category_clothing |
| هدايا | category_gifts |
| مرتب | category_salary |
| فريلانس | category_freelance |
| أخرى | category_other |
| ... | ... |

**Note**: User-created categories after installation will have `nameKey = null` and display their original `name` regardless of app language.
