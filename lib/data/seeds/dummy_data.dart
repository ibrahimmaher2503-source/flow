/// Dummy data for testing and demo purposes
import '../models/transaction_model.dart';
import '../models/wallet_model.dart';
import '../models/budget_model.dart';
import '../models/savings_goal_model.dart';
import '../models/recurring_transaction_model.dart';
import '../models/installment_plan_model.dart';
import '../../core/constants/app_constants.dart';

class DummyData {
  /// Sample wallets for testing
  static List<Wallet> get dummyWallets => [
    Wallet()
      ..name = 'المحفظة الأساسية'
      ..type = WalletType.cash
      ..balance = 15500.50
      ..icon = 'wallet'
      ..color = '6C63FF'
      ..sortOrder = 1,
    Wallet()
      ..name = 'الحساب البنكي'
      ..type = WalletType.bank
      ..balance = 45200.75
      ..icon = 'bank'
      ..color = '2DD4BF'
      ..sortOrder = 2,
    Wallet()
      ..name = 'المحفظة الرقمية'
      ..type = WalletType.ewallet
      ..balance = 8750.00
      ..icon = 'credit_card'
      ..color = 'F59E0B'
      ..sortOrder = 3,
  ];

  /// Sample transactions for testing
  static List<Transaction> get dummyTransactions => [
    Transaction()
      ..amount = 45.00
      ..type = TransactionType.expense
      ..source = TransactionSource.manual
      ..category = 'مطاعم ومقاهي'
      ..subcategory = 'قهوة'
      ..walletId = 1
      ..date = DateTime.now()
      ..note = 'قهوة عربية مع كرواسون'
      ..merchant = 'قهوة من الكافيه'
      ..createdAt = DateTime.now(),
    Transaction()
      ..amount = 8000.00
      ..type = TransactionType.income
      ..source = TransactionSource.manual
      ..category = 'الدخل'
      ..subcategory = 'راتب'
      ..walletId = 2
      ..date = DateTime.now().subtract(Duration(days: 2))
      ..note = 'الراتب الشهري'
      ..merchant = 'راتب شهري'
      ..createdAt = DateTime.now().subtract(Duration(days: 2)),
    Transaction()
      ..amount = 350.00
      ..type = TransactionType.expense
      ..source = TransactionSource.manual
      ..category = 'المرافق والفواتير'
      ..subcategory = 'الكهرباء'
      ..walletId = 2
      ..date = DateTime.now().subtract(Duration(days: 5))
      ..note = 'فاتورة الكهرباء الشهرية'
      ..merchant = 'فاتورة الكهرباء'
      ..createdAt = DateTime.now().subtract(Duration(days: 5)),
    Transaction()
      ..amount = 250.00
      ..type = TransactionType.expense
      ..source = TransactionSource.manual
      ..category = 'مطاعم ومقاهي'
      ..subcategory = 'عشاء'
      ..walletId = 1
      ..date = DateTime.now().subtract(Duration(days: 7))
      ..note = 'عشاء مع العائلة'
      ..merchant = 'العشاء بالمطعم'
      ..createdAt = DateTime.now().subtract(Duration(days: 7)),
    Transaction()
      ..amount = 520.00
      ..type = TransactionType.expense
      ..source = TransactionSource.manual
      ..category = 'الغذاء والبقالة'
      ..subcategory = 'بقالة'
      ..walletId = 2
      ..date = DateTime.now().subtract(Duration(days: 3))
      ..note = 'مشتريات البقالة الأسبوعية'
      ..merchant = 'مشتريات البقالة'
      ..createdAt = DateTime.now().subtract(Duration(days: 3)),
    Transaction()
      ..amount = 150.00
      ..type = TransactionType.expense
      ..source = TransactionSource.recurring
      ..category = 'الصحة واللياقة'
      ..subcategory = 'جيم'
      ..walletId = 1
      ..date = DateTime.now().subtract(Duration(days: 10))
      ..note = 'اشتراك شهري'
      ..merchant = 'اشتراك الجيم'
      ..createdAt = DateTime.now().subtract(Duration(days: 10)),
    Transaction()
      ..amount = 200.00
      ..type = TransactionType.expense
      ..source = TransactionSource.recurring
      ..category = 'المرافق والفواتير'
      ..subcategory = 'إنترنت'
      ..walletId = 2
      ..date = DateTime.now().subtract(Duration(days: 1))
      ..note = 'اشتراك إنترنت شهري'
      ..merchant = 'فاتورة الإنترنت'
      ..createdAt = DateTime.now().subtract(Duration(days: 1)),
    Transaction()
      ..amount = 500.00
      ..type = TransactionType.income
      ..source = TransactionSource.manual
      ..category = 'تحويل'
      ..subcategory = 'من صديق'
      ..walletId = 3
      ..date = DateTime.now().subtract(Duration(days: 4))
      ..note = 'تحويل من أحمد'
      ..merchant = 'تحويل من الصديق'
      ..createdAt = DateTime.now().subtract(Duration(days: 4)),
  ];

