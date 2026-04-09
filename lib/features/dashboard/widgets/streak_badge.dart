import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../providers/settings_provider.dart';
import '../../../l10n/generated/app_localizations.dart';

class StreakBadge extends ConsumerWidget {
  const StreakBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return settingsAsync.when(
      data: (settings) {
        if (settings.streakDays == 0) return const SizedBox();

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      AppColors.accent.withValues(alpha: 0.18),
                      AppColors.accent.withValues(alpha: 0.05),
                    ]
                  : [
                      AppColors.accent.withValues(alpha: 0.12),
                      AppColors.accent.withValues(alpha: 0.03),
                    ],
              begin: AlignmentDirectional.centerEnd,
              end: AlignmentDirectional.centerStart,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: AppColors.accent.withValues(alpha: isDark ? 0.25 : 0.2),
            ),
          ),
          child: Row(
            children: [
              // Animated fire icon container
              _AnimatedFireIcon(),
              const SizedBox(width: AppSpacing.md),

              // Streak text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${settings.streakDays}',
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.streakDaysConsecutive,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _getStreakMessage(settings.streakDays, l10n),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),

              // Streak milestone indicator
              if (settings.streakDays >= 7)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        _getMilestoneLabel(settings.streakDays, l10n),
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
    );
  }

  String _getStreakMessage(int days, AppLocalizations l10n) {
    if (days >= 30) return l10n.streakMessage30;
    if (days >= 14) return l10n.streakMessage14;
    if (days >= 7) return l10n.streakMessage7;
    if (days >= 3) return l10n.streakMessage3;
    return l10n.streakMessageDefault;
  }

  String _getMilestoneLabel(int days, AppLocalizations l10n) {
    if (days >= 30) return l10n.streakMilestoneMonth;
    if (days >= 14) return l10n.streakMilestone2Weeks;
    return l10n.streakMilestoneWeek;
  }
}

class _AnimatedFireIcon extends StatefulWidget {
  @override
  State<_AnimatedFireIcon> createState() => _AnimatedFireIconState();
}

class _AnimatedFireIconState extends State<_AnimatedFireIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  AppColors.accent.withValues(alpha: 0.3),
                  AppColors.accent.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.3),
                  blurRadius: 12,
                  spreadRadius: -2,
                ),
              ],
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: AppColors.accent,
              size: 24,
            ),
          ),
        );
      },
    );
  }
}
