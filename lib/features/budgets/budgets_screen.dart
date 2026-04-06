import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/budget_model.dart';
import '../../providers/budget_provider.dart';
import '../../providers/category_provider.dart';
import '../../shared/widgets/empty_state.dart';
import 'widgets/budget_progress_card.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsAsync = ref.watch(activeBudgetsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('الميزانية')),
      body: budgetsAsync.when(
        data: (budgets) {
          if (budgets.isEmpty) {
            return const EmptyState(
              icon: Icons.pie_chart,
              message: 'مفيش ميزانيات محددة\nحدد ميزانية لكل فئة',
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
                        backgroundColor: AppColors.surface,
                        title: const Text('حذف الميزانية؟',
                            style: TextStyle(
                                fontFamily: 'Cairo', color: Colors.white)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('لا',
                                style: TextStyle(fontFamily: 'Cairo')),
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

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final categoriesAsync = ref.watch(expenseCategoriesProvider);

          return AlertDialog(
            backgroundColor: AppColors.surface,
            title: const Text('إضافة ميزانية',
                style: TextStyle(fontFamily: 'Cairo', color: Colors.white)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('الفئة',
                      style: TextStyle(
                          fontFamily: 'Cairo', color: AppColors.textSecondary)),
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
                                  : AppColors.background,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(c.name,
                                style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 13,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textSecondary)),
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
                    style: const TextStyle(
                        fontFamily: 'Cairo', color: Colors.white),
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
                child: const Text('إلغاء',
                    style: TextStyle(
                        fontFamily: 'Cairo', color: AppColors.textMuted)),
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
    );
  }
}
