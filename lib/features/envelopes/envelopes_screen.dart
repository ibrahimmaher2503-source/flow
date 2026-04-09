import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/smart_feature_models.dart';
import '../../providers/envelope_provider.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/loading_shimmer.dart';
import 'widgets/envelope_card.dart';
import 'widgets/envelope_form_sheet.dart';
import 'widgets/envelope_summary_bar.dart';

/// Main envelope budgeting screen
class EnvelopesScreen extends ConsumerStatefulWidget {
  const EnvelopesScreen({super.key});

  @override
  ConsumerState<EnvelopesScreen> createState() => _EnvelopesScreenState();
}

class _EnvelopesScreenState extends ConsumerState<EnvelopesScreen> {
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;

  bool get _isCurrentMonth =>
      _selectedYear == DateTime.now().year &&
      _selectedMonth == DateTime.now().month;

  String get _monthLabel {
    const months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return '${months[_selectedMonth - 1]} $_selectedYear';
  }

  void _previousMonth() {
    setState(() {
      if (_selectedMonth == 1) {
        _selectedMonth = 12;
        _selectedYear--;
      } else {
        _selectedMonth--;
      }
    });
  }

  void _nextMonth() {
    // Don't allow going beyond current month
    final now = DateTime.now();
    if (_selectedYear > now.year ||
        (_selectedYear == now.year && _selectedMonth >= now.month)) {
      return;
    }
    setState(() {
      if (_selectedMonth == 12) {
        _selectedMonth = 1;
        _selectedYear++;
      } else {
        _selectedMonth++;
      }
    });
  }

  Future<void> _copyFromPrevious() async {
    final service = ref.read(envelopeServiceProvider);
    try {
      await service.copyFromPreviousMonth(
        year: _selectedYear,
        month: _selectedMonth,
      );
      refreshEnvelopes(ref);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم نسخ الأظرف من الشهر السابق')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e')),
        );
      }
    }
  }

  Future<void> _showCreateSheet() async {
    final result = await showEnvelopeFormSheet(context);
    if (result == true) {
      refreshEnvelopes(ref);
    }
  }

  Future<void> _showEditSheet(EnvelopeWithSpent envelope) async {
    final result = await showEnvelopeFormSheet(
      context,
      envelope: envelope.envelope,
    );
    if (result == true) {
      refreshEnvelopes(ref);
    }
  }

  Future<void> _confirmDelete(EnvelopeWithSpent envelope) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.surface : AppColors.lightSurface,
        title: Text(
          'حذف الظرف',
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ),
        content: Text(
          'هل تريد حذف ظرف "${envelope.envelope.name}"؟',
          style: TextStyle(
            color:
                isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'إلغاء',
              style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'حذف',
              style: TextStyle(
                color: isDark ? AppColors.danger : AppColors.lightDanger,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref
          .read(envelopeServiceProvider)
          .deleteEnvelope(envelope.envelope.id);
      refreshEnvelopes(ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final envelopesAsync = ref.watch(
      monthEnvelopesProvider((year: _selectedYear, month: _selectedMonth)),
    );

    return Scaffold(
      backgroundColor: isDark ? AppColors.background : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surface : AppColors.lightSurface,
        title: Text(
          'الأظرف',
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          // Allocate income button
          IconButton(
            icon: Icon(
              Icons.add_chart_rounded,
              color: isDark ? AppColors.primary : AppColors.lightPrimary,
            ),
            tooltip: 'توزيع دخل',
            onPressed: () {
              Navigator.pushNamed(context, '/envelopes/allocate');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Month selector
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            color: isDark ? AppColors.surface : AppColors.lightSurface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.chevron_right_rounded,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  onPressed: _nextMonth,
                ),
                GestureDetector(
                  onTap: () {
                    // Reset to current month
                    setState(() {
                      _selectedYear = DateTime.now().year;
                      _selectedMonth = DateTime.now().month;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        _monthLabel,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (!_isCurrentMonth)
                        Text(
                          'انقر للعودة للشهر الحالي',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.chevron_left_rounded,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  onPressed: _previousMonth,
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: envelopesAsync.when(
              loading: () => _buildLoading(isDark),
              error: (e, _) => _buildError(e.toString(), isDark),
              data: (envelopes) {
                if (envelopes.isEmpty) {
                  return _buildEmpty(isDark);
                }
                return _buildContent(envelopes, isDark);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateSheet,
        backgroundColor: isDark ? AppColors.primary : AppColors.lightPrimary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('ظرف جديد'),
      ),
    );
  }

  Widget _buildLoading(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const LoadingShimmer(height: 120),
          const SizedBox(height: AppSpacing.lg),
          ...List.generate(
            3,
            (i) => const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md),
              child: LoadingShimmer(height: 180),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error, bool isDark) {
    return Center(
      child: EmptyState(
        icon: Icons.error_outline_rounded,
        message: 'حدث خطأ',
        subtitle: error,
        variant: EmptyStateVariant.warning,
      ),
    );
  }

  Widget _buildEmpty(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EmptyState(
            icon: Icons.mail_outline_rounded,
            message: 'لا توجد أظرف',
            subtitle: 'أنشئ أظرف لتوزيع ميزانيتك على الفئات المختلفة',
            variant: EmptyStateVariant.neutral,
          ),
          const SizedBox(height: AppSpacing.xl),
          // Copy from previous month button
          OutlinedButton.icon(
            onPressed: _copyFromPrevious,
            icon: const Icon(Icons.content_copy_rounded),
            label: const Text('نسخ من الشهر السابق'),
            style: OutlinedButton.styleFrom(
              foregroundColor:
                  isDark ? AppColors.primary : AppColors.lightPrimary,
              side: BorderSide(
                color: isDark ? AppColors.primary : AppColors.lightPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(List<EnvelopeWithSpent> envelopes, bool isDark) {
    // Sort by status (danger first), then by essential
    final sorted = List<EnvelopeWithSpent>.from(envelopes)
      ..sort((a, b) {
        // Empty/danger envelopes first
        final statusA = _statusPriority(a.status);
        final statusB = _statusPriority(b.status);
        if (statusA != statusB) return statusA.compareTo(statusB);

        // Then essential
        if (a.envelope.isEssential != b.envelope.isEssential) {
          return a.envelope.isEssential ? -1 : 1;
        }

        // Then by sort order
        return a.envelope.sortOrder.compareTo(b.envelope.sortOrder);
      });

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(
          monthEnvelopesProvider((year: _selectedYear, month: _selectedMonth)),
        );
      },
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // Summary bar at top
          const EnvelopeSummaryBar(),
          const SizedBox(height: AppSpacing.xl),

          // Envelope cards
          ...sorted.map(
            (envelope) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: EnvelopeCard(
                envelope: envelope,
                onTap: () => _showEditSheet(envelope),
                onEdit: () => _showEditSheet(envelope),
                onDelete: () => _confirmDelete(envelope),
              ),
            ),
          ),

          // Bottom padding for FAB
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  int _statusPriority(EnvelopeStatus status) {
    switch (status) {
      case EnvelopeStatus.empty:
        return 0;
      case EnvelopeStatus.danger:
        return 1;
      case EnvelopeStatus.warning:
        return 2;
      case EnvelopeStatus.healthy:
        return 3;
    }
  }
}
