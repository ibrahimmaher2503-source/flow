# Quickstart: Manual Theme Testing Guide

**Created**: 2026-04-08
**Purpose**: Hands-on testing procedures for light theme feature
**Prerequisites**: Phase 2 (Foundational) implementation complete

---

## Prerequisites

- App runs successfully with Phase 2 changes:
  - Light/Dark themes defined in AppColors and AppTheme
  - Theme provider implemented
  - App can switch themes in Settings
  - Preference persists across restarts

---

## Test Environment Setup

### Android Emulator

```bash
# Start emulator with light theme (optional)
emulator -avd Pixel_4_API_31 &

# Or change after launch:
# Settings > Display > Light theme
```

### iOS Simulator

```bash
# Simulator automatically supports system theme
# Change in Simulator > Environment > Appearance
```

### Flutter Hot Reload

```bash
flutter run
# Press 'r' to hot reload after changes
# Press 'R' to hot restart
```

---

## Test 1: Basic Theme Switching (Manual)

**Goal**: Verify user can switch between Light/Dark/System themes

### Steps

1. **Launch app** with `flutter run`
2. **Navigate to Settings**
   - Tap bottom navigation > Settings icon (rightmost tab)
   - Scroll to "الإعدادات" (Settings section)
   - Look for new "Theme" or "المظهر" option
