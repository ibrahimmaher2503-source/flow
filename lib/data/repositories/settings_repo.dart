import 'package:isar/isar.dart';
import '../models/app_settings_model.dart';

class SettingsRepo {
  final Isar isar;

  SettingsRepo(this.isar);

  Future<AppSettings> get() async {
    final settings = await isar.appSettings.get(0);
    return settings ?? AppSettings();
  }

  Future<void> update(AppSettings settings) async {
    await isar.writeTxn(() async {
      await isar.appSettings.put(settings);
    });
  }

  Future<void> updateStreak() async {
    await isar.writeTxn(() async {
      final settings = await isar.appSettings.get(0) ?? AppSettings();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      if (settings.lastLogDate != null) {
        final lastDate = settings.lastLogDate!;
        final lastDay =
            DateTime(lastDate.year, lastDate.month, lastDate.day);
        final diff = today.difference(lastDay).inDays;

        if (diff == 1) {
          settings.streakDays++;
        } else if (diff > 1) {
          settings.streakDays = 1;
        }
      } else {
        settings.streakDays = 1;
      }
      settings.lastLogDate = now;
      await isar.appSettings.put(settings);
    });
  }

  /// Get the user's current theme preference
  Future<String> getThemeMode() async {
    final settings = await isar.appSettings.get(0);
    return settings?.themeMode ?? 'system';
  }

  /// Update the user's theme preference
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
