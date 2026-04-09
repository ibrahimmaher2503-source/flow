import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/icon_resolver.dart';
import '../../data/models/smart_feature_models.dart';
import '../../providers/envelope_provider.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/loading_shimmer.dart';

/// Screen for allocating income across envelopes
class EnvelopeAllocateScreen extends ConsumerStatefulWidget {
  const EnvelopeAllocateScreen({super.key});

  @override
  ConsumerState<EnvelopeAllocateScreen> createState() =>
      _EnvelopeAllocateScreenState();
}

class _EnvelopeAllocateScreenState
    extends ConsumerState<EnvelopeAllocateScreen> {
  final _amountController = TextEditingController();
  bool _essentialFirst = true;
  bool _isLoading = false;
  Map<int, double> _distribution = {};
  double _totalAmount = 0;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _calculateDistribution() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أدخل مبلغ صحيح')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _totalAmount = amount;
    });

    try {
      final service = ref.read(envelopeServiceProvider);
      final distribution = await service.distributeIncome(
        amount,
        essentialFirst: _essentialFirst,
      );
      setState(() {
        _distribution = distribution;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _clearDistribution() {
    setState(() {
      _distribution = {};
      _totalAmount = 0;
      _amountController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final envelopesAsync = ref.watch(currentMonthEnvelopesProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.background : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surface : AppColors.lightSurface,
        title: Text(
          'توزيع الدخل',
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: envelopesAsync.when(
        loading: () => const Center(child: LoadingShimmer(height: 200)),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (envelopes) => _buildContent(envelopes, isDark),
      ),
    );
  }

  Widget _buildContent(List<EnvelopeWithSpent> envelopes, bool isDark) {
    if (envelopes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mail_outline_rounded,
              size: 64,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'لا توجد أظرف للتوزيع',
              style: TextStyle(
                color:
                    isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/envelopes'),
              child: const Text('إنشاء أظرف'),
            ),
          ],
        ),
      );
    }

    // Calculate how much each envelope needs
    final needingFunds = envelopes.where((e) => e.remaining > 0).toList();
    final totalNeeded =
        needingFunds.fold<double>(0, (sum, e) => sum + e.remaining);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Summary card
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceLight.withValues(alpha: 0.5)
                  : AppColors.lightSurfaceContainerLow,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(
                color: isDark
                    ? AppColors.surfaceLight
                    : AppColors.lightSurfaceContainerHighest,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'إجمالي المطلوب',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      CurrencyFormatter.format(totalNeeded),
                      style: TextStyle(
                        color:
                            isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'أظرف تحتاج تمويل',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${needingFunds.length} ظرف',
                      style: TextStyle(
                        color:
                            isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Amount input
          Text(
            'المبلغ المتاح للتوزيع',
            style: TextStyle(
              color:
                  isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: TextStyle(
              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: '0',
              hintStyle: TextStyle(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
              suffixText: 'جنيه',
              filled: true,
              fillColor: isDark
                  ? AppColors.surfaceLight.withValues(alpha: 0.5)
                  : AppColors.lightSurfaceContainerLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Essential first toggle
          SwitchListTile(
            value: _essentialFirst,
            onChanged: (v) => setState(() => _essentialFirst = v),
            title: Text(
              'الأظرف الأساسية أولاً',
              style: TextStyle(
                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'يتم ملء الأظرف الأساسية بالكامل قبل البقية',
              style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                fontSize: 12,
              ),
            ),
            activeTrackColor: isDark ? AppColors.primary : AppColors.lightPrimary,
            contentPadding: EdgeInsets.zero,
          ),

          const SizedBox(height: AppSpacing.lg),

          // Calculate button
          AppButton(
            label: 'حساب التوزيع',
            onPressed: _isLoading ? null : _calculateDistribution,
            isLoading: _isLoading,
          ),

          // Distribution preview
          if (_distribution.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xxl),
            _buildDistributionPreview(envelopes, isDark),
          ],
        ],
      ),
    );
  }

  Widget _buildDistributionPreview(
    List<EnvelopeWithSpent> envelopes,
    bool isDark,
  ) {
    final distributedTotal =
        _distribution.values.fold<double>(0, (sum, v) => sum + v);
    final remaining = _totalAmount - distributedTotal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'التوزيع المقترح',
              style: TextStyle(
                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: _clearDistribution,
              child: const Text('مسح'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        // Distribution items
        ...envelopes
            .where((e) => _distribution.containsKey(e.envelope.id))
            .map((e) {
          final amount = _distribution[e.envelope.id]!;
          final color = _parseColor(e.envelope.colorHex) ??
              (isDark ? AppColors.primary : AppColors.lightPrimary);

          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceLight.withValues(alpha: 0.3)
                  : AppColors.lightSurfaceContainerLow,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Icon(
                    IconResolver.resolve(e.envelope.iconName),
                    color: color,
                    size: 18,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            e.envelope.name,
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (e.envelope.isEssential) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.star_rounded,
                              size: 12,
                              color: isDark
                                  ? AppColors.warning
                                  : AppColors.lightWarning,
                            ),
                          ],
                        ],
                      ),
                      Text(
                        'يحتاج ${CurrencyFormatter.formatCompact(e.remaining)}',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '+${CurrencyFormatter.format(amount)}',
                      style: TextStyle(
                        color: isDark ? AppColors.success : AppColors.lightSuccess,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      amount >= e.remaining ? 'يكفي' : 'جزئي',
                      style: TextStyle(
                        color: amount >= e.remaining
                            ? (isDark ? AppColors.success : AppColors.lightSuccess)
                            : (isDark ? AppColors.warning : AppColors.lightWarning),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: AppSpacing.lg),

        // Summary
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.primary.withValues(alpha: 0.1)
                : AppColors.lightPrimaryContainer,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'سيتم توزيع',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    CurrencyFormatter.format(distributedTotal),
                    style: TextStyle(
                      color: isDark ? AppColors.primary : AppColors.lightPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              if (remaining > 0) ...[
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'متبقي بدون توزيع',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      CurrencyFormatter.format(remaining),
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        // Note about manual application
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceLight.withValues(alpha: 0.3)
                : AppColors.lightSurfaceContainerHigh,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'هذا توزيع مقترح فقط. عند إضافة معاملات ستتأثر الأظرف تلقائياً حسب الفئة.',
                  style: TextStyle(
                    color:
                        isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color? _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    try {
      final colorHex = hex.replaceFirst('#', '');
      return Color(int.parse('FF$colorHex', radix: 16));
    } catch (_) {
      return null;
    }
  }
}
