# Quickstart: Add English Translations

**Feature**: 008-english-translations
**Date**: 2026-04-09

## Overview

Add English language support to FlowSpend, enabling users to switch between Arabic (default) and English. The app will dynamically update all UI text, date formatting, and text direction (RTL↔LTR) based on the selected language.

## Prerequisites

- Flutter SDK (already configured)
- Existing `intl` package (already in pubspec.yaml)
- Understanding of FlowSpend's Riverpod state management

## Quick Setup Steps

### 1. Add Dependencies

```yaml
# pubspec.yaml - add to dependencies:
flutter_localizations:
  sdk: flutter

# Enable code generation in flutter section:
flutter:
  generate: true
```

### 2. Create Localization Config

```yaml
# l10n.yaml (create in project root)
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

### 3. Create ARB Files

```
lib/l10n/
├── app_ar.arb  # Arabic translations (~200 strings)
└── app_en.arb  # English translations (~200 strings)
```

### 4. Add Locale Provider

```dart
// lib/providers/locale_provider.dart
final localeProvider = Provider<Locale>((ref) {
  final settings = ref.watch(appSettingsProvider).valueOrNull;
  final lang = settings?.language ?? 'ar';
  return Locale(lang);
});
```

### 5. Update MaterialApp

```dart
// lib/app.dart
return MaterialApp(
  locale: ref.watch(localeProvider),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  // Remove hardcoded Directionality wrapper
);
```

### 6. Replace Hardcoded Strings

```dart
// Before:
Text('الإعدادات')

// After:
Text(AppLocalizations.of(context)!.screen_settings)
```

## Key Files to Modify

| File | Changes |
|------|---------|
| `pubspec.yaml` | Add flutter_localizations, enable generate |
| `l10n.yaml` | Create localization config |
| `lib/l10n/app_*.arb` | Create translation files |
| `lib/app.dart` | Add locale support, remove RTL wrapper |
| `lib/providers/locale_provider.dart` | New provider |
| `lib/features/settings/widgets/preferences_section.dart` | Add language selector |
| All screen files | Replace hardcoded Arabic strings |
| `lib/core/utils/app_date_utils.dart` | Add locale-aware formatting |
| `lib/providers/gamification_provider.dart` | Use translation keys for badges |

## Estimated Effort

| Phase | Effort |
|-------|--------|
| Infrastructure setup | 1-2 hours |
| ARB file creation (~200 strings) | 2-3 hours |
| Screen-by-screen migration | 4-6 hours |
| Testing & direction fixes | 2-3 hours |
| **Total** | **9-14 hours** |

## Testing Checklist

- [ ] Language switches without app restart
- [ ] Arabic RTL layout preserved
- [ ] English LTR layout correct
- [ ] Dates format correctly in both languages
- [ ] All screens display translated text
- [ ] No layout breaks in either direction
- [ ] Language persists across sessions
- [ ] Default categories show correct language

## Common Gotchas

1. **EdgeInsets vs EdgeInsetsDirectional**: Replace `EdgeInsets.only(left:)` with `EdgeInsetsDirectional.only(start:)` for proper RTL/LTR
2. **Icons with direction**: Some icons (arrows, chevrons) may need `Directionality.of(context)` checks
3. **Text overflow**: English text may be longer than Arabic - test for overflow
4. **Code generation**: Run `flutter gen-l10n` after modifying ARB files
