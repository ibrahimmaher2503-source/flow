import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('عام', [
            _buildTile(Icons.language, 'اللغة', 'العربية'),
            _buildTile(Icons.attach_money, 'العملة', 'EGP - جنيه مصري'),
            _buildTile(Icons.calendar_today, 'بداية الشهر', 'يوم 1'),
          ]),
          const SizedBox(height: 16),
          _buildSection('البيانات', [
            _buildTile(Icons.upload, 'تصدير البيانات', 'JSON'),
            _buildTile(Icons.download, 'استيراد البيانات', ''),
            _buildTile(Icons.delete_forever, 'مسح كل البيانات', '',
                color: AppColors.danger),
          ]),
          const SizedBox(height: 16),
          _buildSection('عن التطبيق', [
            _buildTile(Icons.info_outline, 'الإصدار', '1.0.0'),
          ]),
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
          child: Text(
            title,
            style: const TextStyle(
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
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildTile(IconData icon, String title, String subtitle,
      {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.primary),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Cairo',
          color: color ?? Colors.white,
        ),
      ),
      trailing: subtitle.isNotEmpty
          ? Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.textSecondary,
              ),
            )
          : null,
    );
  }
}
