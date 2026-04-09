import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/extensions.dart';
import '../../data/models/wallet_model.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../providers/wallet_provider.dart';
import '../../shared/widgets/empty_state.dart';
import 'widgets/wallet_card.dart';

class WalletsScreen extends ConsumerWidget {
  const WalletsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final walletsAsync = ref.watch(walletsProvider);
    final totalAsync = ref.watch(totalBalanceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.screenWallets),
      ),
      body: walletsAsync.when(
        data: (wallets) {
          if (wallets.isEmpty) {
            return EmptyState(
              icon: Icons.account_balance_wallet,
              message: l10n.emptyWallets,
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Total balance card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, Color(0xFF4F46E5)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      l10n.labelTotalBalance,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    totalAsync.when(
                      data: (total) => Text(
                        CurrencyFormatter.format(total),
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      loading: () => const Text('...'),
                      error: (_, __) => const Text('--'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ...wallets.map((w) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: WalletCard(
                      wallet: w,
                      onTap: () => _showEditWalletDialog(context, ref, w),
                    ),
                  )),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.errorWithMessage(e.toString()))),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWalletDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  static const _walletColors = [
    '#10B981', '#6C63FF', '#EF4444', '#F59E0B', '#3B82F6', '#EC4899',
  ];

  static String _iconForType(String type) {
    switch (type) {
      case 'cash':
        return 'wallet';
      case 'bank':
        return 'account_balance';
      case 'ewallet':
        return 'phone_android';
      default:
        return 'wallet';
    }
  }

  void _showAddWalletDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final balanceController = TextEditingController(text: '0');
    String selectedType = 'cash';
    String selectedColor = _walletColors[0];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: isDark ? AppColors.surface : AppColors.lightSurface,
          title: Text(l10n.addWallet,
              style: TextStyle(fontFamily: 'Cairo', color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: TextStyle(
                      fontFamily: 'Cairo', color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary),
                  decoration: InputDecoration(
                    hintText: l10n.walletName,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: balanceController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      fontFamily: 'Cairo', color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary),
                  decoration: InputDecoration(
                    hintText: l10n.initialBalance,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _typeChip(l10n.walletTypeCash, 'cash', selectedType,
                        (v) => setDialogState(() => selectedType = v), isDark),
                    const SizedBox(width: 8),
                    _typeChip(l10n.walletTypeBank, 'bank', selectedType,
                        (v) => setDialogState(() => selectedType = v), isDark),
                    const SizedBox(width: 8),
                    _typeChip(l10n.walletTypeCard, 'ewallet', selectedType,
                        (v) => setDialogState(() => selectedType = v), isDark),
                  ],
                ),
                const SizedBox(height: 12),
                // Color picker
                Wrap(
                  spacing: 8,
                  children: _walletColors.map((hex) {
                    final color = hex.toColor;
                    final isSelected = selectedColor == hex;
                    return GestureDetector(
                      onTap: () => setDialogState(() => selectedColor = hex),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.white, width: 2)
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
              child: Text(l10n.buttonCancel,
                  style: TextStyle(
                      fontFamily: 'Cairo', color: isDark ? AppColors.textMuted : AppColors.lightTextMuted)),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.isEmpty) return;
                final balance =
                    double.tryParse(balanceController.text) ?? 0;
                final repo = ref.read(walletRepoProvider);
                final wallets = await repo.getAll();
                await repo.add(Wallet()
                  ..name = nameController.text
                  ..type = selectedType
                  ..balance = balance
                  ..icon = _iconForType(selectedType)
                  ..color = selectedColor
                  ..sortOrder = wallets.length);
                refreshWallets(ref);
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: Text(l10n.buttonAdd,
                  style: const TextStyle(
                      fontFamily: 'Cairo', color: AppColors.primary)),
            ),
          ],
        ),
      ),
    ).then((_) {
      nameController.dispose();
      balanceController.dispose();
    });
  }

  void _showEditWalletDialog(
      BuildContext context, WidgetRef ref, Wallet wallet) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController(text: wallet.name);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.surface : AppColors.lightSurface,
        title: Text(l10n.editWallet,
            style: TextStyle(fontFamily: 'Cairo', color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary)),
        content: TextField(
          controller: nameController,
          style: TextStyle(fontFamily: 'Cairo', color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary),
          decoration: InputDecoration(hintText: l10n.walletName),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: ctx,
                builder: (ctx2) => AlertDialog(
                  backgroundColor: isDark ? AppColors.surface : AppColors.lightSurface,
                  title: Text(l10n.deleteWallet,
                      style: TextStyle(
                          fontFamily: 'Cairo', color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx2, false),
                      child: Text(l10n.buttonNo,
                          style: const TextStyle(fontFamily: 'Cairo')),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx2, true),
                      child: Text(l10n.buttonYes,
                          style: const TextStyle(
                              fontFamily: 'Cairo',
                              color: AppColors.danger)),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                await ref.read(walletRepoProvider).delete(wallet.id);
                refreshWallets(ref);
                if (ctx.mounted) Navigator.pop(ctx);
              }
            },
            child: Text(l10n.buttonDelete,
                style: const TextStyle(
                    fontFamily: 'Cairo', color: AppColors.danger)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.buttonCancel,
                style: TextStyle(
                    fontFamily: 'Cairo', color: isDark ? AppColors.textMuted : AppColors.lightTextMuted)),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isEmpty) return;
              wallet.name = nameController.text;
              await ref.read(walletRepoProvider).update(wallet);
              refreshWallets(ref);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: Text(l10n.buttonSave,
                style: const TextStyle(
                    fontFamily: 'Cairo', color: AppColors.primary)),
          ),
        ],
      ),
    ).then((_) => nameController.dispose());
  }

  Widget _typeChip(
      String label, String value, String selected, ValueChanged<String> onTap, bool isDark) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(color: isDark ? AppColors.textMuted : AppColors.lightTextMuted),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            color: isSelected ? Colors.white : (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
          ),
        ),
      ),
    );
  }
}
