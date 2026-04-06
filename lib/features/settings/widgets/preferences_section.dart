import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/settings_provider.dart';

class PreferencesSection extends ConsumerWidget {
  const PreferencesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8, right: 4),
          child: Text(
            'عام',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
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
                  activeColor: AppColors.primary,
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
                  activeColor: AppColors.primary,
                  onChanged: (val) async {
                    settings.notificationsEnabled = val;
                    await ref.read(settingsRepoProvider).update(settings);
                    refreshSettings(ref);
                  },
                ),
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
}
