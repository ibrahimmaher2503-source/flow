import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../providers/insights_provider.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../../../shared/widgets/section_header.dart';
import '../../insights/widgets/insight_card.dart';

/// Horizontal carousel of top insights for dashboard
class InsightsCarousel extends ConsumerWidget {
  const InsightsCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final insightsAsync = ref.watch(topInsightsProvider);

    return insightsAsync.when(
      loading: () => _buildLoading(),
      error: (e, st) => const SizedBox.shrink(),
      data: (insights) {
        if (insights.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SectionHeader(
                    title: 'رؤى وتحليلات',
                    variant: SectionHeaderVariant.primary,
                  ),
                  if (insights.length > 3)
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/insights'),
                      child: Text(
                        'عرض الكل',
                        style: TextStyle(
                          color:
                              isDark ? AppColors.primary : AppColors.lightPrimary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Carousel
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                itemCount: insights.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, index) {
                  final insight = insights[index];
                  return SizedBox(
                    width: 280,
                    child: InsightCard(
                      insight: insight,
                      compact: true,
                      onTap: () {
                        if (insight.actionRoute != null) {
                          Navigator.pushNamed(context, insight.actionRoute!);
                        } else {
                          Navigator.pushNamed(context, '/insights');
                        }
                      },
                      onDismiss: () async {
                        await dismissInsight(ref, insight.id);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: LoadingShimmer(height: 20, width: 120),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (_, __) => const SizedBox(
              width: 280,
              child: LoadingShimmer(height: 100),
            ),
          ),
        ),
      ],
    );
  }
}

/// Compact insights banner for dashboard (shows high priority only)
class InsightsBanner extends ConsumerWidget {
  const InsightsBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final urgentInsightsAsync = ref.watch(urgentInsightsProvider);

    return urgentInsightsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, st) => const SizedBox.shrink(),
      data: (insights) {
        if (insights.isEmpty) return const SizedBox.shrink();

        final insight = insights.first;
        final color = _parseColor(insight.colorHex, isDark);

        return GestureDetector(
          onTap: () {
            if (insight.actionRoute != null) {
              Navigator.pushNamed(context, insight.actionRoute!);
            } else {
              Navigator.pushNamed(context, '/insights');
            }
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.15),
                  color.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lightbulb_outline,
                    color: color,
                    size: 18,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        insight.titleAr,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        insight.descriptionAr,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (insights.length > 1)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Text(
                      '+${insights.length - 1}',
                      style: TextStyle(
                        color: color,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(width: AppSpacing.sm),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  size: 14,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _parseColor(String? hex, bool isDark) {
    if (hex == null || hex.isEmpty) {
      return isDark ? AppColors.danger : AppColors.lightDanger;
    }
    try {
      final colorHex = hex.replaceFirst('#', '');
      return Color(int.parse('FF$colorHex', radix: 16));
    } catch (_) {
      return isDark ? AppColors.danger : AppColors.lightDanger;
    }
  }
}
