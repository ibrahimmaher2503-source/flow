import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../providers/transaction_provider.dart';
import '../../../providers/category_provider.dart';
import '../../transactions/widgets/transaction_tile.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../l10n/generated/app_localizations.dart';

class RecentTransactions extends ConsumerWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentAsync = ref.watch(recentTransactionsProvider);
    final categoriesAsync = ref.watch(allCategoriesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: l10n.recentTransactionsTitle,
          actionText: l10n.viewAll,
          actionIcon: Icons.arrow_forward_ios_rounded,
          onAction: () {
            // Navigate to transactions - can be implemented later
          },
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.06),
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            child: recentAsync.when(
              data: (transactions) {
                if (transactions.isEmpty) {
                  return _EmptyTransactions(isDark: isDark);
                }

                final catLookup = <String, ({String icon, String color})>{};
                final cats = categoriesAsync.valueOrNull;
                if (cats != null) {
                  for (final c in cats) {
                    catLookup[c.name] = (icon: c.icon, color: c.color);
                  }
                }

                return Column(
                  children: [
                    for (int i = 0; i < transactions.length; i++) ...[
                      TransactionTile(
                        transaction: transactions[i],
                        categoryIcon: catLookup[transactions[i].category]?.icon,
                        categoryColor:
                            catLookup[transactions[i].category]?.color,
                      ),
                      if (i < transactions.length - 1)
                        Divider(
                          height: 1,
                          indent: 60,
                          endIndent: AppSpacing.lg,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : Colors.black.withValues(alpha: 0.05),
                        ),
                    ],
                  ],
                );
              },
              loading: () => _TransactionShimmer(isDark: isDark),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Center(
                  child: Text(
                    l10n.errorLoadingTransactions,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color:
                          isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyTransactions extends StatelessWidget {
  final bool isDark;

  const _EmptyTransactions({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xxxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              size: 32,
              color: AppColors.primary.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.emptyTransactionsYet,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.emptyTransactionsStart,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionShimmer extends StatelessWidget {
  final bool isDark;

  const _TransactionShimmer({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 14,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.black.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 60,
                        height: 10,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.black.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 70,
                  height: 14,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
