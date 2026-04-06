import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/installment_plan_model.dart';
import '../../../shared/widgets/app_card.dart';

class InterestSummary extends StatelessWidget {
  final InstallmentPlan plan;

  const InterestSummary({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ملخص الفوائد',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          _row('السعر الأصلي', CurrencyFormatter.format(plan.originalPrice),
              AppColors.textSecondary),
          _row('الفوائد', CurrencyFormatter.format(plan.totalInterest),
              AppColors.installment),
          _row(
              'الإجمالي',
              CurrencyFormatter.format(plan.totalWithInterest),
              Colors.white),
          const Divider(color: AppColors.textMuted, height: 20),
          _row('نسبة الفائدة', '${plan.interestRate.toStringAsFixed(1)}%',
              AppColors.warning),
          _row('المدفوع', CurrencyFormatter.format(plan.paidAmount),
              AppColors.success),
          _row('الباقي', CurrencyFormatter.format(plan.remainingAmount),
              AppColors.danger),
        ],
      ),
    );
  }

  Widget _row(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              color: AppColors.textMuted,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
