import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ReportSectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  const ReportSectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 20,
                color: isDark ? AppColors.primary : AppColors.lightPrimary,
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color:
                      isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ),
            if (trailing != null) trailing!,
            if (onTap != null)
              Icon(
                Icons.chevron_left,
                size: 20,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
          ],
        ),
      ),
    );
  }
}
