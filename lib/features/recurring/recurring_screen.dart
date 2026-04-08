import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/recurring_transaction_model.dart';
import '../../providers/recurring_provider.dart';
import '../../shared/widgets/empty_state.dart';
import 'widgets/recurring_tile.dart';

class RecurringScreen extends ConsumerWidget {
  const RecurringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recurringAsync = ref.watch(activeRecurringProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('المعاملات المتكررة')),
      body: recurringAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const EmptyState(
              icon: Icons.repeat,
              message: 'مفيش معاملات متكررة\nأضف إيجار، اشتراكات، فواتير',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: RecurringTile(
                  recurring: items[index],
                  onTap: () => _showEditDialog(context, ref, items[index]),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showEditDialog(
      BuildContext context, WidgetRef ref, RecurringTransaction recurring) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(recurring.name,
            style: const TextStyle(fontFamily: 'Cairo', color: AppColors.textPrimary)),
        content: Text(
          'تلقائي: ${recurring.autoAdd ? "نعم" : "لا"}\nنشط: ${recurring.isActive ? "نعم" : "لا"}',
          style:
              const TextStyle(fontFamily: 'Cairo', color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await ref.read(recurringRepoProvider).delete(recurring.id);
              ref.invalidate(activeRecurringProvider);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('حذف',
                style: TextStyle(
                    fontFamily: 'Cairo', color: AppColors.danger)),
          ),
          TextButton(
            onPressed: () async {
              // Close dialog first, then update to avoid stale state
              Navigator.pop(ctx);
              recurring.isActive = !recurring.isActive;
              await ref.read(recurringRepoProvider).update(recurring);
              ref.invalidate(activeRecurringProvider);
            },
            child: Text(
              recurring.isActive ? 'إيقاف' : 'تفعيل',
              style: const TextStyle(
                  fontFamily: 'Cairo', color: AppColors.primary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إغلاق',
                style: TextStyle(fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    String type = 'expense';
    String frequency = 'monthly';
    String category = 'فواتير';
    bool autoAdd = false;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('إضافة معاملة متكررة',
              style: TextStyle(fontFamily: 'Cairo', color: AppColors.textPrimary)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(
                      fontFamily: 'Cairo', color: AppColors.textPrimary),
                  decoration: const InputDecoration(hintText: 'الاسم'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                      fontFamily: 'Cairo', color: AppColors.textPrimary),
                  decoration: const InputDecoration(hintText: 'المبلغ'),
                ),
                const SizedBox(height: 12),

                // Type toggle
                Row(
                  children: [
                    _chip('مصروف', type == 'expense',
                        () => setDialogState(() => type = 'expense')),
                    const SizedBox(width: 8),
                    _chip('دخل', type == 'income',
                        () => setDialogState(() => type = 'income')),
                  ],
                ),
                const SizedBox(height: 8),

                // Frequency
                Row(
                  children: ['monthly', 'weekly', 'yearly'].map((f) {
                    return Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: _chip(
                        _freqLabel(f),
                        frequency == f,
                        () => setDialogState(() => frequency = f),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),

                // Auto-add
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('تسجيل تلقائي',
                        style: TextStyle(
                            fontFamily: 'Cairo', color: AppColors.textPrimary)),
                    Switch(
                      value: autoAdd,
                      onChanged: (v) => setDialogState(() => autoAdd = v),
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء',
                  style: TextStyle(
                      fontFamily: 'Cairo', color: AppColors.textMuted)),
            ),
            TextButton(
              onPressed: () async {
                final amount = double.tryParse(amountController.text);
                if (nameController.text.isEmpty || amount == null) return;

                await ref.read(recurringRepoProvider).add(
                      RecurringTransaction()
                        ..name = nameController.text
                        ..amount = amount
                        ..type = type
                        ..category = category
                        ..frequency = frequency
                        ..autoAdd = autoAdd
                        ..startDate = DateTime.now()
                        ..nextDueDate = DateTime.now(),
                    );
                ref.invalidate(activeRecurringProvider);
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('إضافة',
                  style: TextStyle(
                      fontFamily: 'Cairo', color: AppColors.primary)),
            ),
          ],
        ),
      ),
    ).then((_) {
      nameController.dispose();
      amountController.dispose();
    });
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border:
              selected ? null : Border.all(color: AppColors.textMuted),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  String _freqLabel(String freq) {
    switch (freq) {
      case 'daily':
        return 'يومي';
      case 'weekly':
        return 'أسبوعي';
      case 'monthly':
        return 'شهري';
      case 'yearly':
        return 'سنوي';
      default:
        return freq;
    }
  }
}
