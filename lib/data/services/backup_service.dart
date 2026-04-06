import 'dart:convert';
import 'dart:io';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../models/transaction_model.dart';
import '../models/category_model.dart';
import '../models/budget_model.dart';
import '../models/wallet_model.dart';
import '../models/recurring_transaction_model.dart';
import '../models/savings_goal_model.dart';
import '../models/installment_provider_model.dart';
import '../models/installment_plan_model.dart';
import '../models/app_settings_model.dart';

class BackupService {
  final Isar isar;

  BackupService(this.isar);

  Future<File> exportToJson() async {
    final data = {
      'version': 2,
      'exportDate': DateTime.now().toIso8601String(),
      'app': 'FlowSpend',
      'transactions': await _exportTransactions(),
      'categories': await _exportCategories(),
      'budgets': await _exportBudgets(),
      'wallets': await _exportWallets(),
      'recurringTransactions': await _exportRecurring(),
      'savingsGoals': await _exportGoals(),
      'installmentProviders': await _exportInstallmentProviders(),
      'installmentPlans': await _exportInstallmentPlans(),
      'settings': await _exportSettings(),
    };

    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyy-MM-dd_HH-mm').format(DateTime.now());
    final file = File('${dir.path}/flowspend_backup_$timestamp.json');
    await file.writeAsString(jsonEncode(data));
    return file;
  }

