# Implementation Plan: FlowSpend Enhancement Features

**Branch**: `005-flowspend-enhancements` | **Date**: 2026-04-08 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/005-flowspend-enhancements/spec.md`

## Summary

Implement 8 enhancement features for FlowSpend: AI auto-categorization with user learning, CSV/PDF data export, month-over-month comparison, daily spending limits with alerts, recurring transaction detection, enhanced onboarding, gamification enhancements (weekly challenges, heatmap, progress rings), and Android home screen widget. All features follow the existing Flutter + Riverpod + Isar architecture with Arabic RTL UI.

## Technical Context

**Language/Version**: Dart 3.9.2 / Flutter (SDK ^3.9.2)
**Primary Dependencies**: flutter_riverpod 2.4.0, isar 3.1.0+1, fl_chart 0.68.0, flutter_local_notifications 17.0.0, telephony 0.2.0, share_plus 9.0.0, path_provider 2.1.0
**New Dependencies Required**: csv (for CSV export), pdf (for PDF generation), printing (for PDF preview), home_widget (for Android widget)
**Storage**: Isar (local database with 10 existing collections)
**Testing**: flutter_test (existing setup)
**Target Platform**: Android 8.0+ (primary), iOS support
**Project Type**: Mobile app (Flutter)
**Performance Goals**: Category suggestions < 500ms, Export generation < 60 seconds
**Constraints**: Offline-capable, all data local-only, RTL Arabic UI
**Scale/Scope**: 16 existing screens, ~50 providers, 10 data models (adding 6 new)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**Note**: Constitution file contains template placeholders without specific rules defined. No gates to evaluate - proceeding with standard best practices for Flutter/Riverpod development.

**Standard practices applied**:
- Follow existing architecture (layered: UI → Providers → Repositories → Isar)
- Maintain RTL/Arabic-first approach
- Use existing shared widgets and theme system
- Run `build_runner` after Isar model changes
- Run `flutter analyze` after each feature

## Project Structure

### Documentation (this feature)

```text
specs/005-flowspend-enhancements/
├── plan.md              # This file
├── research.md          # Phase 0 output - technical decisions
├── data-model.md        # Phase 1 output - new Isar collections
├── quickstart.md        # Phase 1 output - development guide
├── contracts/           # Phase 1 output - service interfaces
└── tasks.md             # Phase 2 output (created by /speckit.tasks)
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart      # Add ChallengeType enum
│   ├── theme/
│   │   └── app_colors.dart         # Existing - heatmap colors
│   └── utils/
│       └── category_keywords.dart  # NEW: Built-in keyword map
│
├── data/
│   ├── models/
│   │   ├── category_mapping_model.dart      # NEW: User-learned mappings
│   │   ├── detected_pattern_model.dart      # NEW: Recurring patterns
│   │   ├── weekly_challenge_model.dart      # NEW: Challenges
│   │   ├── daily_limit_settings_model.dart  # NEW: Limit config (extend AppSettings or new)
│   │   └── *.g.dart                          # Generated files
│   │
│   ├── repositories/
│   │   ├── category_mapping_repo.dart   # NEW
│   │   ├── detected_pattern_repo.dart   # NEW
│   │   └── challenge_repo.dart          # NEW
│   │
│   └── services/
│       ├── auto_categorization_service.dart  # NEW: Keyword matching + learning
│       ├── export_service.dart               # NEW: CSV/PDF generation
│       ├── recurring_detection_service.dart  # NEW: Pattern analysis
│       ├── challenge_service.dart            # NEW: Weekly challenge logic
│       ├── daily_limit_service.dart          # NEW: Limit tracking
│       ├── widget_sync_service.dart          # NEW: SharedPreferences sync
│       └── notification_service.dart         # MODIFY: Add daily limit channel
│
├── features/
│   ├── export/                        # NEW feature directory
│   │   ├── export_screen.dart
│   │   └── widgets/
│   │       ├── month_picker.dart
│   │       ├── format_card.dart
│   │       └── filter_section.dart
│   │
│   ├── onboarding/                    # MODIFY existing
│   │   ├── onboarding_screen.dart     # Enhance with 5-screen flow
│   │   └── widgets/
│   │       ├── welcome_page.dart
│   │       ├── privacy_page.dart
│   │       ├── sms_page.dart
│   │       ├── setup_page.dart
│   │       └── ready_page.dart
│   │
│   ├── dashboard/                     # MODIFY existing
│   │   └── widgets/
│   │       ├── daily_limit_indicator.dart   # NEW
│   │       ├── challenge_card.dart          # NEW
│   │       └── recurring_suggestions_card.dart  # NEW
│   │
│   ├── reports/                       # MODIFY existing
│   │   └── widgets/
│   │       ├── month_comparison_section.dart  # NEW
│   │       ├── spending_heatmap.dart          # NEW
│   │       └── comparison_charts.dart         # NEW
│   │
│   ├── budgets/                       # MODIFY existing
│   │   └── widgets/
│   │       └── budget_progress_ring.dart     # NEW: Replace/enhance progress cards
│   │
│   ├── settings/                      # MODIFY existing
│   │   └── widgets/
│   │       └── daily_limit_section.dart      # NEW
│   │
│   └── transactions/                  # MODIFY existing
│       └── widgets/
│           └── category_suggestion_banner.dart  # NEW
│
├── providers/
│   ├── auto_categorization_provider.dart   # NEW
│   ├── export_provider.dart                # NEW
│   ├── comparison_provider.dart            # NEW
│   ├── daily_limit_provider.dart           # NEW
│   ├── detected_pattern_provider.dart      # NEW
│   ├── challenge_provider.dart             # NEW
│   └── widget_sync_provider.dart           # NEW
│
└── shared/widgets/
    ├── spending_heatmap.dart         # NEW: Reusable heatmap
    └── progress_ring.dart            # NEW: Animated circular ring

android/
├── app/src/main/
│   ├── res/layout/
│   │   └── flowspend_widget.xml      # NEW: Widget layout
│   ├── res/xml/
│   │   └── flowspend_widget_info.xml # NEW: Widget metadata
│   └── AndroidManifest.xml           # MODIFY: Register widget
│
└── app/src/main/kotlin/.../
    └── FlowSpendWidgetProvider.kt    # NEW: Widget provider (if needed)

test/
├── services/
│   ├── auto_categorization_service_test.dart
│   ├── export_service_test.dart
│   └── recurring_detection_service_test.dart
└── providers/
    ├── comparison_provider_test.dart
    └── daily_limit_provider_test.dart
```

**Structure Decision**: Follows existing Flutter feature-based structure with lib/features/, lib/providers/, lib/data/ layers. New features get their own directories; enhancements to existing features (dashboard, reports, budgets) add widgets to existing folders.

## Complexity Tracking

> No constitution violations to justify - standard implementation following existing patterns.

| Aspect | Decision | Rationale |
|--------|----------|-----------|
| 6 new Isar models | Required | Each feature needs persistent data; all fit naturally into existing Isar setup |
| 7 new providers | Required | One per feature following Riverpod patterns |
| 1 new screen (Export) | Required | Dedicated export flow with filters and preview |
| Native widget | Required | Android home_widget package handles most complexity |
