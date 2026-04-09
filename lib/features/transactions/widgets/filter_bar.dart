import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../providers/tag_provider.dart';
import '../../tags/widgets/tag_chip.dart';

enum TransactionFilter { all, income, expense, installment }

class FilterBar extends ConsumerWidget {
  final TransactionFilter selected;
  final ValueChanged<TransactionFilter> onChanged;
  final String? selectedTag;
  final ValueChanged<String?>? onTagChanged;

  const FilterBar({
    super.key,
    required this.selected,
    required this.onChanged,
    this.selectedTag,
    this.onTagChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tagsAsync = ref.watch(allTagsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Type filters
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: TransactionFilter.values.map((filter) {
              final isSelected = selected == filter;
              return Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: FilterChip(
                  selected: isSelected,
                  label: Text(
                    _label(filter),
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      color: isSelected ? Colors.white : (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
                    ),
                  ),
                  backgroundColor: isDark ? AppColors.surface : AppColors.lightSurface,
                  selectedColor: AppColors.primary,
                  checkmarkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onSelected: (_) => onChanged(filter),
                ),
              );
            }).toList(),
          ),
        ),

        // Tag filter (if tags exist)
        if (onTagChanged != null)
          tagsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (tags) {
              if (tags.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // "All tags" chip
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8),
                        child: TagChip(
                          label: 'كل التاجات',
                          selected: selectedTag == null,
                          onTap: () => onTagChanged!(null),
                        ),
                      ),
                      // Individual tag chips
                      ...tags.take(5).map((tag) {
                        return Padding(
                          padding: const EdgeInsetsDirectional.only(end: 8),
                          child: TagChip(
                            label: tag.name,
                            colorHex: tag.colorHex,
                            selected: selectedTag == tag.name,
                            onTap: () => onTagChanged!(
                              selectedTag == tag.name ? null : tag.name,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  String _label(TransactionFilter filter) {
    switch (filter) {
      case TransactionFilter.all:
        return 'الكل';
      case TransactionFilter.income:
        return 'دخل';
      case TransactionFilter.expense:
        return 'مصروف';
      case TransactionFilter.installment:
        return 'أقساط';
    }
  }
}
