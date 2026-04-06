import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:isar/isar.dart';
import 'dart:io';
import '../../core/theme/app_colors.dart';
import '../../data/models/transaction_model.dart';
import '../../data/models/budget_model.dart';
import '../../data/models/recurring_transaction_model.dart';
import '../../data/models/savings_goal_model.dart';
import '../../data/models/installment_plan_model.dart';
import '../../data/services/backup_service.dart';
import '../../data/services/isar_service.dart';
import '../../providers/settings_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../providers/installment_provider.dart';
import '../../providers/budget_provider.dart';
import '../../providers/goal_provider.dart';
import '../wallets/wallets_screen.dart';
import '../reports/reports_screen.dart';
import '../goals/goals_screen.dart';
import '../recurring/recurring_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Navigation shortcuts
          _buildSection('الشاشات', [
            _buildNavTile(
              context,
              Icons.account_balance_wallet,
              'المحافظ',
              'إدارة المحافظ والأرصدة',
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const WalletsScreen())),
            ),
            _buildNavTile(
              context,
              Icons.bar_chart,
              'التقارير',
              'تحليل المصاريف والأقساط',
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ReportsScreen())),
            ),
            _buildNavTile(
              context,
              Icons.savings,
              'أهداف التوفير',
              'تتبع أهدافك المالية',
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const GoalsScreen())),
            ),
            _buildNavTile(
              context,
              Icons.repeat,
              'المعاملات المتكررة',
              'إيجار، اشتراكات، فواتير',
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RecurringScreen())),
            ),
          ]),

          const SizedBox(height: 16),

          // General settings
          _buildSection('عام', [
            settingsAsync.when(
              data: (settings) => Column(
                children: [
                  _buildInfoTile(Icons.attach_money, 'العملة',
                      '${settings.currency} - جنيه مصري'),
                  _buildInfoTile(
                      Icons.language, 'اللغة', settings.language == 'ar' ? 'العربية' : 'English'),
                  _buildInfoTile(Icons.calendar_today, 'بداية الشهر',
                      'يوم ${settings.monthStartDay}'),
                  _buildInfoTile(Icons.local_fire_department, 'الـ Streak',
                      '${settings.streakDays} يوم'),
                ],
              ),
              loading: () =>
                  const ListTile(title: Text('...')),
              error: (e, _) => ListTile(title: Text('$e')),
            ),
          ]),

          const SizedBox(height: 16),

          // Backup
          _buildSection('البيانات', [
            _buildActionTile(
              Icons.upload,
              'تصدير البيانات',
              'حفظ نسخة احتياطية JSON',
              () => _exportData(context, ref),
              AppColors.primary,
            ),
            _buildActionTile(
              Icons.download,
              'استيراد البيانات',
              'استعادة من نسخة احتياطية',
              () => _importData(context, ref),
              AppColors.secondary,
            ),
            _buildActionTile(
              Icons.share,
              'مشاركة النسخة الاحتياطية',
              'إرسال عبر أي تطبيق',
              () => _shareBackup(context, ref),
              AppColors.accent,
            ),
            _buildActionTile(
              Icons.delete_forever,
              'مسح كل البيانات',
              'حذف جميع البيانات نهائياً',
              () => _clearAllData(context, ref),
              AppColors.danger,
            ),
          ]),

          const SizedBox(height: 16),

          // About
          _buildSection('عن التطبيق', [
            _buildInfoTile(Icons.info_outline, 'الإصدار', '1.0.0'),
            _buildInfoTile(Icons.code, 'التطوير', 'Flutter + Isar'),
          ]),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, right: 4),
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildNavTile(BuildContext context, IconData icon, String title,
      String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
      title: Text(title,
          style: const TextStyle(fontFamily: 'Cairo', color: Colors.white)),
      subtitle: Text(subtitle,
          style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              color: AppColors.textMuted)),
      trailing:
          const Icon(Icons.chevron_left, color: AppColors.textMuted, size: 20),
      onTap: onTap,
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(title,
          style: const TextStyle(fontFamily: 'Cairo', color: Colors.white)),
      trailing: Text(value,
          style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              color: AppColors.textSecondary)),
    );
  }

  Widget _buildActionTile(IconData icon, String title, String subtitle,
      VoidCallback onTap, Color color) {
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(title,
          style: TextStyle(fontFamily: 'Cairo', color: color)),
      subtitle: Text(subtitle,
          style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              color: AppColors.textMuted)),
      onTap: onTap,
    );
  }

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    try {
      final backup = BackupService(ref.read(isarProvider));
      final file = await backup.exportToJson();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم حفظ النسخة الاحتياطية: ${file.path}')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في التصدير: $e')),
        );
      }
    }
  }

  Future<void> _importData(BuildContext context, WidgetRef ref) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (result == null || result.files.single.path == null) return;

      final file = File(result.files.single.path!);
      final backup = BackupService(ref.read(isarProvider));
      final success = await backup.importFromJson(file);

      if (context.mounted) {
        if (success) {
          // Refresh all providers
          refreshTransactions(ref);
          refreshWallets(ref);
          refreshInstallments(ref);
          refreshBudgets(ref);
          refreshGoals(ref);
          refreshSettings(ref);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم استيراد البيانات بنجاح')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ملف غير صالح')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في الاستيراد: $e')),
        );
      }
    }
  }

  Future<void> _shareBackup(BuildContext context, WidgetRef ref) async {
    try {
      final backup = BackupService(ref.read(isarProvider));
      await backup.shareBackup();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e')),
        );
      }
    }
  }

  Future<void> _clearAllData(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('⚠️ مسح كل البيانات؟',
            style: TextStyle(fontFamily: 'Cairo', color: Colors.white)),
        content: const Text(
          'هيتم حذف كل المعاملات والميزانيات والأقساط والأهداف.\nالعملية دي مش ممكن التراجع عنها!',
          style: TextStyle(fontFamily: 'Cairo', color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('لا، رجّعني',
                style: TextStyle(fontFamily: 'Cairo')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('نعم، امسح كل حاجة',
                style: TextStyle(
                    fontFamily: 'Cairo', color: AppColors.danger)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final isar = ref.read(isarProvider);
      await isar.writeTxn(() async {
        await isar.transactions.clear();
        await isar.budgets.clear();
        await isar.recurringTransactions.clear();
        await isar.savingsGoals.clear();
        await isar.installmentPlans.clear();
      });

      refreshTransactions(ref);
      refreshWallets(ref);
      refreshInstallments(ref);
      refreshBudgets(ref);
      refreshGoals(ref);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم مسح كل البيانات')),
        );
      }
    }
  }
}
