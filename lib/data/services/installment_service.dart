import 'package:isar/isar.dart';
import '../../core/constants/app_constants.dart';
import '../models/transaction_model.dart';
import '../models/installment_plan_model.dart';
import '../models/installment_provider_model.dart';
import '../models/wallet_model.dart';

class InstallmentService {
  final Isar isar;

  InstallmentService(this.isar);

  Future<void> recordPayment(int planId, int walletId) async {
    await isar.writeTxn(() async {
      final plan = await isar.installmentPlans.get(planId);
      if (plan == null) return;

      final transaction = Transaction()
        ..amount = plan.monthlyAmount
        ..type = TransactionType.expense
        ..category = plan.category
        ..note =
            'قسط ${plan.paidInstallments + 1}/${plan.totalInstallments} — ${plan.itemName}'
        ..date = DateTime.now()
        ..walletId = walletId
        ..source = TransactionSource.installment
        ..installmentPlanId = plan.id
        ..createdAt = DateTime.now();

      await isar.transactions.put(transaction);

      final wallet = await isar.wallets.get(walletId);
      if (wallet != null) {
        wallet.balance -= plan.monthlyAmount;
        await isar.wallets.put(wallet);
      }

      plan.paidInstallments++;
      plan.paidAmount += plan.monthlyAmount;
      if (plan.paidInstallments >= plan.totalInstallments) {
        plan.status = PlanStatus.completed;
      }
      await isar.installmentPlans.put(plan);
    });
  }

  Future<double> totalRemainingDebt() async {
    final plans = await isar.installmentPlans
        .where()
        .statusIndexEqualTo(PlanStatus.active)
        .findAll();
    double total = 0;
    for (final p in plans) {
      total += p.remainingAmount;
    }
    return total;
  }

  Future<double> monthlyInstallmentTotal() async {
    final plans = await isar.installmentPlans
        .where()
        .statusIndexEqualTo(PlanStatus.active)
        .findAll();
    double total = 0;
    for (final p in plans) {
      total += p.monthlyAmount;
    }
    return total;
  }

  Future<double> totalInterestPaid() async {
    final plans = await isar.installmentPlans.where().findAll();
    double total = 0;
    for (final plan in plans) {
      if (plan.totalInstallments > 0) {
        final interestPer = plan.totalInterest / plan.totalInstallments;
        total += interestPer * plan.paidInstallments;
      }
    }
    return total;
  }

  Future<Map<String, double>> debtByProvider() async {
    final plans = await isar.installmentPlans
        .where()
        .statusIndexEqualTo(PlanStatus.active)
        .findAll();

    // Batch-fetch all providers to avoid N+1 queries
    final providers = await isar.installmentProviders.where().findAll();
    final providerMap = <int, String>{};
    for (final p in providers) {
      providerMap[p.id] = p.name;
    }

    final Map<String, double> result = {};
    for (final plan in plans) {
      final name = providerMap[plan.providerId] ?? 'غير معروف';
      result[name] = (result[name] ?? 0) + plan.remainingAmount;
    }
    return result;
  }
}
