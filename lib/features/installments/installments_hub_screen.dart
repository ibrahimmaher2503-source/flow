import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/models/installment_plan_model.dart';
import '../../providers/installment_provider.dart';
import '../../shared/widgets/empty_state.dart';
import 'add_installment_screen.dart';
import 'installment_details_screen.dart';
import 'widgets/installment_card.dart';

class InstallmentsHubScreen extends ConsumerStatefulWidget {
  const InstallmentsHubScreen({super.key});

  @override
  ConsumerState<InstallmentsHubScreen> createState() =>
      _InstallmentsHubScreenState();
}

class _InstallmentsHubScreenState
    extends ConsumerState<InstallmentsHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalDebt = ref.watch(totalDebtProvider);
    final monthlyTotal = ref.watch(monthlyInstallmentTotalProvider);
    final interestPaid = ref.watch(totalInterestPaidProvider);
    final activePlans = ref.watch(activePlansProvider);
    final completedPlans = ref.watch(completedPlansProvider);
    final providersAsync = ref.watch(installmentProvidersListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الأقساط'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo'),
          tabs: const [
            Tab(text: 'نشطة'),
            Tab(text: 'مكتملة'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Summary cards
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _summaryCard(
                  'إجمالي الالتزامات',
                  totalDebt,
                  AppColors.installment,
                ),
                const SizedBox(width: 8),
                _summaryCard(
                  'أقساط الشهر',
                  monthlyTotal,
                  AppColors.warning,
                ),
                const SizedBox(width: 8),
                _summaryCard(
                  'فوائد مدفوعة',
                  interestPaid,
                  AppColors.danger,
                ),
              ],
            ),
          ),

          // Plans list
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Active
                _buildPlanList(activePlans, providersAsync, isEmpty: 'مفيش أقساط نشطة'),
                // Completed
                _buildPlanList(completedPlans, providersAsync, isEmpty: 'مفيش أقساط مكتملة'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const AddInstallmentScreen()),
          );
          if (result == true) {
            refreshInstallments(ref);
          }
        },
        backgroundColor: AppColors.installment,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _summaryCard(
      String label, AsyncValue<double> value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 10,
                color: AppColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            value.when(
              data: (v) => Text(
                CurrencyFormatter.formatCompact(v),
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              loading: () => const Text('...'),
              error: (_, __) => const Text('--'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanList(
    AsyncValue<List<InstallmentPlan>> plansAsync,
    AsyncValue<List<dynamic>> providersAsync, {
    required String isEmpty,
  }) {
    return plansAsync.when(
      data: (plans) {
        if (plans.isEmpty) {
          return EmptyState(icon: Icons.credit_card, message: isEmpty);
        }

        final providerMap = <int, dynamic>{};
        final providerList = providersAsync.valueOrNull;
        if (providerList != null) {
          for (final p in providerList) {
            providerMap[p.id] = p;
          }
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: plans.length,
          itemBuilder: (context, index) {
            final plan = plans[index];
            final provider = providerMap[plan.providerId];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InstallmentCard(
                plan: plan,
                providerName: provider?.name,
                providerIcon: provider?.icon,
                providerColor: provider?.color,
                onTap: () async {
                  final result = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          InstallmentDetailsScreen(planId: plan.id),
                    ),
                  );
                  if (result == true) {
                    refreshInstallments(ref);
                  }
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('خطأ: $e')),
    );
  }
}
