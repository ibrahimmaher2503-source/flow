import 'package:isar/isar.dart';
import '../models/recurring_transaction_model.dart';
import '../models/wallet_model.dart';

/// Bill reminder with coverage and tone information
class BillReminder {
  final RecurringTransaction bill;
  final int daysUntilDue;
  final double totalWalletBalance;
  final double coveragePercent;
  final BillTone tone;
  final String message;

  BillReminder({
    required this.bill,
    required this.daysUntilDue,
    required this.totalWalletBalance,
    required this.coveragePercent,
    required this.tone,
    required this.message,
  });

  bool get canCover => coveragePercent >= 100;
  bool get isUrgent => daysUntilDue <= 1;
  bool get isWarning => daysUntilDue <= 3 && daysUntilDue > 1;
}

/// Tone for contextual Arabic messages
enum BillTone {
  encouraging, // Can cover easily
  neutral, // Just enough
  warning, // Tight budget
  urgent, // Can't cover
}

/// Service for smart bill reminders with coverage calculation
class BillReminderService {
  final Isar isar;

  BillReminderService(this.isar);

  /// Get upcoming bills within the next N days
  Future<List<BillReminder>> getUpcomingBills({int daysAhead = 30}) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final endDate = today.add(Duration(days: daysAhead));

    // Get active recurring transactions (expenses only for bills)
    final recurringTxns = await isar.recurringTransactions
        .filter()
        .isActiveEqualTo(true)
        .typeEqualTo('expense')
        .findAll();

    // Get total wallet balance
    final wallets = await isar.wallets.where().findAll();
    final totalBalance = wallets.fold<double>(0, (sum, w) => sum + w.balance);

    final reminders = <BillReminder>[];

    for (final txn in recurringTxns) {
      final nextDue = txn.nextDueDate;
      if (nextDue.isAfter(endDate)) continue;

      final daysUntilDue = nextDue.difference(today).inDays;
      if (daysUntilDue < 0) continue; // Skip overdue for now

      final coveragePercent =
          totalBalance > 0 ? (totalBalance / txn.amount) * 100 : 0.0;
      final tone = _calculateTone(coveragePercent, daysUntilDue);
      final message = _generateMessage(txn, daysUntilDue, coveragePercent, tone);

      reminders.add(BillReminder(
        bill: txn,
        daysUntilDue: daysUntilDue,
        totalWalletBalance: totalBalance,
        coveragePercent: coveragePercent,
        tone: tone,
        message: message,
      ));
    }

    // Sort by due date
    reminders.sort((a, b) => a.daysUntilDue.compareTo(b.daysUntilDue));

