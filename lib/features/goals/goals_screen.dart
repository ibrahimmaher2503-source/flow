import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/models/savings_goal_model.dart';
import '../../providers/goal_provider.dart';
import '../../shared/widgets/empty_state.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(activeGoalsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('أهداف التوفير')),
      body: goalsAsync.when(
        data: (goals) {
          if (goals.isEmpty) {
            return const EmptyState(
              icon: Icons.savings,
              message: 'مفيش أهداف توفير\nحدد هدف وابدأ ادخر',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: goals.length,
            itemBuilder: (context, index) {
              final goal = goals[index];
              final percent = goal.targetAmount > 0
                  ? (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0)
                  : 0.0;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircularPercentIndicator(
                      radius: 32,
                      lineWidth: 5,
                      percent: percent,
                      center: Text(
                        '${(percent * 100).toInt()}%',
                        style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      progressColor: AppColors.secondary,
                      backgroundColor: AppColors.background,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(goal.name,
                              style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                          Text(
                            '${CurrencyFormatter.format(goal.currentAmount)} / ${CurrencyFormatter.format(goal.targetAmount)}',
                            style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 13,
                                color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle,
                          color: AppColors.primary),
                      onPressed: () =>
                          _showContributeDialog(context, ref, goal),
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
        onPressed: () => _showAddGoalDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showContributeDialog(
      BuildContext context, WidgetRef ref, SavingsGoal goal) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('إضافة مبلغ لـ ${goal.name}',
            style: const TextStyle(fontFamily: 'Cairo', color: Colors.white)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(fontFamily: 'Cairo', color: Colors.white),
          decoration: const InputDecoration(hintText: 'المبلغ'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء',
                style: TextStyle(fontFamily: 'Cairo')),
          ),
          TextButton(
            onPressed: () async {
              final amount = double.tryParse(controller.text);
              if (amount == null || amount <= 0) return;
              await ref
                  .read(goalRepoProvider)
                  .addContribution(goal.id, amount);
              refreshGoals(ref);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('إضافة',
                style: TextStyle(
                    fontFamily: 'Cairo', color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final targetController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('هدف توفير جديد',
            style: TextStyle(fontFamily: 'Cairo', color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style:
                  const TextStyle(fontFamily: 'Cairo', color: Colors.white),
              decoration: const InputDecoration(hintText: 'اسم الهدف'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: targetController,
              keyboardType: TextInputType.number,
              style:
                  const TextStyle(fontFamily: 'Cairo', color: Colors.white),
              decoration:
                  const InputDecoration(hintText: 'المبلغ المطلوب'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء',
                style: TextStyle(fontFamily: 'Cairo')),
          ),
          TextButton(
            onPressed: () async {
              final target = double.tryParse(targetController.text);
              if (nameController.text.isEmpty || target == null) return;
              await ref.read(goalRepoProvider).add(SavingsGoal()
                ..name = nameController.text
                ..targetAmount = target
                ..currentAmount = 0
                ..createdAt = DateTime.now());
              refreshGoals(ref);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('إضافة',
                style: TextStyle(
                    fontFamily: 'Cairo', color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
