# Localization API Contract

**Feature**: 008-english-translations
**Type**: Internal UI Contract
**Date**: 2026-04-09

## Overview

This contract defines how localized strings are accessed throughout the FlowSpend app. It ensures consistent usage patterns and type-safe string access.

## Access Pattern

### Primary Access Method

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// In any widget with BuildContext:
final l10n = AppLocalizations.of(context)!;

// Usage:
Text(l10n.nav_home)
Text(l10n.screen_settings)
Text(l10n.button_save)
```

### Extension Helper (Optional)

```dart
// lib/core/extensions/context_extensions.dart
extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

// Usage:
Text(context.l10n.nav_home)
```

## String Key Conventions

### Naming Format

```
{scope}_{descriptor}
```

| Scope | Purpose | Examples |
|-------|---------|----------|
| `nav_` | Bottom navigation, tab labels | `nav_home`, `nav_transactions` |
| `screen_` | Screen/page titles | `screen_settings`, `screen_reports` |
| `button_` | Button labels, actions | `button_save`, `button_cancel`, `button_delete` |
| `label_` | Form field labels | `label_amount`, `label_category`, `label_date` |
| `hint_` | Placeholder/hint text | `hint_search`, `hint_enter_amount` |
| `error_` | Error messages | `error_required`, `error_invalid_amount` |
| `empty_` | Empty state messages | `empty_transactions`, `empty_goals` |
| `badge_` | Gamification badges | `badge_first_transaction`, `badge_streak_7` |
| `category_` | Default category names | `category_food`, `category_transport` |
| `date_` | Relative date strings | `date_today`, `date_yesterday` |
| `onboarding_` | Onboarding screen content | `onboarding_welcome_title` |
| `common_` | Reusable common strings | `common_loading`, `common_retry` |
| `dialog_` | Dialog titles/content | `dialog_confirm_delete`, `dialog_unsaved_changes` |

### Descriptors

- Use snake_case
- Be specific: `button_add_transaction` not `button_add`
- Include context: `empty_transactions_this_month` not just `empty`

## String Categories

### Navigation (5 strings)

```json
{
  "nav_home": "Home",
  "nav_transactions": "Transactions",
  "nav_installments": "Installments",
  "nav_budgets": "Budgets",
  "nav_settings": "Settings"
}
```

### Buttons (~20 strings)

```json
{
  "button_save": "Save",
  "button_cancel": "Cancel",
  "button_delete": "Delete",
  "button_add": "Add",
  "button_edit": "Edit",
  "button_skip": "Skip",
  "button_next": "Next",
  "button_start_now": "Start Now",
  "button_confirm": "Confirm",
  "button_retry": "Retry"
}
```

### Errors (~10 strings)

```json
{
  "error_required_field": "This field is required",
  "error_invalid_amount": "Invalid amount",
  "error_generic": "Something went wrong",
  "error_no_permission": "Permission denied"
}
```

### Badges (7 strings)

```json
{
  "badge_first_transaction": "First Transaction",
  "badge_streak_7": "7 Day Streak",
  "badge_streak_30": "30 Day Streak",
  "badge_first_goal": "First Goal Completed",
  "badge_budget_month": "Budget Champion",
  "badge_first_plan_done": "Debt Free",
  "badge_no_new_installments": "3 Months No New Debt"
}
```

## Parameterized Strings

### Placeholders

```json
{
  "welcome_user": "Welcome, {name}!",
  "@welcome_user": {
    "placeholders": {
      "name": { "type": "String" }
    }
  }
}
```

Usage:
```dart
l10n.welcome_user('Ahmed') // "Welcome, Ahmed!"
```

### Plurals

```json
{
  "days_remaining": "{count, plural, =0{No days left} =1{1 day left} other{{count} days left}}",
  "@days_remaining": {
    "placeholders": {
      "count": { "type": "int" }
    }
  }
}
```

Usage:
```dart
l10n.days_remaining(5) // "5 days left"
```

## Locale Provider Contract

### Provider Definition

```dart
// Must watch AppSettings.language
final localeProvider = Provider<Locale>((ref) {
  final settings = ref.watch(appSettingsProvider).valueOrNull;
  return Locale(settings?.language ?? 'ar');
});
```

### Supported Locales

```dart
static const supportedLocales = [
  Locale('ar'), // Arabic (default)
  Locale('en'), // English
];
```

### Language Switching

```dart
// In SettingsRepo or via provider
Future<void> setLanguage(String langCode) async {
  assert(langCode == 'ar' || langCode == 'en');
  final settings = await get();
  settings.language = langCode;
  await _isar.writeTxn(() => _isar.appSettings.put(settings));
}
```

## Date Formatting Contract

### AppDateUtils Interface

```dart
class AppDateUtils {
  /// Format relative date based on current locale
  static String formatRelative(DateTime date, String locale) {
    // Returns "Today", "Yesterday", "2 days ago" etc.
  }

  /// Format full date based on locale
  static String formatDate(DateTime date, String locale) {
    // locale == 'ar': "٩ أبريل ٢٠٢٦"
    // locale == 'en': "April 9, 2026"
  }

  /// Format month/year
  static String formatMonth(DateTime date, String locale) {
    // locale == 'ar': "أبريل ٢٠٢٦"
    // locale == 'en': "April 2026"
  }
}
```

## Validation Rules

1. **All visible strings** must use `AppLocalizations` - no hardcoded text
2. **String keys** must follow naming conventions above
3. **Both ARB files** must have identical keys (no missing translations)
4. **Placeholders** must be documented with `@key` metadata
5. **Direction-sensitive widgets** must use `EdgeInsetsDirectional` and `AlignmentDirectional`
