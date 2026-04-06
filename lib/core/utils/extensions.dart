import 'package:flutter/material.dart';

extension DateTimeExt on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  DateTime get startOfDay => DateTime(year, month, day);

  DateTime get startOfMonth => DateTime(year, month);

  DateTime get endOfMonth => DateTime(year, month + 1, 0);
}

extension StringExt on String {
  Color get toColor {
    final hex = replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}

extension DoubleExt on double {
  String get formatted {
    if (this == toInt().toDouble()) return toInt().toString();
    return toStringAsFixed(2);
  }

  bool get isPositive => this > 0;
  bool get isNegative => this < 0;
}
