import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/installment_calculator.dart';
import '../../data/models/installment_plan_model.dart';
import '../../data/models/installment_provider_model.dart';
import '../../data/models/wallet_model.dart';
import '../../providers/installment_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../shared/widgets/app_button.dart';
import 'widgets/provider_selector.dart';

class AddInstallmentScreen extends ConsumerStatefulWidget {
  const AddInstallmentScreen({super.key});

  @override
  ConsumerState<AddInstallmentScreen> createState() =>
      _AddInstallmentScreenState();
}

class _AddInstallmentScreenState extends ConsumerState<AddInstallmentScreen> {
  final _itemNameController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _totalPriceController = TextEditingController();
  final _interestRateController = TextEditingController();

  InstallmentProvider? _selectedProvider;
  String _selectedCategory = 'أخرى';
  Wallet? _selectedWallet;
  int _totalInstallments = 12;
  DateTime _firstPaymentDate = DateTime.now();
  int _dayOfMonth = 1;
  bool _autoAdd = false;
  bool _useInterestRate = false;

  double get _monthlyAmount {
    final total = double.tryParse(_totalPriceController.text) ?? 0;
    if (_useInterestRate) {
      final original = double.tryParse(_originalPriceController.text) ?? 0;
      final rate = double.tryParse(_interestRateController.text) ?? 0;
      final calcTotal = InstallmentCalculator.totalFromRate(original, rate);
      return InstallmentCalculator.monthlyAmount(calcTotal, _totalInstallments);
    }
    return InstallmentCalculator.monthlyAmount(total, _totalInstallments);
  }

  double get _totalWithInterest {
    if (_useInterestRate) {
      final original = double.tryParse(_originalPriceController.text) ?? 0;
      final rate = double.tryParse(_interestRateController.text) ?? 0;
      return InstallmentCalculator.totalFromRate(original, rate);
    }
    return double.tryParse(_totalPriceController.text) ?? 0;
  }

  double get _totalInterest {
    final original = double.tryParse(_originalPriceController.text) ?? 0;
    return _totalWithInterest - original;
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _originalPriceController.dispose();
    _totalPriceController.dispose();
    _interestRateController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_itemNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ادخل اسم المنتج')),
      );
      return;
    }
    if (_selectedProvider == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اختار مقدم التقسيط')),
      );
      return;
    }

    final original = double.tryParse(_originalPriceController.text) ?? 0;
    if (original <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ادخل السعر الأصلي')),
      );
      return;
    }

    if (_selectedWallet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اختار محفظة')),
      );
      return;
    }

    final plan = InstallmentPlan()
      ..itemName = _itemNameController.text
      ..category = _selectedCategory
      ..providerId = _selectedProvider!.id
      ..originalPrice = original
      ..totalWithInterest = _totalWithInterest
      ..totalInstallments = _totalInstallments
      ..monthlyAmount = _monthlyAmount
      ..firstPaymentDate = _firstPaymentDate
      ..dayOfMonth = _dayOfMonth
      ..walletId = _selectedWallet!.id
      ..autoAdd = _autoAdd
      ..status = PlanStatus.active
      ..createdAt = DateTime.now();

    await ref.read(installmentRepoProvider).addPlan(plan);
    refreshInstallments(ref);

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final walletsAsync = ref.watch(walletsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('خطة تقسيط جديدة'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item name
            TextField(
              controller: _itemNameController,
              style: const TextStyle(fontFamily: 'Cairo', color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'اسم المنتج / الخدمة',
                prefixIcon: Icon(Icons.shopping_bag, color: AppColors.textMuted),
              ),
            ),

            const SizedBox(height: 16),

            // Provider
            const Text('مقدم التقسيط',
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            const SizedBox(height: 8),
            ProviderSelector(
              selectedProviderId: _selectedProvider?.id,
              onSelected: (p) => setState(() => _selectedProvider = p),
            ),

            const SizedBox(height: 16),

            // Original price
            TextField(
              controller: _originalPriceController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontFamily: 'Cairo', color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'السعر الأصلي',
                prefixIcon: Icon(Icons.attach_money, color: AppColors.textMuted),
              ),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 12),

            // Toggle: total price vs interest rate
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _useInterestRate = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: !_useInterestRate
                            ? AppColors.primary
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('الإجمالي بالفوائد',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                              color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _useInterestRate = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _useInterestRate
                            ? AppColors.primary
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('نسبة الفائدة %',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                              color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (!_useInterestRate)
              TextField(
                controller: _totalPriceController,
                keyboardType: TextInputType.number,
                style:
                    const TextStyle(fontFamily: 'Cairo', color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'الإجمالي بالفوائد',
                ),
                onChanged: (_) => setState(() {}),
              )
            else
              TextField(
                controller: _interestRateController,
                keyboardType: TextInputType.number,
                style:
                    const TextStyle(fontFamily: 'Cairo', color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'نسبة الفائدة %',
                  suffixText: '%',
                ),
                onChanged: (_) => setState(() {}),
              ),

            const SizedBox(height: 16),

            // Number of installments
            const Text('عدد الأقساط',
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [3, 6, 9, 12, 18, 24].map((n) {
                final isSelected = _totalInstallments == n;
                return GestureDetector(
                  onTap: () => setState(() => _totalInstallments = n),
                  child: Container(
                    width: 52,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$n',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // First payment date
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _firstPaymentDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  builder: (context, child) => Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.dark(
                        primary: AppColors.primary,
                        surface: AppColors.surface,
                      ),
                    ),
                    child: child!,
                  ),
                );
                if (picked != null) {
                  setState(() {
                    _firstPaymentDate = picked;
                    _dayOfMonth = picked.day;
                  });
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        color: AppColors.primary, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'أول قسط: ${_firstPaymentDate.day}/${_firstPaymentDate.month}/${_firstPaymentDate.year}',
                      style: const TextStyle(
                          fontFamily: 'Cairo', color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Wallet
            const Text('المحفظة',
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            const SizedBox(height: 8),
            walletsAsync.when(
              data: (wallets) {
                if (_selectedWallet == null && wallets.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && _selectedWallet == null) {
                      setState(() => _selectedWallet = wallets.first);
                    }
                  });
                }
                return Wrap(
                  spacing: 8,
                  children: wallets.map((w) {
                    final isSelected = _selectedWallet?.id == w.id;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedWallet = w),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(w.name,
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary)),
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('$e'),
            ),

            const SizedBox(height: 16),

            // Auto-add toggle
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('تسجيل تلقائي',
                      style: TextStyle(
                          fontFamily: 'Cairo', color: Colors.white)),
                  Switch(
                    value: _autoAdd,
                    onChanged: (v) => setState(() => _autoAdd = v),
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Summary
            if (_monthlyAmount > 0)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.installment.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppColors.installment.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    const Text('ملخص الخطة',
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                    const SizedBox(height: 8),
                    _summaryRow(
                        'القسط الشهري',
                        CurrencyFormatter.format(_monthlyAmount)),
                    _summaryRow(
                        'إجمالي الفوائد',
                        CurrencyFormatter.format(
                            _totalInterest > 0 ? _totalInterest : 0)),
                    _summaryRow(
                        'الإجمالي',
                        CurrencyFormatter.format(_totalWithInterest)),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            AppButton(label: 'إضافة الخطة', onPressed: _save),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: AppColors.textSecondary)),
          Text(value,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
        ],
      ),
    );
  }
}
