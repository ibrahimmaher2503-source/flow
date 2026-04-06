import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/icon_resolver.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final String? categoryIcon;
  final String? categoryColor;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.categoryIcon,
    this.categoryColor,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == 'income';
    final isInstallment = transaction.source == 'installment';
    final color = categoryColor?.toColor ?? AppColors.textMuted;

    return Slidable(
      endActionPane: onDelete != null
          ? ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) => onDelete!(),
                  backgroundColor: AppColors.danger,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'حذف',
                  borderRadius: BorderRadius.circular(12),
                ),
              ],
            )
          : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              // Category icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        IconResolver.resolve(categoryIcon ?? 'category'),
                        color: color,
                        size: 22,
                      ),
                    ),
                    if (isInstallment)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: AppColors.installment,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.credit_card,
                            size: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Category + note
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          transaction.category,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        if (transaction.subcategory != null) ...[
                          const SizedBox(width: 4),
                          Text(
                            '· ${transaction.subcategory}',
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (transaction.note != null &&
                        transaction.note!.isNotEmpty)
                      Text(
                        transaction.note!,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),

              // Amount
              Text(
                '${isIncome ? '+' : '-'} ${CurrencyFormatter.format(transaction.amount)}',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isIncome ? AppColors.secondary : AppColors.danger,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
