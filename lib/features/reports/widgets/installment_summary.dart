import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/reports_provider.dart';
import '../../../shared/widgets/app_card.dart';
import 'report_section_header.dart';

class InstallmentSummary extends ConsumerWidget {
  const InstallmentSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(installmentSummaryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ReportSectionHeader(
          title: 'ملخص الأقساط',
          icon: Icons.summarize_outlined,
        ),
        summaryAsync.when(
          data: (summary) => AppCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Stats row
                Row(
                  children: [
                    Expanded(
                      child: _SummaryItem(
                        icon: Icons.credit_card,
                        label: 'الالتزام الشهري',
                        value: CurrencyFormatter.format(summary.monthlyCommitment),
                        color: AppColors.installment,
                        isDark: isDark,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 50,
                      color: (isDark ? Colors.white : Colors.black)
                          .withValues(alpha: 0.1),
                    ),
                    Expanded(
                      child: _SummaryItem(
                        icon: Icons.folder_outlined,
                        label: 'الأقساط النشطة',
                        value: '${summary.activePlansCount}',
                        color: isDark ? AppColors.primary : AppColors.lightPrimary,
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
                // Payoff date
                if (summary.payoffDate != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.event_available,
                          size: 24,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'تاريخ الانتهاء المتوقع',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.textMuted
                                      : AppColors.lightTextMuted,
                                ),
                              ),
                              Text(
                                _formatPayoffDate(summary.payoffDate!),
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _getMonthsRemaining(summary.payoffDate!),
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          loading: () => const AppCard(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (e, _) => AppCard(
            padding: const EdgeInsets.all(16),
            child: Center(child: Text('$e')),
          ),
        ),
      ],
    );
  }

  String _formatPayoffDate(DateTime date) {
    final months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _getMonthsRemaining(DateTime payoffDate) {
    final now = DateTime.now();
    final months =
        (payoffDate.year - now.year) * 12 + (payoffDate.month - now.month);
    if (months <= 0) return 'هذا الشهر';
    if (months == 1) return 'شهر واحد';
    if (months == 2) return 'شهران';
    if (months <= 10) return '$months أشهر';
    return '$months شهر';
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 11,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
