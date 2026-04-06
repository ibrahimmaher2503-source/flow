import 'package:isar/isar.dart';
import '../models/transaction_model.dart';
import '../models/installment_plan_model.dart';
import '../models/installment_provider_model.dart';
import '../models/wallet_model.dart';

class InstallmentService {
  final Isar isar;

  InstallmentService(this.isar);

  Future<void> recordPayment(int planId, int walletId) async {
    await isar.writeTxn(() async {
      // Re-fetch plan inside transaction for fresh data
      final plan = await isar.installmentPlans.get(planId);
      if (plan == null) return;

      // 1. Create transaction
      final transaction = Transaction()
        ..amount = plan.monthlyAmount
        ..type = 'expense'
        ..category = plan.category
        ..note =
            'قسط ${plan.paidInstallments + 1}/${plan.totalInstallments} — ${plan.itemName}'
        ..date = DateTime.now()
        ..walletId = walletId
        ..source = 'installment'
        ..installmentPlanId = plan.id
        ..createdAt = DateTime.now();

      await isar.transactions.put(transaction);

      // 2. Update wallet
      final wallet = await isar.wallets.get(walletId);
      if (wallet != null) {
        wallet.balance -= plan.monthlyAmount;
        await isar.wallets.put(wallet);
      }

      // 3. Update plan
      plan.paidInstallments++;
      plan.paidAmount += plan.monthlyAmount;
      if (plan.paidInstallments >= plan.totalInstallments) {
        plan.status = 'completed';
      }
      await isar.installmentPlans.put(plan);
    });
  }

  Future<double> totalRemainingDebt() async {
    final plans = await isar.installmentPlans
        .where()
        .statusIndexEqualTo('active')
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
        .statusIndexEqualTo('active')
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
        .statusIndexEqualTo('active')
        .findAll();

    final Map<String, double> result = {};
    for (final plan in plans) {
      final provider = await isar.installmentProviders.get(plan.providerId);
      final name = provider?.name ?? 'غير معروف';
      result[name] = (result[name] ?? 0) + plan.remainingAmount;
    }
    return result;
  }
}
