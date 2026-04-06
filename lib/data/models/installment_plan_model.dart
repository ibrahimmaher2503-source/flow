import 'package:isar/isar.dart';

part 'installment_plan_model.g.dart';

@collection
class InstallmentPlan {
  Id id = Isar.autoIncrement;

  late String itemName;
  late String category;
  late int providerId;

  late double originalPrice;
  late double totalWithInterest;

  @ignore
  double get totalInterest => totalWithInterest - originalPrice;

  @ignore
  double get interestRate =>
      originalPrice > 0 ? (totalInterest / originalPrice) * 100 : 0;

  late int totalInstallments;
  late double monthlyAmount;
  late DateTime firstPaymentDate;
  int dayOfMonth = 1;

  int paidInstallments = 0;
  double paidAmount = 0;
  late String status; // 'active' | 'completed' | 'overdue'
  late int walletId;
  bool autoAdd = false;
  late DateTime createdAt;

  @ignore
  int get remainingInstallments => totalInstallments - paidInstallments;

  @ignore
  double get remainingAmount => totalWithInterest - paidAmount;

  @ignore
  double get progressPercent =>
      totalInstallments > 0 ? paidInstallments / totalInstallments : 0;

  @Index()
  String get statusIndex => status;

  @Index()
  int get providerIndex => providerId;
}
