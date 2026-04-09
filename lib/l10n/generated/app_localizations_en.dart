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

  @override
  String get greetingMorning => 'Good Morning';

  @override
  String get greetingEvening => 'Good Evening';

  @override
  String get motivationMorning => 'New day, new opportunity to save';

  @override
  String get motivationAfternoon => 'Track your financial achievements';

  @override
  String get motivationEvening => 'Review today\'s expenses';

  @override
  String get labelTotalBalanceFull => 'Total Balance';

  @override
  String get labelMonthIncome => 'Monthly Income';

  @override
  String get labelMonthExpense => 'Monthly Expense';

  @override
  String get streakDaysConsecutive => 'consecutive days';

  @override
  String get streakMessage30 => 'A full month! You\'re a champion';

  @override
  String get streakMessage14 => 'Two weeks straight! Amazing';

  @override
  String get streakMessage7 => 'A full week! Excellent';

  @override
  String get streakMessage3 => 'Strong start! Keep going';

  @override
  String get streakMessageDefault => 'Keep logging your expenses!';

  @override
  String get streakMilestoneMonth => 'Month';

  @override
  String get streakMilestone2Weeks => '2 Weeks';

  @override
  String get streakMilestoneWeek => 'Week';

  @override
  String get safeToSpendTitle => 'Safe to Spend';

  @override
  String get safeToSpendDesc => 'Available after budgets';

  @override
  String get safeToSpendOverBudget => 'Over budget by';

  @override
  String get financeScoreTitle => 'Finance Score';

  @override
  String get financeScoreLow => 'Needs Improvement';

  @override
  String get financeScoreMedium => 'Good Progress';

  @override
  String get financeScoreHigh => 'Excellent!';

  @override
  String get installmentSummaryTitle => 'Installments Summary';

  @override
  String get installmentRemaining => 'Remaining';

  @override
  String get installmentInterest => 'Interest Paid';

  @override
  String get installmentMonthly => 'Monthly Payment';

  @override
  String get recentTransactionsTitle => 'Recent Transactions';

  @override
  String get viewAll => 'View All';

  @override
  String get upcomingRecurringTitle => 'Upcoming Recurring';

  @override
  String get dueSoon => 'Due Soon';

  @override
  String get safeToSpendNegative => 'Negative';

  @override
  String safeToSpendFrom(String amount) {
    return 'From $amount';
  }

  @override
  String safeToSpendPercentAvailable(int percent) {
    return '$percent% available';
  }

  @override
  String get safeToSpendShowDetails => 'Show Details';

  @override
  String get safeToSpendHideDetails => 'Hide Details';

  @override
  String get safeToSpendNoObligations => 'No obligations this month';

  @override
  String get safeToSpendObligations => 'Obligations';

  @override
  String get safeToSpendCalcError => 'Error calculating available amount';

  @override
  String get healthStatusHealthy => 'Comfortable position';

  @override
  String get healthStatusCaution => 'Watch your expenses';

  @override
  String get healthStatusDanger => 'Caution - tight budget';

  @override
  String get dueDateToday => 'Today';

  @override
  String get dueDateTomorrow => 'Tomorrow';

  @override
  String dueDateInDays(int days) {
    return 'In $days days';
  }

  @override
  String get installmentsTitle => 'Installments';

  @override
  String get installmentsTrackingDesc => 'Track installments and obligations';

  @override
  String installmentsActive(int count) {
    return '$count active';
  }

  @override
  String get installmentsTotalObligations => 'Total Obligations';

  @override
  String get installmentsMonthly => 'Monthly Installments';

  @override
  String get installmentsAvgProgress => 'Average Progress';

  @override
  String get emptyTransactionsYet => 'No transactions yet';

  @override
  String get emptyTransactionsStart => 'Start by adding your first transaction';

  @override
  String get errorLoadingTransactions => 'Error loading transactions';

  @override
  String get deleteTransaction => 'Delete Transaction?';

  @override
  String get deleteTransactionConfirm =>
      'Are you sure you want to delete this transaction?';

  @override
  String get buttonNo => 'No';

  @override
  String get buttonYesDelete => 'Yes, Delete';

  @override
  String get filterAll => 'All';

  @override
  String get filterIncome => 'Income';

  @override
  String get filterExpense => 'Expense';

  @override
  String get filterInstallment => 'Installment';

  @override
  String get emptyTransactionsPeriod => 'No transactions in this period';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get financeScore => 'Finance Score';

  @override
  String get achievements => 'Achievements';

  @override
  String get scorePoints => 'points';

  @override
  String get scoreProgress => 'Progress';

  @override
  String get scoreExcellent => 'Excellent! You\'re at the top';

  @override
  String get scoreGreat => 'Great! Keep it up';

  @override
  String get scoreGood => 'Good, room for improvement';

  @override
  String get scorePoor => 'Need some focus';

  @override
  String get scoreStart => 'Start with a budget';

  @override
  String get dailyAverage => 'Daily Average';

  @override
  String get topCategory => 'Top Category';

  @override
  String get noData => 'No data';

  @override
  String get interestPaid => 'Interest Paid';

  @override
  String get upcomingTransactions => 'Upcoming Transactions';

  @override
  String get manage => 'Manage';

  @override
  String get frequencyDaily => 'Daily';

  @override
  String get frequencyWeekly => 'Weekly';

  @override
  String get frequencyMonthly => 'Monthly';

  @override
  String get frequencyYearly => 'Yearly';

  @override
  String get deleteBudget => 'Delete Budget?';

  @override
  String get addBudget => 'Add Budget';

  @override
  String addContributionToGoal(String goalName) {
    return 'Add Amount to $goalName';
  }

  @override
  String get addNewGoal => 'New Savings Goal';

  @override
  String get goalName => 'Goal Name';

  @override
  String get addWallet => 'Add Wallet';

  @override
  String get walletName => 'Wallet Name';

  @override
  String get initialBalance => 'Initial Balance';

  @override
  String get editWallet => 'Edit Wallet';

  @override
  String get deleteWallet => 'Delete Wallet?';

  @override
  String get addRecurring => 'Add Recurring Transaction';

  @override
  String get name => 'Name';

  @override
  String get autoRecord => 'Auto Record';

  @override
  String get pauseRecurring => 'Pause';

  @override
  String get activateRecurring => 'Activate';

  @override
  String get buttonClose => 'Close';

  @override
  String get emptyRecurringTransactions => 'No recurring transactions yet';

  @override
  String get emptyWallets => 'No wallets';

  @override
  String get buttonYes => 'Yes';

  @override
  String get selectWallet => 'Select Wallet';

  @override
  String get selectProvider => 'Select Provider';

  @override
  String get addCategory => 'Add Category';

  @override
  String get newCategory => 'New Category';

  @override
  String get enterProductName => 'Enter product name';

  @override
  String get enterOriginalPrice => 'Enter original price';

  @override
  String get retryButton => 'Retry';

  @override
  String get manageCategories => 'Manage Categories';

  @override
  String get categoryIcon => 'Icon';

  @override
  String get categoryColor => 'Color';

  @override
  String get tags => 'Tags';

  @override
  String get reports => 'Reports';

  @override
  String get finance => 'Finance';

  @override
  String get back => 'Back';

  @override
  String get createEnvelopes => 'Create Envelopes';

  @override
  String get distribution => 'Distribution';

  @override
  String get byProvider => 'By Provider';

  @override
  String get planNotFound => 'Plan not found';

  @override
  String get totalWithInterest => 'Total with Interest';

  @override
  String get installments => 'Installments';

  @override
  String get remainingObligations => 'Remaining Obligations';

  @override
  String get smsConfirmationTitle => 'Confirm Transaction';

  @override
  String get smsNotFound => 'Transaction not found';

  @override
  String get smsAlreadyConfirmed => 'Transaction already confirmed';

  @override
  String get smsAlreadyDismissed => 'Transaction already dismissed';

  @override
  String get smsDismissButton => 'Dismiss';

  @override
  String get smsConfirmButton => 'Confirm';

  @override
  String get smsTransactionAddedSuccess => 'Transaction added successfully';

  @override
  String get smsStatusConfirmed => 'Confirmed';

  @override
  String get smsStatusDismissed => 'Dismissed';

  @override
  String get smsStatusPending => 'Pending';

  @override
  String get smsTimeNow => 'Just now';

  @override
  String smsTimeMinutesAgo(int minutes) {
    return '$minutes minutes ago';
  }

  @override
  String smsTimeHoursAgo(int hours) {
    return '$hours hours ago';
  }

  @override
  String smsTimeYesterday(String time) {
    return 'Yesterday $time';
  }

  @override
  String smsTimeDaysAgo(int days) {
    return '$days days ago';
  }

  @override
  String get smsPermissionTitle => 'Allow SMS Access';

  @override
  String get smsPermissionDescription =>
      'FlowSpend needs SMS permission to automatically detect your bank transactions.';

  @override
  String get smsPermissionPrivacyAssurance =>
      'Your data is safe - everything stays on your device locally and no data is sent to the internet.';

  @override
  String get smsPermissionNotNow => 'Not Now';

  @override
  String get smsPermissionAllow => 'Allow';

  @override
  String get tabActive => 'Active';

  @override
  String get tabCompleted => 'Completed';

  @override
  String get totalCommitments => 'Total Commitments';

  @override
  String get monthlyInstallments => 'Monthly Installments';

  @override
  String get paidInterest => 'Interest Paid';

  @override
  String get emptyActiveInstallments => 'No active installments';

  @override
  String get emptyCompletedInstallments => 'No completed installments';

  @override
  String get confirmTransaction => 'Confirm Transaction';

  @override
  String get transactionNotFound => 'Transaction not found';

  @override
  String get transactionAlreadyConfirmed => 'Transaction already confirmed';

  @override
  String get transactionAlreadyRejected => 'Transaction already rejected';

  @override
  String get selectCategory => 'Select Category';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get confirm => 'Confirm';

  @override
  String get transactionAddedSuccessfully => 'Transaction added successfully';

  @override
  String errorOccurred(String error) {
    return 'Error occurred: $error';
  }

  @override
  String get categoryDistribution => 'Category Distribution';

  @override
  String get expenses => 'Expenses';

  @override
  String get noExpensesThisMonth => 'No expenses this month';

  @override
  String get remainingCommitments => 'Remaining Commitments';

  @override
  String get distributionByProvider => 'Distribution by Provider';

  @override
  String get badge7DayStreak => '7 Day Streak';

  @override
  String get badge30DayStreak => '30 Day Streak';

  @override
  String get badgeFirstGoalCompleted => 'First Goal Completed';

  @override
  String get badgeBudgetCommitted => 'Budget Champion';

  @override
  String get badgeFirstPlanCompleted => 'Debt Free';
}