3. **Select Light Theme**
   - Tap "Light Theme" radio button/toggle
   - **Observe**: Entire app should transition to light colors within ~1 second
   - Text should be dark (#1A1A1A)
   - Background should be white (#FFFFFF)
   - Cards should have light surfaces
4. **Navigate between screens** while in light theme
   - Dashboard → Transactions → Budgets → Goals → Settings
   - **Verify**: All screens consistently display light theme
   - No color flashes or glitches
5. **Switch back to Dark Theme**
   - Return to Settings
   - Tap "Dark Theme"
   - **Verify**: App transitions back to dark colors within ~1 second
6. **Select System Default**
   - In Settings, tap "System Default"
   - **Verify**: App matches device's current theme
7. **Change device theme** (while app is open)
   - Android: Settings > Display > Light/Dark theme
   - iOS: Simulator > Environment > Appearance
   - **Verify**: App updates to match device theme in real-time

### Expected Results

| Step | Result | Pass/Fail |
|------|--------|-----------|
| Light theme transitions | All UI is light within 1s | ☐ Pass / ☐ Fail |
| Light theme on all screens | Consistent light appearance | ☐ Pass / ☐ Fail |
| Dark theme transitions back | All UI is dark within 1s | ☐ Pass / ☐ Fail |
| System default follows device | App matches device theme | ☐ Pass / ☐ Fail |
| Real-time device change | App updates without restart | ☐ Pass / ☐ Fail |

---

## Test 2: Theme Persistence (Manual)

**Goal**: Verify selected theme is remembered across app restarts

### Steps

1. **Select Light Theme** in Settings
   - Save and close Settings
2. **Kill the app**
   - Android: Swipe up in recents
   - iOS: Swipe up from bottom
3. **Reopen the app**
   - Tap FlowSpend icon
   - Wait for launch to complete
4. **Observe startup theme**
   - **Verify**: App opens in light theme (not dark)
   - Confirms persistence worked

### Repeat Steps for Dark Theme and System Default

### Expected Results

| Theme | Persist After Restart? | Pass/Fail |
|-------|------------------------|-----------|
| Light | Light theme restored | ☐ Pass / ☐ Fail |
| Dark | Dark theme restored | ☐ Pass / ☐ Fail |
| System | System theme restored | ☐ Pass / ☐ Fail |

---

## Test 3: Contrast & Readability (Manual)

**Goal**: Verify all UI elements are readable in light theme

### Readability Checklist for Light Theme

Navigate through each screen and verify readability:

#### Dashboard Screen
- [ ] Balance cards: Title text readable
- [ ] Finance score: Text on card visible
- [ ] All numbers and currency readable
- [ ] Category icons distinguishable
- [ ] Progress bars visible

#### Transactions Screen
- [ ] Transaction list items readable
- [ ] Category and amount clear
- [ ] Filter buttons distinguishable
- [ ] Date/time visible

#### Budgets Screen
- [ ] Budget names and amounts readable
- [ ] Progress indicators visible
- [ ] Spent vs budget comparison clear
- [ ] Category colors distinguishable

#### Goals Screen
- [ ] Goal names and amounts readable
- [ ] Progress bars visible
- [ ] Savings rate clear
- [ ] Timeline visible

#### Settings Screen
- [ ] All labels readable
- [ ] Toggle switches clear
- [ ] Selected options visible
- [ ] Input fields have clear borders

#### Wallets, Reports, Recurring, SMS Screens
- [ ] All text readable
- [ ] Icons visible
- [ ] Interactive elements clear

### Contrast Validation (Online)

For critical text colors, use: https://webaim.org/resources/contrastchecker/

**Test These Pairs**:

| Element | Light Color | Background | Min Ratio | Result |
|---------|------------|-----------|-----------|--------|
| Body Text | #1A1A1A | #FFFFFF | 4.5:1 | ☐ ✅ ☐ ❌ |
| Secondary Text | #4B5563 | #FFFFFF | 4.5:1 | ☐ ✅ ☐ ❌ |
| Muted Text | #9CA3AF | #FFFFFF | 3:1 | ☐ ✅ ☐ ❌ |
| Primary Button | #6C63FF | #FFFFFF | N/A (colored bg) | ☐ ✅ ☐ ❌ |
| Primary Button Text | #FFFFFF | #6C63FF | 4.5:1 | ☐ ✅ ☐ ❌ |

**If any fail**: Document which color needs adjustment in `contracts/light-colors.md`

### Expected Results

- [ ] All text on light theme is readable without strain
- [ ] Contrast ratios meet WCAG AA standards (4.5:1 minimum)
- [ ] No color pairs fail contrast check
- [ ] No text appears "washed out"

---

## Test 4: Visual Polish (Manual)

**Goal**: Verify visual effects work properly in light theme

### Glassmorphism Cards

1. **Dashboard**: View balance cards (use GlassCard)
2. **Observe**:
   - [ ] Cards have frosted glass effect (slightly blurred)
   - [ ] Cards are not too transparent (readable)
   - [ ] Border visible but subtle
   - [ ] Blur effect is less aggressive than dark mode (8 vs 12)

### Gradients

1. **Dashboard**: View cards with gradient backgrounds
2. **Observe**:
   - [ ] Gradients look natural on light background
   - [ ] Not too bright or washed out
   - [ ] Color transitions smooth

### Loading States

1. **Navigate during data load** (if any async operations)
2. **View loading shimmers/skeletons**
3. **Observe**:
   - [ ] Shimmer animation visible in light theme
   - [ ] Colors consistent with theme
   - [ ] Animation smooth (60fps)

### Shadows

1. **View any elevated UI elements**
2. **Observe**:
   - [ ] Shadows visible but not harsh
   - [ ] Appropriate depth perception
   - [ ] Not too dark (black 0.3) for light backgrounds

### Expected Results

- [ ] Visual effects (glass, gradients, shadows) look natural
- [ ] No stark contrast between light and dark effects
- [ ] Animations smooth (no stuttering)
- [ ] Overall appearance polished and intentional

---

## Test 5: Edge Cases (Manual)

**Goal**: Verify theme switching in unusual situations

### Scenario 1: Theme Switch While Settings Open

1. **Open Settings screen**
2. **Change theme** (Light → Dark)
3. **Verify**:
   - [ ] Settings screen itself updates
   - [ ] Modal dialogs (if any) update
   - [ ] No visual glitches or flashing

### Scenario 2: Theme Switch While Modal Open

1. **Navigate to any screen**
2. **Open a dialog or bottom sheet** (e.g., add transaction)
3. **Change theme** from Settings in background
4. **Verify**:
   - [ ] Dialog/sheet updates theme
   - [ ] No layout shifts
   - [ ] Input fields still accessible

### Scenario 3: Fast Theme Toggling

1. **Rapidly switch** between Light and Dark
2. **5-10 switches in quick succession**
3. **Verify**:
   - [ ] App doesn't crash
   - [ ] All colors apply correctly
   - [ ] No stuck state
   - [ ] Performance acceptable (no lag)

### Scenario 4: App in Background, Device Theme Changes

1. **Set app to "System Default"**
2. **Put app in background** (home button)
3. **Change device theme** (Settings → Display)
4. **Return to app** (tap FlowSpend icon)
5. **Verify**:
   - [ ] App matches new device theme
   - [ ] No restart needed
   - [ ] Theme updates smoothly

### Expected Results

- [ ] Theme switching works in all scenarios
- [ ] No crashes or visual anomalies
- [ ] App remains responsive
- [ ] No stuck or corrupted states

---

## Test 6: Performance (Developer Tools)

**Goal**: Verify theme switching is fast and efficient

### Flutter DevTools Setup

```bash
flutter run
# In another terminal:
open http://localhost:9100 # Opens DevTools in browser
```

### Test: Theme Switch Duration

1. **Open DevTools → Timeline**
2. **Start recording**
3. **Switch from Dark to Light theme** in app
4. **Stop recording**
5. **Analyze**:
   - [ ] Total frame time < 1000ms
   - [ ] No frames dropped (60fps maintained)
   - [ ] Smooth jank-free experience
   - [ ] No excessive rebuilds

### Test: Memory Impact

1. **Open DevTools → Memory**
2. **Note memory usage in Dark theme**
3. **Switch to Light theme**
4. **Note memory usage change**
5. **Verify**:
   - [ ] No significant memory leak
   - [ ] Memory stable after switch
   - [ ] GC working properly

### Expected Results

- [ ] Theme switch completes in <1 second
- [ ] 60fps maintained (no dropped frames)
- [ ] Memory usage stable
- [ ] No performance degradation

---

## Test 7: Accessibility (Manual + Tools)

**Goal**: Verify theme works for users with visual accessibility needs

### Colorblind Simulation (Android)

```
Settings > Accessibility > Display > Color correction
Toggle Deuteranopia, Protanopia, Tritanopia
```

**Test**: All UI elements distinguishable in each mode

### High Contrast Mode (iOS)

```
Settings > Accessibility > Display & Text Size > Increase Contrast
```

**Test**: Text and interactive elements remain visible

### Font Size Testing

```
Settings > Accessibility > Font Sizes (or Display > Text Size)
Increase to Large or Extra Large
```

**Test for Light Theme**:
- [ ] Text doesn't overflow
- [ ] Buttons don't become inaccessible
- [ ] Layout stays intact

### Accessibility Scanner (Android)

```bash
adb shell am start -n com.google.android.apps.accessibility.canary/com.google.android.apps.accessibility.canary.Main
```

**Scan app in light theme**:
- [ ] No contrast warnings
- [ ] Touch targets >48x48dp
- [ ] Text is readable

### Expected Results

- [ ] App usable for colorblind users
- [ ] Text readable at all sizes
- [ ] No accessibility regressions in light mode

---

## Test Report Template

```markdown
# Light Theme Testing Report
**Date**: [Date]
**Tester**: [Name]
**Device**: [Device/Emulator]
**OS Version**: [Version]

## Test Results

### Test 1: Basic Theme Switching
- Status: ☐ Pass / ☐ Fail
- Issues Found: [List any issues]

### Test 2: Theme Persistence
- Status: ☐ Pass / ☐ Fail
- Issues Found: [List any issues]

### Test 3: Contrast & Readability
- Status: ☐ Pass / ☐ Fail
- Issues Found: [List any issues]

### Test 4: Visual Polish
- Status: ☐ Pass / ☐ Fail
- Issues Found: [List any issues]

### Test 5: Edge Cases
- Status: ☐ Pass / ☐ Fail
- Issues Found: [List any issues]

### Test 6: Performance
- Status: ☐ Pass / ☐ Fail
- Issues Found: [List any issues]

### Test 7: Accessibility
- Status: ☐ Pass / ☐ Fail
- Issues Found: [List any issues]

## Summary

**Overall Status**: ☐ All Pass / ☐ Some Failures / ☐ Critical Issues

**Critical Issues**: [If any]

**Recommendations**: [Any improvements needed]

**Sign-Off**: ☐ Ready for Release / ☐ Needs Fixes
```

---

## Sign-Off

**Status**: ✅ Test Plan Ready

**Next Steps**:
1. Execute all tests after Phase 2 implementation
2. Document results in report template
3. Fix any failures before Phase 3
4. Proceed to Phase 3 once all tests pass
