# Contract: Enhanced Shadow System

**Created**: 2026-04-08
**Purpose**: Define premium multi-layered shadow system for light theme
**Related Files**: `lib/core/theme/app_colors.dart`, `lib/shared/widgets/app_card.dart`

---

## Shadow Philosophy

Premium mobile apps use multi-layered shadows to create realistic depth perception. Each layer serves a distinct purpose:

1. **Ambient Layer**: Wide, soft shadow simulating diffused environmental light
2. **Key Layer**: Focused shadow from primary light source
3. **Contact Layer**: Tight shadow at element base for grounding

---

## Shadow Definitions

### Light Theme Shadow Colors

| Name | Current | Enhanced | Purpose |
|------|---------|----------|---------|
| `lightShadow` | `0x0D000000` (5%) | `0x08000000` (3%) | Ambient layer |
| `lightShadowMedium` | `0x14000000` (8%) | `0x0D000000` (5%) | Key layer |
| `lightShadowStrong` | `0x1F000000` (12%) | `0x14000000` (8%) | Contact/strong layer |

### Shadow Level Specifications

#### Level 1: Subtle (Cards, List Tiles)

```dart
static List<BoxShadow> get lightShadowSubtle => [
  // Ambient
  BoxShadow(
    color: const Color(0x08000000),
    blurRadius: 16,
    offset: const Offset(0, 4),
    spreadRadius: 0,
  ),
  // Key
  BoxShadow(
    color: const Color(0x0D000000),
    blurRadius: 8,
    offset: const Offset(0, 2),
    spreadRadius: -2,
  ),
];
```

**Use Cases**: AppCard, TransactionTile, BudgetProgressCard

#### Level 2: Medium (Elevated Cards, Modals)

```dart
static List<BoxShadow> get lightShadowMedium => [
  // Ambient
  BoxShadow(
    color: const Color(0x08000000),
    blurRadius: 24,
    offset: const Offset(0, 6),
    spreadRadius: 2,
  ),
  // Key
  BoxShadow(
    color: const Color(0x0D000000),
    blurRadius: 12,
    offset: const Offset(0, 3),
    spreadRadius: 0,
  ),
  // Contact
  BoxShadow(
    color: const Color(0x08000000),
    blurRadius: 4,
    offset: const Offset(0, 1),
    spreadRadius: -1,
  ),
];
```

**Use Cases**: Balance cards, StatBadge containers, Dialogs

#### Level 3: Strong (FAB, Bottom Sheets)

```dart
static List<BoxShadow> get lightShadowStrong => [
  // Ambient
  BoxShadow(
    color: const Color(0x0A000000),
    blurRadius: 32,
    offset: const Offset(0, 8),
    spreadRadius: 4,
  ),
  // Key
  BoxShadow(
    color: const Color(0x0F000000),
    blurRadius: 16,
    offset: const Offset(0, 4),
    spreadRadius: 0,
  ),
  // Contact
  BoxShadow(
    color: const Color(0x0A000000),
    blurRadius: 6,
    offset: const Offset(0, 2),
    spreadRadius: -2,
  ),
];
```

**Use Cases**: FAB, Bottom sheets, Action sheets

---

## Implementation Guidelines

### AppCard Shadow Update

**File**: `lib/shared/widgets/app_card.dart`

```dart
// Before
final shadows = isDark
    ? [BoxShadow(...)]
    : [
        BoxShadow(color: AppColors.lightShadow, ...),
        BoxShadow(color: AppColors.lightShadowMedium, ...),
      ];

// After
final shadows = isDark
    ? [BoxShadow(...)]
    : AppColors.lightShadowSubtle;
```

### GlassCard Shadow Update

**File**: `lib/shared/widgets/glass_card.dart`

```dart
// Before
final shadows = isDark
    ? <BoxShadow>[]
    : [BoxShadow(color: AppColors.lightShadow, blurRadius: 12, ...)];

// After
final shadows = isDark
    ? <BoxShadow>[]
    : AppColors.lightShadowSubtle;
```

---

## Visual Reference

```
┌─────────────────────────────┐
│         Ambient Layer       │  ← Widest, softest (blur: 16-32px)
│  ┌─────────────────────┐   │
│  │      Key Layer      │   │  ← Focused (blur: 8-16px)
│  │  ┌───────────────┐  │   │
│  │  │    CARD       │  │   │
│  │  │               │  │   │
│  │  └───────────────┘  │   │
│  │   Contact Layer     │   │  ← Tight (blur: 4-6px)
│  └─────────────────────┘   │
└─────────────────────────────┘
```

---

## Validation Checklist

- [ ] AppCard uses `lightShadowSubtle` in light mode
- [ ] GlassCard uses `lightShadowSubtle` in light mode
- [ ] Balance cards use `lightShadowMedium` for elevation
- [ ] FAB and bottom sheets use `lightShadowStrong`
- [ ] All shadows render without performance impact (60fps)
- [ ] Visual depth is perceivable on both AMOLED and LCD displays

---

## Sign-Off

**Status**: ⏳ Pending Implementation

**Approved By**: [TBD]
**Date**: [TBD]
