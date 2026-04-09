import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'FlowSpend'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get navTransactions;

  /// No description provided for @navInstallments.
  ///
  /// In en, this message translates to:
  /// **'Installments'**
  String get navInstallments;

  /// No description provided for @navBudgets.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get navBudgets;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @screenSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get screenSettings;

  /// No description provided for @screenReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get screenReports;

  /// No description provided for @screenWallets.
  ///
  /// In en, this message translates to:
  /// **'Wallets'**
  String get screenWallets;

  /// No description provided for @screenGoals.
  ///
  /// In en, this message translates to:
  /// **'Savings Goals'**
  String get screenGoals;

  /// No description provided for @screenRecurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring Transactions'**
  String get screenRecurring;

  /// No description provided for @screenSms.
  ///
  /// In en, this message translates to:
  /// **'Bank Messages'**
  String get screenSms;

  /// No description provided for @screenCategories.
  ///
  /// In en, this message translates to:
  /// **'Manage Categories'**
  String get screenCategories;

  /// No description provided for @screenAddTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get screenAddTransaction;

  /// No description provided for @screenEditTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit Transaction'**
  String get screenEditTransaction;

  /// No description provided for @sectionScreens.
  ///
  /// In en, this message translates to:
  /// **'Screens'**
  String get sectionScreens;

  /// No description provided for @sectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get sectionAbout;

  /// No description provided for @sectionPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get sectionPreferences;

  /// No description provided for @sectionBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get sectionBackup;

  /// No description provided for @labelWallets.
  ///
  /// In en, this message translates to:
  /// **'Wallets'**
  String get labelWallets;

  /// No description provided for @labelWalletsDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage wallets and balances'**
  String get labelWalletsDesc;

  /// No description provided for @labelReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get labelReports;

  /// No description provided for @labelReportsDesc.
  ///
  /// In en, this message translates to:
  /// **'Analyze expenses and installments'**
  String get labelReportsDesc;

  /// No description provided for @labelGoals.
  ///
  /// In en, this message translates to:
  /// **'Savings Goals'**
  String get labelGoals;

  /// No description provided for @labelGoalsDesc.
  ///
  /// In en, this message translates to:
  /// **'Track your financial goals'**
  String get labelGoalsDesc;

  /// No description provided for @labelRecurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring Transactions'**
  String get labelRecurring;

  /// No description provided for @labelRecurringDesc.
  ///
  /// In en, this message translates to:
  /// **'Rent, subscriptions, bills'**
  String get labelRecurringDesc;

  /// No description provided for @labelSms.
  ///
  /// In en, this message translates to:
  /// **'Bank Messages'**
  String get labelSms;

  /// No description provided for @labelSmsDesc.
  ///
  /// In en, this message translates to:
  /// **'Detect and add transactions from SMS'**
  String get labelSmsDesc;

  /// No description provided for @labelCategories.
  ///
  /// In en, this message translates to:
  /// **'Manage Categories'**
  String get labelCategories;

  /// No description provided for @labelCategoriesDesc.
  ///
  /// In en, this message translates to:
  /// **'Add and edit categories'**
  String get labelCategoriesDesc;

  /// No description provided for @labelVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get labelVersion;

  /// No description provided for @labelDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Development'**
  String get labelDevelopment;

  /// No description provided for @labelCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get labelCategory;

  /// No description provided for @labelWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get labelWallet;

  /// No description provided for @labelAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get labelAmount;

  /// No description provided for @labelNote.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get labelNote;

  /// No description provided for @labelTotalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get labelTotalBalance;

  /// No description provided for @labelMonthlyIncome.
  ///
  /// In en, this message translates to:
  /// **'Monthly Income'**
  String get labelMonthlyIncome;

  /// No description provided for @labelMonthlyExpense.
  ///
  /// In en, this message translates to:
  /// **'Monthly Expense'**
  String get labelMonthlyExpense;

  /// No description provided for @labelRemainingDebt.
  ///
  /// In en, this message translates to:
  /// **'Remaining Debt'**
  String get labelRemainingDebt;

  /// No description provided for @labelInterestPaid.
  ///
  /// In en, this message translates to:
  /// **'Interest Paid'**
  String get labelInterestPaid;

  /// No description provided for @labelFinanceScore.
  ///
  /// In en, this message translates to:
  /// **'Finance Score'**
  String get labelFinanceScore;

  /// No description provided for @buttonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get buttonSave;

  /// No description provided for @buttonSaveEdit.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get buttonSaveEdit;

  /// No description provided for @buttonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get buttonCancel;

  /// No description provided for @buttonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get buttonDelete;

  /// No description provided for @buttonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get buttonAdd;

  /// No description provided for @buttonSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get buttonSkip;

  /// No description provided for @buttonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get buttonNext;

  /// No description provided for @buttonStartNow.
  ///
  /// In en, this message translates to:
  /// **'Start Now'**
  String get buttonStartNow;

  /// No description provided for @transactionTypeExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get transactionTypeExpense;

  /// No description provided for @transactionTypeIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get transactionTypeIncome;

  /// No description provided for @transactionCurrency.
  ///
  /// In en, this message translates to:
  /// **'Egyptian Pound'**
  String get transactionCurrency;

  /// No description provided for @errorInvalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get errorInvalidAmount;

  /// No description provided for @errorSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get errorSelectCategory;

  /// No description provided for @errorSelectWallet.
  ///
  /// In en, this message translates to:
  /// **'Select a wallet'**
  String get errorSelectWallet;

  /// No description provided for @emptyTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions this month'**
  String get emptyTransactions;

  /// No description provided for @emptyBudgets.
  ///
  /// In en, this message translates to:
  /// **'No budgets set'**
  String get emptyBudgets;

  /// No description provided for @emptyGoals.
  ///
  /// In en, this message translates to:
  /// **'No savings goals'**
  String get emptyGoals;

  /// No description provided for @emptyInstallments.
  ///
  /// In en, this message translates to:
  /// **'No active installments'**
  String get emptyInstallments;

  /// No description provided for @emptyExpensesMonth.
  ///
  /// In en, this message translates to:
  /// **'No expenses this month'**
  String get emptyExpensesMonth;

  /// No description provided for @badgeFirstTransaction.
  ///
  /// In en, this message translates to:
  /// **'First Transaction'**
  String get badgeFirstTransaction;

  /// No description provided for @badgeStreak7.
  ///
  /// In en, this message translates to:
  /// **'7 Day Streak'**
  String get badgeStreak7;

  /// No description provided for @badgeStreak30.
  ///
  /// In en, this message translates to:
  /// **'30 Day Streak'**
  String get badgeStreak30;

  /// No description provided for @badgeFirstGoal.
  ///
  /// In en, this message translates to:
  /// **'First Goal Completed'**
  String get badgeFirstGoal;

  /// No description provided for @badgeBudgetMonth.
  ///
  /// In en, this message translates to:
  /// **'Budget Champion'**
  String get badgeBudgetMonth;

  /// No description provided for @badgeFirstPlanDone.
  ///
  /// In en, this message translates to:
  /// **'Debt Free'**
  String get badgeFirstPlanDone;

  /// No description provided for @badgeNoNewInstallments.
  ///
  /// In en, this message translates to:
  /// **'3 Months No New Debt'**
  String get badgeNoNewInstallments;

  /// No description provided for @categoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food & Drinks'**
  String get categoryFood;

  /// No description provided for @categoryPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal Expenses'**
  String get categoryPersonal;

  /// No description provided for @categorySmoking.
  ///
  /// In en, this message translates to:
  /// **'Smoking'**
  String get categorySmoking;

  /// No description provided for @categoryEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get categoryEntertainment;

  /// No description provided for @categoryOutings.
  ///
  /// In en, this message translates to:
  /// **'Outings'**
  String get categoryOutings;

  /// No description provided for @categoryRent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get categoryRent;

  /// No description provided for @categoryTransport.
  ///
  /// In en, this message translates to:
  /// **'Transportation'**
  String get categoryTransport;

  /// No description provided for @categoryBills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get categoryBills;

  /// No description provided for @categoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get categoryHealth;

  /// No description provided for @categoryEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get categoryEducation;

  /// No description provided for @categorySubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get categorySubscriptions;

  /// No description provided for @categoryClothing.
  ///
  /// In en, this message translates to:
  /// **'Clothing'**
  String get categoryClothing;

  /// No description provided for @categoryGifts.
  ///
  /// In en, this message translates to:
  /// **'Gifts'**
  String get categoryGifts;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @categorySalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get categorySalary;

  /// No description provided for @categoryFreelance.
  ///
  /// In en, this message translates to:
  /// **'Freelance'**
  String get categoryFreelance;

  /// No description provided for @categoryRefund.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get categoryRefund;

  /// No description provided for @categoryOtherIncome.
  ///
  /// In en, this message translates to:
  /// **'Other Income'**
  String get categoryOtherIncome;

  /// No description provided for @dateToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dateToday;

  /// No description provided for @dateYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get dateYesterday;

  /// No description provided for @dateBeforeYesterday.
  ///
  /// In en, this message translates to:
  /// **'Day before yesterday'**
  String get dateBeforeYesterday;

  /// No description provided for @dateDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String dateDaysAgo(int count);

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to FlowSpend'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your personal app for managing expenses and installments\nAll your data stays on your device — no internet needed'**
  String get onboardingWelcomeSubtitle;

  /// No description provided for @onboardingInstallmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Track Installments & Interest'**
  String get onboardingInstallmentsTitle;

  /// No description provided for @onboardingInstallmentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Record installments from Sahel, Valu, and credit cards\nSee how much you\'ve paid in interest and what\'s remaining'**
  String get onboardingInstallmentsSubtitle;

  /// No description provided for @onboardingBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Budget & Reports'**
  String get onboardingBudgetTitle;

  /// No description provided for @onboardingBudgetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set a budget for each category\nSee exactly where your money goes'**
  String get onboardingBudgetSubtitle;

  /// No description provided for @onboardingSmsTitle.
  ///
  /// In en, this message translates to:
  /// **'Bank Message Detection'**
  String get onboardingSmsTitle;

  /// No description provided for @onboardingSmsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The app reads bank messages automatically\nAdds transactions without you typing anything'**
  String get onboardingSmsSubtitle;

  /// No description provided for @reportsTabExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get reportsTabExpenses;

  /// No description provided for @reportsTabInstallments.
  ///
  /// In en, this message translates to:
  /// **'Installments'**
  String get reportsTabInstallments;

  /// No description provided for @reportsCategoryDistribution.
  ///
  /// In en, this message translates to:
  /// **'Category Distribution'**
  String get reportsCategoryDistribution;

  /// No description provided for @reportsProviderDistribution.
  ///
  /// In en, this message translates to:
  /// **'Distribution by Provider'**
  String get reportsProviderDistribution;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get settingsLanguageArabic;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsSmsParsing.
  ///
  /// In en, this message translates to:
  /// **'SMS Parsing'**
  String get settingsSmsParsing;

  /// No description provided for @budgetRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get budgetRemaining;

  /// No description provided for @budgetSpent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get budgetSpent;

  /// No description provided for @budgetOverBudget.
  ///
  /// In en, this message translates to:
  /// **'Over Budget'**
  String get budgetOverBudget;

  /// No description provided for @budgetLimit.
  ///
  /// In en, this message translates to:
  /// **'Budget Limit'**
  String get budgetLimit;

  /// No description provided for @goalTarget.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get goalTarget;

  /// No description provided for @goalCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get goalCurrent;

  /// No description provided for @goalProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get goalProgress;

  /// No description provided for @goalCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get goalCompleted;

  /// No description provided for @installmentMonthlyPayment.
  ///
  /// In en, this message translates to:
  /// **'Monthly Payment'**
  String get installmentMonthlyPayment;

  /// No description provided for @installmentRemainingPayments.
  ///
  /// In en, this message translates to:
  /// **'Remaining Payments'**
  String get installmentRemainingPayments;

  /// No description provided for @installmentTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get installmentTotalAmount;

  /// No description provided for @installmentProvider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get installmentProvider;

  /// No description provided for @walletBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get walletBalance;

  /// No description provided for @walletTypeCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get walletTypeCash;

  /// No description provided for @walletTypeBank.
  ///
  /// In en, this message translates to:
  /// **'Bank Account'**
  String get walletTypeBank;

  /// No description provided for @walletTypeCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get walletTypeCard;

  /// No description provided for @recurringFrequencyDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get recurringFrequencyDaily;

  /// No description provided for @recurringFrequencyWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get recurringFrequencyWeekly;

  /// No description provided for @recurringFrequencyMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get recurringFrequencyMonthly;

  /// No description provided for @recurringFrequencyYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get recurringFrequencyYearly;

  /// No description provided for @recurringNextDue.
  ///
  /// In en, this message translates to:
  /// **'Next Due'**
  String get recurringNextDue;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
