# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This App Is

**FlowSpend** — a privacy-first, local-only personal finance tracker for Arabic-speaking users. No internet required; all data stays on-device. Dark theme only, RTL layout (Arabic), with gamification (finance score, badges, streaks).

## Commands

```bash
# Run code generation (required after changing Isar models or adding providers)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode during development
flutter pub run build_runner watch --delete-conflicting-outputs

# Lint
flutter analyze

# Tests
flutter test

# Run a single test file
flutter test test/path/to/test_file.dart

# Build
flutter build apk
flutter build ios
```

## Architecture

**Stack:** Flutter + Riverpod 2.4.0 + Isar (local DB) + Named Routes

### Layered Data Flow

```
UI (ConsumerWidget)
  → Riverpod Providers (lib/providers/)
    → Repositories (lib/data/repositories/)
      → Isar Database (lib/data/services/isar_service.dart)
```

### State Management (Riverpod)

- `isarProvider` (in `isar_service.dart`) — root singleton; overridden in `main.dart` with the actual Isar instance
- `*RepoProvider` — wraps each repository, receives Isar from `isarProvider`
- `FutureProvider` / `FutureProvider.family` — async data fetching; use `ref.invalidate()` to refresh
- `StateProvider` — simple UI state (e.g., selected month)

**Refresh pattern:** After mutations, call `ref.invalidate(...)` on all affected providers. See existing screens for the pattern.

### Database (Isar)

9 collections, all in `lib/data/models/` with auto-generated `*.g.dart` files. Key indexes:
- `monthKey` (format: `YYYY-MM`) — used heavily for monthly queries
- `categoryIndex`, `sourceIndex`, `statusIndex` — for filtered lookups

**Always run `build_runner` after modifying any `@collection` model.**

### Navigation

Simple named-route system in `lib/core/router/app_router.dart`. The app shell (`AppShell`) uses `IndexedStack` with 5 bottom tabs. FAB is gated to tabs 0 (Dashboard) and 1 (Transactions).

### Key Directories

| Path | Purpose |
|------|---------|
| `lib/core/constants/app_constants.dart` | All enums: `TransactionType`, `TransactionSource`, `WalletType`, etc. |
| `lib/core/theme/` | `app_colors.dart`, `app_text_styles.dart`, `app_theme.dart` — dark theme, purple/cyan/amber palette, Cairo font |
| `lib/data/models/` | Isar `@collection` classes + generated `.g.dart` |
| `lib/data/repositories/` | All DB query/mutation logic lives here |
| `lib/data/services/` | `isar_service.dart`, `backup_service.dart`, `notification_service.dart`, `sms_parser_service.dart`, etc. |
| `lib/data/seeds/` | Default Arabic categories and installment providers seeded on first launch |
| `lib/features/` | One directory per feature; each contains a `*_screen.dart` and a `widgets/` subfolder |
| `lib/providers/` | All Riverpod providers |
| `lib/shared/widgets/` | Reusable components: `AppCard`, `GlassCard`, `AppButton`, `EmptyState`, `LoadingShimmer` |

### UI Conventions

- Use `AppCard` or `GlassCard` (glassmorphism with `BackdropFilter`) for card surfaces — not raw `Card`
- Use `AppButton` for primary actions — it has built-in scale animation and gradient
- All text styles come from `AppTextStyles`; all colors from `AppColors`
- RTL is enforced globally in `MaterialApp` builder — do not hardcode directional padding/alignment
- Currency display uses `CurrencyFormatter` (EGP)
- Dates use `AppDateUtils` for relative/formatted strings

### Gamification

`gamification_provider.dart` calculates:
- **Finance Score (0–100):** budget adherence (25%) + savings rate (25%) + logging streak (20%) + goal progress (15%) + debt reduction (15%)
- **Badges:** 7 unlockable achievements tracked in `AppSettings`

### Installments

`InstallmentService` handles payment recording and debt calculations. `InstallmentCalculator` (in `lib/core/utils/`) computes schedules. Avoid N+1 queries — batch-fetch providers as done in `debtByProvider()`.

### Localization (i18n/l10n)

FlowSpend supports both Arabic and English. The localization system uses Flutter's native localization with ARB files.

**Key Files:**
- `lib/l10n/app_en.arb` — English translations (210+ keys)
- `lib/l10n/app_ar.arb` — Arabic translations (210+ keys)
- `lib/l10n/generated/app_localizations.dart` — Auto-generated localization class
- `lib/providers/locale_provider.dart` — Riverpod locale provider
- `lib/core/extensions/context_extensions.dart` — Convenience extension for l10n access

**How to Use l10n in Code:**

```dart
// In build method of any Widget
final l10n = AppLocalizations.of(context)!;

// Use l10n keys
Text(l10n.buttonSave)
Text(l10n.errorWithMessage('Some error'))
Text(l10n.smsTimeMinutesAgo(5))  // With placeholders
```

**Adding New Strings:**

1. Add to `lib/l10n/app_en.arb` with English translation
2. Add matching key to `lib/l10n/app_ar.arb` with Arabic translation
3. Run `flutter gen-l10n` to regenerate AppLocalizations class
4. Use `l10n.keyName` in your code

**Language Switching:**

Users can switch languages in Settings. The app:
- Saves selection to AppSettings database
- Triggers immediate rebuild via `localeProvider`
- Automatically switches RTL/LTR based on locale
- Persists across app restarts

**Key Localization Keys by Feature:**
- Dashboard: `financeScore`, `achievements`, `dailyAverage`, `topCategory`, `interestPaid`
- Transactions: `transactionTypeExpense`, `transactionTypeIncome`, `labelCategory`, `labelWallet`, `buttonSave`
- SMS: `smsConfirmationTitle`, `smsStatusConfirmed`, `smsPermissionTitle`
- Installments: `installmentsTitle`, `installmentRemaining`, `installmentMonthlyPayment`
- Reports: `screenReports`, `reportsTabExpenses`, `reportsTabInstallments`
- Common: `buttonAdd`, `buttonDelete`, `buttonCancel`, `back`, `errorWithMessage`

**Testing l10n:**

- Test English: Change language in Settings and verify all strings translate
- Test Arabic: Reset to Arabic and verify no regressions
- Check RTL: Ensure layout flips correctly in Arabic mode
- Verify persistence: Restart app and confirm language selection persists
