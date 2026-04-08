# Implementation Plan: Light Theme Support

**Branch**: `001-light-theme` | **Date**: 2026-04-08 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-light-theme/spec.md`

## Summary

Convert FlowSpend from dark-only theme to support both light and dark themes with user-selectable preference and system default option. This involves:
1. Adding theme preference to AppSettings (Light/Dark/System)
2. Creating a complete light theme color palette that mirrors the existing dark theme
3. Updating all UI components, screens, and widgets to use theme-aware colors
4. Implementing dynamic theme switching without app restart
5. Ensuring WCAG AA accessibility standards in both themes

**Primary Technical Approach**: Leverage Flutter's existing `ThemeData` and `Theme.of(context)` system to provide two complete theme definitions. Use Riverpod to manage theme state reactively, listening to both user preferences and system theme changes.

## Technical Context

**Language/Version**: Dart 3.3.0, Flutter 3.24.0
**Primary Dependencies**: Riverpod 2.4.0 (state management), Isar 3.1.0 (local database)
**Storage**: Isar local database (theme preference in AppSettings collection)
**Testing**: Flutter widget tests, integration tests
**Target Platform**: Android & iOS mobile apps
**Project Type**: Mobile app (Flutter)
**Performance Goals**: Theme switch <1s, maintain 60fps during transitions
**Constraints**: RTL layout (Arabic), offline-only (no network), WCAG AA contrast (4.5:1 body text, 3:1 large text)
**Scale/Scope**: 9 main screens (Dashboard, Transactions, Budgets, Goals, Settings, Wallets, Reports, Recurring, SMS Inbox) + 20+ reusable widgets + 5 bottom tab navigation

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

No constitution file with specific constraints found. Standard Flutter best practices apply:
- ✅ No hardcoded theme values - use `Theme.of(context)` throughout
- ✅ Single source of truth for colors - define in `AppColors` class
- ✅ Accessibility compliance - WCAG AA standards for contrast
- ✅ Backward compatibility - preserve existing dark theme as default
- ✅ Performance - avoid rebuilding entire widget tree on theme change

## Project Structure

### Documentation (this feature)

```text
specs/001-light-theme/
├── plan.md              # This file
├── spec.md              # Feature specification
├── research.md          # Phase 0: Current theme system analysis
├── data-model.md        # Phase 1: Theme preference data structure
├── quickstart.md        # Phase 1: Testing theme switching manually
├── contracts/           # Phase 1: Color palette contracts
│   ├── light-colors.md
│   └── theme-provider.md
└── checklists/
    └── requirements.md  # Spec quality checklist (completed)
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart          # [MODIFY] Add ThemeMode enum
│   └── theme/
│       ├── app_colors.dart              # [MODIFY] Add light theme colors
│       ├── app_text_styles.dart         # [MODIFY] Add theme-aware text styles
│       └── app_theme.dart               # [MODIFY] Add lightTheme getter
├── data/
│   ├── models/
│   │   ├── app_settings_model.dart      # [MODIFY] Add themeMode field
│   │   └── app_settings_model.g.dart    # [REGENERATE] build_runner
│   └── repositories/
│       └── settings_repository.dart      # [MODIFY] Add updateThemeMode method
├── providers/
│   ├── settings_provider.dart           # [EXISTS] Current settings provider
│   └── theme_provider.dart              # [CREATE] Theme state management
├── features/
│   └── settings/
│       ├── settings_screen.dart         # [NO CHANGE] Uses PreferencesSection
│       └── widgets/
│           └── preferences_section.dart # [MODIFY] Add theme selector UI
├── shared/
│   └── widgets/
│       ├── app_card.dart                # [MODIFY] Theme-aware colors
│       ├── app_button.dart              # [MODIFY] Theme-aware colors
│       ├── empty_state.dart             # [MODIFY] Theme-aware colors
│       └── loading_shimmer.dart         # [MODIFY] Theme-aware colors
├── app.dart                             # [MODIFY] Use themeProvider for ThemeData
└── main.dart                            # [NO CHANGE] Already initializes AppSettings

