import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/report_calculations.dart';
import '../../../providers/reports_provider.dart';
import 'report_section_header.dart';

class WalletDistribution extends ConsumerWidget {
  const WalletDistribution({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final distributionAsync = ref.watch(walletDistributionProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ReportSectionHeader(
          title: 'توزيع المحافظ',
          icon: Icons.account_balance,
        ),
        distributionAsync.when(
          data: (distribution) {
            if (distribution.isEmpty) {
              return _EmptyWallets(isDark: isDark);
            }

            final total =
                distribution.fold<double>(0, (sum, w) => sum + w.balance);

            return Column(
              children: [
                // Pie chart
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 50,
                      sections: distribution.asMap().entries.map((entry) {
                        final index = entry.key;
                        final wallet = entry.value;
                        final color = _getWalletColor(index);

                        return PieChartSectionData(
                          value: wallet.balance.abs(),
                          color: color,
                          radius: 45,
                          title: '',
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Wallet list
                ...distribution.asMap().entries.map((entry) {
                  final index = entry.key;
                  final wallet = entry.value;
                  final color = _getWalletColor(index);

                  return _WalletItem(
                    wallet: wallet,
                    color: color,
                    isDark: isDark,
                  );
                }),
                const SizedBox(height: 12),
                // Total
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (isDark ? AppColors.primary : AppColors.lightPrimary)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'إجمالي الرصيد',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(total),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.primary
                              : AppColors.lightPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Center(child: Text('$e')),
        ),
      ],
    );
  }

  Color _getWalletColor(int index) {
    const colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.warning,
      AppColors.success,
      AppColors.installment,
      Color(0xFF8B5CF6), // Purple
      Color(0xFF06B6D4), // Cyan
    ];
    return colors[index % colors.length];
  }
}

class _EmptyWallets extends StatelessWidget {
  final bool isDark;

  const _EmptyWallets({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.primary : AppColors.lightPrimary)
            .withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (isDark ? AppColors.primary : AppColors.lightPrimary)
              .withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 40,
            color: isDark ? AppColors.primary : AppColors.lightPrimary,
          ),
          const SizedBox(height: 12),
          Text(
            'لم تقم بإضافة محافظ بعد',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletItem extends StatelessWidget {
  final WalletBalance wallet;
  final Color color;
  final bool isDark;

  const _WalletItem({
    required this.wallet,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(12),
          border: isDark ? null : Border.all(color: AppColors.lightBorder),
        ),
        child: Row(
          children: [
            // Color indicator
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            // Wallet icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getWalletIcon(wallet.type),
                size: 20,
                color: color,
              ),
            ),
            const SizedBox(width: 12),
            // Wallet info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wallet.name,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    _getWalletTypeLabel(wallet.type),
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
            // Balance and percentage
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyFormatter.format(wallet.balance),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  '${wallet.percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getWalletIcon(String type) {
    switch (type.toLowerCase()) {
      case 'cash':
        return Icons.payments_outlined;
      case 'bank':
        return Icons.account_balance;
      case 'ewallet':
      case 'e-wallet':
        return Icons.phone_android;
      default:
        return Icons.wallet;
    }
  }

  String _getWalletTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'cash':
        return 'نقدي';
      case 'bank':
        return 'بنك';
      case 'ewallet':
      case 'e-wallet':
        return 'محفظة إلكترونية';
      default:
        return type;
    }
  }
}
