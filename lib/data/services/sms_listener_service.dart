import 'package:flutter/widgets.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:telephony/telephony.dart';

import 'package:permission_handler/permission_handler.dart';

import '../models/detected_sms_model.dart';
import '../models/app_settings_model.dart';
import '../models/transaction_model.dart';
import '../models/category_model.dart';
import '../models/budget_model.dart';
import '../models/wallet_model.dart';
import '../models/recurring_transaction_model.dart';
import '../models/savings_goal_model.dart';
import '../models/installment_provider_model.dart';
import '../models/installment_plan_model.dart';
import 'sms_parser_service.dart';
import 'notification_service.dart';

/// Background message handler - must be top-level function for Dart isolate
@pragma('vm:entry-point')
Future<void> backgroundSmsHandler(SmsMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();

  final body = message.body;
  if (body == null || body.isEmpty) return;

  // Parse the SMS
  final parsed = SmsParserService.parse(body);
  if (parsed == null) return;

  try {
    // Open Isar in background isolate
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [
        TransactionSchema,
        CategorySchema,
        BudgetSchema,
        WalletSchema,
        RecurringTransactionSchema,
        SavingsGoalSchema,
        InstallmentProviderSchema,
        InstallmentPlanSchema,
        AppSettingsSchema,
        DetectedSmsSchema,
      ],
      directory: dir.path,
      name: 'flowspend',
    );

    // Check if SMS parsing is enabled
    final settings = await isar.appSettings.get(0);
    if (settings == null || !settings.smsParsingEnabled) {
      await isar.close();
      return;
    }

    // Save detected SMS
    final detectedSms = DetectedSms()
      ..amount = parsed.amount
      ..type = parsed.type
      ..bank = parsed.bank
      ..rawBody = body
      ..timestamp = DateTime.now()
      ..status = 'pending';

    int savedId = 0;
    await isar.writeTxn(() async {
      savedId = await isar.detectedSms.put(detectedSms);
    });

    // Show notification if enabled
    if (settings.notificationsEnabled) {
      await NotificationService.showTransactionDetected(
        id: savedId,
        amount: parsed.amount,
        type: parsed.type,
        bank: parsed.bank,
      );
    }

    await isar.close();
  } catch (e) {
    // Silently fail in background - log for debugging
    debugPrint('Background SMS handler error: $e');
  }
}

class SmsListenerService {
  static final Telephony _telephony = Telephony.instance;
  static Isar? _isar;
  static bool _isInitialized = false;

  /// Initialize the SMS listener service
  static Future<void> init(Isar isar) async {
    if (_isInitialized) return;

    _isar = isar;
    _isInitialized = true;

    // Check if SMS parsing is enabled
    final settings = await isar.appSettings.get(0);
    if (settings == null || !settings.smsParsingEnabled) {
      debugPrint('SMS parsing disabled in settings');
      return;
    }

    // Check permission status
    final permissionGranted = await _telephony.requestPhoneAndSmsPermissions ?? false;
    if (!permissionGranted) {
      debugPrint('SMS permission not granted');
      return;
    }

    // Start listening for incoming SMS
    _telephony.listenIncomingSms(
      onNewMessage: _onNewMessage,
      onBackgroundMessage: backgroundSmsHandler,
    );

    debugPrint('SMS listener initialized');
  }

  /// Handle incoming SMS in foreground
  static Future<void> _onNewMessage(SmsMessage message) async {
    if (_isar == null) return;

    final body = message.body;
    if (body == null || body.isEmpty) return;

    // Parse the SMS
    final parsed = SmsParserService.parse(body);
    if (parsed == null) return;

    try {
      // Check if SMS parsing is enabled
      final settings = await _isar!.appSettings.get(0);
      if (settings == null || !settings.smsParsingEnabled) return;

      // Save detected SMS
      final detectedSms = DetectedSms()
        ..amount = parsed.amount
        ..type = parsed.type
        ..bank = parsed.bank
        ..rawBody = body
        ..timestamp = DateTime.now()
        ..status = 'pending';

      int savedId = 0;
      await _isar!.writeTxn(() async {
        savedId = await _isar!.detectedSms.put(detectedSms);
      });

      // Show notification if enabled
      if (settings.notificationsEnabled) {
        await NotificationService.showTransactionDetected(
          id: savedId,
          amount: parsed.amount,
          type: parsed.type,
          bank: parsed.bank,
        );
      }
    } catch (e) {
      debugPrint('SMS handler error: $e');
    }
  }

  /// Request SMS permission with optional custom dialog first
  static Future<bool> requestPermission() async {
    return await _telephony.requestPhoneAndSmsPermissions ?? false;
  }

  /// Check if SMS permission is granted (without requesting)
  static Future<bool> hasPermission() async {
    final status = await Permission.sms.status;
    return status.isGranted;
  }

  /// Start listening if not already started (call after permission granted)
  static Future<void> startListening() async {
    if (_isar == null || !_isInitialized) return;

    _telephony.listenIncomingSms(
      onNewMessage: _onNewMessage,
      onBackgroundMessage: backgroundSmsHandler,
    );

    debugPrint('SMS listener started');
  }

  /// Stop listening for SMS (when permission revoked or feature disabled)
  static void stopListening() {
    // Telephony doesn't have a direct "stop" method,
    // but we can prevent processing by checking settings
    debugPrint('SMS listener stopped');
  }
}
