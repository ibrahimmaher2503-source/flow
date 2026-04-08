# Contract: Theme Provider State Management

**Created**: 2026-04-08
**Purpose**: Define theme provider API and state management behavior
**Implementation**: `lib/providers/theme_provider.dart`
**Related**: AppSettings model, SettingsRepository, MaterialApp in app.dart

---

## Theme Mode Enum

```dart
enum ThemeMode {
  light,   // User selected light theme
  dark,    // User selected dark theme
  system,  // Follow device system theme (default)
}
```

---

## Theme Provider Contract

### Provider Definition

```dart
// Provider for current theme mode
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final settingsRepo = ref.watch(settingsRepositoryProvider);
  return ThemeNotifier(settingsRepo);
});

// Provider for current brightness (derived)
final themeBrightnessProvider = Provider<Brightness>((ref) {
  final mode = ref.watch(themeProvider);
  final deviceBrightness = WidgetsBinding.instance.window.platformBrightness;

  if (mode == ThemeMode.light) return Brightness.light;
  if (mode == ThemeMode.dark) return Brightness.dark;
  return deviceBrightness; // system mode
});
```

### ThemeNotifier State Class

```dart
class ThemeNotifier extends StateNotifier<ThemeMode> with WidgetsBindingObserver {
  final SettingsRepository _settingsRepo;

  ThemeNotifier(this._settingsRepo) : super(ThemeMode.system) {
    _initializeTheme();
    WidgetsBinding.instance.addObserver(this);
  }

  // ... implementation details below
}
```

---

## Public API Methods

### 1. Initialize Theme on App Start

```dart
Future<void> _initializeTheme() async {
  final savedMode = await _settingsRepo.getThemeMode();
  state = _stringToThemeMode(savedMode);
}
```

**Behavior**:
- Called in constructor during app startup
- Reads stored theme preference from AppSettings
- Sets initial state to saved preference or 'system' default
- Does NOT trigger UI rebuild on init (state is set directly)

---

### 2. Set User Theme Preference

```dart
Future<void> setThemeMode(String modeString) async {
  final mode = _stringToThemeMode(modeString);

  // Update provider state (triggers UI rebuild)
  state = mode;

  // Persist to AppSettings
  await _settingsRepo.updateThemeMode(modeString);
}
```

**Parameters**:
- `modeString`: 'light', 'dark', or 'system'

**Behavior**:
- Updates provider state immediately (UI rebuilds with new theme)
- Persists preference to AppSettings asynchronously
- No restart needed - MaterialApp listens to provider and updates
- Called from settings UI when user toggles theme selector

**Error Handling**:
- Invalid mode strings default to 'system'
- No exception thrown, just silently revert to safe default

---

### 3. Listen to System Theme Changes

```dart
@override
void didChangePlatformBrightness() {
  super.didChangePlatformBrightness();

  // Only trigger rebuild if user selected "system" mode
  if (state == ThemeMode.system) {
    state = ThemeMode.system; // Triggers rebuild with new system brightness
  }
}
```

**Behavior**:
- Called automatically by Flutter when device theme changes
- Only notifies listeners if user is in 'system' mode
- Dark/light users unaffected by device theme changes
- Allows app to follow system in real-time

---

### 4. Get Current Theme Mode (Getter)

```dart
ThemeMode getCurrentThemeMode() => state;
```

**Usage**:
- Direct access to current ThemeMode enum
- Useful for UI that displays current selection
- Used in settings UI to show selected radio button/dropdown

---

## Integration with MaterialApp

### In app.dart (FlowSpendApp)

```dart
class FlowSpendApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'FlowSpend',
      theme: AppTheme.lightTheme,        // Light theme
      darkTheme: AppTheme.darkTheme,     // Dark theme
      themeMode: themeMode,               // Watch provider
      home: const AppShell(),
    );
  }
}
```

**How It Works**:
1. Consumer widget watches `themeProvider`
2. Any change to provider state triggers rebuild
3. MaterialApp's `themeMode` property updates
4. Flutter's theme system automatically applies correct theme to widget tree
5. All `Theme.of(context)` calls get new theme data
6. All theme-aware widgets update colors automatically

---

## Integration with Settings Repository

### SettingsRepository Methods

```dart
// Retrieve saved theme mode from AppSettings
Future<String> getThemeMode() async {
  final settings = await isar.appSettings.get(0); // singleton
  return settings?.themeMode ?? 'system';
}

// Save theme mode preference to AppSettings
Future<void> updateThemeMode(String mode) async {
  await isar.writeTxn(() async {
    final settings = await isar.appSettings.get(0);
    if (settings != null) {
      settings.themeMode = mode;
      await isar.appSettings.put(settings);
    }
  });
}
```

**Data Flow**:
1. User changes theme in settings
2. `themeProvider.setThemeMode('light')` called
3. Provider state updates → UI rebuilds immediately
4. Repository saves to AppSettings → persists to disk
5. App restart → Provider reads saved mode from repository
6. Theme restored from persistence

---

## State Management Logic

### Theme Mode to Brightness Conversion

