import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/bill_reminder_service.dart';
import '../data/services/isar_service.dart';

/// Provider for BillReminderService
final billReminderServiceProvider = Provider<BillReminderService>((ref) {
  return BillReminderService(ref.watch(isarProvider));
});

/// All upcoming bills (next 30 days)
final upcomingBillsProvider = FutureProvider<List<BillReminder>>((ref) async {
  return ref.watch(billReminderServiceProvider).getUpcomingBills();
});

/// Bills for a specific month (for calendar view)
final monthBillsProvider = FutureProvider.family<Map<DateTime, List<BillReminder>>, String>((ref, monthKey) async {
  final parts = monthKey.split('-');
  final year = int.parse(parts[0]);
  final month = int.parse(parts[1]);
  return ref.watch(billReminderServiceProvider).getBillsByMonth(year, month);
});

/// Today's due bills
final todaysBillsProvider = FutureProvider<List<BillReminder>>((ref) async {
  return ref.watch(billReminderServiceProvider).getTodaysBills();
});

/// Bills due in 3 days (for advance warning)
final threeDayBillsProvider = FutureProvider<List<BillReminder>>((ref) async {
  return ref.watch(billReminderServiceProvider).getBillsDueIn(days: 3);
});

/// Bills due tomorrow
final tomorrowBillsProvider = FutureProvider<List<BillReminder>>((ref) async {
  return ref.watch(billReminderServiceProvider).getBillsDueIn(days: 1);
});

/// Bill summary for dashboard
final billSummaryProvider = FutureProvider<BillSummary>((ref) async {
  return ref.watch(billReminderServiceProvider).getSummary();
});

/// Urgent bills only
final urgentBillsProvider = FutureProvider<List<BillReminder>>((ref) async {
  final bills = await ref.watch(upcomingBillsProvider.future);
  return bills.where((b) => b.tone == BillTone.urgent).toList();
});

/// Bills needing attention (urgent + warning)
final attentionBillsProvider = FutureProvider<List<BillReminder>>((ref) async {
  final bills = await ref.watch(upcomingBillsProvider.future);
  return bills.where((b) => b.tone == BillTone.urgent || b.tone == BillTone.warning).toList();
});

/// Helper to refresh all bill providers
void refreshBillReminders(WidgetRef ref) {
  ref.invalidate(upcomingBillsProvider);
  ref.invalidate(todaysBillsProvider);
  ref.invalidate(threeDayBillsProvider);
  ref.invalidate(tomorrowBillsProvider);
  ref.invalidate(billSummaryProvider);
  ref.invalidate(urgentBillsProvider);
  ref.invalidate(attentionBillsProvider);
}

/// T067: Trigger scheduled reminder checks and return bills needing notifications
Future<List<BillReminder>> checkScheduledReminders(WidgetRef ref) async {
  final service = ref.read(billReminderServiceProvider);
  final billsToNotify = <BillReminder>[];

  // Get bills due in 3 days (first reminder)
  final threeDayBills = await service.getBillsDueIn(days: 3);
  billsToNotify.addAll(threeDayBills);

  // Get bills due tomorrow (second reminder)
  final tomorrowBills = await service.getBillsDueIn(days: 1);
  billsToNotify.addAll(tomorrowBills);

  // Get today's bills (final reminder)
  final todayBills = await service.getTodaysBills();
  billsToNotify.addAll(todayBills);

  return billsToNotify;
}
