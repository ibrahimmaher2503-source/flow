import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static void Function(String?)? _onNotificationTap;

  static Future<void> init({void Function(String?)? onNotificationTap}) async {
    _onNotificationTap = onNotificationTap;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );
  }

  static void _handleNotificationResponse(NotificationResponse response) {
    if (_onNotificationTap != null && response.payload != null) {
      _onNotificationTap!(response.payload);
    }
  }

  static Future<void> show({
    required int id,
    required String title,
    required String body,
    String? payload,
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

    await _plugin.show(id, title, body, details, payload: payload);
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

  /// Show notification for detected SMS transaction
  static Future<void> showTransactionDetected({
    required int id,
    required double amount,
    required String type,
    required String bank,
  }) async {
    final amountStr = amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2);
    final typeText = type == 'credit' ? 'تم إضافة' : 'تم خصم';

    await show(
      id: id + 5000, // Offset to avoid collision with other notification IDs
      title: 'معاملة جديدة',
      body: '$typeText $amountStr جنيه من $bank',
      payload: 'sms:$id', // Payload format for deep linking
    );
  }
}
