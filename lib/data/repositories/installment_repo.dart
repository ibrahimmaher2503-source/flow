import 'package:isar/isar.dart';
import '../models/installment_provider_model.dart';
import '../models/installment_plan_model.dart';

class InstallmentRepo {
  final Isar isar;

  InstallmentRepo(this.isar);

  // --- Providers ---
  Future<List<InstallmentProvider>> getAllProviders() async {
    return isar.installmentProviders.where().findAll();
  }

  Future<InstallmentProvider?> getProvider(int id) async {
    return isar.installmentProviders.get(id);
  }

  Future<int> addProvider(InstallmentProvider provider) async {
    return isar.writeTxn(() async {
      return isar.installmentProviders.put(provider);
    });
  }

  Future<void> updateProvider(InstallmentProvider provider) async {
    await isar.writeTxn(() async {
      await isar.installmentProviders.put(provider);
    });
  }

  Future<void> deleteProvider(int id) async {
    await isar.writeTxn(() async {
      await isar.installmentProviders.delete(id);
    });
  }

  // --- Plans ---
  Future<List<InstallmentPlan>> getAllPlans() async {
    return isar.installmentPlans.where().findAll();
  }

  Future<List<InstallmentPlan>> getActivePlans() async {
    return isar.installmentPlans
        .where()
        .statusIndexEqualTo('active')
        .findAll();
  }

  Future<List<InstallmentPlan>> getCompletedPlans() async {
    return isar.installmentPlans
        .where()
        .statusIndexEqualTo('completed')
        .findAll();
  }

  Future<List<InstallmentPlan>> getByProvider(int providerId) async {
    return isar.installmentPlans
        .where()
        .providerIndexEqualTo(providerId)
        .findAll();
  }

  Future<InstallmentPlan?> getPlan(int id) async {
    return isar.installmentPlans.get(id);
  }

  Future<int> addPlan(InstallmentPlan plan) async {
    return isar.writeTxn(() async {
      return isar.installmentPlans.put(plan);
    });
  }

  Future<void> updatePlan(InstallmentPlan plan) async {
    await isar.writeTxn(() async {
      await isar.installmentPlans.put(plan);
    });
  }

  Future<void> deletePlan(int id) async {
    await isar.writeTxn(() async {
      await isar.installmentPlans.delete(id);
    });
  }

  Future<List<InstallmentPlan>> getDueToday() async {
    final today = DateTime.now();
    final active = await getActivePlans();
    return active.where((p) => p.dayOfMonth == today.day).toList();
  }
}
