import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Premium dashboard header with personalized greeting
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  String _getGreeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.greetingMorning;
    return l10n.greetingEvening;
  }

  String _getMotivation(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.motivationMorning;
    if (hour < 17) return l10n.motivationAfternoon;
    return l10n.motivationEvening;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.lightTextPrimary;
    final mutedColor = isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          // Avatar with solid primary border (no gradient)
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: isDark ? AppColors.surface : AppColors.lightSurfaceContainerLow,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? AppColors.primary : AppColors.lightPrimary,
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.lightPrimary.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.person_rounded,
              color: isDark ? AppColors.primary : AppColors.lightPrimary,
              size: 26,
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Greeting text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(l10n),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getMotivation(l10n),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: mutedColor,
                  ),
                ),
              ],
            ),
          ),

          // Notification bell with badge
          _NotificationBell(isDark: isDark),
        ],
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  final bool isDark;

  const _NotificationBell({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.08),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.notifications_outlined,
            color: isDark ? Colors.white70 : AppColors.lightTextSecondary,
            size: 22,
          ),
          // Badge dot
          Positioned(
            top: 10,
            right: 12,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColors.surface : AppColors.lightSurface,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
