import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/transaction_provider.dart';
import '../../../providers/category_provider.dart';
import '../../transactions/widgets/transaction_tile.dart';
import '../../../shared/widgets/app_card.dart';

class RecentTransactions extends ConsumerWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentAsync = ref.watch(recentTransactionsProvider);
    final categoriesAsync = ref.watch(allCategoriesProvider);

    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'آخر المعاملات',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          recentAsync.when(
            data: (transactions) {
              if (transactions.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'مفيش معاملات لسه',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                );
              }

              final catLookup = <String, ({String icon, String color})>{};
              final cats = categoriesAsync.valueOrNull;
              if (cats != null) {
                for (final c in cats) {
                  catLookup[c.name] = (icon: c.icon, color: c.color);
                }
              }

              return Column(
                children: transactions.map((t) {
                  final cat = catLookup[t.category];
                  return TransactionTile(
                    transaction: t,
                    categoryIcon: cat?.icon,
                    categoryColor: cat?.color,
                  );
                }).toList(),
              );
            },
            loading: () => const SizedBox(
              height: 80,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('$e'),
          ),
        ],
      ),
    );
  }
}
