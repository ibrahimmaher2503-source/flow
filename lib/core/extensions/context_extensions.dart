import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';

/// Extension on BuildContext to provide easy access to localization
extension LocalizationExtension on BuildContext {
  /// Quick access to AppLocalizations
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// Get current locale code (e.g., 'ar', 'en')
  String get localeCode => Localizations.localeOf(this).languageCode;

  /// Check if current locale is Arabic
  bool get isArabic => localeCode == 'ar';

  /// Check if current locale is English
  bool get isEnglish => localeCode == 'en';
}
