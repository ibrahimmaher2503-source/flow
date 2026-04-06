import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/models/transaction_model.dart';
import '../../data/models/category_model.dart';
import '../../data/models/wallet_model.dart';
import '../../data/repositories/transaction_repo.dart';
import '../../data/repositories/wallet_repo.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/wallet_provider.dart';
import 'widgets/number_pad.dart';
import 'widgets/category_grid.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final Transaction? editTransaction;

  const AddTransactionScreen({super.key, this.editTransaction});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  String _type = 'expense';
  String _amount = '0';
  Category? _selectedCategory;
  String? _selectedSubcategory;
  Wallet? _selectedWallet;
  DateTime _date = DateTime.now();
  final _noteController = TextEditingController();
  bool _showSubcategories = false;

  @override
  void initState() {
    super.initState();
    if (widget.editTransaction != null) {
      final t = widget.editTransaction!;
      _type = t.type;
      _amount = t.amount.toString();
      _date = t.date;
      _noteController.text = t.note ?? '';
      _selectedSubcategory = t.subcategory;
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final amount = double.tryParse(_amount);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ادخل مبلغ صحيح')),
      );
      return;
    }
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اختار فئة')),
      );
      return;
    }
    if (_selectedWallet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اختار محفظة')),
      );
      return;
    }

    final repo = ref.read(transactionRepoProvider);
    final walletRepo = ref.read(walletRepoProvider);

    final transaction = widget.editTransaction ?? Transaction();
    transaction
      ..amount = amount
      ..type = _type
      ..category = _selectedCategory!.name
      ..subcategory = _selectedSubcategory
      ..note = _noteController.text.isEmpty ? null : _noteController.text
      ..date = _date
      ..walletId = _selectedWallet!.id
      ..createdAt = widget.editTransaction?.createdAt ?? DateTime.now();

    if (widget.editTransaction != null) {
      // Reverse old wallet effect
      final oldAmount = widget.editTransaction!.amount;
      final oldType = widget.editTransaction!.type;
      final balanceRevert = oldType == 'income' ? -oldAmount : oldAmount;
      await walletRepo.updateBalance(
          widget.editTransaction!.walletId, balanceRevert);

      await repo.update(transaction);
    } else {
      await repo.add(transaction);
    }

    // Update wallet balance
    final balanceChange = _type == 'income' ? amount : -amount;
    await walletRepo.updateBalance(_selectedWallet!.id, balanceChange);

    if (mounted) {
      refreshTransactions(ref);
      refreshWallets(ref);
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletsAsync = ref.watch(walletsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.editTransaction != null ? 'تعديل معاملة' : 'إضافة معاملة'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Type toggle
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _type = 'expense';
                        _selectedCategory = null;
                        _selectedSubcategory = null;
                        _showSubcategories = false;
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _type == 'expense'
                              ? AppColors.danger
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'مصروف',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _type = 'income';
                        _selectedCategory = null;
                        _selectedSubcategory = null;
                        _showSubcategories = false;
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _type == 'income'
                              ? AppColors.success
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'دخل',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Amount display
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    _amount == '0' ? '٠' : _amount,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color:
                          _type == 'income' ? AppColors.secondary : AppColors.danger,
                    ),
                  ),
                  Text(
                    'جنيه مصري',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Number pad
            NumberPad(
              value: _amount,
              onChanged: (val) => setState(() => _amount = val),
            ),

            const SizedBox(height: 20),

            // Category grid
            const Text(
              'الفئة',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            CategoryGrid(
              type: _type,
              selectedCategory: _selectedCategory?.name,
              onSelected: (cat) {
                setState(() {
                  _selectedCategory = cat;
                  _selectedSubcategory = null;
                  _showSubcategories = cat.subcategories.isNotEmpty;
                });
              },
            ),

            // Subcategories
            if (_showSubcategories && _selectedCategory != null) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedCategory!.subcategories.map((sub) {
                  final isSelected = _selectedSubcategory == sub;
                  return GestureDetector(
                    onTap: () => setState(() {
                      _selectedSubcategory = isSelected ? null : sub;
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: isSelected
                            ? null
                            : Border.all(color: AppColors.textMuted),
                      ),
                      child: Text(
                        sub,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 20),

            // Wallet selector
            const Text(
              'المحفظة',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
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
                  runSpacing: 8,
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
                        child: Text(
                          w.name,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('$e'),
            ),

            const SizedBox(height: 16),

            // Date picker
            GestureDetector(
              onTap: _pickDate,
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
                      '${_date.day}/${_date.month}/${_date.year}',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Note
            TextField(
              controller: _noteController,
              style: const TextStyle(fontFamily: 'Cairo', color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'ملاحظة (اختياري)',
                prefixIcon:
                    Icon(Icons.note, color: AppColors.textMuted, size: 20),
              ),
            ),

            const SizedBox(height: 24),

            // Save button
            SizedBox(
              height: 52,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, Color(0xFF4F46E5)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    widget.editTransaction != null ? 'حفظ التعديل' : 'إضافة',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
