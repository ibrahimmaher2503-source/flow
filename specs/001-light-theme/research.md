# Research: Current Theme System Analysis

**Created**: 2026-04-08
**Feature**: Light Theme Support
**Phase**: Phase 0 - Research & Discovery

## Executive Summary

FlowSpend currently has a dark-only theme implementation using Flutter's `ThemeData` system. The color system is well-centralized in `AppColors` with 12 semantic colors plus 3 gradients. Key findings:

- **Good News**: Colors are primarily managed through `AppColors` constants and the `AppTheme` class
- **Good News**: `Theme.of(context)` is not heavily used, making migration straightforward
- **Good News**: Glassmorphism effects are contained in `GlassCard` widget
- **Challenges**: Some hardcoded `Colors.white` and `Colors.black` exist in ~20+ files
- **Challenges**: Multiple `withValues(alpha:)` patterns that need theme-aware brightness handling

---

## Dark Theme Color System

### Core Colors (lib/core/theme/app_colors.dart)

| Color Name | Hex Value | Purpose |
|------------|-----------|---------|
| primary | #6C63FF | Buttons, links, primary actions |
| primaryDark | #4F46E5 | Gradient depth, hover states |
| secondary | #2DD4BF | Accent highlights, savings |
| accent | #F59E0B | Warning, special attention |
| background | #0F0E1A | App scaffold background |
| surface | #1E1B4B | Cards, dropdowns, input fields |
| surfaceLight | #2D2A5E | Lighter surface variant |
| success | #10B981 | Positive outcomes, income |
| danger | #EF4444 | Errors, expenses, debt |
| warning | #F59E0B | Warnings, installments pending |
| installment | #FF6B6B | Installment/debt specific |
| textPrimary | #FFFFFF | Primary text (white) |
| textSecondary | #9CA3AF | Secondary text, muted |
| textMuted | #6B7280 | Disabled text, hints |

### Gradients (lib/core/theme/app_colors.dart)

