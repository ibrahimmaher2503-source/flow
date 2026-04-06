import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../data/repositories/recurring_repo.dart';
import '../../../data/services/isar_service.dart';
import '../../../shared/widgets/app_card.dart';

final _upcomingRecurringProvider = FutureProvider((ref) async {
  final repo = RecurringRepo(ref.watch(isarProvider));
  final active = await repo.getActive();
  active.sort((a, b) => a.nextDueDate.compareTo(b.nextDueDate));
  return active.take(3).toList();
});

class UpcomingRecurring extends ConsumerWidget {
  const UpcomingRecurring({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recurringAsync = ref.watch(_upcomingRecurringProvider);

    return recurringAsync.when(
      data: (items) {
        if (items.isEmpty) return const SizedBox();

        return AppCard(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    Icon(Icons.repeat, color: AppColors.primary, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'القادم',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ...items.map((r) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(r.name,
                              style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 14,
                                  color: Colors.white)),
                        ),
                        Text(
                          AppDateUtils.formatRelative(r.nextDueDate),
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          CurrencyFormatter.format(r.amount),
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: r.type == 'income'
                                ? AppColors.secondary
                                : AppColors.danger,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        );
      },
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
    );
  }
}