tests/
├── unit/
│   ├── theme_provider_test.dart         # [CREATE] Theme logic tests
│   └── settings_repository_test.dart    # [MODIFY] Add theme mode tests
└── widget/
    ├── theme_switcher_test.dart         # [CREATE] Theme switching UI tests
    └── components/                      # [CREATE] Widget tests for light mode
        ├── app_card_test.dart
        └── app_button_test.dart
```

**Structure Decision**: Single Flutter mobile project with standard lib/ structure. All theme-related code lives in `lib/core/theme/` following existing patterns. Theme state management uses existing Riverpod provider pattern in `lib/providers/`.

## Complexity Tracking

> No constitution violations. All changes follow existing Flutter and Riverpod patterns already established in the codebase.

---

## Phase 0: Research & Discovery

**Objective**: Understand current theme system, identify all hardcoded dark mode values, and document color usage patterns.

### Tasks

1. **Audit Current Theme System** *(deliverable: `research.md`)*
   - Document existing `AppColors` structure (primary, secondary, surface, background, text colors)
   - Document existing `AppTheme.darkTheme` definition
   - Document glassmorphism effects (BackdropFilter usage in GlassCard)
   - Identify all gradient usages (primaryGradient, cardGradient, shimmerGradient)
   - List all semantic colors (success, danger, warning, installment)

2. **Identify Hardcoded Color References** *(deliverable: `research.md`)*
   - Search for direct `Colors.white`, `Colors.black` usage
   - Search for hardcoded hex colors outside `AppColors`
   - Search for `AppColors.*` usage patterns across screens
   - Identify text color hardcoding (white, textSecondary, textMuted)
   - Identify status bar styling (`SystemUiOverlayStyle`)

3. **Analyze Existing Components** *(deliverable: `research.md`)*
   - List all widgets in `lib/shared/widgets/` and their color dependencies
   - Document color usage in each of 9 main screens
   - Identify complex visual effects that need light mode adaptation:
     - GlassCard with BackdropFilter
     - AppCard with shadows and gradients
     - Loading shimmers with gradient animations
     - Chart/graph colors

4. **Study Flutter Theme System** *(deliverable: `research.md`)*
   - Document best practices for `Theme.of(context)` usage
   - Research `ColorScheme` light/dark generation
   - Research system theme detection (`MediaQuery.platformBrightness`)
   - Research AnimatedTheme for smooth transitions

### Acceptance Criteria

- ✅ Complete inventory of all colors in dark theme
- ✅ List of all files with hardcoded colors (file:line format)
- ✅ Documentation of glassmorphism and gradient patterns
- ✅ Reference Flutter theme switching examples

---

## Phase 1: Design & Contracts

**Objective**: Define light theme color palette, design theme provider contract, and establish testing approach.

### Deliverables

1. **`data-model.md`** - Theme preference data structure
   ```dart
   // AppSettings addition
   @collection
   class AppSettings {
     // ... existing fields ...
     String themeMode = 'system'; // 'light', 'dark', 'system'
   }
   ```

2. **`contracts/light-colors.md`** - Light theme color palette specification
   - Define all colors in `AppColors` for light mode
   - Include contrast ratios for WCAG AA compliance
   - Document gradient adaptations (lighter, subtler)
   - Document glassmorphism tint adjustments

3. **`contracts/theme-provider.md`** - Theme provider contract
   ```dart
   // Provider signature
   final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>

   // Methods
   - setThemeMode(String mode) // 'light', 'dark', 'system'
   - listenToSystemTheme() // Updates when system changes
   - getCurrentThemeMode() -> ThemeMode
   ```

4. **`quickstart.md`** - Manual testing guide
   - How to test theme switching in development
   - How to verify contrast with accessibility tools
   - How to test system theme following
   - Screenshots of light vs dark mode for key screens

### Design Decisions

**Light Color Palette** (proposed values to be validated in contracts):
- Background: `#F8F9FA` (light gray-white)
- Surface: `#FFFFFF` (pure white)
- SurfaceLight: `#F1F3F5` (slightly darker than background)
- Primary: Keep `#6C63FF` (sufficient contrast on white)
- Secondary: Keep `#2DD4BF` (sufficient contrast)
- Accent: Keep `#F59E0B` (sufficient contrast)
- TextPrimary: `#1A1A1A` (near black)
- TextSecondary: `#4B5563` (dark gray)
- TextMuted: `#9CA3AF` (medium gray)

