import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction_model.dart';
import '../models/category_model.dart';
import '../models/budget_model.dart';
import '../models/wallet_model.dart';
import '../models/recurring_transaction_model.dart';
import '../models/savings_goal_model.dart';
import '../models/installment_provider_model.dart';
import '../models/installment_plan_model.dart';
import '../models/app_settings_model.dart';
import '../models/detected_sms_model.dart';
import '../models/envelope_model.dart';
import '../models/transaction_tag_model.dart';
import '../models/insight_model.dart';

final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError('Must be overridden in main.dart');
});

class IsarService {
  static Future<Isar> open() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(
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
        EnvelopeSchema,
        TransactionTagSchema,
        InsightSchema,
      ],
      directory: dir.path,
      name: 'flowspend',
    );
  }
}