    return reminders;
  }

  /// Get bills due within a specific range (for scheduling)
  Future<List<BillReminder>> getBillsDueIn({required int days}) async {
    final allBills = await getUpcomingBills(daysAhead: days + 1);
    return allBills.where((b) => b.daysUntilDue == days).toList();
  }

  /// Get today's due bills
  Future<List<BillReminder>> getTodaysBills() async {
    return getBillsDueIn(days: 0);
  }

  /// Get bills by month for calendar display
  Future<Map<DateTime, List<BillReminder>>> getBillsByMonth(
      int year, int month) async {
    // Get all active recurring expenses
    final recurringTxns = await isar.recurringTransactions
        .filter()
        .isActiveEqualTo(true)
        .typeEqualTo('expense')
        .findAll();

    // Get total balance
    final wallets = await isar.wallets.where().findAll();
    final totalBalance = wallets.fold<double>(0, (sum, w) => sum + w.balance);

    final billsByDate = <DateTime, List<BillReminder>>{};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final txn in recurringTxns) {
      // Calculate which dates this bill falls on in this month
      final dueDates = _getDueDatesInMonth(txn, year, month);

      for (final dueDate in dueDates) {
        final daysUntilDue = dueDate.difference(today).inDays;
        final coveragePercent =
            totalBalance > 0 ? (totalBalance / txn.amount) * 100 : 0.0;
        final tone = _calculateTone(coveragePercent, daysUntilDue);
        final message =
            _generateMessage(txn, daysUntilDue, coveragePercent, tone);

        final reminder = BillReminder(
          bill: txn,
          daysUntilDue: daysUntilDue,
          totalWalletBalance: totalBalance,
          coveragePercent: coveragePercent,
          tone: tone,
          message: message,
        );

        if (billsByDate[dueDate] == null) {
          billsByDate[dueDate] = [];
        }
        billsByDate[dueDate]!.add(reminder);
      }
    }

    return billsByDate;
  }

  /// Get due dates for a recurring transaction in a specific month
  List<DateTime> _getDueDatesInMonth(
      RecurringTransaction txn, int year, int month) {
    final dates = <DateTime>[];
    final startOfMonth = DateTime(year, month, 1);
    final endOfMonth = DateTime(year, month + 1, 0);

    switch (txn.frequency) {
      case 'daily':
        // Every day of the month
        for (int day = 1; day <= endOfMonth.day; day++) {
          dates.add(DateTime(year, month, day));
        }
        break;

      case 'weekly':
        // Find the weekday of the original due date
        final weekday = txn.nextDueDate.weekday;
        DateTime current = startOfMonth;
        while (current.weekday != weekday) {
          current = current.add(const Duration(days: 1));
        }
        while (current.isBefore(endOfMonth) ||
            current.isAtSameMomentAs(endOfMonth)) {
          dates.add(current);
          current = current.add(const Duration(days: 7));
        }
        break;

      case 'monthly':
        // Same day each month
        final day = txn.nextDueDate.day.clamp(1, endOfMonth.day);
        dates.add(DateTime(year, month, day));
        break;

      case 'yearly':
        // Only if this is the month
        if (txn.nextDueDate.month == month) {
          final day = txn.nextDueDate.day.clamp(1, endOfMonth.day);
          dates.add(DateTime(year, month, day));
        }
        break;
    }

    return dates;
  }

  /// Calculate tone based on coverage and urgency
  BillTone _calculateTone(double coveragePercent, int daysUntilDue) {
    if (coveragePercent < 100) {
      return BillTone.urgent;
    } else if (coveragePercent < 150 && daysUntilDue <= 3) {
      return BillTone.warning;
    } else if (coveragePercent >= 200) {
      return BillTone.encouraging;
    } else {
      return BillTone.neutral;
    }
  }

  /// T071: Generate contextual Arabic message with 4 tones
  String _generateMessage(
    RecurringTransaction bill,
    int daysUntilDue,
    double coveragePercent,
    BillTone tone,
  ) {
    final amount = bill.amount.toStringAsFixed(0);
    final name = bill.name;

    // Time context
    String timeContext;
    if (daysUntilDue == 0) {
      timeContext = 'النهاردة';
    } else if (daysUntilDue == 1) {
      timeContext = 'بكرة';
    } else if (daysUntilDue == 2) {
      timeContext = 'بعد بكرة';
    } else if (daysUntilDue <= 7) {
      timeContext = 'خلال $daysUntilDue أيام';
    } else {
      timeContext = 'في ${bill.nextDueDate.day}/${bill.nextDueDate.month}';
    }

    switch (tone) {
      case BillTone.encouraging:
        // Positive, motivating tone
        final messages = [
          'مبروك! رصيدك يغطي $name ($amount جنيه) $timeContext ومعاك فايض كمان 💚',
          '$name ($amount جنيه) $timeContext - رصيدك تمام ومرتاح 👍',
          'فلوسك مظبوطة! $name $timeContext متغطي بالكامل ✅',
        ];
        return messages[bill.id % messages.length];

      case BillTone.neutral:
        // Informative, calm tone
        final messages = [
          'تذكير: $name ($amount جنيه) $timeContext',
          '$name ($amount جنيه) مستحق $timeContext',
          'عندك $name $timeContext - $amount جنيه',
        ];
        return messages[bill.id % messages.length];

      case BillTone.warning:
        // Alert but not panic
        final messages = [
          'انتبه: $name ($amount جنيه) $timeContext - الرصيد كفاية بس ضيق',
          '$name $timeContext - خلي بالك الرصيد قريب من المبلغ المطلوب',
          'تنبيه: $name ($amount جنيه) قريب $timeContext والرصيد محدود',
        ];
        return messages[bill.id % messages.length];

      case BillTone.urgent:
        // Serious, action-needed tone
        final shortage = bill.amount - (coveragePercent / 100 * bill.amount);
        final shortageStr = shortage.toStringAsFixed(0);
        final messages = [
          '⚠️ $name ($amount جنيه) $timeContext - محتاج تدبر $shortageStr جنيه!',
          'عاجل: الرصيد مش كافي لـ $name $timeContext - ناقص $shortageStr جنيه',
          '$name $timeContext ومفيش رصيد كافي! محتاج $shortageStr جنيه إضافية',
        ];
        return messages[bill.id % messages.length];
    }
  }

  /// Get reminders that need to be sent (3 days, 1 day, today)
  Future<Map<String, List<BillReminder>>> getRemindersToSend() async {
    return {
      '3_days': await getBillsDueIn(days: 3),
      '1_day': await getBillsDueIn(days: 1),
      'today': await getTodaysBills(),
    };
  }

  /// Check if any reminders should be sent now
  /// Returns reminders that need notifications
  Future<List<BillReminder>> checkAndSendReminders() async {
    final reminders = await getRemindersToSend();
    final allReminders = <BillReminder>[];

    for (final entry in reminders.entries) {
      allReminders.addAll(entry.value);
    }

    return allReminders;
  }

  /// Get summary of upcoming bills
  Future<BillSummary> getSummary() async {
    final bills = await getUpcomingBills(daysAhead: 30);

    double totalAmount = 0;
    int urgentCount = 0;
    int warningCount = 0;
    int okCount = 0;

    for (final bill in bills) {
      totalAmount += bill.bill.amount;
      switch (bill.tone) {
        case BillTone.urgent:
          urgentCount++;
          break;
        case BillTone.warning:
          warningCount++;
          break;
        default:
          okCount++;
      }
    }

    return BillSummary(
      totalBills: bills.length,
      totalAmount: totalAmount,
      urgentCount: urgentCount,
      warningCount: warningCount,
      okCount: okCount,
      nextBill: bills.isNotEmpty ? bills.first : null,
    );
  }
}

/// Summary of bill status
class BillSummary {
  final int totalBills;
  final double totalAmount;
  final int urgentCount;
  final int warningCount;
  final int okCount;
  final BillReminder? nextBill;

  BillSummary({
    required this.totalBills,
    required this.totalAmount,
    required this.urgentCount,
    required this.warningCount,
    required this.okCount,
    this.nextBill,
  });

  bool get hasIssues => urgentCount > 0 || warningCount > 0;
}
