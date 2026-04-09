# Quick Start: Light Theme Enhancement Testing

**Feature**: 004-light-theme-enhance
**Purpose**: Visual testing guide for light theme enhancements

---

## Prerequisites

1. App running on device/emulator
2. App in light mode (Settings > Theme > Light)
3. Good lighting conditions for accurate color perception

---

## Visual Testing Checklist

### 1. Shadow Depth Test

**Navigate to**: Dashboard

| Element | Expected | Pass? |
|---------|----------|-------|
| Balance card | Visible 3-layer shadow, clear elevation | [ ] |
| Transaction tiles | Subtle shadow, cards feel lifted | [ ] |
| Stat badges | Medium elevation, distinguishable from background | [ ] |

**How to verify**:
- View cards from an angle (tilt device slightly)
- Shadows should have soft, diffused edges
- No harsh shadow cutoffs

### 2. Gradient Quality Test

**Navigate to**: Dashboard, Wallets

| Element | Expected | Pass? |
|---------|----------|-------|
| Balance gradient | Smooth purple transition, no banding | [ ] |
| Card backgrounds | Subtle warmth, not pure white | [ ] |
| Action buttons | Vibrant gradient, clear boundaries | [ ] |

**How to verify**:
- Look for smooth color transitions (no visible steps)
- White areas should have subtle warmth (not clinical)

### 3. Color Harmony Test

**Navigate to**: Reports (Pie Charts), Budgets, Transactions

| Element | Expected | Pass? |
|---------|----------|-------|
| Pie chart segments | All colors distinguishable | [ ] |
| Status badges | Clear semantic meaning (green=good, red=bad) | [ ] |
| Category indicators | Cohesive palette, no clashing | [ ] |

**How to verify**:
- View charts with multiple categories
- Ensure adjacent colors are distinguishable
- Semantic colors should feel intuitive

### 4. Micro-interaction Test

**Interact with**: Buttons, Cards, Tabs

| Interaction | Expected | Pass? |
|-------------|----------|-------|
| Tap AppButton | Scale down + shadow reduces | [ ] |
| Tap card (where applicable) | Subtle scale feedback | [ ] |
| Switch tabs | Smooth transition | [ ] |
| Scroll lists | No jank or frame drops | [ ] |

**How to verify**:
- Tap and hold buttons, observe shadow change
- Scroll quickly, ensure 60fps (no stuttering)
- Tab transitions should feel fluid

### 5. Accessibility Test

**Navigate to**: All screens

| Check | Expected | Pass? |
|-------|----------|-------|
| Text readability | All text clearly readable | [ ] |
| Touch targets | All buttons/cards easily tappable | [ ] |
| Icon visibility | Icons distinguishable from background | [ ] |
| Contrast in sunlight | Still readable outdoors | [ ] |

**How to verify**:
- Read all text on each screen
- Try tapping interactive elements
- Test outdoors or increase device brightness

---

## Screen-by-Screen Verification

### Dashboard
- [ ] Balance card: Premium gradient, elevated shadow
- [ ] Quick stats: Clear icons, readable values
- [ ] Recent transactions: Cards have depth

### Transactions
- [ ] Transaction tiles: Subtle shadows, clean layout
- [ ] Filter chips: Selected state visible
- [ ] Amount colors: Income green, expense red

### Budgets
- [ ] Progress bars: Smooth gradients
- [ ] Budget cards: Proper elevation
- [ ] Category badges: Harmonious colors

### Goals
- [ ] Goal cards: Visual depth
- [ ] Progress indicators: Clear status

### Wallets
- [ ] Wallet cards: Premium appearance
- [ ] Balance display: Readable typography

### Reports
- [ ] Pie charts: All segments distinguishable
- [ ] Bar charts (if any): Clear data visualization

### Recurring
- [ ] Recurring tiles: Proper card styling
- [ ] Status indicators: Clear states

### Settings
- [ ] Section cards: Consistent styling
- [ ] Toggle states: Clear on/off

### SMS Inbox
- [ ] SMS tiles: Readable messages
- [ ] Action buttons: Clear CTAs

---

## Performance Verification

1. **Frame Rate Check**:
   - Open Flutter DevTools (Performance tab)
   - Navigate through all screens
   - Ensure no red bars (frame drops)
   - Target: 60fps sustained

2. **Animation Smoothness**:
   - Theme switch: Should be instant
   - Card press: Should feel responsive (<100ms)
   - Scrolling: Should be butter-smooth

---

## Comparison Test

**Dark vs Light Parity**:

1. Switch to dark mode
2. Navigate through all screens
3. Switch back to light mode
4. Rate visual quality 1-5:
   - [ ] Light theme feels equally polished
   - [ ] Both themes feel intentionally designed
   - [ ] Light theme is not "just inverted dark"

---

## Issue Reporting

If any check fails, document:

1. **Screen**: Where the issue appears
2. **Element**: Specific widget/component
3. **Expected**: What should happen
4. **Actual**: What actually happens
5. **Screenshot**: Visual evidence

---

## Sign-Off

**Tested By**: ________________
**Date**: ________________
**Device**: ________________
**OS Version**: ________________

**Overall Assessment**:
- [ ] Ready for release
- [ ] Minor fixes needed (document above)
- [ ] Major issues (escalate to team)
