import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_date_utils.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/models/transaction_model.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../providers/category_provider.dart';
import '../../shared/widgets/empty_state.dart';
import 'add_transaction_screen.dart';
import 'widgets/transaction_tile.dart';
import 'widgets/filter_bar.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  TransactionFilter _filter = TransactionFilter.all;

  List<Transaction> _applyFilter(List<Transaction> transactions) {
    switch (_filter) {
      case TransactionFilter.all:
        return transactions;
      case TransactionFilter.income:
        return transactions.where((t) => t.type == TransactionType.income).toList();
      case TransactionFilter.expense:
        return transactions.where((t) => t.type == TransactionType.expense).toList();
      case TransactionFilter.installment:
        return transactions
            .where((t) => t.source == TransactionSource.installment)
            .toList();
    }
  }

  Map<String, List<Transaction>> _groupByDate(List<Transaction> transactions) {
    final Map<String, List<Transaction>> grouped = {};
    for (final t in transactions) {
      final key = AppDateUtils.formatRelative(t.date);
      grouped.putIfAbsent(key, () => []).add(t);
    }
    return grouped;
  }

  Future<void> _deleteTransaction(Transaction t) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('حذف المعاملة؟',
            style: TextStyle(fontFamily: 'Cairo', color: AppColors.textPrimary)),
        content: const Text('هل أنت متأكد من حذف هذه المعاملة؟',
            style: TextStyle(fontFamily: 'Cairo', color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('لا',
                style: TextStyle(fontFamily: 'Cairo', color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('نعم، احذف',
                style: TextStyle(fontFamily: 'Cairo', color: AppColors.danger)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final repo = ref.read(transactionRepoProvider);
      final walletRepo = ref.read(walletRepoProvider);

      // Reverse wallet effect
      final revert = t.type == TransactionType.income ? -t.amount : t.amount;
      await walletRepo.updateBalance(t.walletId, revert);
      await repo.delete(t.id);

      refreshTransactions(ref);
      refreshWallets(ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(monthlyTransactionsProvider);
    final incomeAsync = ref.watch(monthlyIncomeProvider);
    final expenseAsync = ref.watch(monthlyExpenseProvider);
    final selectedMonth = ref.watch(selectedMonthProvider);
    final categoriesAsync = ref.watch(allCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('المعاملات'),
      ),
      body: Column(
        children: [
          // Month selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    ref.read(selectedMonthProvider.notifier).state = DateTime(
                      selectedMonth.year,
                      selectedMonth.month + 1,
                    );
                  },
                  icon: const Icon(Icons.chevron_right, color: AppColors.textPrimary),
                ),
                Text(
                  AppDateUtils.formatMonth(selectedMonth),
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ref.read(selectedMonthProvider.notifier).state = DateTime(
                      selectedMonth.year,
                      selectedMonth.month - 1,
                    );
                  },
                  icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),

          // Summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text('دخل',
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                color: AppColors.textMuted)),
                        incomeAsync.when(
                          data: (val) => Text(
                            CurrencyFormatter.format(val),
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.success,
                            ),
                          ),
                          loading: () => const Text('...'),
                          error: (_, __) => const Text('--'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.danger.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text('مصروف',
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                color: AppColors.textMuted)),
                        expenseAsync.when(
                          data: (val) => Text(
                            CurrencyFormatter.format(val),
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.danger,
                            ),
                          ),
                          loading: () => const Text('...'),
                          error: (_, __) => const Text('--'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Filter bar
          FilterBar(
            selected: _filter,
            onChanged: (f) => setState(() => _filter = f),
          ),

          const SizedBox(height: 8),

          // Transaction list
          Expanded(
            child: transactionsAsync.when(
              data: (transactions) {
                final filtered = _applyFilter(transactions);
                if (filtered.isEmpty) {
                  return const EmptyState(
                    icon: Icons.receipt_long,
                    message: 'مفيش معاملات في الفترة دي',
                  );
                }

                final grouped = _groupByDate(filtered);
                final categoryMap = categoriesAsync.valueOrNull;
                final catLookup = <String, ({String icon, String color})>{};
                if (categoryMap != null) {
                  for (final c in categoryMap) {
                    catLookup[c.name] = (icon: c.icon, color: c.color);
                  }
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: grouped.length,
                  itemBuilder: (context, index) {
                    final entry = grouped.entries.elementAt(index);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            entry.key,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                        ...entry.value.map((t) {
                          final cat = catLookup[t.category];
                          return TransactionTile(
                            transaction: t,
                            categoryIcon: cat?.icon,
                            categoryColor: cat?.color,
                            onTap: () async {
                              final result = await Navigator.push<bool>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddTransactionScreen(
                                      editTransaction: t),
                                ),
                              );
                              if (result == true) {
                                refreshTransactions(ref);
                                refreshWallets(ref);
                              }
                            },
                            onDelete: () => _deleteTransaction(t),
                          );
                        }),
                      ],
                    );
                  },
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('خطأ: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
