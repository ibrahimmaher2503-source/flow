import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_provider.dart';

/// Provider that returns the current locale based on AppSettings.language
final localeProvider = Provider<Locale>((ref) {
  final settingsAsync = ref.watch(appSettingsProvider);
  final language = settingsAsync.valueOrNull?.language ?? 'ar';
  return Locale(language);
});

/// Provider to check if current locale is RTL
final isRtlProvider = Provider<bool>((ref) {
  final locale = ref.watch(localeProvider);
  return locale.languageCode == 'ar';
});
