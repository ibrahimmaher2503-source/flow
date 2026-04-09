# Implementation Plan: Add English Translations

**Branch**: `008-english-translations` | **Date**: 2026-04-09 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/008-english-translations/spec.md`

## Summary

Add English language support to FlowSpend, enabling users to switch between Arabic (default, RTL) and English (LTR) at runtime. Uses Flutter's official localization system with ARB files for type-safe string access. Approximately 200 strings across 15+ screens need translation, including navigation, forms, badges, dates, and default category names.

## Technical Context

**Language/Version**: Dart 3.9 / Flutter 3.x
**Primary Dependencies**: flutter_localizations (SDK), intl (existing), flutter_riverpod 2.4.0 (existing)
**Storage**: Isar (existing) - language preference stored in AppSettings.language
**Testing**: flutter test (widget tests for locale switching)
**Target Platform**: Android (primary), iOS (secondary)
**Project Type**: Mobile app (Flutter)
**Performance Goals**: Language switch < 1 second, no app restart required
**Constraints**: Offline-capable (no network for translations), ~200 translatable strings
**Scale/Scope**: 15+ screens, 7 badges, 24 default categories, date formatting

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The project constitution is a template without specific rules defined. No gates to enforce.

**Status**: ✅ PASS (no constitution violations)

## Project Structure

### Documentation (this feature)

```text
specs/008-english-translations/
├── plan.md              # This file
├── research.md          # Localization approach research
├── data-model.md        # Entity changes for localization
├── quickstart.md        # Implementation guide
├── contracts/
│   └── localization-api.md  # String key conventions
└── tasks.md             # Phase 2 output (created by /speckit.tasks)
```

### Source Code (repository root)

```text
lib/
├── l10n/                    # NEW: Localization files
│   ├── app_ar.arb           # Arabic translations (~200 strings)
│   └── app_en.arb           # English translations (~200 strings)
├── core/
│   ├── extensions/          # NEW: Context extensions
│   │   └── context_extensions.dart
│   └── utils/
│       └── app_date_utils.dart  # MODIFIED: Locale-aware dates
├── providers/
│   └── locale_provider.dart     # NEW: Locale state management
├── features/
│   └── settings/
│       └── widgets/
│           └── preferences_section.dart  # MODIFIED: Language selector
└── app.dart                     # MODIFIED: Add localization delegates

l10n.yaml                        # NEW: Localization config (project root)
pubspec.yaml                     # MODIFIED: Add flutter_localizations
```

**Structure Decision**: Flutter mobile app structure. New `lib/l10n/` directory for ARB files following Flutter conventions. Locale provider integrates with existing Riverpod architecture.

## Implementation Phases

### Phase 1: Infrastructure Setup

1. Add `flutter_localizations` dependency to pubspec.yaml
2. Create `l10n.yaml` configuration file
3. Create `lib/l10n/app_en.arb` (template with all ~200 string keys)
4. Create `lib/l10n/app_ar.arb` (copy existing Arabic strings)
5. Create `lib/providers/locale_provider.dart`
6. Update `lib/app.dart` to use locale provider and remove hardcoded RTL wrapper

### Phase 2: Settings Integration

1. Add language selector to preferences_section.dart
2. Update SettingsRepo with setLanguage method
3. Test language switching persists and triggers rebuild

### Phase 3: Screen Migration (Largest Phase)

Migrate screens in dependency order:
1. AppShell (navigation labels)
2. Dashboard widgets
3. Transactions screen + add form
4. Settings screen
5. Budgets, Goals, Reports screens
6. Installments screens
7. Onboarding screens
8. Shared widgets (EmptyState, etc.)

### Phase 4: Special Cases

1. Update AppDateUtils for locale-aware formatting
2. Update gamification_provider.dart badge names to use l10n
3. Add nameKey to CategoryModel for default categories
4. Update category display logic to check nameKey

### Phase 5: Testing & Polish

1. Test RTL/LTR layout in all screens
2. Fix any overflow issues with longer English text
3. Replace EdgeInsets with EdgeInsetsDirectional where needed
4. Verify language persistence across app restarts

## Complexity Tracking

No constitution violations requiring justification.

## Artifacts Generated

| Artifact | Path | Purpose |
|----------|------|---------|
| Research | [research.md](./research.md) | Localization approach decisions |
| Data Model | [data-model.md](./data-model.md) | Entity changes documentation |
| Quickstart | [quickstart.md](./quickstart.md) | Implementation guide |
| Contract | [contracts/localization-api.md](./contracts/localization-api.md) | String key conventions |

## Next Steps

Run `/speckit.tasks` to generate the detailed task breakdown for implementation.
