import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'core/router/app_router.dart';
import 'data/services/notification_service.dart';
import 'data/models/transaction_model.dart';
import 'data/models/category_model.dart';
import 'data/models/budget_model.dart';
import 'data/models/wallet_model.dart';
import 'data/models/recurring_transaction_model.dart';
import 'data/models/savings_goal_model.dart';
import 'data/models/installment_provider_model.dart';
import 'data/models/installment_plan_model.dart';
import 'data/models/app_settings_model.dart';
import 'data/models/detected_sms_model.dart';
import 'data/services/isar_service.dart';
import 'data/services/sms_listener_service.dart';
import 'data/seeds/default_categories.dart';
import 'data/seeds/default_installment_providers.dart';
import 'data/seeds/dummy_data.dart';

/// Global navigator key for notification deep linking
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications with tap handler for SMS confirmation
  await NotificationService.init(
    onNotificationTap: (payload) {
      if (payload != null && payload.startsWith('sms:')) {
        final smsId = int.tryParse(payload.substring(4));
        if (smsId != null) {
          navigatorKey.currentState?.pushNamed(
            AppRouter.smsConfirmation,
            arguments: smsId,
          );
        }
      }
    },
  );

  await initializeDateFormatting('ar', null);

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

  final settingsCount = await isar.appSettings.count();
  final isFirstLaunch = settingsCount == 0;
  if (isFirstLaunch) {
    await _seedDefaults(isar);
  }

  // Initialize SMS listener service
  await SmsListenerService.init(isar);

  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isar),
      ],
      child: FlowSpendApp(showOnboarding: isFirstLaunch),
    ),
  );
}

Future<void> _seedDefaults(Isar isar) async {
  await isar.writeTxn(() async {
    // Settings
    await isar.appSettings.put(AppSettings());

    // Default wallet
    await isar.wallets.put(
      Wallet()
        ..name = 'كاش'
        ..type = 'cash'
        ..balance = 0
        ..icon = 'wallet'
        ..color = '#10B981'
        ..sortOrder = 0,
    );

    // Default categories
    for (var i = 0; i < defaultCategories.length; i++) {
      final cat = defaultCategories[i];
      await isar.categorys.put(
        Category()
          ..name = cat['name'] as String
          ..type = cat['type'] as String
          ..icon = cat['icon'] as String
          ..color = cat['color'] as String
          ..subcategories =
              List<String>.from(cat['subcategories'] as List<dynamic>)
          ..sortOrder = i,
      );
    }

    // Default installment providers
    for (final provider in defaultInstallmentProviders) {
      await isar.installmentProviders.put(
        InstallmentProvider()
          ..name = provider['name'] as String
          ..icon = provider['icon'] as String
          ..color = provider['color'] as String
          ..createdAt = DateTime.now(),
      );
    }

    // Seed dummy data for testing and demo
    for (final wallet in DummyData.dummyWallets) {
      await isar.wallets.put(wallet);
    }
    for (final transaction in DummyData.dummyTransactions) {
      await isar.transactions.put(transaction);
    }
    for (final budget in DummyData.dummyBudgets) {
      await isar.budgets.put(budget);
    }
    for (final goal in DummyData.dummyGoals) {
      await isar.savingsGoals.put(goal);
    }
    for (final recurring in DummyData.dummyRecurring) {
      await isar.recurringTransactions.put(recurring);
    }
    for (final installment in DummyData.dummyInstallments) {
      await isar.installmentPlans.put(installment);
    }
  });
}
