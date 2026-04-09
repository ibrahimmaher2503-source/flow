import 'package:intl/intl.dart';
import '../../l10n/generated/app_localizations.dart';

class AppDateUtils {
  static String formatDate(DateTime date, {String locale = 'ar'}) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Format date relative to today (e.g., "Today", "Yesterday", "3 days ago")
  /// Requires AppLocalizations for localized relative date strings
  static String formatRelative(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;

    if (diff == 0) return l10n.relativeDateToday;
    if (diff == 1) return l10n.relativeDateYesterday;
    if (diff == 2) return l10n.relativeDateBeforeYesterday;
    if (diff < 7) return l10n.relativeDateDaysAgo(diff);
    return formatDate(date);
  }

  /// Legacy formatRelative for backwards compatibility (uses Arabic)
  static String formatRelativeArabic(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;

    if (diff == 0) return 'النهاردة';
    if (diff == 1) return 'إمبارح';
    if (diff == 2) return 'أول إمبارح';
    if (diff < 7) return 'من $diff أيام';
    return formatDate(date);
  }

  static String formatMonth(DateTime date, {String locale = 'ar'}) {
    return DateFormat('MMMM yyyy', locale).format(date);
  }

  static String formatDayMonth(DateTime date, {String locale = 'ar'}) {
    return DateFormat('d MMMM', locale).format(date);
  }

  static int daysUntil(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    return target.difference(today).inDays;
  }
}
