import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/extensions.dart';
import '../../core/utils/icon_resolver.dart';
import '../../data/models/category_model.dart';
import '../../providers/category_provider.dart';
import '../../shared/widgets/empty_state.dart';

// Available icons for the picker
const _availableIcons = [
  'restaurant', 'shopping_cart', 'directions_car', 'receipt', 'house',
  'medical_services', 'school', 'subscriptions', 'checkroom',
  'card_giftcard', 'sports_esports', 'nightlife', 'favorite', 'groups',
  'credit_card', 'work', 'payments', 'savings', 'more_horiz',
  'smoking_rooms', 'phone_android', 'diamond', 'redeem', 'add_circle',
];

const _availableColors = [
  '#EF4444', '#EC4899', '#A855F7', '#6C63FF', '#3B82F6',
  '#14B8A6', '#10B981', '#F59E0B', '#F97316', '#78716C',
];

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? _expandedCategoryId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String get _currentType =>
      _tabController.index == 0 ? TransactionType.expense : TransactionType.income;

  @override
  Widget build(BuildContext context) {
    final expenseAsync = ref.watch(expenseCategoriesProvider);
    final incomeAsync = ref.watch(incomeCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الفئات'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelStyle: const TextStyle(
              fontFamily: 'Cairo', fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo'),
          onTap: (_) => setState(() => _expandedCategoryId = null),
          tabs: const [
            Tab(text: 'مصروف'),
            Tab(text: 'دخل'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCategoryList(expenseAsync),
          _buildCategoryList(incomeAsync),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCategoryDialog(),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded),
        label: const Text('إضافة فئة',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildCategoryList(AsyncValue<List<Category>> categoriesAsync) {
    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) {
          return const EmptyState(
            icon: Icons.category,
            message: 'مفيش فئات',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            final isExpanded = _expandedCategoryId == cat.id;
            return _CategoryTile(
              category: cat,
              isExpanded: isExpanded,
              onTap: () => setState(() {
                _expandedCategoryId = isExpanded ? null : cat.id;
              }),
              onDelete: () => _deleteCategory(cat),
              onAddSubcategory: (name) => _addSubcategory(cat.id, name),
              onRemoveSubcategory: (name) =>
                  _removeSubcategory(cat.id, name),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
    );
  }

  Future<void> _deleteCategory(Category cat) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('حذف "${cat.name}"؟'),
        content: const Text(
            'المعاملات المسجلة على الفئة دي مش هتتأثر بس مش هتقدر تستخدمها تاني.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('لا', style: TextStyle(fontFamily: 'Cairo')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('نعم، احذف',
                style: TextStyle(
                    fontFamily: 'Cairo', color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(categoryRepoProvider).delete(cat.id);
      refreshCategories(ref);
    }
  }

  Future<void> _addSubcategory(int categoryId, String name) async {
    if (name.trim().isEmpty) return;
    await ref.read(categoryRepoProvider).addSubcategory(categoryId, name.trim());
    refreshCategories(ref);
  }

  Future<void> _removeSubcategory(int categoryId, String name) async {
    await ref.read(categoryRepoProvider).removeSubcategory(categoryId, name);
    refreshCategories(ref);
  }

  void _showAddCategoryDialog() {
    final nameController = TextEditingController();
    String selectedIcon = 'category';
    String selectedColor = _availableColors[0];

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('إضافة فئة جديدة'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                TextField(
                  controller: nameController,
                  style: const TextStyle(
                      fontFamily: 'Cairo', color: Colors.white),
                  decoration: const InputDecoration(hintText: 'اسم الفئة'),
                ),

                const SizedBox(height: 16),

                // Icon picker
                const Text('الأيقونة',
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 160,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: _availableIcons.length,
                    itemBuilder: (ctx, i) {
                      final iconName = _availableIcons[i];
                      final isSelected = selectedIcon == iconName;
                      return GestureDetector(
                        onTap: () =>
                            setDialogState(() => selectedIcon = iconName),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? selectedColor.toColor.withValues(alpha: 0.3)
                                : AppColors.background,
                            borderRadius: BorderRadius.circular(10),
                            border: isSelected
                                ? Border.all(
                                    color: selectedColor.toColor, width: 2)
                                : null,
                          ),
                          child: Icon(
                            IconResolver.resolve(iconName),
                            color: isSelected
                                ? selectedColor.toColor
                                : AppColors.textMuted,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Color picker
                const Text('اللون',
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableColors.map((hex) {
                    final color = hex.toColor;
                    final isSelected = selectedColor == hex;
                    return GestureDetector(
                      onTap: () =>
                          setDialogState(() => selectedColor = hex),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.white, width: 2.5)
                              : null,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.5),
                                    blurRadius: 8,
                                  )
                                ]
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء',
                  style: TextStyle(
                      fontFamily: 'Cairo', color: AppColors.textMuted)),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) return;
                final repo = ref.read(categoryRepoProvider);
                final existing = await repo.getAll();
                await repo.add(Category()
                  ..name = nameController.text.trim()
                  ..type = _currentType
                  ..icon = selectedIcon
                  ..color = selectedColor
                  ..isCustom = true
                  ..sortOrder = existing.length);
                refreshCategories(ref);
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('إضافة',
                  style: TextStyle(
                      fontFamily: 'Cairo', color: AppColors.primary)),
            ),
          ],
        ),
      ),
    ).then((_) => nameController.dispose());
  }
}

/// Single category tile with expandable subcategory section
class _CategoryTile extends StatelessWidget {
  final Category category;
  final bool isExpanded;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final ValueChanged<String> onAddSubcategory;
  final ValueChanged<String> onRemoveSubcategory;

  const _CategoryTile({
    required this.category,
    required this.isExpanded,
    required this.onTap,
    required this.onDelete,
    required this.onAddSubcategory,
    required this.onRemoveSubcategory,
  });

  @override
  Widget build(BuildContext context) {
    final color = category.color.toColor;
    final subController = TextEditingController();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            isExpanded
                ? color.withValues(alpha: 0.1)
                : AppColors.surface.withValues(alpha: 0.8),
            AppColors.surface.withValues(alpha: 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: isExpanded
            ? Border.all(color: color.withValues(alpha: 0.3))
            : Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: Column(
        children: [
          // Main row
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withValues(alpha: 0.25),
                          color.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(IconResolver.resolve(category.icon),
                        color: color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              category.name,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            if (category.isCustom) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'مخصص',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (category.subcategories.isNotEmpty)
                          Text(
                            '${category.subcategories.length} فئة فرعية',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: AppColors.textMuted.withValues(alpha: 0.8),
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded,
                        color: AppColors.textMuted, size: 20),
                    onPressed: onDelete,
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // Expanded subcategory section
          if (isExpanded) ...[
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.white.withValues(alpha: 0.06),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الفئات الفرعية',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Existing subcategories
                  if (category.subcategories.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: category.subcategories.map((sub) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: color.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                sub,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 13,
                                  color: color,
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () => onRemoveSubcategory(sub),
                                child: Icon(Icons.close_rounded,
                                    size: 14, color: color),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                  if (category.subcategories.isNotEmpty)
                    const SizedBox(height: 10),

                  // Add new subcategory
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: subController,
                          style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                              color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'إضافة فئة فرعية...',
                            hintStyle: TextStyle(
                                fontSize: 13,
                                color:
                                    AppColors.textMuted.withValues(alpha: 0.6)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            isDense: true,
                          ),
                          onSubmitted: (val) {
                            onAddSubcategory(val);
                            subController.clear();
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          onAddSubcategory(subController.text);
                          subController.clear();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.add_rounded,
                              color: color, size: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
