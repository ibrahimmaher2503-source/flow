import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/settings_repo.dart';
import 'settings_provider.dart';

/// App theme mode options (different from Flutter's ThemeMode)
enum AppThemeMode {
  light,   // User selected light theme
  dark,    // User selected dark theme
  system,  // Follow device system theme (default)
}

/// Converts string to AppThemeMode enum
AppThemeMode _stringToThemeMode(String value) {
  switch (value.toLowerCase()) {
    case 'light':
      return AppThemeMode.light;
    case 'dark':
      return AppThemeMode.dark;
    case 'system':
      return AppThemeMode.system;
    default:
      return AppThemeMode.system;
  }
}

/// Converts AppThemeMode enum to string
String _themeModeToString(AppThemeMode mode) {
  switch (mode) {
    case AppThemeMode.light:
      return 'light';
    case AppThemeMode.dark:
      return 'dark';
    case AppThemeMode.system:
      return 'system';
  }
}

/// Notifier for managing theme state
class ThemeNotifier extends StateNotifier<AppThemeMode>
    with WidgetsBindingObserver {
  final SettingsRepo _settingsRepo;

  ThemeNotifier(this._settingsRepo) : super(AppThemeMode.system) {
    _initializeTheme();
    WidgetsBinding.instance.addObserver(this);
  }

  /// Initialize theme from saved preference
  Future<void> _initializeTheme() async {
    final savedMode = await _settingsRepo.getThemeMode();
    state = _stringToThemeMode(savedMode);
  }

  /// Set user's theme preference and persist to AppSettings
  Future<void> setThemeMode(String modeString) async {
    final mode = _stringToThemeMode(modeString);
    state = mode;
    await _settingsRepo.updateThemeMode(_themeModeToString(mode));
  }

  /// Listen to device theme changes
  /// Only triggers rebuild if user selected "system" mode
  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();

    if (state == AppThemeMode.system) {
      state = AppThemeMode.system; // Triggers rebuild with new system brightness
    }
  }

  /// Get current theme mode
  AppThemeMode getCurrentThemeMode() => state;

  /// Cleanup - remove observer when provider is disposed
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

/// Provider for current app theme mode
final themeProvider =
    StateNotifierProvider<ThemeNotifier, AppThemeMode>((ref) {
  final settingsRepo = ref.watch(settingsRepoProvider);
  return ThemeNotifier(settingsRepo);
});

/// Derived provider for current brightness based on theme mode
final themeBrightnessProvider = Provider<Brightness>((ref) {
  final mode = ref.watch(themeProvider);

  if (mode == AppThemeMode.light) return Brightness.light;
  if (mode == AppThemeMode.dark) return Brightness.dark;

  // System mode: get device brightness from MediaQuery
  return Brightness.dark; // Default fallback
});
