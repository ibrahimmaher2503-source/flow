import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/insight_model.dart';
import '../../data/models/smart_feature_models.dart';
import '../../providers/insights_provider.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/loading_shimmer.dart';
import 'widgets/insight_card.dart';
import 'widgets/insight_filter.dart';

/// Smart insights screen - personalized spending pattern insights
class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key});

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  InsightType? _selectedType;
  int? _selectedPriority;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Generate insights on screen open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      triggerInsightGeneration(ref);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Insight> _filterInsights(List<Insight> insights) {
    return insights.where((insight) {
      if (_selectedPriority != null && insight.priority != _selectedPriority) {
        return false;
      }
      if (_selectedType != null && insight.type != _selectedType!.value) {
        return false;
      }
      return true;
    }).toList();
  }

  Map<String, List<Insight>> _groupByPeriod(List<Insight> insights) {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final monthStart = DateTime(now.year, now.month, 1);

    final thisWeek = <Insight>[];
    final thisMonth = <Insight>[];
    final previous = <Insight>[];

    for (final insight in insights) {
      if (insight.generatedAt.isAfter(weekAgo)) {
        thisWeek.add(insight);
      } else if (insight.generatedAt.isAfter(monthStart)) {
        thisMonth.add(insight);
      } else {
        previous.add(insight);
      }
    }

    return {
      'thisWeek': thisWeek,
      'thisMonth': thisMonth,
      'previous': previous,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.background : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surface : AppColors.lightSurface,
        title: Text(
          'الذكاء المالي',
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh_rounded,
              color: isDark ? AppColors.primary : AppColors.lightPrimary,
            ),
            onPressed: () => triggerInsightGeneration(ref),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: isDark ? AppColors.primary : AppColors.lightPrimary,
          unselectedLabelColor:
              isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          indicatorColor: isDark ? AppColors.primary : AppColors.lightPrimary,
          tabs: const [
            Tab(text: 'نشطة'),
            Tab(text: 'مؤرشفة'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filters
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: InsightFilter(
              selectedType: _selectedType,
              selectedPriority: _selectedPriority,
              onTypeChanged: (type) {
                setState(() {
                  _selectedType = type;
                  _selectedPriority = null;
                });
              },
              onPriorityChanged: (priority) {
                setState(() {
                  _selectedPriority = priority;
                  _selectedType = null;
                });
              },
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _ActiveInsightsTab(
                  filterInsights: _filterInsights,
                  groupByPeriod: _groupByPeriod,
                ),
                _DismissedInsightsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveInsightsTab extends ConsumerWidget {
  final List<Insight> Function(List<Insight>) filterInsights;
  final Map<String, List<Insight>> Function(List<Insight>) groupByPeriod;

  const _ActiveInsightsTab({
    required this.filterInsights,
    required this.groupByPeriod,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final insightsAsync = ref.watch(activeInsightsProvider);

    return insightsAsync.when(
      loading: () => _buildLoading(),
      error: (e, st) => _buildError(e.toString()),
      data: (allInsights) {
        final insights = filterInsights(allInsights);

        if (insights.isEmpty) {
          return _buildEmpty(isDark);
        }

        final grouped = groupByPeriod(insights);

        return RefreshIndicator(
          onRefresh: () async {
            await triggerInsightGeneration(ref);
          },
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              // This week
              if (grouped['thisWeek']!.isNotEmpty) ...[
                _SectionHeader(title: 'هذا الأسبوع', isDark: isDark),
                const SizedBox(height: AppSpacing.md),
                ...grouped['thisWeek']!.map((insight) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: InsightCard(
                        insight: insight,
                        onDismiss: () => dismissInsight(ref, insight.id),
                      ),
                    )),
                const SizedBox(height: AppSpacing.lg),
              ],

              // This month
              if (grouped['thisMonth']!.isNotEmpty) ...[
                _SectionHeader(title: 'هذا الشهر', isDark: isDark),
                const SizedBox(height: AppSpacing.md),
                ...grouped['thisMonth']!.map((insight) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: InsightCard(
                        insight: insight,
                        onDismiss: () => dismissInsight(ref, insight.id),
                      ),
                    )),
                const SizedBox(height: AppSpacing.lg),
              ],

              // Previous
              if (grouped['previous']!.isNotEmpty) ...[
                _SectionHeader(title: 'سابقة', isDark: isDark),
                const SizedBox(height: AppSpacing.md),
                ...grouped['previous']!.map((insight) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: InsightCard(
                        insight: insight,
                        onDismiss: () => dismissInsight(ref, insight.id),
                      ),
                    )),
              ],

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoading() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: List.generate(
          4,
          (i) => const Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.md),
            child: LoadingShimmer(height: 100),
          ),
        ),
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: EmptyState(
        icon: Icons.error_outline_rounded,
        message: 'حدث خطأ',
        subtitle: error,
        variant: EmptyStateVariant.warning,
      ),
    );
  }

  Widget _buildEmpty(bool isDark) {
    return Center(
      child: EmptyState(
        icon: Icons.lightbulb_outline_rounded,
        message: 'لا توجد رؤى جديدة',
        subtitle: 'استمر في تسجيل معاملاتك للحصول على تحليلات ذكية',
        variant: EmptyStateVariant.neutral,
      ),
    );
  }
}

class _DismissedInsightsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dismissedAsync = ref.watch(dismissedInsightsProvider);

    return dismissedAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('خطأ: $e')),
      data: (insights) {
        if (insights.isEmpty) {
          return Center(
            child: EmptyState(
              icon: Icons.archive_outlined,
              message: 'لا توجد رؤى مؤرشفة',
              subtitle: 'الرؤى التي تؤرشفها ستظهر هنا',
              variant: EmptyStateVariant.neutral,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: insights.length,
          itemBuilder: (context, index) {
            final insight = insights[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Opacity(
                opacity: 0.7,
                child: InsightCard(
                  insight: insight,
                  showDismissHint: false,
                  onTap: () async {
                    // Show option to restore
                    final restore = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor:
                            isDark ? AppColors.surface : AppColors.lightSurface,
                        title: Text(
                          'استعادة الرؤية',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        content: Text(
                          'هل تريد استعادة هذه الرؤية؟',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('إلغاء'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('استعادة'),
                          ),
                        ],
                      ),
                    );

                    if (restore == true) {
                      await undismissInsight(ref, insight.id);
                    }
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isDark;

  const _SectionHeader({
    required this.title,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: isDark ? AppColors.primary : AppColors.lightPrimary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
