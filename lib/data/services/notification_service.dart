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

  /// Show envelope low balance warning (20% remaining)
  static Future<void> showEnvelopeLowWarning({
    required String envelopeName,
    required double remaining,
    required double allocated,
  }) async {
    final percent = ((remaining / allocated) * 100).round();
    final remainingStr = remaining.toStringAsFixed(remaining.truncateToDouble() == remaining ? 0 : 2);

    await show(
      id: 'envelope_low_$envelopeName'.hashCode,
      title: 'ظرف قارب على النفاد',
      body: 'ظرف "$envelopeName" فاضل فيه $remainingStr جنيه ($percent%)',
      payload: 'envelope:low',
    );
  }

  /// Show envelope empty warning (0% remaining)
  static Future<void> showEnvelopeEmptyWarning({
    required String envelopeName,
    required double overspent,
  }) async {
    final overspentStr = overspent.abs().toStringAsFixed(overspent.abs().truncateToDouble() == overspent.abs() ? 0 : 2);

    String body;
    if (overspent < 0) {
      body = 'ظرف "$envelopeName" نفد! تجاوزت بـ $overspentStr جنيه';
    } else {
      body = 'ظرف "$envelopeName" نفد! خلاص مفيش رصيد';
    }

    await show(
      id: 'envelope_empty_$envelopeName'.hashCode,
      title: 'ظرف نفد',
      body: body,
      payload: 'envelope:empty',
    );
  }

  /// T066: Show bill reminder notification with contextual message
  static Future<void> showBillReminder({
    required int billId,
    required String billName,
    required double amount,
    required int daysUntilDue,
    required String message,
    required String tone, // 'encouraging' | 'neutral' | 'warning' | 'urgent'
  }) async {
    // Determine notification importance based on tone
    final importance = tone == 'urgent'
        ? Importance.max
        : tone == 'warning'
            ? Importance.high
            : Importance.defaultImportance;

    final priority = tone == 'urgent'
        ? Priority.max
        : tone == 'warning'
            ? Priority.high
            : Priority.defaultPriority;

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'flowspend_bills',
        'Bill Reminders',
        channelDescription: 'Upcoming bill payment reminders',
        importance: importance,
        priority: priority,
        styleInformation: BigTextStyleInformation(message),
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    String title;
    if (daysUntilDue == 0) {
      title = '💰 $billName مستحق اليوم';
    } else if (daysUntilDue == 1) {
      title = '📅 $billName مستحق بكرة';
    } else {
      title = '📋 $billName خلال $daysUntilDue أيام';
    }

    await _plugin.show(
      'bill_$billId'.hashCode,
      title,
      message,
      details,
      payload: 'recurring:$billId',
    );
  }

  /// T067: Schedule bill reminder for a specific date/time
  static Future<void> scheduleBillReminder({
    required int billId,
    required String billName,
    required double amount,
    required DateTime scheduledDate,
    required String message,
    required String tone,
  }) async {
    // Note: Actual scheduling requires timezone package and additional setup
    // For now, we'll use immediate notifications triggered by app startup checks
    // Full scheduling can be implemented with flutter_local_notifications zonedSchedule

    // Calculate days until due from scheduled date
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(scheduledDate.year, scheduledDate.month, scheduledDate.day);
    final daysUntilDue = dueDate.difference(today).inDays;

    await showBillReminder(
      billId: billId,
      billName: billName,
      amount: amount,
      daysUntilDue: daysUntilDue,
      message: message,
      tone: tone,
    );
  }

  /// Show envelope health summary notification
  static Future<void> showEnvelopesSummary({
    required int healthyCount,
    required int warningCount,
    required int emptyCount,
  }) async {
    if (warningCount == 0 && emptyCount == 0) {
      await show(
        id: 'envelope_summary'.hashCode,
        title: 'حالة الأظرف',
        body: 'كل الأظرف ($healthyCount) بخير 💚',
        payload: 'envelope:summary',
      );
    } else {
      final parts = <String>[];
      if (emptyCount > 0) parts.add('$emptyCount نفدوا');
      if (warningCount > 0) parts.add('$warningCount قاربين');
      if (healthyCount > 0) parts.add('$healthyCount بخير');

      await show(
        id: 'envelope_summary'.hashCode,
        title: 'حالة الأظرف',
        body: parts.join(' • '),
        payload: 'envelope:summary',
      );
    }
  }
}
