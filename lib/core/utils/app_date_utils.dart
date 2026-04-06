import 'package:intl/intl.dart';

class AppDateUtils {
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatRelative(DateTime date) {
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

  static String formatMonth(DateTime date) {
    return DateFormat('MMMM yyyy', 'ar').format(date);
  }

  static String formatDayMonth(DateTime date) {
    return DateFormat('d MMMM', 'ar').format(date);
  }

  static int daysUntil(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    return target.difference(today).inDays;
  }
}
