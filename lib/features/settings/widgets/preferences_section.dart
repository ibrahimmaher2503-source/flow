import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/theme_provider.dart' show themeProvider, AppThemeMode;

class PreferencesSection extends ConsumerWidget {
  const PreferencesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(
          builder: (context) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8, right: 4),
              child: Text(
                'عام',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                ),
              ),
            );
          },
        ),
        Builder(
          builder: (context) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.surface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: settingsAsync.when(
                data: (settings) => Column(
                  children: [
                    _infoTile(Icons.attach_money, 'العملة',
                        '${settings.currency} - جنيه مصري'),
                    _infoTile(Icons.language, 'اللغة',
                        settings.language == 'ar' ? 'العربية' : 'English'),
                    _infoTile(Icons.calendar_today, 'بداية الشهر',
                        'يوم ${settings.monthStartDay}'),
                    _infoTile(Icons.local_fire_department, 'الـ Streak',
                        '${settings.streakDays} يوم'),
                    SwitchListTile(
                      title: const Text('قراءة SMS',
                          style: TextStyle(
                              fontFamily: 'Cairo', color: Colors.white)),
                      subtitle: const Text('اكتشاف رسائل البنوك تلقائياً',
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: AppColors.textMuted)),
                      value: settings.smsParsingEnabled,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) async {
                        settings.smsParsingEnabled = val;
                        await ref.read(settingsRepoProvider).update(settings);
                        refreshSettings(ref);
                      },
                    ),
                    SwitchListTile(
                      title: const Text('الإشعارات',
                          style: TextStyle(
                              fontFamily: 'Cairo', color: Colors.white)),
                      subtitle: const Text('تنبيهات الميزانية والأقساط',
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: AppColors.textMuted)),
                      value: settings.notificationsEnabled,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) async {
                        settings.notificationsEnabled = val;
                        await ref.read(settingsRepoProvider).update(settings);
                        refreshSettings(ref);
                      },
                    ),
                    const Divider(color: Colors.white12, height: 1),
                    _buildThemeSelector(context, ref),
                  ],
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('$e'),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(title,
          style: const TextStyle(fontFamily: 'Cairo', color: Colors.white)),
      trailing: Text(value,
          style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              color: AppColors.textSecondary)),
    );
  }

  Widget _buildThemeSelector(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'المظهر',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: [
              _themeButton(
                ref,
                'فاتح',
                AppThemeMode.light,
                currentTheme,
                Icons.light_mode,
              ),
              _themeButton(
                ref,
                'داكن',
                AppThemeMode.dark,
                currentTheme,
                Icons.dark_mode,
              ),
              _themeButton(
                ref,
                'افتراضي',
                AppThemeMode.system,
                currentTheme,
                Icons.brightness_auto,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _themeButton(
    WidgetRef ref,
    String label,
    AppThemeMode mode,
    AppThemeMode currentMode,
    IconData icon,
  ) {
    final isSelected = currentMode == mode;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 16,
              color: isSelected ? Colors.white : AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          final modeString = _themeModeToString(mode);
          ref.read(themeProvider.notifier).setThemeMode(modeString);
        }
      },
      backgroundColor: Colors.transparent,
      selectedColor: AppColors.primary.withValues(alpha: 0.3),
      labelStyle: TextStyle(
        fontFamily: 'Cairo',
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.textMuted.withValues(alpha: 0.3),
        width: isSelected ? 1.5 : 1,
      ),
    );
  }

  String _themeModeToString(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'light';
      case AppThemeMode.dark:
        return 'dark';
      case AppThemeMode.system:
        return 'system';
    }
  }
}
