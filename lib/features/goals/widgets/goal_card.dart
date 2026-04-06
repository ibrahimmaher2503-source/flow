import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/savings_goal_model.dart';

class GoalCard extends StatelessWidget {
  final SavingsGoal goal;
  final VoidCallback? onTap;
  final VoidCallback? onContribute;

  const GoalCard({
    super.key,
    required this.goal,
    this.onTap,
    this.onContribute,
  });

  @override
  Widget build(BuildContext context) {
    final percent = goal.targetAmount > 0
        ? (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0)
        : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: goal.isCompleted
              ? Border.all(color: AppColors.success.withValues(alpha: 0.4))
              : null,
        ),
        child: Row(
          children: [
            CircularPercentIndicator(
              radius: 30,
              lineWidth: 5,
              percent: percent,
              center: goal.isCompleted
                  ? const Icon(Icons.check, color: AppColors.success, size: 20)
                  : Text(
                      '${(percent * 100).toInt()}%',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
              progressColor:
                  goal.isCompleted ? AppColors.success : AppColors.secondary,
              backgroundColor: AppColors.background,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (goal.icon != null) ...[
                        Text(goal.icon!,
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 6),
                      ],
                      Expanded(
                        child: Text(
                          goal.name,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${CurrencyFormatter.format(goal.currentAmount)} / ${CurrencyFormatter.format(goal.targetAmount)}',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (goal.deadline != null)
                    Text(
                      'الموعد: ${goal.deadline!.day}/${goal.deadline!.month}/${goal.deadline!.year}',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                ],
              ),
            ),
            if (!goal.isCompleted && onContribute != null)
              IconButton(
                onPressed: onContribute,
                icon: const Icon(Icons.add_circle,
                    color: AppColors.primary, size: 28),
              ),
          ],
        ),
      ),
    );
  }
}