**Glassmorphism in Light Mode**:
- Reduce blur sigma from 12 to 8
- Use darker tint (surface with 0.3 alpha instead of 0.5)
- Increase border opacity from 0.08 to 0.15 for visibility

**Gradients in Light Mode**:
- Reduce gradient intensity (lighter colors)
- CardGradient: subtle white-to-light-gray instead of purple tones
- Consider replacing some gradients with solid colors

### Acceptance Criteria

- ✅ All colors defined with WCAG AA contrast ratios documented
- ✅ ThemeProvider contract approved (state, methods, behavior)
- ✅ Data model for AppSettings.themeMode defined
- ✅ Manual testing guide complete with expected results

---

## Phase 2: Implementation Tasks

**Objective**: Implement theme switching functionality, light theme colors, and update all UI components.

This phase will be broken down into granular tasks using `/speckit.tasks` after Phase 1 approval. High-level task categories:

### Category 1: Data Layer (Priority: P1)
- Add `themeMode` field to `AppSettings` model
- Run `build_runner` to regenerate `.g.dart` files
- Add `updateThemeMode(String mode)` to `SettingsRepository`
- Write unit tests for settings repository theme methods

### Category 2: Theme System (Priority: P1)
- Define light theme colors in `AppColors` class
- Create `AppTheme.lightTheme` getter matching structure of `darkTheme`
- Create theme-aware text styles in `AppTextStyles` (use `Theme.of(context).colorScheme`)
- Add `ThemeMode` enum to `app_constants.dart`

### Category 3: State Management (Priority: P1)
- Create `theme_provider.dart` with `StateNotifierProvider`
- Implement system theme listening with `WidgetsBindingObserver`
- Connect theme provider to settings repository
- Write unit tests for theme provider logic

### Category 4: App Integration (Priority: P1)
- Update `FlowSpendApp` in `app.dart` to consume `themeProvider`
- Set `theme` and `darkTheme` properties of `MaterialApp`
- Set `themeMode` from provider state
- Ensure theme persists across app restarts

### Category 5: Settings UI (Priority: P2)
- Add theme selector to `PreferencesSection` widget
- Create radio buttons/dropdown for Light/Dark/System
- Wire up to `themeProvider.setThemeMode()`
- Show current selection from provider state

### Category 6: Component Updates (Priority: P2)
**Shared Widgets** (4 widgets):
- Update `AppCard` - use `Theme.of(context).colorScheme.surface`
- Update `GlassCard` - adjust blur and tint based on brightness
- Update `AppButton` - use theme-aware gradient/colors
- Update `LoadingShimmer` - adjust shimmer colors for light mode
- Update `EmptyState` - use theme-aware text colors

**Screen Updates** (9 screens):
- Update Dashboard screen
- Update Transactions screen
- Update Budgets screen
- Update Goals screen
- Update Settings screen
- Update Wallets screen
- Update Reports screen
- Update Recurring screen
- Update SMS Inbox screen

Each screen update involves:
- Replace hardcoded `Colors.white` with `Theme.of(context).colorScheme.onSurface`
- Replace `AppColors.surface` with `Theme.of(context).colorScheme.surface`
- Replace `AppColors.textSecondary` with `Theme.of(context).textTheme.bodyMedium.color`
- Update any custom gradients or effects

### Category 7: Testing (Priority: P3)
- Write widget tests for theme switching behavior
- Write widget tests for each updated component in light mode
- Test WCAG contrast compliance (automated or manual)
- Test system theme following on iOS and Android
- Integration test: settings → change theme → verify all screens

### Category 8: Polish & Edge Cases (Priority: P3)
- Smooth theme transition animation (AnimatedTheme)
- Handle theme change during modal/dialog display
- Update status bar/navigation bar colors per theme
- Test and fix any visual glitches in light mode
- Ensure all chart/graph colors work in both themes

