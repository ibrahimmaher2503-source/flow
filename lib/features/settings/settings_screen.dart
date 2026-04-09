import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';
import '../wallets/wallets_screen.dart';
import '../reports/reports_screen.dart';
import '../goals/goals_screen.dart';
import '../recurring/recurring_screen.dart';
import '../sms/sms_inbox_screen.dart';
import 'categories_screen.dart';
import 'widgets/preferences_section.dart';
import 'widgets/installment_providers_section.dart';
import 'widgets/backup_section.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.screenSettings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Navigation shortcuts
          _buildSection(l10n.sectionScreens, [
            _buildNavTile(
              context,
              Icons.account_balance_wallet,
              l10n.labelWallets,
              l10n.labelWalletsDesc,
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const WalletsScreen())),
            ),
            _buildNavTile(
              context,
              Icons.bar_chart,
              l10n.labelReports,
              l10n.labelReportsDesc,
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ReportsScreen())),
            ),
            _buildNavTile(
              context,
              Icons.savings,
              l10n.labelGoals,
              l10n.labelGoalsDesc,
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const GoalsScreen())),
            ),
            _buildNavTile(
              context,
              Icons.repeat,
              l10n.labelRecurring,
              l10n.labelRecurringDesc,
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RecurringScreen())),
            ),
            _buildNavTile(
              context,
              Icons.sms,
              l10n.labelSms,
              l10n.labelSmsDesc,
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SmsInboxScreen())),
            ),
            _buildNavTile(
              context,
              Icons.category_rounded,
              l10n.labelCategories,
              l10n.labelCategoriesDesc,
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CategoriesScreen())),
            ),
          ]),

          const SizedBox(height: 16),

          // Preferences
          const PreferencesSection(),

          const SizedBox(height: 16),

          // Installment providers
          const InstallmentProvidersSection(),

          const SizedBox(height: 16),

          // Backup
          const BackupSection(),

          const SizedBox(height: 16),

          // About
          _buildSection(l10n.sectionAbout, [
            _buildInfoTile(Icons.info_outline, l10n.labelVersion, '1.0.0'),
            _buildInfoTile(Icons.code, l10n.labelDevelopment, 'Flutter + Isar'),
          ]),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12, right: 4),
          child: Builder(
            builder: (context) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return Text(
                title,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                  letterSpacing: 0.3,
                ),
              );
            },
          ),
        ),
        Builder(
          builder: (context) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceLight : AppColors.lightSurfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : AppColors.lightBorderVariant,
                  width: 1,
                ),
                boxShadow: isDark
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: AppColors.lightShadow,
                          blurRadius: 8,
                          offset: const Offset(0, 1),
                        ),
                      ],
              ),
              child: Column(children: children),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNavTile(BuildContext context, IconData icon, String title,
      String subtitle, VoidCallback onTap) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final titleColor = isDark ? Colors.white : AppColors.lightTextPrimary;
        final subtitleColor =
            isDark ? AppColors.textMuted : AppColors.lightTextMuted;
        final primaryColor = isDark ? AppColors.primary : AppColors.lightPrimary;
        final iconBgColor = isDark
            ? primaryColor.withValues(alpha: 0.15)
            : AppColors.lightPrimaryMuted;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? primaryColor.withValues(alpha: 0.2)
                    : primaryColor.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Icon(icon, color: primaryColor, size: 22),
          ),
          title: Text(title,
              style: TextStyle(
                fontFamily: 'Cairo',
                color: titleColor,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              )),
          subtitle: Text(subtitle,
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  color: subtitleColor,
                  fontWeight: FontWeight.w400)),
          trailing:
              Icon(Icons.chevron_left, color: subtitleColor, size: 20),
          onTap: onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final titleColor = isDark ? Colors.white : AppColors.lightTextPrimary;
        final valueColor = isDark
            ? AppColors.textSecondary
            : AppColors.lightTextSecondary;
        final primaryColor = isDark ? AppColors.primary : AppColors.lightPrimary;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: Icon(icon, color: primaryColor, size: 22),
          title: Text(title,
              style: TextStyle(
                fontFamily: 'Cairo',
                color: titleColor,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              )),
          trailing: Text(value,
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: valueColor,
                  fontWeight: FontWeight.w400)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }
}
