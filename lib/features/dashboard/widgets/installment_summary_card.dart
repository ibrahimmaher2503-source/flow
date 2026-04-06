import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/installment_provider.dart';

class InstallmentSummaryCard extends ConsumerWidget {
  const InstallmentSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalDebt = ref.watch(totalDebtProvider);
    final monthlyTotal = ref.watch(monthlyInstallmentTotalProvider);
    final activePlans = ref.watch(activePlansProvider);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.installment.withValues(alpha: 0.12),
            AppColors.surface.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.installment.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.installment.withValues(alpha: 0.25),
                      AppColors.installment.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.credit_card_rounded,
                    color: AppColors.installment, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'الأقساط',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              activePlans.when(
                data: (plans) => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.installment.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${plans.length} نشطة',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.installment,
                    ),
                  ),
                ),
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _miniStat(
                  'إجمالي الالتزامات',
                  totalDebt,
                  AppColors.installment,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _miniStat(
                  'أقساط الشهر',
                  monthlyTotal,
                  AppColors.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, AsyncValue<double> value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textMuted.withValues(alpha: 0.8))),
        const SizedBox(height: 4),
        value.when(
          data: (v) => Text(
            CurrencyFormatter.format(v),
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          loading: () => const Text('...'),
          error: (_, __) => const Text('--'),
        ),
      ],
    );
  }
}