## Phase 3: Validation & Release

**Objective**: Verify all success criteria met, run comprehensive tests, and prepare for merge.

### Validation Checklist

- [ ] **SC-001**: Theme switch reflects across all screens within 1 second (timed test)
- [ ] **SC-002**: All text meets WCAG AA contrast (4.5:1 body, 3:1 large) - use contrast checker
- [ ] **SC-003**: 100% screens render correctly in both themes - visual QA all 9 screens
- [ ] **SC-004**: Theme preference persists across restarts - close/reopen app test
- [ ] **SC-005**: Smooth transitions without flashes - verify AnimatedTheme working
- [ ] **SC-006**: System default follows device theme - test on iOS/Android

### Testing Tasks

- Run `flutter analyze` - zero warnings/errors
- Run `flutter test` - all tests pass
- Run integration tests on real devices (Android + iOS)
- Manual QA: switch themes on every screen, check for visual issues
- Accessibility audit: use Flutter's accessibility scanner
- Performance test: measure theme switch duration with DevTools

### Release Preparation

- Update version in `pubspec.yaml` (if applicable)
- Update `CHANGELOG.md` (if exists) with theme feature
- Create PR with screenshots of light mode
- Code review: verify no hardcoded colors remain
- Merge to main after approval

---

## Success Metrics

| Criterion | Target | Measurement Method |
|-----------|--------|-------------------|
| SC-001: Switch speed | <1 second | Stopwatch test: toggle theme in settings, time until all visible UI updates |
| SC-002: Contrast | WCAG AA (4.5:1 body, 3:1 large) | Use online contrast checker (e.g., webaim.org/resources/contrastchecker) on all text colors |
| SC-003: Rendering | 100% screens correct | Visual checklist: 9 screens × 2 themes = 18 manual checks |
| SC-004: Persistence | 100% reliability | Test 10 restart cycles: set light → restart → verify still light |
| SC-005: Smoothness | No color flash | Visual inspection during theme toggle, verify AnimatedTheme in use |
| SC-006: System follow | Correct match | Test matrix: app=System + device=Light/Dark on iOS/Android (4 tests) |

---

## Risk Mitigation

| Risk | Impact | Mitigation |
|------|--------|-----------|
| Hardcoded colors missed in audit | High - visual bugs in light mode | Thorough grep for `Colors.`, `AppColors.`, hex codes; visual QA all screens |
| Poor contrast in light mode | High - accessibility failure | Define colors with contrast checker first; validate before implementation |
| Theme change causes performance issues | Medium - poor UX | Use `AnimatedTheme`, avoid rebuilding entire tree; profile with DevTools |
| Glassmorphism looks bad in light mode | Medium - design quality | Create design mockups in Phase 1; get approval before implementing |
| System theme detection breaks on old OS | Low - edge case | Test on minimum supported OS versions (iOS 13, Android 8.0) |

---

## Dependencies

1. **Phase 0 → Phase 1**: Must complete research before designing colors
2. **Phase 1 → Phase 2**: Must approve color palette before implementation
3. **Category 1 → Category 3**: Settings repository needed before theme provider
4. **Category 3 → Category 4**: Theme provider needed before app integration
5. **Category 4 → Category 5**: Working theme switching needed before settings UI
6. **Categories 1-5 → Category 6**: Core theme system must work before component updates
7. **Category 6 → Category 7**: Components updated before testing begins

**Critical Path**: Phase 0 Research → Phase 1 Color Design → Category 1-3 (Data + Theme System) → Category 4-5 (App Integration + Settings UI) → Category 6 (Component Updates) → Category 7-8 (Testing + Polish) → Phase 3 Validation

---

## Next Steps

1. **Review this plan**: Approve overall approach and phase breakdown
2. **Execute Phase 0**: Create `research.md` with current theme audit
3. **Execute Phase 1**: Create contracts for light colors and theme provider
4. **Run `/speckit.tasks`**: Generate granular task breakdown for Phase 2
5. **Implement**: Execute tasks in priority order (P1 → P2 → P3)
6. **Validate**: Run Phase 3 checklist and tests
7. **Merge**: Create PR and merge to main
