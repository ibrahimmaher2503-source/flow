import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/budget_model.dart';
import '../../../providers/budget_provider.dart';

class BudgetProgressCard extends ConsumerWidget {
  final Budget budget;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const BudgetProgressCard({
    super.key,
    required this.budget,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usageAsync = ref.watch(budgetUsageProvider(budget.categoryName));

    return GestureDetector(
      onTap: onTap,
      onLongPress: onDelete,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: usageAsync.when(
          data: (spent) {
            final percent = budget.limitAmount > 0
                ? (spent / budget.limitAmount).clamp(0.0, 1.0)
                : 0.0;
            final remaining = budget.limitAmount - spent;
            final color = percent < 0.7
                ? AppColors.success
                : percent < 0.9
                    ? AppColors.warning
                    : AppColors.danger;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      budget.categoryName,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${CurrencyFormatter.format(spent)} / ${CurrencyFormatter.format(budget.limitAmount)}',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percent,
                    backgroundColor: AppColors.background,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  remaining >= 0
                      ? 'باقي: ${CurrencyFormatter.format(remaining)}'
                      : 'تجاوزت الميزانية بـ ${CurrencyFormatter.format(-remaining)}!',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    color: remaining >= 0 ? AppColors.textMuted : AppColors.danger,
                  ),
                ),
              ],
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text('$e'),
        ),
      ),
    );
  }
}
