import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/services/sms_listener_service.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/theme_provider.dart' show themeProvider, AppThemeMode;
import '../../sms/widgets/sms_permission_dialog.dart';

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
                    _infoTile(context, Icons.attach_money, 'العملة',
                        '${settings.currency} - جنيه مصري'),
                    _infoTile(context, Icons.language, 'اللغة',
                        settings.language == 'ar' ? 'العربية' : 'English'),
                    _infoTile(context, Icons.calendar_today, 'بداية الشهر',
                        'يوم ${settings.monthStartDay}'),
                    _infoTile(context, Icons.local_fire_department, 'الـ Streak',
                        '${settings.streakDays} يوم'),
                    _buildSmsToggle(context, ref, settings, isDark),
                    SwitchListTile(
                      title: Text('الإشعارات',
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              color: isDark
                                  ? Colors.white
                                  : AppColors.lightTextPrimary)),
                      subtitle: Text('تنبيهات الميزانية والأقساط',
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted)),
                      value: settings.notificationsEnabled,
                      activeThumbColor:
                          isDark ? AppColors.primary : AppColors.lightPrimary,
                      onChanged: (val) async {
                        settings.notificationsEnabled = val;
                        await ref.read(settingsRepoProvider).update(settings);
                        refreshSettings(ref);
                      },
                    ),
                    Divider(
                        color: isDark ? Colors.white12 : Colors.black12,
                        height: 1),
                    _buildThemeSelector(context, ref, isDark),
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

  Widget _buildSmsToggle(
      BuildContext context, WidgetRef ref, dynamic settings, bool isDark) {
    return FutureBuilder<PermissionStatus>(
      future: Permission.sms.status,
      builder: (context, snapshot) {
        final permissionStatus = snapshot.data;
        final isPermissionGranted = permissionStatus?.isGranted ?? false;
        final isPermanentlyDenied =
            permissionStatus?.isPermanentlyDenied ?? false;

        String subtitle = 'اكتشاف رسائل البنوك تلقائياً';
        if (!isPermissionGranted && settings.smsParsingEnabled) {
          subtitle = isPermanentlyDenied
              ? 'يرجى تفعيل الصلاحية من الإعدادات'
              : 'يحتاج صلاحية قراءة الرسائل';
        }

        return SwitchListTile(
          title: Text('قراءة SMS',
              style: TextStyle(
                  fontFamily: 'Cairo',
                  color: isDark ? Colors.white : AppColors.lightTextPrimary)),
          subtitle: Row(
            children: [
              Expanded(
                child: Text(subtitle,
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted)),
              ),
              if (isPermanentlyDenied && settings.smsParsingEnabled)
                TextButton(
                  onPressed: () => openAppSettings(),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'فتح الإعدادات',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      color: isDark ? AppColors.primary : AppColors.lightPrimary,
                    ),
                  ),
                ),
            ],
          ),
          value: settings.smsParsingEnabled,
          activeThumbColor:
              isDark ? AppColors.primary : AppColors.lightPrimary,
          onChanged: (val) async {
            if (val) {
              // Turning ON - need to request permission
              final dialogResult = await SmsPermissionDialog.show(context);
              if (dialogResult == true) {
                final granted = await SmsListenerService.requestPermission();
                if (granted) {
                  settings.smsParsingEnabled = true;
                  await ref.read(settingsRepoProvider).update(settings);
                  await SmsListenerService.startListening();
                  refreshSettings(ref);
                } else {
                  // Permission denied
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('لم يتم منح صلاحية قراءة الرسائل'),
                      ),
                    );
                  }
                }
              }
            } else {
              // Turning OFF
              settings.smsParsingEnabled = false;
              await ref.read(settingsRepoProvider).update(settings);
              SmsListenerService.stopListening();
              refreshSettings(ref);
            }
          },
        );
      },
    );
  }

  Widget _infoTile(
      BuildContext context, IconData icon, String title, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Icon(icon,
          color: isDark ? AppColors.primary : AppColors.lightPrimary, size: 22),
      title: Text(title,
          style: TextStyle(
              fontFamily: 'Cairo',
              color: isDark ? Colors.white : AppColors.lightTextPrimary)),
      trailing: Text(value,
          style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary)),
    );
  }

  Widget _buildThemeSelector(BuildContext context, WidgetRef ref, bool isDark) {
    final currentTheme = ref.watch(themeProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'المظهر',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.lightTextPrimary,
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
                isDark,
              ),
              _themeButton(
                ref,
                'داكن',
                AppThemeMode.dark,
                currentTheme,
                Icons.dark_mode,
                isDark,
              ),
              _themeButton(
                ref,
                'افتراضي',
                AppThemeMode.system,
                currentTheme,
                Icons.brightness_auto,
                isDark,
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
    bool isDark,
  ) {
    final isSelected = currentMode == mode;
    final primaryColor = isDark ? AppColors.primary : AppColors.lightPrimary;
    final mutedColor = isDark ? AppColors.textMuted : AppColors.lightTextMuted;
    final secondaryColor =
        isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 16, color: isSelected ? Colors.white : secondaryColor),
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
      selectedColor: primaryColor.withValues(alpha: 0.3),
      labelStyle: TextStyle(
        fontFamily: 'Cairo',
        color: isSelected ? primaryColor : secondaryColor,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? primaryColor : mutedColor.withValues(alpha: 0.3),
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
