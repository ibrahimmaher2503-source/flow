import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/icon_resolver.dart';
import '../../../core/utils/installment_calculator.dart';
import '../../../data/models/installment_plan_model.dart';

class InstallmentCard extends StatelessWidget {
  final InstallmentPlan plan;
  final String? providerName;
  final String? providerIcon;
  final String? providerColor;
  final VoidCallback? onTap;

  const InstallmentCard({
    super.key,
    required this.plan,
    this.providerName,
    this.providerIcon,
    this.providerColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = providerColor?.toColor ?? AppColors.installment;
    final nextPayment = InstallmentCalculator.nextPaymentDate(
      plan.firstPaymentDate,
      plan.paidInstallments,
      plan.dayOfMonth,
    );
    final daysLeft = InstallmentCalculator.daysUntilNextPayment(nextPayment);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    IconResolver.resolve(providerIcon ?? 'credit_card'),
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.itemName,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      if (providerName != null)
                        Text(
                          providerName!,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            color: color,
                          ),
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      CurrencyFormatter.format(plan.monthlyAmount),
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.installment,
                      ),
                    ),
                    const Text(
                      '/شهر',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: plan.progressPercent,
                backgroundColor: AppColors.background,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6,
              ),
            ),

            const SizedBox(height: 8),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${plan.paidInstallments}/${plan.totalInstallments} أقساط',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (plan.status == 'active')
                  Text(
                    daysLeft <= 0
                        ? 'مستحق اليوم!'
                        : 'القادم: $daysLeft يوم',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: daysLeft <= 3
                          ? AppColors.warning
                          : AppColors.textMuted,
                    ),
                  ),
                Text(
                  'باقي: ${CurrencyFormatter.format(plan.remainingAmount)}',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
