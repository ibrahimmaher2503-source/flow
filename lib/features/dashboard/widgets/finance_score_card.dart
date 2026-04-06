import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/gamification_provider.dart';

class FinanceScoreCard extends ConsumerWidget {
  const FinanceScoreCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(financeScoreProvider);
    final badgesAsync = ref.watch(earnedBadgesProvider);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.secondary.withValues(alpha: 0.12),
            AppColors.surface.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Score circle
              scoreAsync.when(
                data: (score) {
                  final color = score >= 70
                      ? AppColors.success
                      : score >= 40
                          ? AppColors.warning
                          : AppColors.danger;
                  return CircularPercentIndicator(
                    radius: 36,
                    lineWidth: 6,
                    percent: (score / 100).clamp(0.0, 1.0),
                    center: Text(
                      '$score',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                    progressColor: color,
                    backgroundColor: AppColors.background,
                    circularStrokeCap: CircularStrokeCap.round,
                  );
                },
                loading: () => const SizedBox(
                  width: 72,
                  height: 72,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (_, __) => const SizedBox(width: 72, height: 72),
              ),

              const SizedBox(width: 16),

              // Label + description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Finance Score',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    scoreAsync.when(
                      data: (score) => Text(
                        score >= 70
                            ? 'ممتاز! استمر كده'
                            : score >= 40
                                ? 'كويس، فيه مجال للتحسين'
                                : 'محتاج تحسين — ابدأ بالميزانية',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color:
                              AppColors.textMuted.withValues(alpha: 0.8),
                        ),
                      ),
                      loading: () => const SizedBox(),
                      error: (_, __) => const SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Earned badges
          badgesAsync.when(
            data: (earned) {
              if (earned.isEmpty) return const SizedBox();
              return Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Row(
                  children: [
                    const Text(
                      'الإنجازات',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        children: earned
                            .map((b) => Tooltip(
                                  message: b.name,
                                  child: Text(b.icon,
                                      style: const TextStyle(fontSize: 20)),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
    );
  }
}
