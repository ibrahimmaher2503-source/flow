import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/report_calculations.dart';
import '../../../providers/reports_provider.dart';
import 'report_section_header.dart';

class PaymentTimeline extends ConsumerWidget {
  const PaymentTimeline({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentsAsync = ref.watch(upcomingPaymentsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ReportSectionHeader(
          title: 'الدفعات القادمة',
          icon: Icons.calendar_month_outlined,
        ),
        paymentsAsync.when(
          data: (payments) {
            if (payments.isEmpty) {
              return _EmptyTimeline(isDark: isDark);
            }

            // Group payments by month
            final groupedPayments = <String, List<UpcomingPayment>>{};
            for (final payment in payments) {
              final monthKey = DateFormat('yyyy-MM').format(payment.dueDate);
              groupedPayments.putIfAbsent(monthKey, () => []);
              groupedPayments[monthKey]!.add(payment);
            }

            return Column(
              children: groupedPayments.entries.map((entry) {
                final monthDate = DateTime.parse('${entry.key}-01');
                final monthName = _getArabicMonth(monthDate.month);
                final monthTotal = entry.value.fold<double>(
                    0, (sum, p) => sum + p.amount);

                return _MonthSection(
                  monthName: monthName,
                  monthTotal: monthTotal,
                  payments: entry.value,
                  isDark: isDark,
                );
              }).toList(),
            );
          },
          loading: () => const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Center(child: Text('$e')),
        ),
      ],
    );
  }

  String _getArabicMonth(int month) {
    const months = [
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
    return months[(month - 1) % 12];
  }
}

class _EmptyTimeline extends StatelessWidget {
  final bool isDark;

  const _EmptyTimeline({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 40,
            color: AppColors.success,
          ),
          const SizedBox(height: 12),
          Text(
            'لا توجد دفعات قادمة',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'لا يوجد لديك أقساط نشطة حالياً',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthSection extends StatelessWidget {
  final String monthName;
  final double monthTotal;
  final List<UpcomingPayment> payments;
  final bool isDark;

  const _MonthSection({
    required this.monthName,
    required this.monthTotal,
    required this.payments,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.installment.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  monthName,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.installment,
                  ),
                ),
                Text(
                  CurrencyFormatter.format(monthTotal),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.installment,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Payment items
          ...payments.map((payment) => _PaymentItem(
                payment: payment,
                isDark: isDark,
              )),
        ],
      ),
    );
  }
}

class _PaymentItem extends StatelessWidget {
  final UpcomingPayment payment;
  final bool isDark;

  const _PaymentItem({
    required this.payment,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final dayFormat = DateFormat('d');
    final isOverdue = payment.dueDate.isBefore(DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: isOverdue
            ? Border.all(color: AppColors.danger.withValues(alpha: 0.5))
            : (isDark ? null : Border.all(color: AppColors.lightBorder)),
      ),
      child: Row(
        children: [
          // Day circle
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: (isOverdue ? AppColors.danger : AppColors.installment)
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              dayFormat.format(payment.dueDate),
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isOverdue ? AppColors.danger : AppColors.installment,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.itemName,
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
                  'القسط ${payment.installmentNumber} من ${payment.totalInstallments}',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
          // Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyFormatter.format(payment.amount),
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isOverdue ? AppColors.danger : AppColors.installment,
                ),
              ),
              if (isOverdue)
                Text(
                  'متأخر',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.danger,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
