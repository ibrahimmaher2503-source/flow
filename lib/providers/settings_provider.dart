import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/app_settings_model.dart';
import '../data/repositories/settings_repo.dart';
import '../data/services/isar_service.dart';

final settingsRepoProvider = Provider<SettingsRepo>((ref) {
  return SettingsRepo(ref.watch(isarProvider));
});

final appSettingsProvider = FutureProvider<AppSettings>((ref) async {
  return ref.watch(settingsRepoProvider).get();
});

void refreshSettings(WidgetRef ref) {
  ref.invalidate(appSettingsProvider);
}
