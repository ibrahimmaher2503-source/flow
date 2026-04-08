/// Dummy data for testing and demo purposes
import '../models/transaction_model.dart';
import '../models/wallet_model.dart';
import '../models/budget_model.dart';
import '../models/savings_goal_model.dart';
import '../models/recurring_transaction_model.dart';
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
}
