import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/icon_resolver.dart';
import '../../../data/models/category_model.dart';
import '../../../providers/category_provider.dart';

class CategoryGrid extends ConsumerWidget {
  final String type;
  final String? selectedCategory;
  final ValueChanged<Category> onSelected;

  const CategoryGrid({
    super.key,
    required this.type,
    this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = type == 'expense'
        ? ref.watch(expenseCategoriesProvider)
        : ref.watch(incomeCategoriesProvider);

    return categoriesAsync.when(
      data: (categories) => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.85,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = selectedCategory == cat.name;
          final color = cat.color.toColor;

          return GestureDetector(
            onTap: () => onSelected(cat),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: 0.3)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(color: color, width: 2)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      IconResolver.resolve(cat.icon),
                      color: color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cat.name,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('خطأ: $e')),
    );
  }
}
