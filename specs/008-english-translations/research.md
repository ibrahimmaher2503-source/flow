# Research: Add English Translations

**Feature**: 008-english-translations
**Date**: 2026-04-09

## Research Questions

### 1. Flutter Localization Approach

**Question**: What is the best approach for adding localization to an existing Flutter app?

**Decision**: Use Flutter's official `flutter_localizations` package with ARB (Application Resource Bundle) files.

**Rationale**:
- Official Flutter solution, well-documented and maintained
- ARB format is human-readable JSON-like structure
- Supports plurals, placeholders, and date/number formatting
- Code generation creates type-safe access to strings via `AppLocalizations.of(context)`
- Already uses `intl` package (in pubspec.yaml) which integrates well

**Alternatives Considered**:
- **easy_localization**: Third-party, more features but adds dependency bloat
- **GetX localization**: Requires adopting GetX state management
- **Manual string maps**: No type safety, harder to maintain

### 2. Dynamic Language Switching Without Restart

**Question**: How to switch language at runtime without requiring app restart?

**Decision**: Use Riverpod to manage locale state. Update `MaterialApp.locale` reactively when user changes preference.

**Rationale**:
- App already uses Riverpod extensively for state management
- `localeProvider` can watch `AppSettings.language` and update reactively
- `MaterialApp` rebuilds when `locale` property changes
- Text direction handled automatically by Flutter when locale changes

**Implementation Pattern**:
```dart
// In app.dart
final locale = ref.watch(localeProvider); // returns Locale('ar') or Locale('en')
return MaterialApp(
  locale: locale,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
);
```

### 3. RTL/LTR Direction Handling

**Question**: How to properly handle text direction when switching between Arabic (RTL) and English (LTR)?

**Decision**: Remove hardcoded `Directionality(textDirection: TextDirection.rtl)` wrapper and let Flutter handle direction based on locale.

**Rationale**:
- Currently the app forces RTL in `app.dart` builder
- Flutter automatically sets text direction based on locale (ar = RTL, en = LTR)
- Material widgets adapt automatically (padding, alignment, icons)
- `AlignmentDirectional` and `EdgeInsetsDirectional` already used in some places

**Changes Required**:
- Remove `Directionality` wrapper from `app.dart`
- Audit widgets for hardcoded RTL assumptions
- Replace `EdgeInsets` with `EdgeInsetsDirectional` where directional

### 4. Category Name Localization Strategy

**Question**: How to handle seeded category names that are currently hardcoded in Arabic?

**Decision**: Store category `nameKey` (e.g., "category_food") in database. Display localized name via `AppLocalizations.of(context).category_food`.

**Rationale**:
- Categories are seeded on first launch in `default_categories.dart`
- Current design stores Arabic names directly in Isar
- User-created categories keep their original names (not localized)
- Default categories get localization keys; existing data migrated to keys

**Migration Approach**:
1. Add `nameKey` field to CategoryModel (nullable, for backwards compatibility)
2. Default categories use keys like `category_food`, `category_transport`
3. UI checks: if `nameKey` exists, show localized; else show `name` directly
4. Existing user data unaffected (nameKey stays null)

### 5. Date Formatting by Locale

**Question**: How to format dates according to selected language?

**Decision**: Update `AppDateUtils` to accept locale parameter. Use `DateFormat` with locale-aware patterns.

**Rationale**:
- `intl` package already included and supports locale-aware date formatting
- Arabic relative dates ("النهاردة", "إمبارح") need English equivalents ("Today", "Yesterday")
- Month names and day formats differ by locale

**Changes to AppDateUtils**:
```dart
static String formatRelative(DateTime date, String locale) {
  final diff = _daysDiff(date);
  if (diff == 0) return locale == 'ar' ? 'النهاردة' : 'Today';
  if (diff == 1) return locale == 'ar' ? 'إمبارح' : 'Yesterday';
  // ...
}
```

### 6. Translation File Organization

**Question**: How to organize translation strings for maintainability?

**Decision**: Single ARB file per language at `lib/l10n/app_ar.arb` and `lib/l10n/app_en.arb`.

**Rationale**:
- App is not extremely large (~15 screens)
- Single file per language easier to manage than split files
- Flutter's gen-l10n tool expects this structure
- Namespacing via prefixes: `nav_*`, `screen_*`, `button_*`, `error_*`, `badge_*`

**ARB Structure**:
```json
{
  "@@locale": "en",
  "nav_home": "Home",
  "nav_transactions": "Transactions",
  "screen_dashboard_title": "Dashboard",
  "button_save": "Save",
  "error_generic": "Something went wrong",
  "badge_first_transaction": "First Transaction"
}
```

## Technical Findings

### Current Translation Touchpoints

| Area | Files | String Count (Est.) |
|------|-------|---------------------|
| Navigation | app.dart | 5 labels |
| Settings | settings_screen.dart, preferences_section.dart | ~30 strings |
| Onboarding | onboarding_screen.dart | ~15 strings |
| Dashboard | dashboard widgets (6 files) | ~25 strings |
| Transactions | add_transaction_screen.dart, filter_bar.dart, transaction_tile.dart | ~20 strings |
| Budgets | budgets_screen.dart, budget_progress_card.dart | ~10 strings |
| Goals | goals_screen.dart, goal_card.dart | ~10 strings |
| Reports | reports_screen.dart, chart widgets | ~15 strings |
| Installments | installments_hub_screen.dart, installment widgets | ~20 strings |
| Gamification | gamification_provider.dart (badges) | 7 badge names |
| Empty States | empty_state.dart usages | ~10 strings |
| Date Utils | app_date_utils.dart | 5 relative date strings |
| Categories | default_categories.dart | 24 category names |
| **Total** | | **~200 strings** |

### Existing Infrastructure

- `AppSettings.language` field exists (currently unused, defaults to 'ar')
- `intl` package already in pubspec.yaml
- Riverpod state management ready for locale provider
- Cairo font supports both Arabic and English glyphs

## Recommendations

1. **Use flutter_localizations + gen-l10n**: Standard Flutter approach, minimal dependencies
2. **Add localeProvider**: Riverpod provider that maps AppSettings.language to Locale
3. **Incremental migration**: Start with navigation/shell, then screen by screen
4. **Keep existing Arabic as fallback**: If key missing, show Arabic (graceful degradation)
5. **Test both directions**: Verify layouts work in both RTL and LTR modes