1. **primaryGradient**: primary (#6C63FF) → primaryDark (#4F46E5)
   - Used for buttons and primary action backgrounds

2. **cardGradient**: #1E1B4B → #161340
   - Subtle dark gradient for card backgrounds

3. **shimmerGradient**: Tri-color (primary, secondary, accent)
   - Loading state animations

### Theme Data Structure (lib/core/theme/app_theme.dart)

**AppTheme.darkTheme** provides:
- **scaffoldBackgroundColor**: background (#0F0E1A)
- **colorScheme**: ColorScheme.dark with primary, secondary, surface, error
- **appBarTheme**: Transparent background, white text/icons
- **bottomNavigationBarTheme**: Background + primary/muted item colors
- **cardTheme**: Surface color, no elevation, 20px border radius
- **floatingActionButtonTheme**: Primary background, white foreground
- **inputDecorationTheme**: Filled with surface color, white border hints
- **dialogTheme**: Surface background, white title text
- **snackBarTheme**: SurfaceLight background, white content text
- **textTheme**: White/secondary/muted colors for body styles
- **systemOverlayStyle**: Light status bar icons on transparent background

---

## Hardcoded Colors Found

### Critical Files (Colors.white / Colors.black hardcoded)

**High-Priority (>3 instances)**:
1. `lib/features/dashboard/widgets/balance_card.dart` - 6 instances (Colors.white opacity)
2. `lib/features/dashboard/widgets/finance_score_card.dart` - 3 instances
3. `lib/core/theme/app_theme.dart` - 10 instances (Colors.white, Colors.black in theme definition)
4. `lib/app.dart` - 2 instances (Colors.black in splash screen)

**Medium-Priority (1-2 instances)**:
- `lib/features/wallets/wallets_screen.dart`
- `lib/features/transactions/transactions_screen.dart`
- `lib/features/settings/settings_screen.dart`
- `lib/features/reports/` (2 files)
- And ~12 other files

### Opacity Patterns (withValues(alpha:))

Most opacity patterns use:
- `Colors.white.withValues(alpha: 0.06 to 0.15)` - Borders and dividers
- `AppColors.primary.withValues(alpha: 0.5 to 1.0)` - Background highlights
- `AppColors.surface.withValues(alpha: 0.6 to 0.8)` - Fill variants
- `color.withValues(alpha: 0.1 to 0.25)` - Dynamic color overlays

**Key Finding**: These opacity patterns need theme-aware brightness handling in light mode.

---

## Glassmorphism Implementation (GlassCard)

**Location**: `lib/shared/widgets/app_card.dart` (lines 47-82)

```dart
class GlassCard extends StatelessWidget {
  final double blur;        // Currently fixed at 12
  final Color? tint;        // Currently surface with 0.5 alpha

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: (tint ?? AppColors.surface).withValues(alpha: 0.5),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
        ),
      ),
    );
  }
}
```

**Current Light Mode Challenge**:
- Blur sigma of 12 is too aggressive on light backgrounds
- Tint color (AppColors.surface = #1E1B4B) is dark purple, doesn't work for light mode
- Border with white 0.08 opacity won't be visible on light backgrounds

**Recommendations**:
- Detect brightness: `Theme.of(context).brightness == Brightness.light`
- Light mode: blur 8, tint to light surface color with 0.3 alpha, border with dark 0.15 alpha
- Dark mode: blur 12, tint to dark surface color with 0.5 alpha, border with white 0.08 alpha

---

## Screen Color Usage Analysis

### Shared Widgets (Highest Impact - 20+ screens use these)

1. **AppCard** (`lib/shared/widgets/app_card.dart`)
   - Uses cardGradient (hardcoded dark gradient)
   - White 0.06 alpha border
   - Black 0.3 alpha shadow
   - **Action**: Make gradient theme-aware, use Theme.of(context) for shadow

2. **GlassCard** (`lib/shared/widgets/app_card.dart`)
   - Uses 0.5 alpha surface tint
   - White 0.08 alpha border
   - **Action**: Make tint and border brightness-aware

3. **AppButton** (`lib/shared/widgets/app_button.dart`)
   - Uses primaryGradient
   - Text: Colors.white (hardcoded)
   - **Action**: Make gradient dynamic, use textTheme for text color

4. **EmptyState** (`lib/shared/widgets/empty_state.dart`)
   - Uses Colors.white and AppColors.textMuted
   - **Action**: Use Theme.of(context).textTheme

5. **LoadingShimmer** (`lib/shared/widgets/loading_shimmer.dart`)
   - Uses shimmerGradient (tri-color)
   - **Action**: Make gradient brightness-aware or adjust colors

### Screens (9 Major Screens)

All screens inherit dark theme colors from:
- `AppColors.*` constants
- `Theme.of(context).colorScheme` (minimal usage)
- Direct `Colors.white` references in AppBar titles

**Common Patterns Across All Screens**:
- AppBar: `color: Colors.white` for title
- Text: Mix of AppColors.textSecondary, textMuted, and hardcoded white
- Backgrounds: AppColors.background and AppColors.surface
- Cards: Use AppCard or custom containers with AppColors.surface

---

## Flutter Theme System Best Practices

### ColorScheme Light vs Dark

Flutter provides built-in support:
```dart
ColorScheme.light(
  primary: ...,
  surface: ...,
  onSurface: ..., // Text color on surface
)

ColorScheme.dark(
  primary: ...,
  surface: ...,
  onSurface: ...,
)
```

**Current Implementation Gap**: AppTheme uses custom colors instead of leveraging ColorScheme properties for text colors.

### Theme.of(context) Usage

Best Practice:
- `Theme.of(context).colorScheme.surface` for backgrounds
- `Theme.of(context).colorScheme.onSurface` for text on backgrounds
- `Theme.of(context).brightness` for detecting light/dark mode

**Current Implementation**: Mostly using `AppColors.*` constants directly.

### System Theme Detection

```dart
MediaQuery.of(context).platformBrightness // Current device brightness
```

Use with:
- `WidgetsBindingObserver` to listen for platform theme changes
- `ThemeMode.system` in MaterialApp for automatic following

---

## Data Model: AppSettings

**Current Structure** (`lib/data/models/app_settings_model.dart`):
```dart
@collection
class AppSettings {
  Id id = 0; // singleton
  String currency = 'EGP';
  String language = 'ar';
  bool smsParsingEnabled = true;
  bool notificationsEnabled = true;
  int monthStartDay = 1;
  String defaultWallet = 'cash';
  int streakDays = 0;
  DateTime? lastLogDate;
}
```

**Required Addition**:
```dart
String themeMode = 'system'; // 'light', 'dark', 'system'
```

**Justification**: Simple string field allows flexibility. Could be enum later if needed. Stored in singleton instance for app-wide access.

---

## Status Bar & Navigation Bar Styling

**Dark Mode** (`lib/core/theme/app_theme.dart`):
- statusBarColor: Transparent
- statusBarIconBrightness: Light (white icons on dark content)
- No navigation bar styling currently set

**Light Mode Required**:
- statusBarColor: Transparent (no change needed)
- statusBarIconBrightness: Dark (dark icons on light content)
- Consider navigation bar styling if app targets Android

---

## Summary of Changes Needed

### Phase 2 (Foundational)

1. **AppColors**: Add light mode color variants
   - Light background, surface, text colors with proper WCAG AA contrast
   - Light gradient alternatives
   - Maintain semantic color meanings (success, danger, warning)

2. **AppTheme**: Add lightTheme getter matching darkTheme structure
   - Mirror all appBarTheme, cardTheme, etc. settings
   - Use light colors from AppColors
   - Handle Colors.white hardcodes in titleTextStyle

3. **Theme Provider**: Create Riverpod provider for theme state
   - Listen to system theme changes
   - Persist preference to AppSettings
   - Provide both ThemeMode enum and boolean brightness detection

4. **Data Model**: Add themeMode field to AppSettings
   - String field ('light', 'dark', 'system')
   - Run build_runner to regenerate

### Phase 3 & Beyond (User Stories)

1. **Settings UI**: Add theme selector in PreferencesSection
2. **Shared Widgets**: Update 5 widgets to use Theme.of(context)
3. **Screens**: Update 9 screens to use theme-aware colors
4. **Glassmorphism**: Adjust GlassCard based on brightness
5. **Status Bar**: Adjust iconBrightness based on theme

---

## Accessibility Considerations

**WCAG AA Requirements** for light mode:

| Element | Requirement | Challenge |
|---------|-------------|-----------|
| Body text (#1A1A1A on #FFFFFF) | 4.5:1 | ✅ High contrast (~20:1) |
| Large text | 3:1 | ✅ Easily achieved |
| Primary button (#6C63FF on light) | 4.5:1 | ⚠️ Needs verification (likely 8.5:1) |
| Secondary accent (#2DD4BF on light) | 4.5:1 | ⚠️ Needs verification |
| Borders & dividers | Visible | ⚠️ Need to test opacity values |
| Interactive elements | Clear states | ⚠️ Need visual testing |

**Recommendation**: Use online contrast checker (webaim.org) to validate all text color pairs before finalizing palette.

---

## Risk Mitigation

| Risk | Severity | Mitigation |
|------|----------|-----------|
| Hardcoded Colors.white missed | High | Run grep after updates, visual QA all 9 screens |
| Poor glassmorphism in light | High | Design mockup first, test early |
| Theme switch performance | Medium | Profile with DevTools, use AnimatedTheme |
| Semantic color meaning lost | Medium | Document color ratios, test colorblind mode |
| Old OS compatibility | Low | Test on iOS 13, Android 8.0 minimum |

---

## Phase 1 Conclusion

✅ **Research Complete**

**Key Deliverables**:
- 12 core colors + 3 gradients documented
- 20+ files with hardcoded colors identified
- Glassmorphism challenge analyzed
- AppSettings data model defined
- Accessibility requirements outlined

**Next Phase**: Design light color palette and theme provider contracts
