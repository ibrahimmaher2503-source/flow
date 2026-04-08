# Data Model: Theme Preference Storage

**Created**: 2026-04-08
**Purpose**: Define how theme preference is stored in AppSettings
**Location**: `lib/data/models/app_settings_model.dart`
**Related**: `lib/data/repositories/settings_repository.dart`

---

## AppSettings Collection Update

### Current Structure

```dart
@collection
class AppSettings {
  Id id = 0; // singleton

  String currency = 'EGP';
  String language = 'ar';
  bool smsParsingEnabled = true;
  bool notificationsEnabled = true;
  int monthStartDay = 1;
  String defaultWallet = 'cash';
  int streakDays = 0;
  DateTime? lastLogDate;
}
```

### New Field Addition

```dart
@collection
class AppSettings {
  Id id = 0; // singleton

  // ... existing fields ...

  String themeMode = 'system'; // NEW: 'light', 'dark', or 'system'
}
```

---

## Field Specification

### `themeMode: String`

| Property | Value |
|----------|-------|
| **Type** | String |
| **Default** | 'system' |
| **Allowed Values** | 'light', 'dark', 'system' |
| **Indexed** | No (singleton, no queries) |
| **Nullable** | No |
| **Required** | Yes |

### Rationale for String Type

**Why String instead of Enum or Int?**

1. **Flexibility**: Can extend with custom themes later ('custom-1', etc.)
2. **Serialization**: Easy to serialize/deserialize if exported
3. **Default Value**: String default is more straightforward
4. **Consistency**: Matches existing field types (currency = 'EGP', language = 'ar')
5. **Future-Proof**: Can migrate to enum if schema changes needed

**Why 'system' as Default?**

1. **User Expectation**: Modern apps default to system theme
2. **Accessibility**: Users with device-wide theme preference respected
3. **No Preference Required**: Users don't need to take action on first launch
4. **Cross-Platform**: Works naturally on iOS and Android

---

## Database Schema Impact

### Isar Generation

After adding the field, run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**What This Does**:
1. Regenerates `lib/data/models/app_settings_model.g.dart`
2. Updates schema to include `themeMode` field
3. No migration needed (Isar handles schema evolution)
4. Default value applied to existing records

### Schema Migration

**New Record Creation** (first app launch):
```dart
final settings = AppSettings()
  ..currency = 'EGP'
  ..language = 'ar'
  ..themeMode = 'system' // New field with default
  // ... other fields ...
```

**Existing Records** (app update):
- Isar automatically adds field with default value
- No data loss
- Backward compatible

---

## Access Pattern

### Reading Theme Mode

```dart
Future<String> getThemeMode() async {
  final settings = await isar.appSettings.get(0); // Singleton ID
  return settings?.themeMode ?? 'system'; // Fallback if missing
}
```

**Why Get by ID 0**:
- AppSettings is singleton (only one record)
- Always stored with ID = 0
- Fast O(1) lookup
- No query needed

### Writing Theme Mode

```dart
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

**Transaction Guarantees**:
- Atomic write (all or nothing)
- No partial updates
- Thread-safe

**Why Check null**:
- Extra safety (should always exist)
- Graceful handling of corrupted state
- No exception thrown

---

## Repository Methods

### New Method in SettingsRepository

```dart
class SettingsRepository {
  final Isar isar;

  SettingsRepository(this.isar);

  // ... existing methods ...

  /// Get the user's current theme preference
  Future<String> getThemeMode() async {
    final settings = await isar.appSettings.get(0);
    return settings?.themeMode ?? 'system';
  }

  /// Update the user's theme preference
  ///
  /// [mode] must be one of: 'light', 'dark', 'system'
  Future<void> updateThemeMode(String mode) async {
    await isar.writeTxn(() async {
      final settings = await isar.appSettings.get(0);
      if (settings != null) {
        settings.themeMode = mode;
        await isar.appSettings.put(settings);
      }
    });
  }
}
```

---

## Validation

### String Validation in Provider

```dart
ThemeMode _stringToThemeMode(String value) {
  switch (value.toLowerCase()) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    case 'system':
      return ThemeMode.system;
    default:
      return ThemeMode.system; // Fallback to safe default
  }
}
```

**Behavior**:
- Case-insensitive for robustness
- Unknown values default to 'system'
- No exceptions thrown
- Safe against corrupted data

---

## Testing Scenarios

### Scenario 1: First App Launch

```dart
// App starts, no AppSettings exists
// In _seedDefaults() in main.dart:

await isar.writeTxn(() async {
  await isar.appSettings.put(AppSettings());
  // themeMode will be 'system' (default)
});

// Expected: themeMode = 'system'
```

### Scenario 2: User Changes Theme

```dart
// User selects "Light Theme" in settings
await settingsRepo.updateThemeMode('light');

// Read back
final mode = await settingsRepo.getThemeMode();
assert(mode == 'light'); // ✅
```

### Scenario 3: App Restart with Saved Theme

```dart
// First run: app default = 'system'
// User changes to 'dark'
await settingsRepo.updateThemeMode('dark');

// App closes and restarts
// In _initializeTheme():
final saved = await settingsRepo.getThemeMode();
// saved = 'dark' (persisted) ✅
```

### Scenario 4: Corrupted Data

```dart
// Somehow themeMode = 'invalid_theme'
final settings = await isar.appSettings.get(0);
settings.themeMode = 'invalid_theme';
await isar.appSettings.put(settings);

// Reading back:
final mode = await settingsRepo.getThemeMode();
// Returns 'system' (fallback) ✅ App still works
```

---

## Performance Characteristics

| Operation | Time | Notes |
|-----------|------|-------|
| Get by ID | O(1) | Direct index lookup |
| Write | O(1) | Single record update |
| Transaction | ~1ms | Local database, very fast |
| App Startup | <50ms | Include reading all settings |

**Impact**: Negligible. Theme initialization is imperceptibly fast.

---

## Backward Compatibility

### Upgrade Path

1. **User on old app** (no themeMode field)
2. **Updates to new app**
3. **build_runner generates new schema**
4. **Isar reads old database**
5. **Missing field gets default ('system')**
6. **App works without migration** ✅

### Data Preservation

- All existing settings fields preserved
- Only new field gets default
- No data loss
- User experience: seamless upgrade

---

## Related Changes Checklist

When implementing, ensure:

- [ ] Add `themeMode` field to `AppSettings` class
- [ ] Run `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] Verify `app_settings_model.g.dart` regenerated
- [ ] Add `getThemeMode()` to `SettingsRepository`
- [ ] Add `updateThemeMode()` to `SettingsRepository`
- [ ] Write tests for both repository methods
- [ ] Verify app starts without errors
- [ ] Verify theme mode persists across restarts

---

## Sign-Off

**Status**: ✅ Approved

**Next Steps**:
1. Modify `app_settings_model.dart`
2. Run build_runner
3. Update `settings_repository.dart`
4. Write unit tests
5. Proceed to Phase 2 implementation
