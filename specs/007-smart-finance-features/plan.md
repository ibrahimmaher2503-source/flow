# Implementation Plan: Core Smart Finance Features

**Branch**: `007-smart-finance-features` | **Date**: 2026-04-09 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/007-smart-finance-features/spec.md`

## Summary

Implement six interconnected smart features for FlowSpend that transform it from a transaction tracker into an intelligent financial assistant: Safe-to-Spend Dashboard, Envelope Budgeting System, Transaction Tags, Cash Flow Forecast, Smart Insights Engine, and Smart Bill Reminders. All features operate locally using Isar database, integrate with existing Riverpod providers, and support both dark/light themes with Arabic RTL layout.

## Technical Context

**Language/Version**: Dart 3.x / Flutter 3.x
**Primary Dependencies**: flutter_riverpod ^2.4.0, isar ^3.1.0, fl_chart ^0.68.0, flutter_local_notifications
**Storage**: Isar (local NoSQL database with 10 existing collections)
**Testing**: flutter_test (widget tests), integration_test
**Target Platform**: Android (primary), iOS (secondary) — local-only, offline-capable
**Project Type**: Mobile app (Flutter)
**Performance Goals**: Safe-to-spend calculation <1s, forecast generation <2s for 12 months history
**Constraints**: Offline-only, privacy-first, RTL Arabic UI, <10,000 transactions typical volume
**Scale/Scope**: 16 existing screens, 14+ providers, 10 data models → adding 4 new screens, 6 new providers, 3 new Isar collections

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The constitution template is unpopulated (placeholder content only). Applying reasonable defaults based on CLAUDE.md:

| Principle | Status | Notes |
|-----------|--------|-------|
| Privacy-First | PASS | All features local-only, no API calls |
| Existing Patterns | PASS | Following Riverpod + Isar + Repository pattern |
| RTL/Arabic | PASS | All UI text in Arabic, existing theme system handles RTL |
| Code Generation | PASS | Will run build_runner after adding Isar models |
| Theme Support | PASS | Dark/light theme variants using existing AppColors |

## Project Structure

### Documentation (this feature)

```text
specs/007-smart-finance-features/
├── plan.md              # This file
├── research.md          # Phase 0 output - technical decisions
├── data-model.md        # Phase 1 output - Isar model definitions
├── quickstart.md        # Phase 1 output - implementation guide
├── contracts/           # Phase 1 output - service interfaces
│   ├── safe-to-spend-service.md
│   ├── envelope-service.md
│   ├── forecast-service.md
│   └── insights-service.md
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
lib/
├── data/
│   ├── models/
│   │   ├── envelope_model.dart           # NEW: Envelope budgeting
│   │   ├── envelope_model.g.dart         # GENERATED
│   │   ├── transaction_tag_model.dart    # NEW: Tag metadata
│   │   ├── transaction_tag_model.g.dart  # GENERATED
│   │   ├── insight_model.dart            # NEW: Cached insights
│   │   ├── insight_model.g.dart          # GENERATED
│   │   └── transaction_model.dart        # MODIFY: Add tags field
│   ├── repositories/
│   │   ├── envelope_repo.dart            # NEW
│   │   ├── tag_repo.dart                 # NEW
│   │   └── insight_repo.dart             # NEW
│   └── services/
│       ├── safe_to_spend_service.dart    # NEW
│       ├── envelope_service.dart         # NEW
│       ├── forecast_service.dart         # NEW
│       ├── insights_service.dart         # NEW
│       ├── bill_reminder_service.dart    # NEW
│       └── notification_service.dart     # MODIFY: Add new notification types
├── providers/
│   ├── safe_to_spend_provider.dart       # NEW
│   ├── envelope_provider.dart            # NEW
│   ├── tag_provider.dart                 # NEW
│   ├── forecast_provider.dart            # NEW
│   ├── insights_provider.dart            # NEW
│   └── bill_reminder_provider.dart       # NEW
├── features/
│   ├── dashboard/
│   │   └── widgets/
│   │       ├── safe_to_spend_card.dart   # NEW
│   │       ├── spending_velocity.dart    # NEW
│   │       ├── forecast_mini_card.dart   # NEW
│   │       └── insights_carousel.dart    # NEW
│   ├── envelopes/                        # NEW FEATURE FOLDER
│   │   ├── envelopes_screen.dart
│   │   ├── envelope_allocate_screen.dart
│   │   └── widgets/
│   │       ├── envelope_card.dart
│   │       └── envelope_form_sheet.dart
│   ├── tags/                             # NEW FEATURE FOLDER
│   │   ├── tags_screen.dart
│   │   └── widgets/
│   │       ├── tag_chip.dart
│   │       ├── tag_input_field.dart
│   │       └── tag_analytics_card.dart
│   ├── forecast/                         # NEW FEATURE FOLDER
│   │   ├── forecast_screen.dart
│   │   └── widgets/
│   │       ├── forecast_chart.dart
│   │       ├── scenario_legend.dart
│   │       └── assumptions_card.dart
│   ├── insights/                         # NEW FEATURE FOLDER
│   │   ├── insights_screen.dart
│   │   └── widgets/
│   │       ├── insight_card.dart
│   │       └── insight_filter.dart
│   ├── recurring/
│   │   └── widgets/
│   │       └── bill_calendar.dart        # NEW
│   ├── transactions/
│   │   └── widgets/
│   │       └── filter_bar.dart           # MODIFY: Add tag filter
│   └── settings/
│       └── widgets/
│           └── preferences_section.dart  # MODIFY: Add envelope toggle
└── core/
    └── router/
        └── app_router.dart               # MODIFY: Add new routes
```

**Structure Decision**: Following existing Flutter feature-based structure with lib/features/{feature}/ pattern. New services follow existing service layer pattern. New providers follow existing Riverpod FutureProvider patterns.

## Complexity Tracking

No constitution violations requiring justification. All features follow existing patterns.

## Implementation Phases

### Phase 0: Research (Complete)
- Technical context gathered from codebase exploration
- All NEEDS CLARIFICATION resolved
- See `research.md` for decisions

### Phase 1: Design (Current)
- Data models defined in `data-model.md`
- Service contracts in `contracts/`
- Implementation guide in `quickstart.md`

### Phase 2: Task Generation (Next)
- Run `/speckit.tasks` to generate implementation tasks
- Tasks organized by priority (P1-P6) matching spec priorities