```dart
Brightness _getEffectiveBrightness(ThemeMode mode) {
  if (mode == ThemeMode.light) return Brightness.light;
  if (mode == ThemeMode.dark) return Brightness.dark;

  // System mode: get device brightness
  return WidgetsBinding.instance.window.platformBrightness;
}
```

**Used By**:
- Theme-aware widgets that need to detect brightness
- Glassmorphism adaptations (blur, tint, border)
- Derived provider (`themeBrightnessProvider`)

---

## Configuration & Initialization

### In main.dart

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ... other initialization ...

  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isar),
        // themeProvider will auto-initialize in first read
      ],
      child: FlowSpendApp(),
    ),
  );
}
```

**Auto-Initialization**:
- Provider is lazy - doesn't initialize until first read
- First read occurs when MaterialApp is built
- Calls `_initializeTheme()` which reads AppSettings
- Then sets state to persisted preference
- No blocking operation needed in main()

---

## Lifecycle Diagram

```
App Start
  ↓
MaterialApp builds FlowSpendApp
  ↓
FlowSpendApp reads themeProvider (first time)
  ↓
ThemeNotifier._initializeTheme() called
  ↓
Read saved theme mode from AppSettings
  ↓
Set state = savedThemeMode
  ↓
Provider notifies listeners
  ↓
FlowSpendApp rebuilds with current theme
  ↓
All child widgets see Theme.of(context) = current theme
```

---

## Testing Scenarios

### Scenario 1: User Selects Light Theme

1. User opens Settings
2. Taps "Light Theme" radio button
3. Settings UI calls `themeProvider.setThemeMode('light')`
4. Provider state updates immediately → entire app rebuilds with light colors
5. Settings UI reads `themeBrightnessProvider` to verify change
6. Repository saves 'light' to AppSettings asynchronously
7. User navigates away from settings
8. App continues displaying light theme

### Scenario 2: User Restarts App with Light Theme Selected

1. App starts
2. MaterialApp builds, reads themeProvider
3. Provider initializes, reads AppSettings → finds 'light'
4. Provider state set to `ThemeMode.light`
5. All child widgets receive light theme
6. User sees light theme restored from persistence ✅

### Scenario 3: Device Theme Changes (User in System Mode)

1. User selected "System Default" theme
2. Device in light mode
3. User goes to Settings → Device appearance
4. Changes to Dark mode
5. Flutter calls `didChangePlatformBrightness()`
6. Provider's override called
7. State = `ThemeMode.system` (triggers rebuild)
8. `_getEffectiveBrightness(system)` returns new device brightness
9. App rebuilds with dark theme ✅
10. User returns to app - dark theme applied

### Scenario 4: Device Theme Changes (User in Dark Mode)

1. User selected "Dark Theme" (not system)
2. Device in light mode
3. Device theme changed to dark
4. Flutter calls `didChangePlatformBrightness()`
5. Provider checks: `state == ThemeMode.system`? → NO (user picked dark)
6. No rebuild triggered
7. App continues displaying dark theme (as user selected) ✅

---

## Error Handling

| Error | Handling | Result |
|-------|----------|--------|
| Invalid mode string | Default to 'system' | Safe default, app works |
| AppSettings missing | Default to 'system' | Graceful fallback |
| Repo update fails | Silently log, state already changed | Theme applied but not persisted |
| Device brightness unavailable | Use system default | Unlikely, but safe |

---

## Performance Considerations

### Optimization: Avoid Rebuilding Entire Tree

**Current Approach**:
- Only StateNotifierProvider updates
- Listeners (MaterialApp) get new themeMode
- Flutter intelligently applies theme to widget tree
- Widgets using `Theme.of(context)` rebuild only if theme colors change

**Not Rebuilding**:
- App doesn't use ChangeNotifier or StreamBuilder
- No unnecessary widget rebuilds
- Only themes and direct dependents update

### Optimization: Lazy Initialization

- Provider initialized on first read (in build)
- No startup performance impact
- Settings read is fast (local Isar database)

### Optimization: System Theme Listening

- `WidgetsBindingObserver` is lightweight
- Only checks state value, doesn't rebuild in dark/light mode
- Only rebuilds when user in system mode

---

## Cleanup on App Shutdown

```dart
@override
void dispose() {
  WidgetsBinding.instance.removeObserver(this);
  super.dispose();
}
```

**Behavior**:
- Automatically called when provider is disposed (usually on app close)
- Unregisters observer to prevent memory leaks
- Safe for app shutdown

---

## API Summary

| Method | Returns | Effect |
|--------|---------|--------|
| `setThemeMode(String)` | Future<void> | Update state + persist |
| `getCurrentThemeMode()` | ThemeMode | Get current enum value |
| `didChangePlatformBrightness()` | void | Listen to device theme (auto) |
| `state` | ThemeMode | Readable provider value |

---

## Sign-Off

**Status**: ✅ Approved

**Next Steps**:
1. Implement in `lib/providers/theme_provider.dart`
2. Add to settings repository
3. Integrate with `app.dart` MaterialApp
4. Test theme switching on device
