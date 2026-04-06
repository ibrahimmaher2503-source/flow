import 'package:flutter/material.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/transactions/transactions_screen.dart';
import '../../features/installments/installments_hub_screen.dart';
import '../../features/budgets/budgets_screen.dart';
import '../../features/settings/settings_screen.dart';

class AppRouter {
  static const dashboard = '/';
  static const transactions = '/transactions';
  static const installments = '/installments';
  static const budgets = '/budgets';
  static const settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case transactions:
        return MaterialPageRoute(
            builder: (_) => const TransactionsScreen());
      case installments:
        return MaterialPageRoute(
            builder: (_) => const InstallmentsHubScreen());
      case budgets:
        return MaterialPageRoute(builder: (_) => const BudgetsScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => const DashboardScreen());
    }
  }
}
