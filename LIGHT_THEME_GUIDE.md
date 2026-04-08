# Light Theme Support - Implementation Guide

## Overview

FlowSpend now supports both light and dark themes with automatic system preference detection. Users can manually select their preferred theme in Settings, and the app provides immediate visual feedback with theme persistence across app restarts.

## User Features

### Theme Selection
Users can access theme preferences in **Settings → Theme Selector** with three options:
- **Light**: Forces light theme (white backgrounds, dark text)
- **Dark**: Forces dark theme (dark backgrounds, white text)
- **System**: Automatically follows device system settings

### Theme Persistence
Selected theme preference is saved to local AppSettings and restored on app launch.

### System Theme Synchronization
When "System" mode is selected, the app automatically:
- Detects device theme changes (light/dark mode)
- Updates the app UI in real-time
- Maintains selection across background/foreground transitions

## Technical Architecture

### Color System (lib/core/theme/app_colors.dart)

#### Dark Theme Colors (Existing)
```dart
primary = #6C63FF (Purple)
secondary = #2DD4BF (Cyan)
accent = #F59E0B (Amber)
background = #0F0E1A (Very Dark Blue)
surface = #1E1B4B (Dark Blue)
textPrimary = #FFFFFF (White)
textSecondary = #9CA3AF (Light Gray)
textMuted = #6B7280 (Medium Gray)
```

#### Light Theme Colors (New)
```dart
lightBackground = #F8F9FA (Very Light Gray)
lightSurface = #FFFFFF (White)
lightSurfaceLight = #F1F3F5 (Light Gray)
lightTextPrimary = #1A1A1A (Dark Gray/Black)
lightTextSecondary = #4B5563 (Medium Gray)
lightTextMuted = #5F6B7D (Darker Gray)
```

#### Accessibility - WCAG AA Compliance
All light theme colors meet WCAG AA contrast standards:
- **lightTextPrimary on lightBackground**: 16.9:1 (WCAG AAA) ✅
- **lightTextSecondary on lightBackground**: 7.7:1 (WCAG AAA) ✅
- **lightTextMuted on lightBackground**: 5.3:1 (WCAG AA) ✅

Minimum requirements:
- Normal text: 4.5:1 contrast ratio
- Large text: 3:1 contrast ratio

### Theme Provider (lib/providers/theme_provider.dart)

**AppThemeMode Enum:**
```dart
enum AppThemeMode { light, dark, system }
```

**ThemeNotifier Class:**
- Extends `StateNotifier<AppThemeMode>` with `WidgetsBindingObserver`
- Initializes theme from `AppSettings.themeMode`
- Listens to device brightness changes via `didChangePlatformBrightness()`
- Persists user preference to local database

**Key Methods:**
- `setThemeMode(String modeString)`: Update and persist theme preference
- `didChangePlatformBrightness()`: System theme change detection
- `dispose()`: Cleanup observer on provider disposal

### Material App Integration (lib/app.dart)

```dart
MaterialApp(
  theme: AppTheme.lightTheme,      // Light theme definition
  darkTheme: AppTheme.darkTheme,   // Dark theme definition
  themeMode: _getFlutterThemeMode(appThemeMode),  // Maps to Flutter's ThemeMode
  // ...
)
```

When `AppThemeMode.system` → Flutter's `ThemeMode.system`:
- Flutter automatically manages theme switching
- Responds to device brightness changes
- No manual intervention needed

### Theme Definition (lib/core/theme/app_theme.dart)

**AppTheme.darkTheme:**
- Uses dark color constants from AppColors
- Purple/cyan/amber accent palette
- All text styles use dark-appropriate colors

**AppTheme.lightTheme:**
- Uses light color constants from AppColors
- Same accent palette (works on light backgrounds)
- All text styles use light-appropriate colors
- InputDecoration borders updated (black instead of white)

### Shared Widgets Theme Adaptation

All core widgets automatically adapt to theme:

**AppCard & GlassCard:**
- Background color: Theme-aware (AppColors.surface for dark, AppColors.lightSurface for light)
- Glassmorphism effects: Blur intensity adjusted (12px dark, 8px light)
- Border colors: Adjusted for visibility (white with alpha for dark, black with alpha for light)
- Shadow opacity: Darker in light mode (0.1 vs 0.3)

**AppButton:**
- Uses primary gradient (works on both light and dark)
- White text on colored button (correct for both themes)

**EmptyState:**
- Icon color: Theme-aware muted colors
- Text color: Theme-aware secondary colors

**LoadingShimmer:**
- Base color: Theme-aware (surface for dark, lightSurfaceLight for light)
- Highlight color: Theme-aware (surfaceLight for dark, lightBackground for light)

