# Contract: Light Theme Color Palette

**Created**: 2026-04-08
**Purpose**: Define light mode colors with WCAG AA contrast validation
**Related Files**: `lib/core/theme/app_colors.dart`, `lib/core/theme/app_theme.dart`

---

## Light Theme Color Palette

### Core Colors (lib/core/theme/app_colors.dart additions)

| Color Name | Dark Value | Light Value | Purpose | WCAG AA* |
|------------|-----------|-----------|---------|----------|
| background | #0F0E1A | #F8F9FA | App scaffold background | N/A |
| surface | #1E1B4B | #FFFFFF | Cards, dropdowns, inputs | N/A |
| surfaceLight | #2D2A5E | #F1F3F5 | Lighter surface variant | N/A |
| primary | #6C63FF | #6C63FF | Buttons, links (keep brand) | ⚠️ TBV* |
| primaryDark | #4F46E5 | #4F46E5 | Gradient depth (keep brand) | ⚠️ TBV |
| secondary | #2DD4BF | #2DD4BF | Accents, savings (keep brand) | ⚠️ TBV |
| accent | #F59E0B | #D97706 | Warnings (darken for light bg) | ⚠️ TBV |
| success | #10B981 | #10B981 | Positive, income (keep brand) | ✅ 6.5:1 |
| danger | #EF4444 | #EF4444 | Errors, expenses (keep brand) | ✅ 5.2:1 |
| warning | #F59E0B | #D97706 | Warnings (darken variant) | ⚠️ TBV |
| installment | #FF6B6B | #FF6B6B | Debt indicator (keep brand) | ⚠️ TBV |
| textPrimary | #FFFFFF | #1A1A1A | Primary text | ✅ 20:1 |
| textSecondary | #9CA3AF | #4B5563 | Secondary text | ✅ 10:1 |
| textMuted | #6B7280 | #9CA3AF | Disabled text, hints | ✅ 6.5:1 |

**Legend**:
- `⚠️ TBV` = To Be Validated with online contrast checker (webaim.org)
- `✅ X:1` = Estimated/verified WCAG AA ratio (4.5:1 minimum for normal text, 3:1 for large)
- `N/A` = Background colors, not text ratio applicable

### Contrast Validation Task

**Must verify before finalizing**:
```
Primary (#6C63FF) on Light Surface (#FFFFFF): Ratio = ?
Secondary (#2DD4BF) on Light Surface (#FFFFFF): Ratio = ?
Accent (#D97706) on Light Surface (#FFFFFF): Ratio = ?
Installment (#FF6B6B) on Light Surface (#FFFFFF): Ratio = ?
```

Use: https://webaim.org/resources/contrastchecker/

---

## Light Theme Gradients

### Primary Gradient
```dart
const primaryGradient = LinearGradient(
  colors: [Color(0xFF6C63FF), Color(0xFF4F46E5)], // Keep purple brand
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
```
**Status**: Approved (brand colors work on light backgrounds)

### Card Gradient
```dart
// Dark Mode
const cardGradient = LinearGradient(
  colors: [Color(0xFF1E1B4B), Color(0xFF161340)], // Subtle dark gradient

// Light Mode
const cardGradientLight = LinearGradient(
  colors: [Color(0xFFFFFFFF), Color(0xFFF1F3F5)], // Subtle white-to-light-gray
);
```
**Status**: Needs Design Review
**Rationale**: Keep subtle gradient visual effect while using light colors

### Shimmer Gradient
```dart
const shimmerGradient = LinearGradient(
  colors: [
    Color(0xFF6C63FF), // Purple
    Color(0xFF2DD4BF), // Cyan
    Color(0xFFF59E0B), // Amber
  ],
);
```
**Status**: Approved (brand colors work on any background for animation)

---

## Glassmorphism Adaptations

### Dark Mode (Current)
```dart
GlassCard(
  blur: 12,
  tint: AppColors.surface.withValues(alpha: 0.5), // #1E1B4B at 50%
  border: Colors.white.withValues(alpha: 0.08),
)
```

### Light Mode (New)
```dart
// Detect brightness in GlassCard.build()
final isDark = Theme.of(context).brightness == Brightness.dark;

if (isDark) {
  // Dark mode: High blur, dark tint, light border
  blur = 12
  tint = AppColors.surface.withValues(alpha: 0.5)
  border = Colors.white.withValues(alpha: 0.08)
} else {
  // Light mode: Lower blur, light tint, dark border
  blur = 8
  tint = AppColors.surfaceLight.withValues(alpha: 0.3) // #F1F3F5 at 30%
  border = Colors.black.withValues(alpha: 0.1)
}
```

**Rationale**:
- Reduced blur (12→8) prevents excessive frosting on light background
- Lighter tint (surface → surfaceLight) avoids dark purple overlay
- Darker border (white 0.08 → black 0.1) visible on light backgrounds
- Opacity adjusted (0.5→0.3) to maintain frosted glass feel

---

## Status Bar & Navigation Bar Styling

### Dark Mode (Current)
```dart
appBarTheme: AppBarTheme(
  backgroundColor: Colors.transparent,
  systemOverlayStyle: SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light, // White icons
  ),
)
```

### Light Mode (New)
```dart
appBarTheme: AppBarTheme(
  backgroundColor: Colors.transparent,
  systemOverlayStyle: SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark, // Dark icons
  ),
)
```

**Change**: Icon brightness from `Brightness.light` to `Brightness.dark`
**Rationale**: Dark icons on light backgrounds (inverse of dark theme)

---

## Text Style Adaptations

