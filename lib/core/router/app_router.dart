import 'package:flutter/material.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/transactions/transactions_screen.dart';
import '../../features/transactions/add_transaction_screen.dart';
import '../../features/installments/installments_hub_screen.dart';
import '../../features/installments/add_installment_screen.dart';
import '../../features/budgets/budgets_screen.dart';
import '../../features/wallets/wallets_screen.dart';
import '../../features/reports/reports_screen.dart';
import '../../features/goals/goals_screen.dart';
import '../../features/recurring/recurring_screen.dart';
import '../../features/sms/sms_inbox_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/settings/categories_screen.dart';

class AppRouter {
  static const dashboard = '/';
  static const transactions = '/transactions';
  static const addTransaction = '/transactions/add';
  static const installments = '/installments';
  static const addInstallment = '/installments/add';
  static const budgets = '/budgets';
  static const wallets = '/wallets';
  static const reports = '/reports';
  static const goals = '/goals';
  static const recurring = '/recurring';
  static const smsInbox = '/sms';
  static const categories = '/categories';
  static const settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case transactions:
        return MaterialPageRoute(
            builder: (_) => const TransactionsScreen());
      case addTransaction:
        return MaterialPageRoute(
            builder: (_) => const AddTransactionScreen());
      case installments:
        return MaterialPageRoute(
            builder: (_) => const InstallmentsHubScreen());
      case addInstallment:
        return MaterialPageRoute(
            builder: (_) => const AddInstallmentScreen());
      case budgets:
        return MaterialPageRoute(builder: (_) => const BudgetsScreen());
      case wallets:
        return MaterialPageRoute(builder: (_) => const WalletsScreen());
      case reports:
        return MaterialPageRoute(builder: (_) => const ReportsScreen());
      case goals:
        return MaterialPageRoute(builder: (_) => const GoalsScreen());
      case recurring:
        return MaterialPageRoute(
            builder: (_) => const RecurringScreen());
      case smsInbox:
        return MaterialPageRoute(
            builder: (_) => const SmsInboxScreen());
      case categories:
        return MaterialPageRoute(
            builder: (_) => const CategoriesScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => const DashboardScreen());
    }
  }
}