## Screen Updates

### Dialog & Alert Colors
All dialog titles and text inputs updated to use `AppColors.textPrimary` instead of hardcoded `Colors.white`:
- **TransactionsScreen**: Delete confirmation dialog
- **GoalsScreen**: 2 dialogs (contribute, add goal) with 5 text instances
- **BudgetsScreen**: 2 dialogs (delete, add budget) with 4 text instances
- **WalletsScreen**: 3 dialogs (add, edit, delete) with 7 text instances
- **RecurringScreen**: 2 dialogs (edit, add) with 5 text instances
- **ReportsScreen**: Section title text

### Colors Preserved As-Is
Colors that remain unchanged (appropriate for both themes):
- Colors.white on colored gradient backgrounds (BalanceCard, wallet cards)
- Colors.white text on AppColors.primary buttons
- Colored backgrounds with white text (green success, red danger, amber warning)

## Data Persistence

### AppSettings Model
```dart
class AppSettings {
  String themeMode = 'system';  // Stored as string ('light', 'dark', 'system')
  // ... other settings
}
```

### Settings Repository
- `getThemeMode()`: Retrieve saved preference
- `updateThemeMode(String mode)`: Persist user selection

## Testing Checklist

### Manual Testing
- [ ] Open Settings → Theme Selector
- [ ] Select Light → App immediately becomes light
- [ ] Select Dark → App immediately becomes dark
- [ ] Select System → App matches device setting
- [ ] Restart app → Theme preference persists
- [ ] Change device theme (when System selected) → App follows
- [ ] Open dialogs in light mode → Text is visible
- [ ] Check all screens in both light and dark modes
- [ ] Verify no white text on white backgrounds
- [ ] Check dialog shadows and borders in light mode

### Accessibility Testing
- [ ] Use contrast checker on all text colors
- [ ] Verify minimum 4.5:1 contrast for normal text
- [ ] Verify minimum 3:1 contrast for large text
- [ ] Test with system accessibility features
- [ ] Check reading order in both themes

### Device Testing
- [ ] Test on Android device/emulator
- [ ] Test on iOS device/simulator
- [ ] Verify system theme following on both platforms
- [ ] Test theme switching while in background

## Integration Points

### With Existing Systems
- **Riverpod State Management**: Theme state centralized in `themeProvider`
- **Router**: Automatic theme application across all screens
- **Data Persistence**: Settings stored in Isar database (same as other preferences)
- **Platform Channels**: System brightness detection via Flutter's native integration

### User Settings Integration
Theme preference stored in `AppSettings` singleton alongside:
- Currency (EGP)
- Language (Arabic/English)
- SMS parsing setting
- Notification setting
- Monthly start day
- Other user preferences

## Performance Notes

- **Initial Load**: Theme loaded from database during app startup
- **Theme Switch**: Instant visual feedback (<100ms rebuild)
- **System Changes**: Handled by Flutter framework (no performance impact)
- **Memory**: Minimal overhead (single enum state + saved preference)

## Future Enhancements

Potential additions (not implemented in current MVP):
- Animated transitions between themes (smooth fade effects)
- Custom theme builder for user-defined colors
- Per-screen theme overrides
- Scheduled theme switching (light during day, dark at night)
- Theme sync across devices

## Known Limitations

- All accent colors (primary, secondary, success, danger) remain constant across themes
- Custom theme creation not supported
- Theme selection per screen not supported
- No animated transitions between themes

## Troubleshooting

### Theme doesn't persist
- Check AppSettings database is initialized
- Verify `SettingsRepository.updateThemeMode()` is called
- Check Isar database permissions

### System theme doesn't follow
- Verify device is in system dark/light mode
- Check app is in "System" mode in Settings
- Some devices/emulators may have theme change delays

### Text color issues in light mode
- Ensure using `AppColors.lightTextPrimary` not `Colors.white`
- Check contrast ratio meets WCAG AA (4.5:1 minimum)
- Verify background color is light (use `AppColors.lightSurface` or `AppColors.lightBackground`)

## Related Files

- Color Palette: `lib/core/theme/app_colors.dart`
- Theme Definitions: `lib/core/theme/app_theme.dart`
- Provider Logic: `lib/providers/theme_provider.dart`
- Settings UI: `lib/features/settings/widgets/preferences_section.dart`
- App Setup: `lib/app.dart`
- Data Model: `lib/data/models/app_settings_model.dart`
- Repository: `lib/data/repositories/settings_repo.dart`

## Version History

- **v1.0** (2026-04-08): Initial light theme implementation
  - Theme selection UI
  - Light color palette
  - System theme following
  - WCAG AA accessibility compliance
  - Persistence to AppSettings
