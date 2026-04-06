import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/extensions.dart';
import '../../core/utils/icon_resolver.dart';
import '../../data/models/installment_plan_model.dart';
import '../../providers/installment_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/wallet_provider.dart';
import 'widgets/payment_timeline.dart';
import 'widgets/interest_summary.dart';

final _planProvider =
    FutureProvider.family<InstallmentPlan?, int>((ref, planId) async {
  return ref.watch(installmentRepoProvider).getPlan(planId);
});

class InstallmentDetailsScreen extends ConsumerWidget {
  final int planId;

  const InstallmentDetailsScreen({super.key, required this.planId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(_planProvider(planId));
    final service = ref.watch(installmentServiceProvider);
    final providersAsync = ref.watch(installmentProvidersListProvider);

    return planAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('خطأ: $e')),
      ),
      data: (plan) {
        if (plan == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: Text('الخطة غير موجودة',
                  style: TextStyle(
                      fontFamily: 'Cairo', color: AppColors.textMuted)),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(plan.itemName),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete, color: AppColors.danger),
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: AppColors.surface,
                      title: const Text('حذف الخطة؟',
                          style: TextStyle(
                              fontFamily: 'Cairo', color: Colors.white)),
                      content: const Text(
                          'هل أنت متأكد من حذف خطة التقسيط دي؟',
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              color: AppColors.textSecondary)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('لا',
                              style: TextStyle(fontFamily: 'Cairo')),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('نعم، احذف',
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: AppColors.danger)),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true) {
                    await ref
                        .read(installmentRepoProvider)
                        .deletePlan(planId);
                    refreshInstallments(ref);
                    if (context.mounted) Navigator.pop(context, true);
                  }
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Provider info
                providersAsync.when(
                  data: (providers) {
                    final provider = providers
                        .where((p) => p.id == plan.providerId)
                        .firstOrNull;
                    if (provider == null) return const SizedBox();
                    final color = provider.color.toColor;
                    return Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(IconResolver.resolve(provider.icon),
                              color: color),
                          const SizedBox(width: 8),
                          Text(provider.name,
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: color)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: plan.status == 'completed'
                                  ? AppColors.success.withValues(alpha: 0.2)
                                  : AppColors.primary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              plan.status == 'completed' ? 'مكتمل' : 'نشط',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                color: plan.status == 'completed'
                                    ? AppColors.success
                                    : AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  loading: () => const SizedBox(),
                  error: (_, __) => const SizedBox(),
                ),

                // Interest summary
                InterestSummary(plan: plan),

                const SizedBox(height: 16),

                // Record payment button
                if (plan.status == 'active' && !plan.autoAdd)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              backgroundColor: AppColors.surface,
                              title: const Text('تسجيل دفع القسط؟',
                                  style: TextStyle(
                                      fontFamily: 'Cairo',
                                      color: Colors.white)),
                              content: Text(
                                'قسط ${plan.paidInstallments + 1} من ${plan.totalInstallments}',
                                style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    color: AppColors.textSecondary),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(ctx, false),
                                  child: const Text('لا',
                                      style:
                                          TextStyle(fontFamily: 'Cairo')),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(ctx, true),
                                  child: const Text('نعم، سجل',
                                      style: TextStyle(
                                          fontFamily: 'Cairo',
                                          color: AppColors.success)),
                                ),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            await service.recordPayment(
                                plan, plan.walletId);
                            refreshInstallments(ref);
                            refreshTransactions(ref);
                            refreshWallets(ref);
                            ref.invalidate(_planProvider(planId));
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('تم تسجيل دفع القسط')),
                              );
                              Navigator.pop(context, true);
                            }
                          }
                        },
                        icon: const Icon(Icons.check_circle),
                        label: const Text('سجل دفع القسط',
                            style: TextStyle(fontFamily: 'Cairo')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),

                // Timeline
                const Text('جدول الأقساط',
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                const SizedBox(height: 12),
                PaymentTimeline(plan: plan),
              ],
            ),
          ),
        );
      },
    );
  }
}
