import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/budget_model.dart';
import '../../providers/budget_provider.dart';
import '../../providers/category_provider.dart';
import '../../shared/widgets/empty_state.dart';
import '../../l10n/generated/app_localizations.dart';
import 'widgets/budget_progress_card.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsAsync = ref.watch(activeBudgetsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navBudgets)),
      body: budgetsAsync.when(
        data: (budgets) {
          if (budgets.isEmpty) {
            return EmptyState(
              icon: Icons.pie_chart,
              message: l10n.emptyBudgets,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: budgets.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: BudgetProgressCard(
                  budget: budgets[index],
                  onDelete: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: isDark ? AppColors.surface : AppColors.lightSurface,
                        title: Text(l10n.deleteBudget,
                            style: TextStyle(
                                fontFamily: 'Cairo', color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text(l10n.buttonNo,
                                style: const TextStyle(fontFamily: 'Cairo')),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('نعم',
                                style: TextStyle(
                                    fontFamily: 'Cairo',
                                    color: AppColors.danger)),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      await ref
                          .read(budgetRepoProvider)
                          .delete(budgets[index].id);
                      refreshBudgets(ref);
                    }
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBudgetDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddBudgetDialog(BuildContext context, WidgetRef ref) {
    final limitController = TextEditingController();
    String? selectedCategory;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final categoriesAsync = ref.watch(expenseCategoriesProvider);

          return AlertDialog(
            backgroundColor: isDark ? AppColors.surface : AppColors.lightSurface,
            title: Text('إضافة ميزانية',
                style: TextStyle(fontFamily: 'Cairo', color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('الفئة',
                      style: TextStyle(
                          fontFamily: 'Cairo', color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary)),
                  const SizedBox(height: 8),
                  categoriesAsync.when(
                    data: (cats) => Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: cats.map((c) {
                        final isSelected = selectedCategory == c.name;
                        return GestureDetector(
                          onTap: () =>
                              setDialogState(() => selectedCategory = c.name),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : (isDark ? AppColors.background : AppColors.lightBackground),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(c.name,
                                style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 13,
                                    color: isSelected
                                        ? Colors.white
                                        : (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary))),
                          ),
                        );
                      }).toList(),
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (e, _) => Text('$e'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: limitController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        fontFamily: 'Cairo', color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary),
                    decoration: const InputDecoration(
                      hintText: 'الحد الأقصى (جنيه)',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('إلغاء',
                    style: TextStyle(
                        fontFamily: 'Cairo', color: isDark ? AppColors.textMuted : AppColors.lightTextMuted)),
              ),
              TextButton(
                onPressed: () async {
                  if (selectedCategory == null ||
                      limitController.text.isEmpty) return;
                  final limit = double.tryParse(limitController.text);
                  if (limit == null || limit <= 0) return;

                  await ref.read(budgetRepoProvider).add(Budget()
                    ..categoryName = selectedCategory!
                    ..limitAmount = limit
                    ..period = 'monthly'
                    ..startDate = DateTime.now());

                  refreshBudgets(ref);
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                child: const Text('إضافة',
                    style: TextStyle(
                        fontFamily: 'Cairo', color: AppColors.primary)),
              ),
            ],
          );
        },
      ),
    ).then((_) => limitController.dispose());
  }
}
