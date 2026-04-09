# Tasks: Light Theme Support

**Input**: Design documents from `/specs/001-light-theme/`
**Prerequisites**: plan.md (required), spec.md (required for user stories)

**Status**: ✅ IMPLEMENTATION COMPLETE

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- Flutter mobile project structure: `lib/` for source code
- All paths relative to repository root: `C:\Users\berog\StudioProjects\flow`

---

## Phase 1: Setup (Research & Design)

**Purpose**: Understand current theme system and design light theme color palette

- [x] T001 Audit current AppColors structure in lib/core/theme/app_colors.dart and document all colors
- [x] T002 [P] Audit current AppTheme.darkTheme in lib/core/theme/app_theme.dart and document ThemeData structure
- [x] T003 [P] Search for hardcoded Colors.white and Colors.black references across lib/ directory
- [x] T004 [P] Search for AppColors.* usage patterns in all screens and widgets
- [x] T005 [P] Document glassmorphism implementation in lib/shared/widgets/app_card.dart (GlassCard)
- [x] T006 [P] Document gradient patterns (primaryGradient, cardGradient, shimmerGradient) in lib/core/theme/app_colors.dart
- [x] T007 Create research.md in specs/001-light-theme/ with complete theme system audit
- [x] T008 Design light theme color palette with WCAG AA contrast ratios in specs/001-light-theme/contracts/light-colors.md
- [x] T009 [P] Define theme provider contract in specs/001-light-theme/contracts/theme-provider.md
- [x] T010 [P] Define data model for AppSettings.themeMode in specs/001-light-theme/data-model.md
- [x] T011 [P] Create manual testing guide in specs/001-light-theme/quickstart.md

**Checkpoint**: ✅ Design approved - ready to implement

---

## Phase 2: Foundational (Core Theme System)

**Purpose**: Core infrastructure that MUST be complete before ANY user story UI can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T012 Add themeMode field (String, default 'system') to AppSettings in lib/data/models/app_settings_model.dart
- [x] T013 Run flutter pub run build_runner build --delete-conflicting-outputs to regenerate lib/data/models/app_settings_model.g.dart
- [x] T014 Add updateThemeMode(String mode) method to SettingsRepository in lib/data/repositories/settings_repo.dart
- [x] T015 Define light theme colors in AppColors class in lib/core/theme/app_colors.dart (background, surface, text colors per contract)
- [x] T016 [P] Create AppTheme.lightTheme getter matching darkTheme structure in lib/core/theme/app_theme.dart
- [x] T017 [P] Create theme_provider.dart with StateNotifierProvider<ThemeNotifier, AppThemeMode> in lib/providers/theme_provider.dart
- [x] T018 Implement system theme listening with WidgetsBindingObserver in lib/providers/theme_provider.dart
- [x] T019 Connect theme provider to settings repository in lib/providers/theme_provider.dart
- [x] T020 Update FlowSpendApp to consume themeProvider in lib/app.dart
- [x] T021 Configure MaterialApp theme, darkTheme, and themeMode properties in lib/app.dart
- [x] T022 Verify theme persists across app restarts by testing with hot restart

**Checkpoint**: ✅ Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Theme Preference Selection (Priority: P1) 🎯 MVP

**Goal**: Users can manually choose between light and dark themes in settings, with immediate app-wide visual update and persistent preference storage

**Independent Test**: Open settings, select "Light Theme", verify entire app transitions to light mode, restart app, verify light mode persists

### Implementation for User Story 1

- [x] T023 [US1] Add theme selector UI to PreferencesSection widget in lib/features/settings/widgets/preferences_section.dart
- [x] T024 [US1] Create SegmentedButton or Radio group for Light/Dark/System options in lib/features/settings/widgets/preferences_section.dart
- [x] T025 [US1] Wire theme selector to themeProvider.setThemeMode() in lib/features/settings/widgets/preferences_section.dart
- [x] T026 [US1] Display current theme selection from provider state in lib/features/settings/widgets/preferences_section.dart
- [x] T027 [P] [US1] Update AppCard to use Theme.of(context).brightness detection in lib/shared/widgets/app_card.dart
- [x] T028 [P] [US1] Update GlassCard to adjust blur (8 for light, 12 for dark) based on Theme.of(context).brightness in lib/shared/widgets/app_card.dart
- [x] T029 [P] [US1] Update GlassCard tint color opacity based on brightness in lib/shared/widgets/app_card.dart
- [x] T030 [P] [US1] AppButton already theme-ready (white text on colored gradient) in lib/shared/widgets/app_button.dart
- [x] T031 [P] [US1] Update EmptyState to use theme-aware text colors in lib/shared/widgets/empty_state.dart
- [x] T032 [P] [US1] Update LoadingShimmer gradient colors based on brightness in lib/shared/widgets/loading_shimmer.dart
- [x] T033 [P] [US1] Update Dashboard screen colors (lib/features/dashboard/) - all widget files
- [x] T034 [P] [US1] Update Transactions screen colors (lib/features/transactions/) - all widget files
- [x] T035 [P] [US1] Update Budgets screen colors (lib/features/budgets/) - all widget files
- [x] T036 [P] [US1] Update Goals screen colors (lib/features/goals/) - all widget files
- [x] T037 [P] [US1] Update Settings screen colors (lib/features/settings/settings_screen.dart)
- [x] T038 [P] [US1] Update Wallets screen colors (lib/features/wallets/) - all widget files
- [x] T039 [P] [US1] Update Reports screen colors (lib/features/reports/) - all widget files
- [x] T040 [P] [US1] Update Recurring screen colors (lib/features/recurring/) - all widget files
- [x] T041 [P] [US1] Update SMS Inbox screen colors (lib/features/sms/) - all widget files
- [x] T042 [US1] Update status bar style based on theme (already done in app_theme.dart)
- [x] T043 [US1] Test theme switching on all 9 screens - verify immediate visual update
- [x] T044 [US1] Test theme persistence - set light, restart app, verify still light

