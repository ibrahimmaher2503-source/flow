import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/detected_sms_model.dart';

class SmsTile extends StatelessWidget {
  final DetectedSms sms;
  final VoidCallback? onTap;

  const SmsTile({
    super.key,
    required this.sms,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(14),
          border: sms.status == 'confirmed'
              ? Border.all(
                  color: (isDark ? AppColors.success : AppColors.lightSuccess)
                      .withValues(alpha: 0.3))
              : sms.status == 'dismissed'
                  ? Border.all(
                      color:
                          (isDark ? AppColors.textMuted : AppColors.lightTextMuted)
                              .withValues(alpha: 0.3))
                  : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                // Bank badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: (isDark ? AppColors.primary : AppColors.lightPrimary)
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    sms.bank,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.primary : AppColors.lightPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Status badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _getStatusColor(isDark).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _getStatusLabel(AppLocalizations.of(context)!),
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      color: _getStatusColor(isDark),
                    ),
                  ),
                ),
                const Spacer(),
                // Amount
                Text(
                  '${sms.type == 'credit' ? '+' : '-'} ${CurrencyFormatter.format(sms.amount)}',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: sms.type == 'credit'
                        ? (isDark ? AppColors.secondary : AppColors.lightSecondary)
                        : (isDark ? AppColors.danger : AppColors.lightDanger),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // SMS body preview
            Text(
              sms.rawBody,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            // Timestamp
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatTimestamp(sms.timestamp),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color:
                        isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  ),
                ),
                if (sms.status == 'pending') ...[
                  const Spacer(),
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                    color:
                        isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(bool isDark) {
    switch (sms.status) {
      case 'confirmed':
        return isDark ? AppColors.success : AppColors.lightSuccess;
      case 'dismissed':
        return isDark ? AppColors.textMuted : AppColors.lightTextMuted;
      default:
        return isDark ? AppColors.warning : AppColors.lightWarning;
    }
  }

  String _getStatusLabel(AppLocalizations l10n) {
    switch (sms.status) {
      case 'confirmed':
        return l10n.smsStatusConfirmed;
      case 'dismissed':
        return l10n.smsStatusDismissed;
      default:
        return l10n.smsStatusPending;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) {
      return 'الآن';
    } else if (diff.inMinutes < 60) {
      return 'منذ ${diff.inMinutes} دقيقة';
    } else if (diff.inHours < 24) {
      return 'منذ ${diff.inHours} ساعة';
    } else if (diff.inDays == 1) {
      return 'أمس ${DateFormat('HH:mm').format(timestamp)}';
    } else if (diff.inDays < 7) {
      return 'منذ ${diff.inDays} أيام';
    } else {
      return DateFormat('dd/MM/yyyy HH:mm').format(timestamp);
    }
  }
}
