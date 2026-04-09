import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
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
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.1),
              AppColors.surface.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.withValues(alpha: 0.25),
                        color.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    IconResolver.resolve(providerIcon ?? 'credit_card'),
                    color: color,
                    size: 22,
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
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      if (providerName != null)
                        Text(
                          providerName!,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: color.withValues(alpha: 0.8),
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
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                    Text(
                      '/${l10n.installmentMonthly}',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        color: AppColors.textMuted.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Progress bar
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: plan.progressPercent.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withValues(alpha: 0.6)],
                    ),
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${plan.paidInstallments}/${plan.totalInstallments} ${l10n.installmentsTotalObligations}',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (plan.status == 'active')
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: daysLeft <= 3
                          ? AppColors.warning.withValues(alpha: 0.15)
                          : Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      daysLeft <= 0
                          ? l10n.dueDateToday
                          : '${l10n.recurringNextDue}: $daysLeft ${l10n.dateDaysAgo(daysLeft)}',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: daysLeft <= 3
                            ? AppColors.warning
                            : AppColors.textMuted,
                      ),
                    ),
                  ),
                Text(
                  '${l10n.budgetRemaining}: ${CurrencyFormatter.format(plan.remainingAmount)}',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
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