  /// Sample budgets for testing
  static List<Budget> get dummyBudgets => [
    Budget()
      ..categoryName = 'مطاعم ومقاهي'
      ..limitAmount = 1000.00
      ..period = 'monthly'
      ..startDate = DateTime.now()
      ..isActive = true,
    Budget()
      ..categoryName = 'الغذاء والبقالة'
      ..limitAmount = 2000.00
      ..period = 'monthly'
      ..startDate = DateTime.now()
      ..isActive = true,
    Budget()
      ..categoryName = 'المرافق والفواتير'
      ..limitAmount = 1500.00
      ..period = 'monthly'
      ..startDate = DateTime.now()
      ..isActive = true,
    Budget()
      ..categoryName = 'الصحة واللياقة'
      ..limitAmount = 500.00
      ..period = 'monthly'
      ..startDate = DateTime.now()
      ..isActive = true,
  ];

  /// Sample savings goals for testing
  static List<SavingsGoal> get dummyGoals => [
    SavingsGoal()
      ..name = 'رحلة الصيف'
      ..targetAmount = 5000.00
      ..currentAmount = 3200.00
      ..icon = '✈️'
      ..deadline = DateTime.now().add(Duration(days: 120))
      ..createdAt = DateTime.now(),
    SavingsGoal()
      ..name = 'سيارة جديدة'
      ..targetAmount = 100000.00
      ..currentAmount = 25500.00
      ..icon = '🚗'
      ..deadline = DateTime.now().add(Duration(days: 365))
      ..createdAt = DateTime.now(),
    SavingsGoal()
      ..name = 'شقة'
      ..targetAmount = 500000.00
      ..currentAmount = 120000.00
      ..icon = '🏠'
      ..deadline = DateTime.now().add(Duration(days: 730))
      ..createdAt = DateTime.now(),
    SavingsGoal()
      ..name = 'الطوارئ'
      ..targetAmount = 10000.00
      ..currentAmount = 8500.00
      ..icon = '🚨'
      ..deadline = null
      ..createdAt = DateTime.now(),
  ];

  /// Sample recurring transactions for testing
  static List<RecurringTransaction> get dummyRecurring => [
    RecurringTransaction()
      ..name = 'الراتب الشهري'
      ..amount = 8000.00
      ..frequency = Frequency.monthly
      ..category = 'الدخل'
      ..type = TransactionType.income
      ..startDate = DateTime.now().subtract(Duration(days: 90))
      ..isActive = true
      ..nextDueDate = DateTime.now().add(Duration(days: 15)),
    RecurringTransaction()
      ..name = 'الإيجار'
      ..amount = 2500.00
      ..frequency = Frequency.monthly
      ..category = 'السكن'
      ..type = TransactionType.expense
      ..startDate = DateTime.now().subtract(Duration(days: 120))
      ..isActive = true
      ..nextDueDate = DateTime.now().add(Duration(days: 5)),
    RecurringTransaction()
      ..name = 'فاتورة الإنترنت'
      ..amount = 200.00
      ..frequency = Frequency.monthly
      ..category = 'المرافق والفواتير'
      ..type = TransactionType.expense
      ..startDate = DateTime.now().subtract(Duration(days: 60))
      ..isActive = true
      ..nextDueDate = DateTime.now().add(Duration(days: 8)),
    RecurringTransaction()
      ..name = 'اشتراك الجيم'
      ..amount = 150.00
      ..frequency = Frequency.monthly
      ..category = 'الصحة واللياقة'
      ..type = TransactionType.expense
      ..startDate = DateTime.now().subtract(Duration(days: 45))
      ..isActive = true
      ..nextDueDate = DateTime.now().add(Duration(days: 12)),
    RecurringTransaction()
      ..name = 'اشتراك التطبيق'
      ..amount = 99.00
      ..frequency = Frequency.monthly
      ..category = 'الترفيه'
      ..type = TransactionType.expense
      ..startDate = DateTime.now().subtract(Duration(days: 30))
      ..isActive = true
      ..nextDueDate = DateTime.now().add(Duration(days: 20)),
  ];

