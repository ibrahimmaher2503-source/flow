import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/installment_plan_model.dart';
import '../data/models/installment_provider_model.dart';
import '../data/repositories/installment_repo.dart';
import '../data/services/installment_service.dart';
import '../data/services/isar_service.dart';

final installmentRepoProvider = Provider<InstallmentRepo>((ref) {
  return InstallmentRepo(ref.watch(isarProvider));
});

final installmentServiceProvider = Provider<InstallmentService>((ref) {
  return InstallmentService(ref.watch(isarProvider));
});

final installmentProvidersListProvider =
    FutureProvider<List<InstallmentProvider>>((ref) async {
  return ref.watch(installmentRepoProvider).getAllProviders();
});

final activePlansProvider =
    FutureProvider<List<InstallmentPlan>>((ref) async {
  return ref.watch(installmentRepoProvider).getActivePlans();
});

final completedPlansProvider =
    FutureProvider<List<InstallmentPlan>>((ref) async {
  return ref.watch(installmentRepoProvider).getCompletedPlans();
});

final totalDebtProvider = FutureProvider<double>((ref) async {
  return ref.watch(installmentServiceProvider).totalRemainingDebt();
});

final monthlyInstallmentTotalProvider = FutureProvider<double>((ref) async {
  return ref.watch(installmentServiceProvider).monthlyInstallmentTotal();
});

final totalInterestPaidProvider = FutureProvider<double>((ref) async {
  return ref.watch(installmentServiceProvider).totalInterestPaid();
});

final debtByProviderProvider =
    FutureProvider<Map<String, double>>((ref) async {
  return ref.watch(installmentServiceProvider).debtByProvider();
});

void refreshInstallments(WidgetRef ref) {
  ref.invalidate(activePlansProvider);
  ref.invalidate(completedPlansProvider);
  ref.invalidate(totalDebtProvider);
  ref.invalidate(monthlyInstallmentTotalProvider);
  ref.invalidate(totalInterestPaidProvider);
  ref.invalidate(debtByProviderProvider);
  ref.invalidate(installmentProvidersListProvider);
}
