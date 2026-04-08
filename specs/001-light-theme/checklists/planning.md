# Implementation Planning Checklist: Light Theme Support

**Purpose**: Track progress through implementation phases
**Created**: 2026-04-08
**Feature**: [plan.md](../plan.md)

## Phase 0: Research & Discovery

- [ ] Audit current theme system (colors, ThemeData, gradients)
- [ ] Identify all hardcoded color references (grep Colors., AppColors., hex)
- [ ] Analyze existing components (shared widgets, screens)
- [ ] Study Flutter theme system best practices
- [ ] Create `research.md` deliverable

**Output**: `research.md` with complete theme system audit

---

## Phase 1: Design & Contracts

- [ ] Define `data-model.md` - AppSettings.themeMode structure
- [ ] Define `contracts/light-colors.md` - Complete light palette with contrast ratios
- [ ] Define `contracts/theme-provider.md` - Theme state management API
- [ ] Create `quickstart.md` - Manual testing guide
- [ ] Validate WCAG AA contrast for all light mode colors
- [ ] Get approval for color palette and design decisions

**Output**: Approved contracts and data models ready for implementation

---

## Phase 2: Implementation (will use `/speckit.tasks` for granular breakdown)

### Category 1: Data Layer (P1)
- [ ] Add themeMode field to AppSettings model
- [ ] Run build_runner to regenerate .g.dart files
- [ ] Add updateThemeMode() to SettingsRepository
- [ ] Write unit tests for theme repository methods

### Category 2: Theme System (P1)
- [ ] Define light theme colors in AppColors
- [ ] Create AppTheme.lightTheme getter
- [ ] Update AppTextStyles to be theme-aware
- [ ] Add ThemeMode enum to app_constants.dart

### Category 3: State Management (P1)
- [ ] Create theme_provider.dart with StateNotifierProvider
- [ ] Implement system theme listening
- [ ] Connect to settings repository
- [ ] Write unit tests for theme provider

### Category 4: App Integration (P1)
- [ ] Update FlowSpendApp to use themeProvider
- [ ] Configure MaterialApp theme/darkTheme/themeMode
- [ ] Verify theme persists across restarts

### Category 5: Settings UI (P2)
- [ ] Add theme selector to PreferencesSection
- [ ] Wire up to themeProvider
- [ ] Show current selection

### Category 6: Component Updates (P2)
- [ ] Update 4 shared widgets (AppCard, GlassCard, AppButton, LoadingShimmer)
- [ ] Update 9 main screens (Dashboard, Transactions, Budgets, Goals, Settings, Wallets, Reports, Recurring, SMS)
- [ ] Replace all hardcoded colors with Theme.of(context)

### Category 7: Testing (P3)
- [ ] Widget tests for theme switching
- [ ] Widget tests for components in light mode
- [ ] WCAG contrast compliance tests
- [ ] System theme following tests
- [ ] Integration tests

### Category 8: Polish (P3)
- [ ] AnimatedTheme transitions
- [ ] Modal/dialog edge cases
- [ ] Status bar/navigation bar styling
- [ ] Visual glitch fixes

---

## Phase 3: Validation & Release

### Success Criteria Validation
- [ ] SC-001: Theme switch <1 second (timed test)
- [ ] SC-002: WCAG AA contrast compliance (contrast checker)
- [ ] SC-003: 100% screens render correctly (18 visual checks: 9 screens × 2 themes)
- [ ] SC-004: Theme persistence across restarts (10 restart test cycles)
- [ ] SC-005: Smooth transitions (visual inspection)
- [ ] SC-006: System theme following works (4 platform tests)

### Testing
- [ ] flutter analyze - zero warnings
- [ ] flutter test - all pass
- [ ] Integration tests on Android device
- [ ] Integration tests on iOS device
- [ ] Manual QA all screens
- [ ] Accessibility audit
- [ ] Performance profiling

### Release
- [ ] Update version/changelog
- [ ] Create PR with screenshots
- [ ] Code review
- [ ] Merge to main

---

## Current Status

**Phase**: Not started
**Blockers**: None
**Next Action**: Begin Phase 0 research by auditing current theme system

## Notes

- Use `/speckit.tasks` after Phase 1 approval to generate detailed Phase 2 tasks
- Each phase must be completed and approved before proceeding to next
- Document any deviations from plan in this section
