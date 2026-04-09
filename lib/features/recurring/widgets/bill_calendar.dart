import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/services/bill_reminder_service.dart';
import '../../../providers/bill_reminder_provider.dart';

/// T068: Calendar widget showing bills with color-coded dots
class BillCalendar extends ConsumerStatefulWidget {
  final Function(DateTime, List<BillReminder>)? onDayTap;

  const BillCalendar({super.key, this.onDayTap});

  @override
  ConsumerState<BillCalendar> createState() => _BillCalendarState();
}

class _BillCalendarState extends ConsumerState<BillCalendar> {
  late DateTime _selectedMonth;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month, 1);
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month - 1,
        1,
      );
      _selectedDay = null;
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + 1,
        1,
      );
      _selectedDay = null;
    });
  }

  String get _monthKey =>
      '${_selectedMonth.year}-${_selectedMonth.month.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final billsAsync = ref.watch(monthBillsProvider(_monthKey));

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceLight.withValues(alpha: 0.5)
            : AppColors.lightSurfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: isDark
              ? AppColors.surfaceLight
              : AppColors.lightSurfaceContainerHighest,
        ),
      ),
      child: Column(
        children: [
          // Month header
          _buildMonthHeader(isDark),

          // Weekday headers
          _buildWeekdayHeader(isDark),

          // Calendar grid
          billsAsync.when(
            loading: () => const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, st) => SizedBox(
              height: 200,
              child: Center(child: Text('خطأ: $e')),
            ),
            data: (billsByDate) => _buildCalendarGrid(billsByDate, isDark),
          ),

          // Selected day details
          if (_selectedDay != null)
            billsAsync.whenData((data) {
              final bills = data[_selectedDay] ?? [];
              if (bills.isEmpty) return const SizedBox.shrink();
              return _buildSelectedDayDetails(bills, isDark);
            }).value ?? const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildMonthHeader(bool isDark) {
    final monthNames = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _previousMonth,
            icon: Icon(
              Icons.chevron_right_rounded,
              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
            ),
          ),
          Text(
            '${monthNames[_selectedMonth.month - 1]} ${_selectedMonth.year}',
            style: TextStyle(
              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            onPressed: _nextMonth,
            icon: Icon(
              Icons.chevron_left_rounded,
              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeader(bool isDark) {
    // Arabic weekdays starting from Saturday
    const weekdays = ['س', 'ح', 'ن', 'ث', 'ر', 'خ', 'ج'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Row(
        children: weekdays.map((day) {
          return Expanded(
            child: Center(
              child: Text(
                day,
                style: TextStyle(
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid(
    Map<DateTime, List<BillReminder>> billsByDate,
    bool isDark,
  ) {
    final daysInMonth = DateTime(
      _selectedMonth.year,
      _selectedMonth.month + 1,
      0,
    ).day;

    final firstDayOfMonth = DateTime(
      _selectedMonth.year,
      _selectedMonth.month,
      1,
    );

    // Adjust for Saturday-start week (Saturday = 0)
    int firstWeekday = (firstDayOfMonth.weekday + 1) % 7;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final cells = <Widget>[];

    // Empty cells before first day
    for (int i = 0; i < firstWeekday; i++) {
      cells.add(const SizedBox());
    }

    // Day cells
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_selectedMonth.year, _selectedMonth.month, day);
      final bills = billsByDate[date] ?? [];
      final isToday = date == today;
      final isSelected = _selectedDay == date;

      cells.add(
        _buildDayCell(
          day: day,
          date: date,
          bills: bills,
          isToday: isToday,
          isSelected: isSelected,
          isDark: isDark,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: GridView.count(
        crossAxisCount: 7,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1,
        children: cells,
      ),
    );
  }

  Widget _buildDayCell({
    required int day,
    required DateTime date,
    required List<BillReminder> bills,
    required bool isToday,
    required bool isSelected,
    required bool isDark,
  }) {
    // Determine dot color based on bills
    Color? dotColor;

    if (bills.isNotEmpty) {
      // Find most urgent bill tone
      final hasUrgent = bills.any((b) => b.tone == BillTone.urgent);
      final hasWarning = bills.any((b) => b.tone == BillTone.warning);

      if (hasUrgent) {
        dotColor = isDark ? AppColors.danger : AppColors.lightDanger;
      } else if (hasWarning) {
        dotColor = isDark ? AppColors.warning : AppColors.lightWarning;
      } else {
        dotColor = isDark ? AppColors.success : AppColors.lightSuccess;
      }
    }

    return GestureDetector(
      onTap: bills.isNotEmpty
          ? () {
              setState(() {
                _selectedDay = isSelected ? null : date;
              });
              if (!isSelected && widget.onDayTap != null) {
                widget.onDayTap!(date, bills);
              }
            }
          : null,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.primary : AppColors.lightPrimary)
                  .withValues(alpha: 0.15)
              : isToday
                  ? (isDark ? AppColors.primary : AppColors.lightPrimary)
                      .withValues(alpha: 0.08)
                  : null,
          borderRadius: BorderRadius.circular(8),
          border: isToday
              ? Border.all(
                  color: isDark ? AppColors.primary : AppColors.lightPrimary,
                  width: 1.5,
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: TextStyle(
                color: isSelected
                    ? (isDark ? AppColors.primary : AppColors.lightPrimary)
                    : isToday
                        ? (isDark ? AppColors.primary : AppColors.lightPrimary)
                        : (isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary),
                fontSize: 13,
                fontWeight: isToday || isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (dotColor != null) ...[
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  // Show additional dot if multiple bills
                  if (bills.length > 1) ...[
                    const SizedBox(width: 2),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: dotColor.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedDayDetails(List<BillReminder> bills, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark
                ? AppColors.surfaceLight
                : AppColors.lightSurfaceContainerHighest,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الفواتير المستحقة',
            style: TextStyle(
              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...bills.map((bill) => _buildBillItem(bill, isDark)),
        ],
      ),
    );
  }

  Widget _buildBillItem(BillReminder bill, bool isDark) {
    final toneColor = switch (bill.tone) {
      BillTone.urgent => isDark ? AppColors.danger : AppColors.lightDanger,
      BillTone.warning => isDark ? AppColors.warning : AppColors.lightWarning,
      BillTone.encouraging => isDark ? AppColors.success : AppColors.lightSuccess,
      BillTone.neutral => isDark ? AppColors.primary : AppColors.lightPrimary,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: toneColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: toneColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: toneColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bill.bill.name,
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  bill.message,
                  style: TextStyle(
                    color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                    fontSize: 11,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            CurrencyFormatter.format(bill.bill.amount),
            style: TextStyle(
              color: toneColor,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact calendar for dashboard or small spaces
class BillCalendarCompact extends ConsumerWidget {
  final VoidCallback? onTap;

  const BillCalendarCompact({super.key, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final summaryAsync = ref.watch(billSummaryProvider);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceLight.withValues(alpha: 0.5)
              : AppColors.lightSurfaceContainerLow,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isDark
                ? AppColors.surfaceLight
                : AppColors.lightSurfaceContainerHighest,
          ),
        ),
        child: summaryAsync.when(
          loading: () => const SizedBox(
            height: 40,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (e, st) => const Text('خطأ'),
          data: (summary) => Row(
            children: [
              Icon(
                Icons.calendar_month_rounded,
                color: summary.hasIssues
                    ? (isDark ? AppColors.warning : AppColors.lightWarning)
                    : (isDark ? AppColors.primary : AppColors.lightPrimary),
                size: 24,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الفواتير القادمة',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      summary.nextBill != null
                          ? '${summary.nextBill!.bill.name} ${_getDaysText(summary.nextBill!.daysUntilDue)}'
                          : 'لا توجد فواتير قريبة',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (summary.totalBills > 0) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: (summary.hasIssues
                            ? (isDark ? AppColors.warning : AppColors.lightWarning)
                            : (isDark ? AppColors.primary : AppColors.lightPrimary))
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Text(
                    '${summary.totalBills}',
                    style: TextStyle(
                      color: summary.hasIssues
                          ? (isDark ? AppColors.warning : AppColors.lightWarning)
                          : (isDark ? AppColors.primary : AppColors.lightPrimary),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDaysText(int days) {
    if (days == 0) return 'اليوم';
    if (days == 1) return 'بكرة';
    if (days == 2) return 'بعد بكرة';
    return 'خلال $days أيام';
  }
}
