import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../../core/theme/app_colors.dart';
import '../../../data/services/backup_service.dart';
import '../../../data/services/isar_service.dart';
import '../../../providers/transaction_provider.dart';
import '../../../providers/wallet_provider.dart';
import '../../../providers/installment_provider.dart';
import '../../../providers/budget_provider.dart';
import '../../../providers/goal_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/models/budget_model.dart';
import '../../../data/models/recurring_transaction_model.dart';
import '../../../data/models/savings_goal_model.dart';
import '../../../data/models/installment_plan_model.dart';

class BackupSection extends ConsumerWidget {
  const BackupSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8, right: 4),
          child: Text(
            'البيانات',
            style: TextStyle(
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
          child: Column(
            children: [
              _ActionTile(
                icon: Icons.upload,
                title: 'تصدير البيانات',
                subtitle: 'حفظ نسخة احتياطية JSON',
                color: AppColors.primary,
                onTap: () => _export(context, ref),
              ),
              _ActionTile(
                icon: Icons.download,
                title: 'استيراد البيانات',
                subtitle: 'استعادة من نسخة احتياطية',
                color: AppColors.secondary,
                onTap: () => _import(context, ref),
              ),
              _ActionTile(
                icon: Icons.share,
                title: 'مشاركة النسخة الاحتياطية',
                subtitle: 'إرسال عبر أي تطبيق',
                color: AppColors.accent,
                onTap: () => _share(context, ref),
              ),
              _ActionTile(
                icon: Icons.delete_forever,
                title: 'مسح كل البيانات',
                subtitle: 'حذف جميع البيانات نهائياً',
                color: AppColors.danger,
                onTap: () => _clearAll(context, ref),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    try {
      final backup = BackupService(ref.read(isarProvider));
      final file = await backup.exportToJson();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم الحفظ: ${file.path}')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('خطأ: $e')));
      }
    }
  }

  Future<void> _import(BuildContext context, WidgetRef ref) async {
    try {
      final result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['json']);
      if (result == null || result.files.single.path == null) return;

      final file = File(result.files.single.path!);
      final backup = BackupService(ref.read(isarProvider));
      final success = await backup.importFromJson(file);

      if (context.mounted) {
        if (success) {
          refreshTransactions(ref);
          refreshWallets(ref);
          refreshInstallments(ref);
          refreshBudgets(ref);
          refreshGoals(ref);
          refreshSettings(ref);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم الاستيراد بنجاح')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ملف غير صالح')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('خطأ: $e')));
      }
    }
  }

  Future<void> _share(BuildContext context, WidgetRef ref) async {
    try {
      final backup = BackupService(ref.read(isarProvider));
      await backup.shareBackup();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('خطأ: $e')));
      }
    }
  }

  Future<void> _clearAll(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('مسح كل البيانات؟',
            style: TextStyle(fontFamily: 'Cairo', color: Colors.white)),
        content: const Text(
          'هيتم حذف كل المعاملات والميزانيات والأقساط والأهداف.\nمش ممكن التراجع!',
          style: TextStyle(fontFamily: 'Cairo', color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child:
                const Text('لا', style: TextStyle(fontFamily: 'Cairo')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('نعم، امسح',
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

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
}
