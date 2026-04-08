import 'package:isar/isar.dart';

part 'app_settings_model.g.dart';

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
  String themeMode = 'system'; // 'light', 'dark', or 'system'
}
