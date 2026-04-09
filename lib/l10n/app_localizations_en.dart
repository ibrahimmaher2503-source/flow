// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'FlowSpend';

  @override
  String get navHome => 'Home';

  @override
  String get navTransactions => 'Transactions';

  @override
  String get navInstallments => 'Installments';

  @override
  String get navBudgets => 'Budgets';

  @override
  String get navSettings => 'Settings';

  @override
  String get screenSettings => 'Settings';

  @override
  String get screenReports => 'Reports';

  @override
  String get screenWallets => 'Wallets';

  @override
  String get screenGoals => 'Savings Goals';

  @override
  String get screenRecurring => 'Recurring Transactions';

  @override
  String get screenSms => 'Bank Messages';

  @override
  String get screenCategories => 'Manage Categories';

  @override
  String get screenAddTransaction => 'Add Transaction';

  @override
  String get screenEditTransaction => 'Edit Transaction';

  @override
  String get sectionScreens => 'Screens';

  @override
  String get sectionAbout => 'About App';

  @override
  String get sectionPreferences => 'Preferences';

  @override
  String get sectionBackup => 'Backup & Restore';

  @override
  String get labelWallets => 'Wallets';

  @override
  String get labelWalletsDesc => 'Manage wallets and balances';

  @override
  String get labelReports => 'Reports';

  @override
  String get labelReportsDesc => 'Analyze expenses and installments';

  @override
  String get labelGoals => 'Savings Goals';

  @override
  String get labelGoalsDesc => 'Track your financial goals';

  @override
  String get labelRecurring => 'Recurring Transactions';

  @override
  String get labelRecurringDesc => 'Rent, subscriptions, bills';

  @override
  String get labelSms => 'Bank Messages';

  @override
  String get labelSmsDesc => 'Detect and add transactions from SMS';

  @override
  String get labelCategories => 'Manage Categories';

  @override
  String get labelCategoriesDesc => 'Add and edit categories';

  @override
  String get labelVersion => 'Version';

  @override
  String get labelDevelopment => 'Development';

  @override
  String get labelCategory => 'Category';

  @override
  String get labelWallet => 'Wallet';

  @override
  String get labelAmount => 'Amount';

  @override
  String get labelNote => 'Note (optional)';

  @override
  String get labelTotalBalance => 'Total Balance';

  @override
  String get labelMonthlyIncome => 'Monthly Income';

  @override
  String get labelMonthlyExpense => 'Monthly Expense';

  @override
  String get labelRemainingDebt => 'Remaining Debt';

  @override
  String get labelInterestPaid => 'Interest Paid';

  @override
  String get labelFinanceScore => 'Finance Score';

  @override
  String get buttonSave => 'Save';

  @override
  String get buttonSaveEdit => 'Save Changes';

  @override
  String get buttonCancel => 'Cancel';

  @override
  String get buttonDelete => 'Delete';

  @override
  String get buttonAdd => 'Add';

  @override
  String get buttonSkip => 'Skip';

  @override
  String get buttonNext => 'Next';

  @override
  String get buttonStartNow => 'Start Now';

  @override
  String get transactionTypeExpense => 'Expense';

  @override
  String get transactionTypeIncome => 'Income';

  @override
  String get transactionCurrency => 'Egyptian Pound';

  @override
  String get errorInvalidAmount => 'Enter a valid amount';

  @override
  String get errorSelectCategory => 'Select a category';

  @override
  String get errorSelectWallet => 'Select a wallet';

  @override
  String get emptyTransactions => 'No transactions this month';

  @override
  String get emptyBudgets => 'No budgets set';

  @override
  String get emptyGoals => 'No savings goals';

  @override
  String get emptyInstallments => 'No active installments';

  @override
  String get emptyExpensesMonth => 'No expenses this month';

  @override
  String get badgeFirstTransaction => 'First Transaction';

  @override
  String get badgeStreak7 => '7 Day Streak';

  @override
  String get badgeStreak30 => '30 Day Streak';

  @override
  String get badgeFirstGoal => 'First Goal Completed';

  @override
  String get badgeBudgetMonth => 'Budget Champion';

  @override
  String get badgeFirstPlanDone => 'Debt Free';

  @override
  String get badgeNoNewInstallments => '3 Months No New Debt';

  @override
  String get categoryFood => 'Food & Drinks';

  @override
  String get categoryPersonal => 'Personal Expenses';

  @override
  String get categorySmoking => 'Smoking';

  @override
  String get categoryEntertainment => 'Entertainment';

  @override
  String get categoryOutings => 'Outings';

  @override
  String get categoryRent => 'Rent';

  @override
  String get categoryTransport => 'Transportation';

  @override
  String get categoryBills => 'Bills';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryEducation => 'Education';

  @override
  String get categorySubscriptions => 'Subscriptions';

  @override
  String get categoryClothing => 'Clothing';

  @override
  String get categoryGifts => 'Gifts';

  @override
  String get categoryOther => 'Other';

  @override
  String get categorySalary => 'Salary';

  @override
  String get categoryFreelance => 'Freelance';

  @override
  String get categoryRefund => 'Refund';

  @override
  String get categoryOtherIncome => 'Other Income';

  @override
  String get dateToday => 'Today';

  @override
  String get dateYesterday => 'Yesterday';

  @override
  String get dateBeforeYesterday => 'Day before yesterday';

  @override
  String dateDaysAgo(int count) {
    return '$count days ago';
  }

  @override
  String get onboardingWelcomeTitle => 'Welcome to FlowSpend';

  @override
  String get onboardingWelcomeSubtitle =>
      'Your personal app for managing expenses and installments\nAll your data stays on your device — no internet needed';

  @override
  String get onboardingInstallmentsTitle => 'Track Installments & Interest';

  @override
  String get onboardingInstallmentsSubtitle =>
      'Record installments from Sahel, Valu, and credit cards\nSee how much you\'ve paid in interest and what\'s remaining';

  @override
  String get onboardingBudgetTitle => 'Smart Budget & Reports';

  @override
  String get onboardingBudgetSubtitle =>
      'Set a budget for each category\nSee exactly where your money goes';

  @override
  String get onboardingSmsTitle => 'Bank Message Detection';

  @override
  String get onboardingSmsSubtitle =>
      'The app reads bank messages automatically\nAdds transactions without you typing anything';

  @override
  String get reportsTabExpenses => 'Expenses';

  @override
  String get reportsTabInstallments => 'Installments';

  @override
  String get reportsCategoryDistribution => 'Category Distribution';

  @override
  String get reportsProviderDistribution => 'Distribution by Provider';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageArabic => 'Arabic';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsSmsParsing => 'SMS Parsing';

  @override
  String get budgetRemaining => 'Remaining';

  @override
  String get budgetSpent => 'Spent';

  @override
  String get budgetOverBudget => 'Over Budget';

  @override
  String get budgetLimit => 'Budget Limit';

  @override
  String get goalTarget => 'Target';

  @override
  String get goalCurrent => 'Current';

  @override
  String get goalProgress => 'Progress';

  @override
  String get goalCompleted => 'Completed';

  @override
  String get installmentMonthlyPayment => 'Monthly Payment';

  @override
  String get installmentRemainingPayments => 'Remaining Payments';

  @override
  String get installmentTotalAmount => 'Total Amount';

  @override
  String get installmentProvider => 'Provider';

  @override
  String get walletBalance => 'Balance';

  @override
  String get walletTypeCash => 'Cash';

  @override
  String get walletTypeBank => 'Bank Account';

  @override
  String get walletTypeCard => 'Card';

  @override
  String get recurringFrequencyDaily => 'Daily';

  @override
  String get recurringFrequencyWeekly => 'Weekly';

  @override
  String get recurringFrequencyMonthly => 'Monthly';

  @override
  String get recurringFrequencyYearly => 'Yearly';

  @override
  String get recurringNextDue => 'Next Due';
}
