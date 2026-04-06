import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../data/models/installment_plan_model.dart';

class PaymentTimeline extends StatelessWidget {
  final InstallmentPlan plan;

  const PaymentTimeline({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(plan.totalInstallments, (index) {
        final isPaid = index < plan.paidInstallments;
        final isNext = index == plan.paidInstallments;
        final paymentDate = DateTime(
          plan.firstPaymentDate.year,
          plan.firstPaymentDate.month + index,
          plan.dayOfMonth,
        );

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline dot + line
            SizedBox(
              width: 32,
              child: Column(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isPaid
                          ? AppColors.success
                          : isNext
                              ? AppColors.primary
                              : AppColors.textMuted.withValues(alpha: 0.3),
                      border: isNext
                          ? Border.all(color: AppColors.primary, width: 3)
                          : null,
                    ),
                    child: isPaid
                        ? const Icon(Icons.check,
                            size: 10, color: Colors.white)
                        : null,
                  ),
                  if (index < plan.totalInstallments - 1)
                    Container(
                      width: 2,
                      height: 40,
                      color: isPaid
                          ? AppColors.success.withValues(alpha: 0.3)
                          : AppColors.textMuted.withValues(alpha: 0.2),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Content
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isNext
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: isNext
                      ? Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3))
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'قسط ${index + 1}',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight:
                                isNext ? FontWeight.w600 : FontWeight.normal,
                            color: isPaid
                                ? AppColors.textMuted
                                : isNext
                                    ? Colors.white
                                    : AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          AppDateUtils.formatDate(paymentDate),
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      CurrencyFormatter.format(plan.monthlyAmount),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isPaid
                            ? AppColors.success
                            : isNext
                                ? AppColors.installment
                                : AppColors.textSecondary,
                        decoration: isPaid
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