### Dark Mode Text Theme
```dart
textTheme: const TextTheme(
  bodyLarge: TextStyle(fontFamily: 'Cairo', color: Colors.white),
  bodyMedium: TextStyle(fontFamily: 'Cairo', color: AppColors.textSecondary),
  bodySmall: TextStyle(fontFamily: 'Cairo', color: AppColors.textMuted),
)
```

### Light Mode Text Theme
```dart
textTheme: const TextTheme(
  bodyLarge: TextStyle(fontFamily: 'Cairo', color: Color(0xFF1A1A1A)), // Black
  bodyMedium: TextStyle(fontFamily: 'Cairo', color: Color(0xFF4B5563)), // Dark gray
  bodySmall: TextStyle(fontFamily: 'Cairo', color: Color(0xFF9CA3AF)),  // Medium gray
)
```

**Rationale**: Inverse text colors for light background (dark text instead of white)

---

## Theme-Aware Widget Updates

### AppCard
**Current**: Uses hardcoded `cardGradient` and `Colors.black` shadow
**Light Mode**: Use theme-aware gradient and shadow color
```dart
// Pseudo-code
final isDark = Theme.of(context).brightness == Brightness.dark;
final gradient = isDark ? AppColors.cardGradient : AppColors.cardGradientLight;
final shadowColor = isDark ? Colors.black.withValues(alpha: 0.3)
                           : Colors.black.withValues(alpha: 0.1);
```

### GlassCard
**Current**: Dark-only glassmorphism
**Light Mode**: Brightness-aware blur, tint, border (see above)

### AppButton
**Current**: Uses `primaryGradient` and `Colors.white` text
**Light Mode**: Keep gradient, use theme-aware text color
```dart
final textColor = isDark ? Colors.white : Colors.white; // On colored bg, keep white
// OR use Theme.of(context).textTheme.buttonText if available
```

### LoadingShimmer
**Current**: Uses `shimmerGradient`
**Light Mode**: Keep gradient colors (work on any background)

### EmptyState
**Current**: Uses `Colors.white` and `AppColors.textMuted`
**Light Mode**: Use theme-aware text colors
```dart
final titleColor = isDark ? Colors.white : Color(0xFF1A1A1A);
final bodyColor = isDark ? AppColors.textSecondary : Color(0xFF4B5563);
```

---

## Semantic Color Usage

### Success Color (Income/Positive)
- **Value**: #10B981 (green, kept constant)
- **Dark Mode**: White text on green ✅
- **Light Mode**: White text on green ✅
- **Status**: No change needed

### Danger Color (Expenses/Debt/Error)
- **Value**: #EF4444 (red, kept constant)
- **Dark Mode**: White text on red ✅
- **Light Mode**: White text on red ✅
- **Status**: No change needed

### Warning Color (Pending/Attention)
- **Value**: #F59E0B (amber, needs darkening for light mode)
- **Dark Mode**: White text on amber ✅
- **Light Mode**: Dark text on amber? Or darken to #D97706 ⚠️
- **Status**: Requires design review and contrast validation

### Installment Color (Debt Indicator)
- **Value**: #FF6B6B (red-pink, keep constant)
- **Dark Mode**: White text on red ✅
- **Light Mode**: White text on red - verify contrast ⚠️
- **Status**: Requires contrast validation

---

## Summary of Changes

### Required Additions to AppColors
- `static const lightBackground = Color(0xFFF8F9FA);`
- `static const lightSurface = Color(0xFFFFFFFF);`
- `static const lightSurfaceLight = Color(0xFFF1F3F5);`
- `static const lightTextPrimary = Color(0xFF1A1A1A);`
- `static const lightTextSecondary = Color(0xFF4B5563);`
- `static const lightTextMuted = Color(0xFF9CA3AF);`
- `static const cardGradientLight = LinearGradient(...);`

### Required Changes to AppTheme
- Add `lightTheme` getter matching `darkTheme` structure
- Use light colors for backgrounds and text
- Update `systemOverlayStyle` for `statusBarIconBrightness`
- Handle all `Colors.white` hardcodes

### Required Updates to Widgets
- AppCard: Theme-aware gradient and shadow
- GlassCard: Brightness-aware blur, tint, border
- AppButton: Already uses theme-aware gradient, ensure text is visible
- LoadingShimmer: Already uses brand gradients, no change needed
- EmptyState: Use theme-aware text colors

---

## Validation Checklist

Before finalizing palette:

- [ ] Run contrast checker on all text color pairs
  - [ ] #1A1A1A (#textPrimary) on #FFFFFF (surface)
  - [ ] #4B5563 (#textSecondary) on #FFFFFF (surface)
  - [ ] #9CA3AF (#textMuted) on #FFFFFF (surface)
  - [ ] #6C63FF (primary) on #FFFFFF for buttons
  - [ ] #2DD4BF (secondary) on #FFFFFF for accents
  - [ ] #D97706 (accent/warning) on #FFFFFF
  - [ ] #FF6B6B (installment) on #FFFFFF

- [ ] Visual QA on actual device/emulator
  - [ ] Cards look good with light gradient
  - [ ] Glassmorphism effect visible but not overdone
  - [ ] Text is readable on all backgrounds
  - [ ] Icons are distinguishable
  - [ ] Buttons have clear visual states

- [ ] Test with accessibility tools
  - [ ] Run Flutter accessibility scanner
  - [ ] Test colorblind mode (if available)
  - [ ] Verify touch target sizes still adequate

---

## Sign-Off

**Status**: ⏳ Pending Contrast Validation

**Next Steps**:
1. Use online contrast checker to validate all TBV items
2. Adjust amber/warning colors if needed (#F59E0B → #D97706)
3. Confirm all ratios meet WCAG AA (4.5:1 for normal, 3:1 for large)
4. Approve palette before proceeding to Phase 2 implementation