  /// Sample installment plans for testing
  static List<InstallmentPlan> get dummyInstallments => [
    // Active iPhone installment - سهولة (provider 1)
    InstallmentPlan()
      ..itemName = 'آيفون 15 برو ماكس'
      ..category = 'إلكترونيات'
      ..providerId = 1
      ..originalPrice = 55000.00
      ..totalWithInterest = 61600.00
      ..totalInstallments = 12
      ..monthlyAmount = 5133.33
      ..firstPaymentDate = DateTime.now().subtract(Duration(days: 90))
      ..dayOfMonth = 15
      ..paidInstallments = 3
      ..paidAmount = 15400.00
      ..status = 'active'
      ..walletId = 2
      ..autoAdd = true
      ..createdAt = DateTime.now().subtract(Duration(days: 95)),

    // Active laptop installment - فاليو (provider 2)
    InstallmentPlan()
      ..itemName = 'لابتوب ماك بوك برو'
      ..category = 'إلكترونيات'
      ..providerId = 2
      ..originalPrice = 75000.00
      ..totalWithInterest = 82500.00
      ..totalInstallments = 18
      ..monthlyAmount = 4583.33
      ..firstPaymentDate = DateTime.now().subtract(Duration(days: 60))
      ..dayOfMonth = 1
      ..paidInstallments = 2
      ..paidAmount = 9166.66
      ..status = 'active'
      ..walletId = 2
      ..autoAdd = false
      ..createdAt = DateTime.now().subtract(Duration(days: 65)),

    // Active furniture installment - كونتكت (provider 3)
    InstallmentPlan()
      ..itemName = 'أثاث غرفة النوم'
      ..category = 'أثاث ومنزل'
      ..providerId = 3
      ..originalPrice = 35000.00
      ..totalWithInterest = 38500.00
      ..totalInstallments = 10
      ..monthlyAmount = 3850.00
      ..firstPaymentDate = DateTime.now().subtract(Duration(days: 150))
      ..dayOfMonth = 20
      ..paidInstallments = 5
      ..paidAmount = 19250.00
      ..status = 'active'
      ..walletId = 1
      ..autoAdd = true
      ..createdAt = DateTime.now().subtract(Duration(days: 155)),

    // Active AC installment - بريميم (provider 4)
    InstallmentPlan()
      ..itemName = 'تكييف سبليت 2.25 حصان'
      ..category = 'أجهزة منزلية'
      ..providerId = 4
      ..originalPrice = 28000.00
      ..totalWithInterest = 30800.00
      ..totalInstallments = 6
      ..monthlyAmount = 5133.33
      ..firstPaymentDate = DateTime.now().subtract(Duration(days: 30))
      ..dayOfMonth = 10
      ..paidInstallments = 1
      ..paidAmount = 5133.33
      ..status = 'active'
      ..walletId = 2
      ..autoAdd = false
      ..createdAt = DateTime.now().subtract(Duration(days: 35)),

    // Overdue installment - أمان (provider 5)
    InstallmentPlan()
      ..itemName = 'جوال سامسونج S24'
      ..category = 'إلكترونيات'
      ..providerId = 5
      ..originalPrice = 42000.00
      ..totalWithInterest = 46200.00
      ..totalInstallments = 12
      ..monthlyAmount = 3850.00
      ..firstPaymentDate = DateTime.now().subtract(Duration(days: 120))
      ..dayOfMonth = 5
      ..paidInstallments = 3
      ..paidAmount = 11550.00
      ..status = 'overdue'
      ..walletId = 1
      ..autoAdd = false
      ..createdAt = DateTime.now().subtract(Duration(days: 125)),

    // Completed installment - كريدت كارد (provider 6)
    InstallmentPlan()
      ..itemName = 'غسالة أوتوماتيك'
      ..category = 'أجهزة منزلية'
      ..providerId = 6
      ..originalPrice = 15000.00
      ..totalWithInterest = 16500.00
      ..totalInstallments = 6
      ..monthlyAmount = 2750.00
      ..firstPaymentDate = DateTime.now().subtract(Duration(days: 200))
      ..dayOfMonth = 25
      ..paidInstallments = 6
      ..paidAmount = 16500.00
      ..status = 'completed'
      ..walletId = 2
      ..autoAdd = true
      ..createdAt = DateTime.now().subtract(Duration(days: 210)),

    // Completed installment - سهولة (provider 1)
    InstallmentPlan()
      ..itemName = 'سماعات AirPods Pro'
      ..category = 'إلكترونيات'
      ..providerId = 1
      ..originalPrice = 8000.00
      ..totalWithInterest = 8800.00
      ..totalInstallments = 4
      ..monthlyAmount = 2200.00
      ..firstPaymentDate = DateTime.now().subtract(Duration(days: 150))
      ..dayOfMonth = 15
      ..paidInstallments = 4
      ..paidAmount = 8800.00
      ..status = 'completed'
      ..walletId = 1
      ..autoAdd = false
      ..createdAt = DateTime.now().subtract(Duration(days: 155)),
  ];
}