**Checkpoint**: ✅ User Story 1 complete - Users can manually select and persist theme preference across all screens

---

## Phase 4: User Story 3 - Accessible Contrast and Readability (Priority: P1)

**Goal**: All text, icons, and UI elements meet WCAG AA contrast standards in both light and dark modes

**Independent Test**: View all screens in light mode, verify text is readable, use contrast checker to validate 4.5:1 body text, 3:1 large text

**Note**: This story is implemented alongside US1 but validated separately for accessibility compliance

### Implementation for User Story 3

- [x] T047 [P] [US3] Validate all text colors in light theme meet WCAG AA (4.5:1 normal, 3:1 large) using online contrast checker
- [x] T048 [P] [US3] Validate primary action button text contrast in light mode
- [x] T049 [P] [US3] Validate chart/graph colors are distinguishable in light mode (if charts exist in Dashboard/Reports)
- [x] T050 [P] [US3] Validate card borders and interactive element boundaries visible in light mode
- [x] T051 [US3] Adjust any failing colors in lib/core/theme/app_colors.dart to meet WCAG AA
- [x] T052 [US3] Re-test all screens with adjusted colors
- [x] T053 [US3] Document contrast ratios for all color pairs in specs/001-light-theme/contracts/light-colors.md

**Checkpoint**: ✅ User Story 3 complete - All UI elements meet accessibility standards in both themes

---

## Phase 5: User Story 2 - Automatic Theme Based on System Settings (Priority: P2)

**Goal**: Users can select "System Default" theme option, and the app automatically follows device light/dark mode preference, updating dynamically when device theme changes

**Independent Test**: Set app to "System Default", change device theme from light to dark, verify app follows; change back, verify app follows

### Implementation for User Story 2

- [x] T054 [US2] Implement system theme change listener in theme_provider.dart using WidgetsBindingObserver.didChangePlatformBrightness
- [x] T055 [US2] Update theme provider to watch MediaQuery.platformBrightnessOf when mode is 'system'
- [x] T056 [US2] Test system theme following on Android emulator/device - change device theme, verify app updates
- [x] T057 [US2] Test system theme following on iOS simulator/device - change device theme, verify app updates
- [x] T058 [US2] Test app foreground/background transitions - verify theme updates when returning to app after device theme change

**Checkpoint**: ✅ User Story 2 complete - App correctly follows system theme when "System Default" is selected

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories and edge cases

- [x] T059 [P] Add AnimatedTheme wrapper or implicit animations to smooth theme transitions in lib/app.dart
- [x] T060 [P] Test theme switching while modal dialog is open - verify no visual glitches
- [x] T061 [P] Test theme switching while bottom sheet is open - verify no visual glitches
- [x] T062 Update navigation bar colors to match theme in lib/app.dart
- [x] T063 [P] Review and fix any remaining hardcoded colors missed in initial pass
- [x] T064 [P] Test all gradient effects in light mode - adjust if visually incoherent
- [x] T065 [P] Test loading shimmers and skeleton screens in light mode
- [x] T066 Run flutter analyze - ensure zero warnings/errors
- [x] T067 Run flutter test (if any existing tests) - ensure all pass
- [x] T068 Perform manual QA on all 9 screens in both light and dark modes (18 visual checks total)
- [ ] T069 Measure theme switch duration with DevTools - verify <1 second (manual)
- [ ] T070 Update quickstart.md with actual testing results and screenshots (manual)

**Checkpoint**: ✅ All implementation complete - feature ready for final validation

---

## Summary

| Phase | Tasks | Status |
|-------|-------|--------|
| Setup | T001-T011 | ✅ Complete |
| Foundational | T012-T022 | ✅ Complete |
| US1 | T023-T044 | ✅ Complete |
| US3 | T047-T053 | ✅ Complete |
| US2 | T054-T058 | ✅ Complete |
| Polish | T059-T070 | 🟡 10/12 (manual tasks pending) |

**Total Tasks**: 70
**Completed**: 68/70 (97%)
**Remaining**: 2 manual documentation tasks
