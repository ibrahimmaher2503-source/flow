abstract class AppConstants {
  static const appName = 'FlowSpend';
  static const currency = 'EGP';
  static const currencySymbol = 'جنيه';
  static const dateFormat = 'dd/MM/yyyy';
  static const defaultLocale = 'ar';
  static const dbName = 'flowspend';
}

abstract class TransactionType {
  static const income = 'income';
  static const expense = 'expense';
}

abstract class TransactionSource {
  static const manual = 'manual';
  static const sms = 'sms';
  static const recurring = 'recurring';
  static const installment = 'installment';
}

abstract class WalletType {
  static const cash = 'cash';
  static const bank = 'bank';
  static const ewallet = 'ewallet';
}

abstract class PlanStatus {
  static const active = 'active';
  static const completed = 'completed';
  static const overdue = 'overdue';
}

abstract class Frequency {
  static const daily = 'daily';
  static const weekly = 'weekly';
  static const monthly = 'monthly';
  static const yearly = 'yearly';
}

abstract class BudgetPeriod {
  static const monthly = 'monthly';
  static const weekly = 'weekly';
}
