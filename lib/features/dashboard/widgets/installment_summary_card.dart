import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/installment_provider.dart';
import '../../../shared/widgets/app_card.dart';

class InstallmentSummaryCard extends ConsumerWidget {
  const InstallmentSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalDebt = ref.watch(totalDebtProvider);
    final monthlyTotal = ref.watch(monthlyInstallmentTotalProvider);
    final activePlans = ref.watch(activePlansProvider);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.installment.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.credit_card,
                    color: AppColors.installment, size: 20),
              ),
              const SizedBox(width: 10),
              const Text(
                'الأقساط',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              activePlans.when(
                data: (plans) => Text(
                  '${plans.length} نشطة',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('إجمالي الالتزامات',
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            color: AppColors.textMuted)),
                    totalDebt.when(
                      data: (v) => Text(
                        CurrencyFormatter.format(v),
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.installment,
                        ),
                      ),
                      loading: () => const Text('...'),
                      error: (_, __) => const Text('--'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('أقساط الشهر',
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            color: AppColors.textMuted)),
                    monthlyTotal.when(
                      data: (v) => Text(
                        CurrencyFormatter.format(v),
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.warning,
                        ),
                      ),
                      loading: () => const Text('...'),
                      error: (_, __) => const Text('--'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
