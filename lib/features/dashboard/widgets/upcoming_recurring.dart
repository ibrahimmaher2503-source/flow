import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../providers/recurring_provider.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../l10n/generated/app_localizations.dart';

final _upcomingRecurringProvider = FutureProvider((ref) async {
  final repo = ref.watch(recurringRepoProvider);
  final active = await repo.getActive();
  active.sort((a, b) => a.nextDueDate.compareTo(b.nextDueDate));
  return active.take(3).toList();
});

class UpcomingRecurring extends ConsumerWidget {
  const UpcomingRecurring({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recurringAsync = ref.watch(_upcomingRecurringProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return recurringAsync.when(
      data: (items) {
        if (items.isEmpty) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: l10n.upcomingTransactions,
              actionText: l10n.manage,
              actionIcon: Icons.settings_rounded,
              onAction: () {
                // Navigate to recurring management
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
              child: Column(
                children: [
                  for (int i = 0; i < items.length; i++) ...[
                    _RecurringItem(
                      item: items[i],
                      isDark: isDark,
                      l10n: l10n,
                    ),
                    if (i < items.length - 1)
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
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
    );
  }
}

class _RecurringItem extends StatelessWidget {
  final dynamic item;
  final bool isDark;
  final AppLocalizations l10n;

  const _RecurringItem({required this.item, required this.isDark, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final isIncome = item.type == 'income';
    final amountColor = isIncome ? AppColors.secondary : AppColors.danger;
    final daysUntil = item.nextDueDate.difference(DateTime.now()).inDays;
    final isUrgent = daysUntil <= 3 && daysUntil >= 0;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (isIncome ? AppColors.secondary : AppColors.primary)
                      .withValues(alpha: 0.15),
                  (isIncome ? AppColors.secondary : AppColors.primary)
                      .withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(
              isIncome ? Icons.arrow_downward_rounded : Icons.repeat_rounded,
              color: isIncome ? AppColors.secondary : AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Name and due date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.lightTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (isUrgent) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          l10n.dueSoon,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Icon(
                      Icons.schedule_rounded,
                      size: 12,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppDateUtils.formatRelative(item.nextDueDate),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isIncome ? '+' : '-'}${CurrencyFormatter.formatCompact(item.amount)}',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: amountColor,
                ),
              ),
              Text(
                _getFrequencyLabel(item.frequency, l10n),
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 10,
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getFrequencyLabel(String frequency, AppLocalizations l10n) {
    switch (frequency) {
      case 'daily':
        return l10n.frequencyDaily;
      case 'weekly':
        return l10n.frequencyWeekly;
      case 'monthly':
        return l10n.frequencyMonthly;
      case 'yearly':
        return l10n.frequencyYearly;
      default:
        return frequency;
    }
  }
}
