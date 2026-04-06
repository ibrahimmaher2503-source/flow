import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SmsTile extends StatelessWidget {
  final String body;
  final String bank;
  final double amount;
  final String type; // 'debit' | 'credit'
  final String status; // 'pending' | 'added' | 'rejected'
  final VoidCallback? onAdd;
  final VoidCallback? onReject;

  const SmsTile({
    super.key,
    required this.body,
    required this.bank,
    required this.amount,
    required this.type,
    required this.status,
    this.onAdd,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: status == 'added'
            ? Border.all(color: AppColors.success.withValues(alpha: 0.3))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  bank,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _statusLabel,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: _statusColor,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${type == 'credit' ? '+' : '-'} $amount جنيه',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: type == 'credit' ? AppColors.secondary : AppColors.danger,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Body
          Text(
            body,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          // Actions
          if (status == 'pending') ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onReject,
                  child: const Text('تجاهل',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          color: AppColors.textMuted)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onAdd,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  ),
                  child: const Text('إضافة',
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 13)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color get _statusColor {
    switch (status) {
      case 'added':
        return AppColors.success;
      case 'rejected':
        return AppColors.textMuted;
      default:
        return AppColors.warning;
    }
  }

  String get _statusLabel {
    switch (status) {
      case 'added':
        return 'مضافة';
      case 'rejected':
        return 'مرفوضة';
      default:
        return 'في الانتظار';
    }
  }
}
