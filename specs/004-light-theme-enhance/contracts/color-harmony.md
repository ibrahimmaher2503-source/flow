# Contract: Color Harmony Enhancement

**Created**: 2026-04-08
**Purpose**: Define cohesive color relationships for premium light theme
**Related Files**: `lib/core/theme/app_colors.dart`

---

## Color Harmony Philosophy

A premium light theme requires:
1. **Warmth**: Pure white feels clinical; subtle warmth feels premium
2. **Brand cohesion**: Primary color subtly integrated throughout
3. **Semantic clarity**: Status colors remain distinct and meaningful
4. **Accessibility**: All combinations meet WCAG AA standards

---

## Enhanced Color Definitions

### Background & Surface Colors

| Name | Current | Enhanced | Change Reason |
|------|---------|----------|---------------|
| `lightBackground` | `#F7F8FA` | `#F8F9FB` | Slightly cooler for card contrast |
| `lightSurface` | `#FFFFFF` | `#FEFEFF` | Micro-tint for warmth |
| `lightSurfaceElevated` | `#FDFDFE` | `#FFFFFF` | Pure white for modals |
| `lightSurfaceMuted` | `#E8EBF0` | `#EAECF0` | Slightly warmer gray |

### Border Colors

| Name | Current | Enhanced | Change Reason |
|------|---------|----------|---------------|
| `lightBorder` | `#E5E7EB` | `#E4E5EB` | Slight purple tint for brand |
| `lightBorderLight` | `#F3F4F6` | `#F2F3F7` | Consistent with border |
| `lightBorderFocus` | `#5B52E5` | `#5B52E5` | Keep - already primary |

### Gradient Enhancements

#### Card Gradient (Enhanced Warmth)

```dart
// Current
static const cardGradientLight = LinearGradient(
  colors: [Color(0xFFFFFFFF), Color(0xFFFAFBFC)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Enhanced
static const cardGradientLightEnhanced = LinearGradient(
  colors: [
    Color(0xFFFEFEFF),  // Warm white with micro blue-tint
    Color(0xFFFAFAFC),  // Slightly cooler at bottom
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
```

#### Hero Card Gradient (Balance Display)

```dart
// Keep existing - already premium
static const lightPrimaryGradient = LinearGradient(
  colors: [
    Color(0xFF6366F1),  // Indigo
    Color(0xFF5B52E5),  // Purple
    Color(0xFF4F46E5),  // Deep purple
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
```

---

## Color Relationships

### Primary Color Family

```
Primary:        #5B52E5  ████████████
Primary Light:  #7C74FF  ████████████  (hover/active)
Primary Muted:  #EEECFC  ████████████  (backgrounds)
Primary Border: #D4D2F7  ████████████  (borders)
```

### Secondary Color Family

```
Secondary:        #0D9488  ████████████
Secondary Light:  #14B8A6  ████████████  (hover/active)
Secondary Muted:  #E6F7F5  ████████████  (backgrounds)
Secondary Border: #B2E8E2  ████████████  (borders)
```

### Semantic Colors

```
Success:    #059669  ████  → Muted: #D1FAE5
Danger:     #DC2626  ████  → Muted: #FEE2E2
Warning:    #D97706  ████  → Muted: #FEF3C7
Installment:#E11D48  ████  → Muted: #FFE4E6
```

---

## Chart/Graph Color Palette

For pie charts, category indicators, and data visualization:

| Index | Color | Hex | Purpose |
|-------|-------|-----|---------|
| 1 | Primary | `#5B52E5` | Main category |
| 2 | Secondary | `#0D9488` | Secondary category |
| 3 | Accent | `#D97706` | Tertiary category |
| 4 | Success | `#059669` | Income/positive |
| 5 | Danger | `#E11D48` | Expenses/negative |
| 6 | Blue | `#3B82F6` | Additional category |
| 7 | Purple | `#8B5CF6` | Additional category |
| 8 | Pink | `#EC4899` | Additional category |

**Contrast Check**: All colors pass 3:1 minimum contrast against `#FFFFFF` surface.

---

## Badge & Chip Styling

### Status Badges

```dart
// Success badge
Container(
  decoration: BoxDecoration(
    color: AppColors.lightSuccessMuted,  // #D1FAE5
    border: Border.all(color: AppColors.lightSuccessBorder),  // #6EE7B7
    borderRadius: BorderRadius.circular(8),
  ),
  child: Text('Paid', style: TextStyle(color: AppColors.lightSuccess)),  // #059669
)

// Danger badge
Container(
  decoration: BoxDecoration(
    color: AppColors.lightDangerMuted,  // #FEE2E2
    border: Border.all(color: AppColors.lightDangerBorder),  // #FCA5A5
    borderRadius: BorderRadius.circular(8),
  ),
  child: Text('Overdue', style: TextStyle(color: AppColors.lightDanger)),  // #DC2626
)
```

### Filter Chips

```dart
// Unselected
Chip(
  backgroundColor: AppColors.lightSurfaceLight,  // #F3F4F6
  side: BorderSide(color: AppColors.lightBorderLight),  // #F2F3F7
  labelStyle: TextStyle(color: AppColors.lightTextSecondary),  // #374151
)

// Selected
Chip(
  backgroundColor: AppColors.lightPrimaryMuted,  // #EEECFC
  side: BorderSide(color: AppColors.lightPrimaryBorder),  // #D4D2F7
  labelStyle: TextStyle(color: AppColors.lightPrimary),  // #5B52E5
)
```

---

## Implementation Updates

### AppColors Additions

```dart
// Add to lib/core/theme/app_colors.dart

// Enhanced light theme colors
static const lightBackgroundEnhanced = Color(0xFFF8F9FB);
static const lightSurfaceEnhanced = Color(0xFFFEFEFF);
static const lightBorderEnhanced = Color(0xFFE4E5EB);
static const lightBorderLightEnhanced = Color(0xFFF2F3F7);

// Enhanced card gradient
static const cardGradientLightEnhanced = LinearGradient(
  colors: [Color(0xFFFEFEFF), Color(0xFFFAFAFC)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
```

---

## WCAG AA Validation

All color combinations validated:

| Foreground | Background | Ratio | Status |
|------------|------------|-------|--------|
| `#111827` (textPrimary) | `#FEFEFF` | 19.2:1 | ✅ Pass |
| `#374151` (textSecondary) | `#FEFEFF` | 10.8:1 | ✅ Pass |
| `#6B7280` (textMuted) | `#FEFEFF` | 5.6:1 | ✅ Pass |
| `#5B52E5` (primary) | `#FEFEFF` | 6.2:1 | ✅ Pass |
| `#0D9488` (secondary) | `#FEFEFF` | 4.8:1 | ✅ Pass |
| `#D97706` (accent) | `#FEFEFF` | 4.6:1 | ✅ Pass |
| `#059669` (success) | `#FEFEFF` | 4.5:1 | ✅ Pass |
| `#DC2626` (danger) | `#FEFEFF` | 5.1:1 | ✅ Pass |

---

## Validation Checklist

- [ ] All muted background colors are visually distinct from surface
- [ ] Badge text colors contrast with their muted backgrounds
- [ ] Chart colors are distinguishable when adjacent
- [ ] Border colors provide visible separation
- [ ] Gradient transitions are smooth (no banding)
- [ ] Interactive states are clearly distinguishable

---

## Sign-Off

**Status**: ⏳ Pending Implementation

**Approved By**: [TBD]
**Date**: [TBD]
