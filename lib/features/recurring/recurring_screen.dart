import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/app_date_utils.dart';
import '../../data/models/recurring_transaction_model.dart';
import '../../data/repositories/recurring_repo.dart';
import '../../data/services/isar_service.dart';
import '../../shared/widgets/empty_state.dart';

final recurringRepoProvider = Provider<RecurringRepo>((ref) {
  return RecurringRepo(ref.watch(isarProvider));
});

final activeRecurringProvider =
    FutureProvider<List<RecurringTransaction>>((ref) async {
  return ref.watch(recurringRepoProvider).getActive();
});

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
              final r = items[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: (r.type == 'income'
                                ? AppColors.success
                                : AppColors.danger)
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.repeat,
                        color: r.type == 'income'
                            ? AppColors.success
                            : AppColors.danger,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.name,
                              style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                          Text(
                            '${_freqLabel(r.frequency)} · القادم: ${AppDateUtils.formatDate(r.nextDueDate)}',
                            style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      CurrencyFormatter.format(r.amount),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: r.type == 'income'
                            ? AppColors.secondary
                            : AppColors.danger,
                      ),
                    ),
                  ],
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

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    String type = 'expense';
    String frequency = 'monthly';
    String category = 'فواتير';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('إضافة معاملة متكررة',
              style: TextStyle(fontFamily: 'Cairo', color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(
                      fontFamily: 'Cairo', color: Colors.white),
                  decoration: const InputDecoration(hintText: 'الاسم'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                      fontFamily: 'Cairo', color: Colors.white),
                  decoration: const InputDecoration(hintText: 'المبلغ'),
                ),
                const SizedBox(height: 8),
                Row(
                  children: ['monthly', 'weekly', 'yearly'].map((f) {
                    final isSelected = frequency == f;
                    return Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: GestureDetector(
                        onTap: () => setDialogState(() => frequency = f),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: isSelected
                                ? null
                                : Border.all(color: AppColors.textMuted),
                          ),
                          child: Text(
                            _freqLabel(f),
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 13,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
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
    );
  }
}
