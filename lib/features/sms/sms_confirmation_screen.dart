import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/models/category_model.dart';
import '../../data/models/transaction_model.dart';
import '../../data/models/wallet_model.dart';
import '../../providers/sms_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../shared/widgets/app_button.dart';
import '../transactions/widgets/category_grid.dart';

class SmsConfirmationScreen extends ConsumerStatefulWidget {
  final int smsId;

  const SmsConfirmationScreen({super.key, required this.smsId});

  @override
  ConsumerState<SmsConfirmationScreen> createState() =>
      _SmsConfirmationScreenState();
}

class _SmsConfirmationScreenState extends ConsumerState<SmsConfirmationScreen> {
  Category? _selectedCategory;
  Wallet? _selectedWallet;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final smsAsync = ref.watch(detectedSmsByIdProvider(widget.smsId));
    final walletsAsync = ref.watch(walletsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.smsConfirmationTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: smsAsync.when(
        data: (sms) {
          if (sms == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: isDark ? AppColors.danger : AppColors.lightDanger,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.smsNotFound,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          if (sms.status != 'pending') {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    sms.status == 'confirmed'
                        ? Icons.check_circle
                        : Icons.cancel,
                    size: 64,
                    color: sms.status == 'confirmed'
                        ? (isDark ? AppColors.success : AppColors.lightSuccess)
                        : (isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    sms.status == 'confirmed'
                        ? l10n.smsAlreadyConfirmed
                        : l10n.smsAlreadyDismissed,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.back),
                  ),
                ],
              ),
            );
          }

          final transactionType =
              sms.type == 'credit' ? TransactionType.income : TransactionType.expense;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Transaction summary card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surface : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // Amount
                      Text(
                        '${sms.type == 'credit' ? '+' : '-'} ${CurrencyFormatter.format(sms.amount)}',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: sms.type == 'credit'
                              ? (isDark
                                  ? AppColors.secondary
                                  : AppColors.lightSecondary)
                              : (isDark
                                  ? AppColors.danger
                                  : AppColors.lightDanger),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Bank
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              (isDark ? AppColors.primary : AppColors.lightPrimary)
                                  .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          sms.bank,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.primary
                                : AppColors.lightPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // SMS body preview
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.background
                              : AppColors.lightBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          sms.rawBody,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Category selection
                Text(
                  l10n.selectCategory,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color:
                        isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                CategoryGrid(
                  type: transactionType,
                  selectedCategory: _selectedCategory?.name,
                  onSelected: (category) {
                    setState(() => _selectedCategory = category);
                  },
                ),

                const SizedBox(height: 24),

                // Wallet selection
                Text(
                  l10n.selectWallet,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color:
                        isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                walletsAsync.when(
                  data: (wallets) => Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: wallets.map((wallet) {
                      final isSelected = _selectedWallet?.id == wallet.id;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedWallet = wallet),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark
                                        ? AppColors.primary
                                        : AppColors.lightPrimary)
                                    .withValues(alpha: 0.2)
                                : (isDark
                                    ? AppColors.surface
                                    : AppColors.lightSurface),
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected
                                ? Border.all(
                                    color: isDark
                                        ? AppColors.primary
                                        : AppColors.lightPrimary,
                                    width: 2,
                                  )
                                : null,
                          ),
                          child: Text(
                            wallet.name,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              color: isSelected
                                  ? (isDark
                                      ? AppColors.primary
                                      : AppColors.lightPrimary)
                                  : (isDark
                                      ? AppColors.textSecondary
                                      : AppColors.lightTextSecondary),
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('${l10n.errorWithMessage}: $e'),
                ),

                const SizedBox(height: 32),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : () => _dismissTransaction(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          l10n.smsDismissButton,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            color: isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: AppButton(
                        label: l10n.smsConfirmButton,
                        onPressed:
                            (_selectedCategory != null && _selectedWallet != null)
                                ? () => _confirmTransaction(sms)
                                : null,
                        isLoading: _isLoading,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            '${l10n.errorWithMessage}: $error',
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmTransaction(dynamic sms) async {
    if (_selectedCategory == null || _selectedWallet == null) return;

    setState(() => _isLoading = true);

    try {
      final transactionRepo = ref.read(transactionRepoProvider);
      final detectedSmsRepo = ref.read(detectedSmsRepoProvider);

      // Create transaction
      final transactionId = const Uuid().v4();
      final transaction = Transaction()
        ..amount = sms.amount
        ..type = sms.type == 'credit' ? 'income' : 'expense'
        ..category = _selectedCategory!.name
        ..date = sms.timestamp
        ..walletId = _selectedWallet!.id
        ..source = 'sms'
        ..smsBody = sms.rawBody
        ..createdAt = DateTime.now();

      await transactionRepo.add(transaction);

      // Update SMS status
      await detectedSmsRepo.updateStatus(
        widget.smsId,
        'confirmed',
        transactionId: transactionId,
        categoryId: _selectedCategory!.id,
      );

      // Refresh providers
      refreshTransactions(ref);
      refreshWallets(ref);
      refreshSmsProviders(ref);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.smsTransactionAddedSuccess),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.errorWithMessage('$e')),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _dismissTransaction() async {
    setState(() => _isLoading = true);

    try {
      final detectedSmsRepo = ref.read(detectedSmsRepoProvider);
      await detectedSmsRepo.updateStatus(widget.smsId, 'dismissed');

      refreshSmsProviders(ref);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.errorWithMessage('$e')),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
