import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'data/models/transaction_model.dart';
import 'data/models/category_model.dart';
import 'data/models/budget_model.dart';
import 'data/models/wallet_model.dart';
import 'data/models/recurring_transaction_model.dart';
import 'data/models/savings_goal_model.dart';
import 'data/models/installment_provider_model.dart';
import 'data/models/installment_plan_model.dart';
import 'data/models/app_settings_model.dart';
import 'data/services/isar_service.dart';
import 'data/seeds/default_categories.dart';
import 'data/seeds/default_installment_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
    ],
    directory: dir.path,
    name: 'flowspend',
  );

  final settingsCount = await isar.appSettings.count();
  if (settingsCount == 0) {
    await _seedDefaults(isar);
  }

  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isar),
      ],
      child: const FlowSpendApp(),
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
          ..name = provider['name']!
          ..icon = provider['icon']!
          ..color = provider['color']!
          ..createdAt = DateTime.now(),
      );
    }
  });
}
