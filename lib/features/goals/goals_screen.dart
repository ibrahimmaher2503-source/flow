import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/savings_goal_model.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../providers/goal_provider.dart';
import '../../shared/widgets/empty_state.dart';
import 'widgets/goal_card.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final goalsAsync = ref.watch(activeGoalsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.screenGoals)),
      body: goalsAsync.when(
        data: (goals) {
          if (goals.isEmpty) {
            return EmptyState(
              icon: Icons.savings,
              message: l10n.emptyGoals,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: goals.length,
            itemBuilder: (context, index) {
              final goal = goals[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GoalCard(
                  goal: goal,
                  onContribute: () =>
                      _showContributeDialog(context, ref, goal),
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
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.surface : AppColors.lightSurface,
        title: Text(l10n.addContributionToGoal(goal.name),
            style: TextStyle(fontFamily: 'Cairo', color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: TextStyle(fontFamily: 'Cairo', color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary),
          decoration: InputDecoration(hintText: l10n.labelAmount),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.buttonCancel,
                style: const TextStyle(fontFamily: 'Cairo')),
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
            child: Text(l10n.buttonAdd,
                style: const TextStyle(
                    fontFamily: 'Cairo', color: AppColors.primary)),
          ),
        ],
      ),
    ).then((_) => controller.dispose());
  }

  void _showAddGoalDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final targetController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.surface : AppColors.lightSurface,
        title: Text(l10n.addNewGoal,
            style: TextStyle(fontFamily: 'Cairo', color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style:
                  TextStyle(fontFamily: 'Cairo', color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary),
              decoration: InputDecoration(hintText: l10n.goalName),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: targetController,
              keyboardType: TextInputType.number,
              style:
                  TextStyle(fontFamily: 'Cairo', color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary),
              decoration: InputDecoration(hintText: l10n.goalTarget),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.buttonCancel,
                style: const TextStyle(fontFamily: 'Cairo')),
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
            child: Text(l10n.buttonAdd,
                style: const TextStyle(
                    fontFamily: 'Cairo', color: AppColors.primary)),
          ),
        ],
      ),
    ).then((_) {
      nameController.dispose();
      targetController.dispose();
    });
  }
}