  Future<bool> importFromJson(File file) async {
    try {
      final content = await file.readAsString();
      final data = jsonDecode(content) as Map<String, dynamic>;

      if (data['app'] != 'FlowSpend') return false;

      await isar.writeTxn(() async {
        await isar.transactions.clear();
        await isar.categorys.clear();
        await isar.budgets.clear();
        await isar.wallets.clear();
        await isar.recurringTransactions.clear();
        await isar.savingsGoals.clear();
        await isar.installmentProviders.clear();
        await isar.installmentPlans.clear();
        await isar.appSettings.clear();

        await _importTransactions(data['transactions'] as List?);
        await _importCategories(data['categories'] as List?);
        await _importBudgets(data['budgets'] as List?);
        await _importWallets(data['wallets'] as List?);
        await _importRecurring(data['recurringTransactions'] as List?);
        await _importGoals(data['savingsGoals'] as List?);

        if (data.containsKey('installmentProviders')) {
          await _importInstallmentProviders(
              data['installmentProviders'] as List?);
        }
        if (data.containsKey('installmentPlans')) {
          await _importInstallmentPlans(data['installmentPlans'] as List?);
        }

        // Always restore settings (use defaults if missing from backup)
        final s = data['settings'] as Map<String, dynamic>? ?? {};
        await isar.appSettings.put(AppSettings()
          ..currency = s['currency'] as String? ?? 'EGP'
          ..language = s['language'] as String? ?? 'ar'
          ..monthStartDay = s['monthStartDay'] as int? ?? 1
          ..smsParsingEnabled = s['smsParsingEnabled'] as bool? ?? true
          ..notificationsEnabled = s['notificationsEnabled'] as bool? ?? true);
      });

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> shareBackup() async {
    final file = await exportToJson();
    await Share.shareXFiles([XFile(file.path)], subject: 'FlowSpend Backup');
  }

  // Export helpers
  Future<List<Map<String, dynamic>>> _exportTransactions() async {
    final items = await isar.transactions.where().findAll();
    return items
        .map((t) => {
              'amount': t.amount,
              'type': t.type,
              'category': t.category,
              'subcategory': t.subcategory,
              'note': t.note,
              'merchant': t.merchant,
              'date': t.date.toIso8601String(),
              'walletId': t.walletId,
              'source': t.source,
              'installmentPlanId': t.installmentPlanId,
              'isInterest': t.isInterest,
              'createdAt': t.createdAt.toIso8601String(),
            })
        .toList();
  }

  Future<List<Map<String, dynamic>>> _exportCategories() async {
    final items = await isar.categorys.where().findAll();
    return items
        .map((c) => {
              'name': c.name,
              'type': c.type,
              'icon': c.icon,
              'color': c.color,
              'subcategories': c.subcategories,
              'isCustom': c.isCustom,
              'sortOrder': c.sortOrder,
            })
        .toList();
  }

  Future<List<Map<String, dynamic>>> _exportBudgets() async {
    final items = await isar.budgets.where().findAll();
    return items
        .map((b) => {
              'categoryName': b.categoryName,
              'limitAmount': b.limitAmount,
              'period': b.period,
              'startDate': b.startDate.toIso8601String(),
              'isActive': b.isActive,
            })
        .toList();
  }

  Future<List<Map<String, dynamic>>> _exportWallets() async {
    final items = await isar.wallets.where().findAll();
    return items
        .map((w) => {
              'name': w.name,
              'type': w.type,
              'balance': w.balance,
              'icon': w.icon,
              'color': w.color,
              'sortOrder': w.sortOrder,
            })
        .toList();
  }

  Future<List<Map<String, dynamic>>> _exportRecurring() async {
    final items = await isar.recurringTransactions.where().findAll();
    return items
        .map((r) => {
              'amount': r.amount,
              'type': r.type,
              'category': r.category,
              'name': r.name,
              'frequency': r.frequency,
              'nextDueDate': r.nextDueDate.toIso8601String(),
              'startDate': r.startDate.toIso8601String(),
              'isActive': r.isActive,
              'autoAdd': r.autoAdd,
            })
        .toList();
  }

  Future<List<Map<String, dynamic>>> _exportGoals() async {
    final items = await isar.savingsGoals.where().findAll();
    return items
        .map((g) => {
              'name': g.name,
              'targetAmount': g.targetAmount,
              'currentAmount': g.currentAmount,
              'icon': g.icon,
              'createdAt': g.createdAt.toIso8601String(),
              'isCompleted': g.isCompleted,
            })
        .toList();
  }

  Future<List<Map<String, dynamic>>> _exportInstallmentProviders() async {
    final items = await isar.installmentProviders.where().findAll();
    return items
        .map((p) => {
              'name': p.name,
              'icon': p.icon,
              'color': p.color,
              'creditLimit': p.creditLimit,
            })
        .toList();
  }

  Future<List<Map<String, dynamic>>> _exportInstallmentPlans() async {
    final items = await isar.installmentPlans.where().findAll();
    return items
        .map((p) => {
              'itemName': p.itemName,
              'category': p.category,
              'providerId': p.providerId,
              'originalPrice': p.originalPrice,
              'totalWithInterest': p.totalWithInterest,
              'totalInstallments': p.totalInstallments,
              'monthlyAmount': p.monthlyAmount,
              'firstPaymentDate': p.firstPaymentDate.toIso8601String(),
              'dayOfMonth': p.dayOfMonth,
              'paidInstallments': p.paidInstallments,
              'paidAmount': p.paidAmount,
              'status': p.status,
              'walletId': p.walletId,
              'autoAdd': p.autoAdd,
            })
        .toList();
  }

  Future<Map<String, dynamic>> _exportSettings() async {
    final s = await isar.appSettings.get(0) ?? AppSettings();
    return {
      'currency': s.currency,
      'language': s.language,
      'monthStartDay': s.monthStartDay,
      'streakDays': s.streakDays,
    };
  }

  // Import helpers
  Future<void> _importTransactions(List? items) async {
    if (items == null) return;
    for (final item in items) {
      final m = item as Map<String, dynamic>;
      await isar.transactions.put(Transaction()
        ..amount = (m['amount'] as num).toDouble()
        ..type = m['type']
        ..category = m['category']
        ..subcategory = m['subcategory']
        ..note = m['note']
        ..merchant = m['merchant']
        ..date = DateTime.parse(m['date'])
        ..walletId = (m['walletId'] as int?) ?? 1
        ..source = m['source'] ?? 'manual'
        ..installmentPlanId = m['installmentPlanId']
        ..isInterest = m['isInterest'] ?? false
        ..createdAt = DateTime.parse(m['createdAt']));
    }
  }

  Future<void> _importCategories(List? items) async {
    if (items == null) return;
    for (final item in items) {
      final m = item as Map<String, dynamic>;
      await isar.categorys.put(Category()
        ..name = m['name']
        ..type = m['type']
        ..icon = m['icon']
        ..color = m['color']
        ..subcategories = List<String>.from(m['subcategories'] ?? [])
        ..isCustom = m['isCustom'] ?? false
        ..sortOrder = m['sortOrder'] ?? 0);
    }
  }

  Future<void> _importBudgets(List? items) async {
    if (items == null) return;
    for (final item in items) {
      final m = item as Map<String, dynamic>;
      await isar.budgets.put(Budget()
        ..categoryName = m['categoryName']
        ..limitAmount = (m['limitAmount'] as num).toDouble()
        ..period = m['period']
        ..startDate = DateTime.parse(m['startDate'])
        ..isActive = m['isActive'] ?? true);
    }
  }

  Future<void> _importWallets(List? items) async {
    if (items == null) return;
    for (final item in items) {
      final m = item as Map<String, dynamic>;
      await isar.wallets.put(Wallet()
        ..name = m['name']
        ..type = m['type']
        ..balance = (m['balance'] as num).toDouble()
        ..icon = m['icon']
        ..color = m['color']
        ..sortOrder = m['sortOrder'] ?? 0);
    }
  }

  Future<void> _importRecurring(List? items) async {
    if (items == null) return;
    for (final item in items) {
      final m = item as Map<String, dynamic>;
      await isar.recurringTransactions.put(RecurringTransaction()
        ..amount = (m['amount'] as num).toDouble()
        ..type = m['type']
        ..category = m['category']
        ..name = m['name']
        ..frequency = m['frequency']
        ..nextDueDate = DateTime.parse(m['nextDueDate'])
        ..startDate = DateTime.parse(m['startDate'])
        ..isActive = m['isActive'] ?? true
        ..autoAdd = m['autoAdd'] ?? false);
    }
  }

  Future<void> _importGoals(List? items) async {
    if (items == null) return;
    for (final item in items) {
      final m = item as Map<String, dynamic>;
      await isar.savingsGoals.put(SavingsGoal()
        ..name = m['name']
        ..targetAmount = (m['targetAmount'] as num).toDouble()
        ..currentAmount = (m['currentAmount'] as num).toDouble()
        ..icon = m['icon']
        ..createdAt = DateTime.parse(m['createdAt'])
        ..isCompleted = m['isCompleted'] ?? false);
    }
  }

  Future<void> _importInstallmentProviders(List? items) async {
    if (items == null) return;
    for (final item in items) {
      final m = item as Map<String, dynamic>;
      await isar.installmentProviders.put(InstallmentProvider()
        ..name = m['name']
        ..icon = m['icon']
        ..color = m['color']
        ..creditLimit = m['creditLimit'] != null
            ? (m['creditLimit'] as num).toDouble()
            : null
        ..createdAt = DateTime.now());
    }
  }

  Future<void> _importInstallmentPlans(List? items) async {
    if (items == null) return;
    for (final item in items) {
      final m = item as Map<String, dynamic>;
      await isar.installmentPlans.put(InstallmentPlan()
        ..itemName = m['itemName']
        ..category = m['category']
        ..providerId = m['providerId']
        ..originalPrice = (m['originalPrice'] as num).toDouble()
        ..totalWithInterest = (m['totalWithInterest'] as num).toDouble()
        ..totalInstallments = m['totalInstallments']
        ..monthlyAmount = (m['monthlyAmount'] as num).toDouble()
        ..firstPaymentDate = DateTime.parse(m['firstPaymentDate'])
        ..dayOfMonth = m['dayOfMonth'] ?? 1
        ..paidInstallments = m['paidInstallments'] ?? 0
        ..paidAmount = (m['paidAmount'] as num?)?.toDouble() ?? 0
        ..status = m['status'] ?? 'active'
        ..walletId = (m['walletId'] as int?) ?? 1
        ..autoAdd = m['autoAdd'] ?? false
        ..createdAt = DateTime.now());
    }
  }
}
