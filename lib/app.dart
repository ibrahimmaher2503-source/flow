import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/generated/app_localizations.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/transactions/transactions_screen.dart';
import 'features/transactions/add_transaction_screen.dart';
import 'features/installments/installments_hub_screen.dart';
import 'features/budgets/budgets_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'providers/theme_provider.dart' show themeProvider, AppThemeMode;
import 'providers/locale_provider.dart';
import 'main.dart' show navigatorKey;

class FlowSpendApp extends ConsumerWidget {
  final bool showOnboarding;

  const FlowSpendApp({super.key, this.showOnboarding = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'FlowSpend',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _getFlutterThemeMode(appThemeMode),
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateRoute: AppRouter.generateRoute,
      home: showOnboarding ? _OnboardingWrapper() : const AppShell(),
      builder: (context, child) {
        // Wrap with AnimatedTheme for smooth theme transitions
        return AnimatedTheme(
          data: Theme.of(context),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: child!,
        );
      },
    );
  }

  /// Convert our AppThemeMode to Flutter's ThemeMode
  ThemeMode _getFlutterThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final _screens = const [
    DashboardScreen(),
    TransactionsScreen(),
    InstallmentsHubScreen(),
    BudgetsScreen(),
    SettingsScreen(),
  ];

  // FAB only on Dashboard (0) and Transactions (1) tabs
  bool get _showFab => _currentIndex == 0 || _currentIndex == 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Builder(
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final navBarTheme = Theme.of(context).bottomNavigationBarTheme;

          return Container(
            decoration: BoxDecoration(
              color: navBarTheme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
              boxShadow: isDark
                  ? [
                      BoxShadow(
                        color: AppColors.background.withValues(alpha: 0.5),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ]
                  : AppColors.lightShadowSubtle,
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_rounded),
                  label: AppLocalizations.of(context)!.navHome,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.receipt_long_rounded),
                  label: AppLocalizations.of(context)!.navTransactions,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.credit_card_rounded),
                  label: AppLocalizations.of(context)!.navInstallments,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.pie_chart_rounded),
                  label: AppLocalizations.of(context)!.navBudgets,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.settings_rounded),
                  label: AppLocalizations.of(context)!.navSettings,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: _showFab
          ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddTransactionScreen(),
                    ),
                  );
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: const Icon(Icons.add_rounded, size: 28),
              ),
            )
          : null,
    );
  }
}

class _OnboardingWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OnboardingScreen(
      onComplete: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AppShell()),
        );
      },
    );
  }
}
