import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/models/smart_feature_models.dart';
import '../../providers/tag_provider.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/loading_shimmer.dart';
import 'widgets/tag_analytics_card.dart';

/// Tag analytics screen - view and manage transaction tags
class TagsScreen extends ConsumerStatefulWidget {
  const TagsScreen({super.key});

  @override
  ConsumerState<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends ConsumerState<TagsScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final analyticsAsync = ref.watch(allTagAnalyticsProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.background : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('التاجات'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: analyticsAsync.when(
        loading: () => const _LoadingState(),
        error: (error, stack) => Center(
          child: Text('خطأ: $error'),
        ),
        data: (analytics) {
          if (analytics.isEmpty) {
            return const _EmptyState();
          }
          return _TagsList(
            analytics: analytics,
            onRename: _showRenameDialog,
            onDelete: _showDeleteDialog,
          );
        },
      ),
    );
  }

  void _showRenameDialog(TagAnalytics tag) {
    final controller = TextEditingController(text: tag.tagName);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.surface : AppColors.lightSurface,
        title: Text(
          'تعديل اسم التاج',
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'الاسم الجديد',
            hintStyle: TextStyle(
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(
                color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isNotEmpty && newName != tag.tagName) {
                final service = ref.read(tagServiceProvider);
                await service.renameTag(tag.tagName, newName);
                refreshTags(ref);
              }
              if (mounted) Navigator.pop(context);
            },
            child: Text(
              'حفظ',
              style: TextStyle(
                color: isDark ? AppColors.primary : AppColors.lightPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(TagAnalytics tag) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.surface : AppColors.lightSurface,
        title: Text(
          'حذف التاج',
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ),
        content: Text(
          'هل تريد حذف "${tag.tagName}"؟\nسيتم إزالته من ${tag.transactionCount} معاملة.',
          style: TextStyle(
            color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(
                color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final service = ref.read(tagServiceProvider);
              await service.deleteTag(tag.tagName);
              refreshTags(ref);
              if (mounted) Navigator.pop(context);
            },
            child: Text(
              'حذف',
              style: TextStyle(
                color: isDark ? AppColors.danger : AppColors.lightDanger,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TagsList extends StatelessWidget {
  final List<TagAnalytics> analytics;
  final void Function(TagAnalytics) onRename;
  final void Function(TagAnalytics) onDelete;

  const _TagsList({
    required this.analytics,
    required this.onRename,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Calculate totals
    final totalAmount = analytics.fold<double>(0, (sum, a) => sum + a.totalAmount);
    final totalTransactions =
        analytics.fold<int>(0, (sum, a) => sum + a.transactionCount);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Summary header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: isDark
                    ? AppColors.primaryGradient
                    : AppColors.lightPrimaryGradient,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _SummaryItem(
                      label: 'عدد التاجات',
                      value: '${analytics.length}',
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  Expanded(
                    child: _SummaryItem(
                      label: 'إجمالي المعاملات',
                      value: '$totalTransactions',
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  Expanded(
                    child: _SummaryItem(
                      label: 'إجمالي المصروفات',
                      value: CurrencyFormatter.formatCompact(totalAmount),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Section header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              'كل التاجات',
              style: TextStyle(
                color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.md),
        ),

        // Tags list
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final tag = analytics[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: TagAnalyticsCard(
                    analytics: tag,
                    onRename: () => onRename(tag),
                    onDelete: () => onDelete(tag),
                  ),
                );
              },
              childCount: analytics.length,
            ),
          ),
        ),

        // Bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: List.generate(
          4,
          (index) => const Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.md),
            child: LoadingShimmer(height: 120),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: EmptyState(
        icon: Icons.tag_rounded,
        message: 'لا توجد تاجات',
        subtitle: 'أضف تاجات للمعاملات لتتبع المصروفات\nمثل: رمضان، سفر، فرح',
      ),
    );
  }
}
