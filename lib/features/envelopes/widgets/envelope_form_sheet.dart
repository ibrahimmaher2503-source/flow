import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/envelope_model.dart';
import '../../../data/models/category_model.dart';
import '../../../providers/category_provider.dart';
import '../../../providers/envelope_provider.dart';
import '../../../shared/widgets/app_button.dart';

/// Bottom sheet for creating/editing envelopes
class EnvelopeFormSheet extends ConsumerStatefulWidget {
  final Envelope? envelope; // null = create, non-null = edit

  const EnvelopeFormSheet({
    super.key,
    this.envelope,
  });

  @override
  ConsumerState<EnvelopeFormSheet> createState() => _EnvelopeFormSheetState();
}

class _EnvelopeFormSheetState extends ConsumerState<EnvelopeFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  Category? _selectedCategory;
  bool _isEssential = false;
  bool _rolloverEnabled = false;
  bool _isLoading = false;

  bool get _isEditing => widget.envelope != null;

  @override
  void initState() {
    super.initState();
    if (widget.envelope != null) {
      _nameController.text = widget.envelope!.name;
      _amountController.text = widget.envelope!.allocatedAmount.toString();
      _isEssential = widget.envelope!.isEssential;
      _rolloverEnabled = widget.envelope!.rolloverEnabled;
      // Load category after frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadCategory();
      });
    }
  }

  Future<void> _loadCategory() async {
    if (widget.envelope == null) return;
    final catRepo = ref.read(categoryRepoProvider);
    final cat = await catRepo.getByName(widget.envelope!.categoryName);
    if (mounted && cat != null) {
      setState(() => _selectedCategory = cat);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اختر فئة')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final service = ref.read(envelopeServiceProvider);
      final amount = double.parse(_amountController.text);

      if (_isEditing) {
        final envelope = widget.envelope!
          ..name = _nameController.text
          ..allocatedAmount = amount
          ..isEssential = _isEssential
          ..rolloverEnabled = _rolloverEnabled;
        await service.updateEnvelope(envelope);
      } else {
        await service.createEnvelope(
          name: _nameController.text,
          categoryName: _selectedCategory!.name,
          allocatedAmount: amount,
          iconName: _selectedCategory!.icon,
          colorHex: _selectedCategory!.color,
          isEssential: _isEssential,
          rolloverEnabled: _rolloverEnabled,
        );
      }

      refreshEnvelopes(ref);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categoriesAsync = ref.watch(expenseCategoriesProvider);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.surfaceLight
                        : AppColors.lightSurfaceContainerHighest,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Title
              Text(
                _isEditing ? 'تعديل الظرف' : 'ظرف جديد',
                style: TextStyle(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Name field
              TextFormField(
                controller: _nameController,
                style: TextStyle(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
                decoration: InputDecoration(
                  labelText: 'اسم الظرف',
                  hintText: 'مثل: أكل البيت',
                  prefixIcon: const Icon(Icons.label_outline_rounded),
                  filled: true,
                  fillColor: isDark
                      ? AppColors.surfaceLight.withValues(alpha: 0.5)
                      : AppColors.lightSurfaceContainerLow,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'أدخل اسم الظرف';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Category selector
              if (!_isEditing) ...[
                Text(
                  'الفئة',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                categoriesAsync.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text('خطأ: $e'),
                  data: (categories) => Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: categories.map((cat) {
                      final isSelected = _selectedCategory?.name == cat.name;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = cat),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark
                                    ? AppColors.primary
                                    : AppColors.lightPrimary)
                                : (isDark
                                    ? AppColors.surfaceLight
                                    : AppColors.lightSurfaceContainerHigh),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusMd),
                          ),
                          child: Text(
                            cat.name,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : (isDark
                                      ? AppColors.textSecondary
                                      : AppColors.lightTextSecondary),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // Amount field
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
                decoration: InputDecoration(
                  labelText: 'المبلغ المخصص',
                  hintText: '1000',
                  prefixIcon: const Icon(Icons.attach_money_rounded),
                  suffixText: 'جنيه',
                  filled: true,
                  fillColor: isDark
                      ? AppColors.surfaceLight.withValues(alpha: 0.5)
                      : AppColors.lightSurfaceContainerLow,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'أدخل المبلغ';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'أدخل مبلغ صحيح';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Essential toggle
              SwitchListTile(
                value: _isEssential,
                onChanged: (v) => setState(() => _isEssential = v),
                title: Text(
                  'ظرف أساسي',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'الأظرف الأساسية لها أولوية في التنبيهات',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                    fontSize: 12,
                  ),
                ),
                activeTrackColor: isDark ? AppColors.primary : AppColors.lightPrimary,
                contentPadding: EdgeInsets.zero,
              ),

              // Rollover toggle
              SwitchListTile(
                value: _rolloverEnabled,
                onChanged: (v) => setState(() => _rolloverEnabled = v),
                title: Text(
                  'ترحيل المتبقي',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'المبلغ المتبقي يُضاف للشهر التالي',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                    fontSize: 12,
                  ),
                ),
                activeTrackColor: isDark ? AppColors.primary : AppColors.lightPrimary,
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Save button
              AppButton(
                label: _isEditing ? 'حفظ التعديل' : 'إنشاء الظرف',
                onPressed: _isLoading ? null : _save,
                isLoading: _isLoading,
              ),

              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

/// Show the envelope form as a bottom sheet
Future<bool?> showEnvelopeFormSheet(
  BuildContext context, {
  Envelope? envelope,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => EnvelopeFormSheet(envelope: envelope),
  );
}
