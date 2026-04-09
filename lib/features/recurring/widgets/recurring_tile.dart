import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../data/models/recurring_transaction_model.dart';

class RecurringTile extends StatelessWidget {
  final RecurringTransaction recurring;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;

  const RecurringTile({
    super.key,
    required this.recurring,
    this.onTap,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isExpense = recurring.type == 'expense';
    final color = isExpense ? AppColors.danger : AppColors.success;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(14),
          border: !recurring.isActive
              ? Border.all(color: (isDark ? AppColors.textMuted : AppColors.lightTextMuted).withValues(alpha: 0.2))
              : (isDark ? null : Border.all(color: AppColors.lightBorder)),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: recurring.isActive ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.repeat,
                color: recurring.isActive
                    ? color
                    : AppColors.textMuted,
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recurring.name,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: recurring.isActive
                          ? (isDark ? Colors.white : AppColors.lightTextPrimary)
                          : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        _frequencyLabel(recurring.frequency),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'القادم: ${AppDateUtils.formatRelative(recurring.nextDueDate)}',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Amount + toggle
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyFormatter.format(recurring.amount),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: recurring.isActive ? color : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                  ),
                ),
                if (recurring.autoAdd)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'تلقائي',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 10,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _frequencyLabel(String freq) {
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
