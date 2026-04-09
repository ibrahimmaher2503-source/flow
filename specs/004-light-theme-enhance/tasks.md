# Tasks: Enhance Light Theme Design

**Input**: Design documents from `/specs/004-light-theme-enhance/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, contracts/

**Status**: ✅ IMPLEMENTATION COMPLETE

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story. Note: User Story 1 (Visual Polish) and User Story 3 (Color Harmony) are combined as P1 priorities that share core color/shadow infrastructure.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- Flutter mobile project structure: `lib/` for source code
- All paths relative to repository root: `C:\Users\berog\StudioProjects\flow`

---

## Phase 1: Setup (Research & Validation)

**Purpose**: Validate current implementation and confirm enhancement approach

- [x] T001 Review current shadow implementation in lib/shared/widgets/app_card.dart
- [x] T002 [P] Review current gradient definitions in lib/core/theme/app_colors.dart
- [x] T003 [P] Review current GlassCard implementation in lib/shared/widgets/glass_card.dart
- [x] T004 Verify app runs in light mode without errors before starting enhancements

**Checkpoint**: ✅ Current implementation understood - ready for enhancements

---

## Phase 2: Foundational (Core Theme Infrastructure)

**Purpose**: Core color and shadow definitions that ALL user stories depend on

**⚠️ CRITICAL**: No user story widget updates can begin until this phase is complete

- [x] T005 Add enhanced shadow level definitions (lightShadowSubtle, lightShadowMediumLevel, lightShadowStrong) to lib/core/theme/app_colors.dart
- [x] T006 [P] Update existing lightShadow, lightShadowMedium, lightShadowStrong color values per contracts/enhanced-shadows.md in lib/core/theme/app_colors.dart
- [x] T007 [P] Add enhanced surface colors (lightBackgroundEnhanced, lightSurfaceEnhanced) to lib/core/theme/app_colors.dart
- [x] T008 [P] Add enhanced border colors (lightBorderEnhanced, lightBorderLightEnhanced) to lib/core/theme/app_colors.dart
- [x] T009 Update cardGradientLight to cardGradientLightEnhanced values in lib/core/theme/app_colors.dart
- [x] T010 Run flutter analyze to ensure no errors after AppColors updates

**Checkpoint**: ✅ Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 + 3 - Premium Visual Polish & Color Harmony (Priority: P1) 🎯 MVP

**Goal**: Users experience refined, premium light theme with enhanced shadows, gradients, and harmonious colors creating modern, polished appearance

**Independent Test**: Navigate all 9 screens in light mode; verify cards have visible layered shadows, gradients are smooth, and colors feel cohesive and professional

### Implementation for User Story 1 + 3

#### Core Widget Updates

- [x] T011 [US1] Update AppCard to use lightShadowSubtle for light mode shadows in lib/shared/widgets/app_card.dart
- [x] T012 [P] [US1] Update AppCard to use cardGradientLightEnhanced for light mode gradient in lib/shared/widgets/app_card.dart
- [x] T013 [P] [US1] Update GlassCard to use enhanced shadow system in lib/shared/widgets/glass_card.dart
- [x] T014 [P] [US1] Refine GlassCard blur and tint values for light mode (blur*0.6, tintAlpha 0.85) in lib/shared/widgets/glass_card.dart
- [x] T015 [P] [US3] Update StatBadge to use enhanced border colors in lib/shared/widgets/stat_badge.dart
- [x] T016 [P] [US3] Update SectionHeader action button styling with enhanced colors in lib/shared/widgets/section_header.dart
- [x] T017 [P] [US3] Update EmptyState text colors for light mode harmony in lib/shared/widgets/empty_state.dart
- [x] T018 [P] [US1] Update LoadingShimmer gradient for smoother light mode animation in lib/shared/widgets/loading_shimmer.dart

#### Theme Configuration Updates

- [x] T019 [US3] Update lightTheme cardTheme to use enhanced shadow colors in lib/core/theme/app_theme.dart
- [x] T020 [P] [US3] Update lightTheme chipTheme with enhanced border colors in lib/core/theme/app_theme.dart
- [x] T021 [P] [US3] Update lightTheme dialogTheme with enhanced shadow in lib/core/theme/app_theme.dart
- [x] T022 [P] [US3] Update lightTheme bottomSheetTheme with enhanced shadow in lib/core/theme/app_theme.dart

#### Screen Verification (Visual QA)

- [x] T023 [P] [US1] Verify Dashboard screen cards have proper shadow depth in lib/features/dashboard/
- [x] T024 [P] [US1] Verify Transactions screen tiles have proper shadow depth in lib/features/transactions/
- [x] T025 [P] [US1] Verify Budgets screen cards have proper shadow depth in lib/features/budgets/
- [x] T026 [P] [US1] Verify Goals screen cards have proper shadow depth in lib/features/goals/
- [x] T027 [P] [US1] Verify Wallets screen cards have proper shadow depth in lib/features/wallets/
- [x] T028 [P] [US3] Verify Reports screen pie charts have harmonious colors in lib/features/reports/
- [x] T029 [P] [US1] Verify Recurring screen tiles have proper shadow depth in lib/features/recurring/
- [x] T030 [P] [US1] Verify SMS Inbox screen tiles have proper styling in lib/features/sms/
- [x] T031 [US1] Verify Settings screen maintains visual consistency in lib/features/settings/

**Checkpoint**: ✅ User Story 1 + 3 complete - Premium visual polish and color harmony achieved across all screens

---

## Phase 4: User Story 2 - Enhanced Micro-interactions (Priority: P2)

**Goal**: Users experience smoother, more delightful micro-interactions with improved button feedback and card animations

**Independent Test**: Tap buttons and interactive cards; verify smooth press animations with shadow/scale changes and responsive feedback within 100ms

### Implementation for User Story 2

- [x] T032 [US2] Add shadow animation to AppButton on press (shadow reduction during press) in lib/shared/widgets/app_button.dart
- [x] T033 [US2] Ensure AppButton animation uses Curves.easeOutCubic for premium feel in lib/shared/widgets/app_button.dart
- [x] T034 [P] [US2] Add subtle border brightness shift to GlassCard on tap (if onTap provided) in lib/shared/widgets/glass_card.dart
- [x] T035 [P] [US2] Consider adding subtle scale animation (0.99) to AppCard when tappable in lib/shared/widgets/app_card.dart
- [x] T036 [US2] Test micro-interactions on Dashboard balance card for smooth feedback
- [x] T037 [P] [US2] Test micro-interactions on Transactions screen filter chips
- [x] T038 [US2] Verify all animations complete within 100ms frame budget

**Checkpoint**: ✅ User Story 2 complete - All interactive elements have polished micro-interactions

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Final validation and performance verification

- [x] T039 Run flutter analyze - ensure zero warnings/errors
- [x] T040 [P] Profile shadow rendering performance with DevTools - verify 60fps
- [x] T041 [P] Test theme switching animation (light to dark and back)
- [x] T042 [P] Verify dark mode is unaffected by all changes
- [x] T043 Test on low-brightness screen setting - colors remain distinguishable
- [x] T044 [P] Test on device in bright lighting conditions - contrast sufficient
- [x] T045 Compare light theme to dark theme - verify visual parity (both feel premium)
- [ ] T046 Run quickstart.md validation checklist from specs/004-light-theme-enhance/quickstart.md (manual)
- [ ] T047 Update contracts/enhanced-shadows.md validation checklist with results (manual)
- [ ] T048 Update contracts/color-harmony.md validation checklist with results (manual)

**Checkpoint**: ✅ All implementation complete - awaiting manual validation

---

## Summary

| Phase | Tasks | Status |
|-------|-------|--------|
| Setup | T001-T004 | ✅ Complete |
| Foundational | T005-T010 | ✅ Complete |
| US1+US3 | T011-T031 | ✅ Complete |
| US2 | T032-T038 | ✅ Complete |
| Polish | T039-T048 | 🟡 7/10 (manual validation pending) |

**Total Tasks**: 48
**Completed**: 45/48 (94%)
**Remaining**: 3 manual validation/documentation tasks
