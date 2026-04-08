import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/reports_provider.dart';
import 'report_section_header.dart';

class InterestAnalysis extends ConsumerWidget {
  const InterestAnalysis({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisAsync = ref.watch(interestAnalysisProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ReportSectionHeader(
          title: 'تحليل الفوائد',
          icon: Icons.percent,
        ),
        analysisAsync.when(
          data: (analysis) {
            if (analysis.totalInterest == 0) {
              return _NoInterestInfo(isDark: isDark);
            }

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.danger.withValues(alpha: 0.1),
                    AppColors.warning.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.danger.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Total interest paid
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.danger.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.money_off,
                                size: 28,
                                color: AppColors.danger,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'إجمالي الفوائد',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              CurrencyFormatter.format(analysis.totalInterest),
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.danger,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Divider
                      Container(
                        width: 1,
                        height: 80,
                        color: (isDark ? Colors.white : Colors.black)
                            .withValues(alpha: 0.1),
                      ),
                      // Interest percentage
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.trending_up,
                                size: 28,
                                color: AppColors.warning,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'نسبة الفوائد',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${analysis.interestPercentage.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Info text
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (isDark ? Colors.white : Colors.black)
                          .withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'نسبة الفوائد تعني أنك تدفع ${analysis.interestPercentage.toStringAsFixed(1)}% إضافية على سعر المنتجات الأصلي',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Center(child: Text('$e')),
        ),
      ],
    );
  }
}

class _NoInterestInfo extends StatelessWidget {
  final bool isDark;

  const _NoInterestInfo({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 32,
            color: AppColors.success,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'لا توجد فوائد',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
                Text(
                  'ليس لديك أقساط بفوائد حالياً',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
