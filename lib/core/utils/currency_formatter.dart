import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final _formatter = NumberFormat('#,##0.##', 'ar');

  static String format(double amount) {
    return '${_formatter.format(amount)} جنيه';
  }

  static String formatCompact(double amount) {
    if (amount >= 1000000) {
      return '${_formatter.format(amount / 1000000)} مليون';
    } else if (amount >= 1000) {
      return '${_formatter.format(amount / 1000)} ألف';
    }
    return _formatter.format(amount);
  }
}
