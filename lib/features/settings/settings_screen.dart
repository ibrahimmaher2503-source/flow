import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Navigation shortcuts
          _buildSection('الشاشات', [
            _buildNavTile(
              context,
              Icons.account_balance_wallet,
              'المحافظ',
              'إدارة المحافظ والأرصدة',
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const WalletsScreen())),
            ),
            _buildNavTile(
              context,
              Icons.bar_chart,
              'التقارير',
              'تحليل المصاريف والأقساط',
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ReportsScreen())),
            ),
            _buildNavTile(
              context,
              Icons.savings,
              'أهداف التوفير',
              'تتبع أهدافك المالية',
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const GoalsScreen())),
            ),
            _buildNavTile(
              context,
              Icons.repeat,
              'المعاملات المتكررة',
              'إيجار، اشتراكات، فواتير',
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RecurringScreen())),
            ),
            _buildNavTile(
              context,
              Icons.sms,
              'رسائل البنوك',
              'كشف وإضافة معاملات من SMS',
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SmsInboxScreen())),
            ),
            _buildNavTile(
              context,
              Icons.category_rounded,
              'إدارة الفئات',
              'إضافة وتعديل الفئات والفئات الفرعية',
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
          _buildSection('عن التطبيق', [
            _buildInfoTile(Icons.info_outline, 'الإصدار', '1.0.0'),
            _buildInfoTile(Icons.code, 'التطوير', 'Flutter + Isar'),
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
          padding: const EdgeInsets.only(bottom: 8, right: 4),
          child: Builder(
            builder: (context) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return Text(
                title,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
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
                color: isDark ? AppColors.surface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(16),
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

        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          title: Text(title,
              style: TextStyle(fontFamily: 'Cairo', color: titleColor)),
          subtitle: Text(subtitle,
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: subtitleColor)),
          trailing:
              Icon(Icons.chevron_left, color: subtitleColor, size: 20),
          onTap: onTap,
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

        return ListTile(
          leading: Icon(icon, color: AppColors.primary, size: 22),
          title: Text(title,
              style: TextStyle(fontFamily: 'Cairo', color: titleColor)),
          trailing: Text(value,
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: valueColor)),
        );
      },
    );
  }
}
