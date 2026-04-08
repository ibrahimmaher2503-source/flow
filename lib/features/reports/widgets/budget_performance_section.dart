import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/reports_provider.dart';
import 'budget_performance_card.dart';
import 'report_section_header.dart';

class BudgetPerformanceSection extends ConsumerWidget {
  const BudgetPerformanceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final performanceAsync = ref.watch(budgetPerformanceProvider);
    final exceededCountAsync = ref.watch(exceededBudgetsCountProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReportSectionHeader(
          title: 'أداء الميزانية',
          icon: Icons.account_balance_wallet_outlined,
          trailing: exceededCountAsync.when(
            data: (count) => count > 0
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.danger.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$count تجاوز',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.danger,
                      ),
                    ),
                  )
                : null,
            loading: () => null,
            error: (_, __) => null,
          ),
        ),
        performanceAsync.when(
          data: (performances) {
            if (performances.isEmpty) {
              return _NoBudgetsPrompt(isDark: isDark);
            }

            // Sort: exceeded first, then by percentage used (highest first)
            final sorted = [...performances]
              ..sort((a, b) {
                if (a.isExceeded != b.isExceeded) {
                  return a.isExceeded ? -1 : 1;
                }
                return b.percentUsed.compareTo(a.percentUsed);
              });

            return Column(
              children: sorted
                  .map((p) => BudgetPerformanceCard(performance: p))
                  .toList(),
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
}

class _NoBudgetsPrompt extends StatelessWidget {
  final bool isDark;

  const _NoBudgetsPrompt({required this.isDark});

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
            Icons.savings_outlined,
            size: 40,
            color: isDark ? AppColors.primary : AppColors.lightPrimary,
          ),
          const SizedBox(height: 12),
          Text(
            'لم تقم بإعداد ميزانيات بعد',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'أضف ميزانيات لمتابعة إنفاقك بشكل أفضل',
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
