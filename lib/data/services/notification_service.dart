import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(settings);
  }

  static Future<void> show({
    required int id,
    required String title,
    required String body,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'flowspend_channel',
        'FlowSpend',
        channelDescription: 'FlowSpend notifications',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(id, title, body, details);
  }

  static Future<void> showBudgetAlert(
      String category, double percent) async {
    final pct = (percent * 100).toInt();
    await show(
      id: category.hashCode,
      title: 'تنبيه ميزانية',
      body: 'وصلت لـ $pct% من ميزانية $category',
    );
  }

  static Future<void> showInstallmentReminder(
      String itemName, double amount) async {
    await show(
      id: itemName.hashCode,
      title: 'موعد قسط',
      body: 'قسط $itemName — $amount جنيه مستحق اليوم',
    );
  }

  static Future<void> showStreakWarning(int streakDays) async {
    await show(
      id: 999,
      title: 'الـ Streak بتاعك!',
      body: 'عندك $streakDays يوم streak — سجل مصاريفك النهاردة عشان متخسروش',
    );
  }

  static Future<void> showInstallmentCompleted(String itemName) async {
    await show(
      id: itemName.hashCode + 1000,
      title: 'مبروك!',
      body: 'خلصت أقساط $itemName 🎉',
    );
  }

  static Future<void> showDailyReminder() async {
    await show(
      id: 0,
      title: 'FlowSpend',
      body: 'متنساش تسجل مصاريفك النهاردة',
    );
  }
}
