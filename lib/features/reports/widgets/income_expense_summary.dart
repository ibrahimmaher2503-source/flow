import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/reports_provider.dart';
import '../../../shared/widgets/app_card.dart';

class IncomeExpenseSummary extends ConsumerWidget {
  const IncomeExpenseSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(incomeExpenseBalanceProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return balanceAsync.when(
      data: (balance) => AppCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Main balance row
            Row(
              children: [
                // Income
                Expanded(
                  child: _BalanceItem(
                    label: 'الدخل',
                    amount: balance.income,
                    icon: Icons.arrow_downward,
                    color: AppColors.success,
                    isDark: isDark,
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: (isDark ? Colors.white : Colors.black)
                      .withValues(alpha: 0.1),
                ),
                // Expense
                Expanded(
                  child: _BalanceItem(
                    label: 'المصروفات',
                    amount: balance.expense,
                    icon: Icons.arrow_upward,
                    color: AppColors.danger,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Divider
            Container(
              height: 1,
              color: (isDark ? Colors.white : Colors.black)
                  .withValues(alpha: 0.1),
            ),
            const SizedBox(height: 16),
            // Net balance row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (balance.isSurplus
                                ? AppColors.success
                                : AppColors.danger)
                            .withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        balance.isSurplus
                            ? Icons.trending_up
                            : Icons.trending_down,
                        size: 20,
                        color: balance.isSurplus
                            ? AppColors.success
                            : AppColors.danger,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'صافي الرصيد',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                        Text(
                          balance.isSurplus ? 'فائض' : 'عجز',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 11,
                            color: balance.isSurplus
                                ? AppColors.success
                                : AppColors.danger,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  CurrencyFormatter.format(balance.netBalance.abs()),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: balance.isSurplus
                        ? AppColors.success
                        : AppColors.danger,
                  ),
                ),
              ],
            ),
            // Savings rate (if income > 0)
            if (balance.savingsRate != null) ...[
              const SizedBox(height: 12),
              _SavingsRateIndicator(
                rate: balance.savingsRate!,
                isDark: isDark,
              ),
            ],
          ],
        ),
      ),
      loading: () => const AppCard(
        padding: EdgeInsets.all(16),
        child: SizedBox(
          height: 150,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, _) => AppCard(
        padding: const EdgeInsets.all(16),
        child: Center(child: Text('$e')),
      ),
    );
  }
}

class _BalanceItem extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _BalanceItem({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            CurrencyFormatter.format(amount),
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class _SavingsRateIndicator extends StatelessWidget {
  final double rate;
  final bool isDark;

  const _SavingsRateIndicator({
    required this.rate,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isGoodRate = rate >= 20; // 20% savings rate is considered good
    final color = isGoodRate ? AppColors.success : AppColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isGoodRate ? Icons.savings : Icons.info_outline,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            'معدل الادخار: ${rate.toStringAsFixed(1)}%',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
