import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/recurring_transaction_model.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../providers/recurring_provider.dart';
import '../../shared/widgets/empty_state.dart';
import 'widgets/recurring_tile.dart';

class RecurringScreen extends ConsumerWidget {
  const RecurringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final recurringAsync = ref.watch(activeRecurringProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.screenRecurring)),
      body: recurringAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              icon: Icons.repeat,
              message: l10n.emptyRecurringTransactions,
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
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.surface : AppColors.lightSurface,
        title: Text(recurring.name,
            style: TextStyle(fontFamily: 'Cairo', color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary)),
        content: Text(
          'تلقائي: ${recurring.autoAdd ? "نعم" : "لا"}\nنشط: ${recurring.isActive ? "نعم" : "لا"}',
          style:
              TextStyle(fontFamily: 'Cairo', color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await ref.read(recurringRepoProvider).delete(recurring.id);
              ref.invalidate(activeRecurringProvider);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: Text(l10n.buttonDelete,
                style: const TextStyle(
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
              recurring.isActive ? l10n.pauseRecurring : l10n.activateRecurring,
              style: const TextStyle(
                  fontFamily: 'Cairo', color: AppColors.primary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.buttonClose,
                style: const TextStyle(fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    String type = 'expense';
    String frequency = 'monthly';
    String category = 'فواتير';
    bool autoAdd = false;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: isDark ? AppColors.surface : AppColors.lightSurface,
          title: Text(l10n.addRecurring,
              style: TextStyle(fontFamily: 'Cairo', color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: TextStyle(
                      fontFamily: 'Cairo', color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary),
                  decoration: InputDecoration(hintText: l10n.name),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      fontFamily: 'Cairo', color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary),
                  decoration: InputDecoration(hintText: l10n.labelAmount),
                ),
                const SizedBox(height: 12),

                // Type toggle
                Row(
                  children: [
                    _chip(l10n.transactionTypeExpense, type == 'expense',
                        () => setDialogState(() => type = 'expense'), isDark),
                    const SizedBox(width: 8),
                    _chip(l10n.transactionTypeIncome, type == 'income',
                        () => setDialogState(() => type = 'income'), isDark),
                  ],
                ),
                const SizedBox(height: 8),

                // Frequency
                Row(
                  children: ['monthly', 'weekly', 'yearly'].map((f) {
                    return Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: _chip(
                        _freqLabel(f, l10n),
                        frequency == f,
                        () => setDialogState(() => frequency = f),
                        isDark,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),

                // Auto-add
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.autoRecord,
                        style: TextStyle(
                            fontFamily: 'Cairo', color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary)),
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
              child: Text(l10n.buttonCancel,
                  style: TextStyle(
                      fontFamily: 'Cairo', color: isDark ? AppColors.textMuted : AppColors.lightTextMuted)),
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
              child: Text(l10n.buttonAdd,
                  style: const TextStyle(
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

  Widget _chip(String label, bool selected, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border:
              selected ? null : Border.all(color: isDark ? AppColors.textMuted : AppColors.lightTextMuted),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            color: selected ? Colors.white : (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
          ),
        ),
      ),
    );
  }

  String _freqLabel(String freq, AppLocalizations l10n) {
    switch (freq) {
      case 'daily':
        return l10n.frequencyDaily;
      case 'weekly':
        return l10n.frequencyWeekly;
      case 'monthly':
        return l10n.frequencyMonthly;
      case 'yearly':
        return l10n.frequencyYearly;
      default:
        return freq;
    }
  }
}
