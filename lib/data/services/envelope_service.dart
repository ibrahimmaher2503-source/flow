import 'package:isar/isar.dart';
import '../models/envelope_model.dart';
import '../models/transaction_model.dart';
import '../models/smart_feature_models.dart';

/// Service for managing envelope budgeting
class EnvelopeService {
  final Isar isar;

  EnvelopeService(this.isar);

  /// Get all envelopes for a month with their spent amounts
  Future<List<EnvelopeWithSpent>> getEnvelopesWithSpent(int year, int month) async {
    final envelopes = await isar.envelopes
        .filter()
        .yearEqualTo(year)
        .monthEqualTo(month)
        .sortBySortOrder()
        .findAll();

    final monthKey = '$year-${month.toString().padLeft(2, '0')}';
    final result = <EnvelopeWithSpent>[];

    for (final envelope in envelopes) {
      final spent = await _getSpentForCategory(envelope.categoryName, monthKey);
      result.add(EnvelopeWithSpent(
        envelope: envelope,
        spentAmount: spent,
      ));
    }

    return result;
  }

  /// Get spent amount for a category in a month
  Future<double> _getSpentForCategory(String categoryName, String monthKey) async {
    final transactions = await isar.transactions
        .filter()
        .monthKeyEqualTo(monthKey)
        .categoryEqualTo(categoryName)
        .typeEqualTo('expense')
        .findAll();

    return transactions.fold<double>(0, (sum, t) => sum + t.amount);
  }

  /// Get a single envelope with spent amount
  Future<EnvelopeWithSpent?> getEnvelopeWithSpent(int envelopeId) async {
    final envelope = await isar.envelopes.get(envelopeId);
    if (envelope == null) return null;

    final monthKey = envelope.monthKey;
    final spent = await _getSpentForCategory(envelope.categoryName, monthKey);

    return EnvelopeWithSpent(
      envelope: envelope,
      spentAmount: spent,
    );
  }

  /// Get envelope for a category in current month
  Future<EnvelopeWithSpent?> getEnvelopeForCategory(String categoryName) async {
    final now = DateTime.now();
    final envelope = await isar.envelopes
        .filter()
        .categoryNameEqualTo(categoryName)
        .yearEqualTo(now.year)
        .monthEqualTo(now.month)
        .findFirst();

    if (envelope == null) return null;

    final spent = await _getSpentForCategory(categoryName, envelope.monthKey);
    return EnvelopeWithSpent(
      envelope: envelope,
      spentAmount: spent,
    );
  }

  /// Create a new envelope
  Future<Envelope> createEnvelope({
    required String name,
    required String categoryName,
    required double allocatedAmount,
    required String iconName,
    required String colorHex,
    bool isEssential = false,
    bool rolloverEnabled = false,
    int? year,
    int? month,
  }) async {
    final now = DateTime.now();
    final targetYear = year ?? now.year;
    final targetMonth = month ?? now.month;

    // Check if envelope for this category already exists this month
    final existing = await isar.envelopes
        .filter()
        .categoryNameEqualTo(categoryName)
        .yearEqualTo(targetYear)
        .monthEqualTo(targetMonth)
        .findFirst();

    if (existing != null) {
      throw Exception('Envelope for $categoryName already exists this month');
    }

    // Get next sort order
    final envelopes = await isar.envelopes
        .filter()
        .yearEqualTo(targetYear)
        .monthEqualTo(targetMonth)
        .findAll();
    final maxSort = envelopes.isEmpty
        ? 0
        : envelopes.map((e) => e.sortOrder).reduce((a, b) => a > b ? a : b);

    final envelope = Envelope()
      ..name = name
      ..categoryName = categoryName
      ..allocatedAmount = allocatedAmount
      ..iconName = iconName
      ..colorHex = colorHex
      ..isEssential = isEssential
      ..rolloverEnabled = rolloverEnabled
      ..sortOrder = maxSort + 1
      ..year = targetYear
      ..month = targetMonth
      ..createdAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.envelopes.put(envelope);
    });

    return envelope;
  }

  /// Update an existing envelope
  Future<void> updateEnvelope(Envelope envelope) async {
    await isar.writeTxn(() async {
      await isar.envelopes.put(envelope);
    });
  }

  /// Delete an envelope
  Future<void> deleteEnvelope(int id) async {
    await isar.writeTxn(() async {
      await isar.envelopes.delete(id);
    });
  }

  /// Get summary for current month
  Future<EnvelopeSummary> getMonthlySummary({int? year, int? month}) async {
    final now = DateTime.now();
    final targetYear = year ?? now.year;
    final targetMonth = month ?? now.month;

    final envelopesWithSpent = await getEnvelopesWithSpent(targetYear, targetMonth);

    double totalAllocated = 0;
    double totalSpent = 0;
    int overspentCount = 0;
    int warningCount = 0;

    for (final env in envelopesWithSpent) {
      totalAllocated += env.envelope.allocatedAmount;
      totalSpent += env.spentAmount;

      if (env.isOverspent) {
        overspentCount++;
      } else if (env.status == EnvelopeStatus.danger ||
                 env.status == EnvelopeStatus.warning) {
        warningCount++;
      }
    }

    return EnvelopeSummary(
      totalAllocated: totalAllocated,
      totalSpent: totalSpent,
      totalRemaining: totalAllocated - totalSpent,
      envelopeCount: envelopesWithSpent.length,
      overspentCount: overspentCount,
      warningCount: warningCount,
    );
  }

  /// Copy envelopes from previous month (for new month setup)
  Future<List<Envelope>> copyFromPreviousMonth({int? year, int? month}) async {
    final now = DateTime.now();
    final targetYear = year ?? now.year;
    final targetMonth = month ?? now.month;

    final prevYear = targetMonth == 1 ? targetYear - 1 : targetYear;
    final prevMonth = targetMonth == 1 ? 12 : targetMonth - 1;

    // Check if target month already has envelopes
    final existing = await isar.envelopes
        .filter()
        .yearEqualTo(targetYear)
        .monthEqualTo(targetMonth)
        .findAll();

    if (existing.isNotEmpty) {
      return existing; // Already set up
    }

    // Get previous month's envelopes
    final previousEnvelopes = await isar.envelopes
        .filter()
        .yearEqualTo(prevYear)
        .monthEqualTo(prevMonth)
        .sortBySortOrder()
        .findAll();

    if (previousEnvelopes.isEmpty) {
      return []; // Nothing to copy
    }

    final newEnvelopes = <Envelope>[];

    await isar.writeTxn(() async {
      for (final prev in previousEnvelopes) {
        double newAmount = prev.allocatedAmount;

        // Apply rollover if enabled
        if (prev.rolloverEnabled) {
          final prevSpent = await _getSpentForCategory(
            prev.categoryName,
            prev.monthKey,
          );
          final remaining = prev.allocatedAmount - prevSpent;
          if (remaining > 0) {
            newAmount += remaining; // Add unspent to new allocation
          }
        }

        final newEnvelope = Envelope()
          ..name = prev.name
          ..categoryName = prev.categoryName
          ..allocatedAmount = newAmount
          ..iconName = prev.iconName
          ..colorHex = prev.colorHex
          ..isEssential = prev.isEssential
          ..rolloverEnabled = prev.rolloverEnabled
          ..sortOrder = prev.sortOrder
          ..year = targetYear
          ..month = targetMonth
          ..createdAt = DateTime.now();

        await isar.envelopes.put(newEnvelope);
        newEnvelopes.add(newEnvelope);
      }
    });

    return newEnvelopes;
  }

  /// Distribute income across envelopes proportionally
  Future<Map<int, double>> distributeIncome(
    double amount, {
    int? year,
    int? month,
    bool essentialFirst = true,
  }) async {
    final now = DateTime.now();
    final targetYear = year ?? now.year;
    final targetMonth = month ?? now.month;

    final envelopesWithSpent = await getEnvelopesWithSpent(targetYear, targetMonth);
    if (envelopesWithSpent.isEmpty) return {};

    final distribution = <int, double>{};
    double remaining = amount;

    if (essentialFirst) {
      // First fill essential envelopes
      final essentials = envelopesWithSpent
          .where((e) => e.envelope.isEssential && e.remaining > 0)
          .toList();

      for (final env in essentials) {
        if (remaining <= 0) break;
        final needed = env.remaining;
        final toAllocate = needed < remaining ? needed : remaining;
        distribution[env.envelope.id] = toAllocate;
        remaining -= toAllocate;
      }
    }

    // Then distribute remaining proportionally to non-essential
    if (remaining > 0) {
      final others = envelopesWithSpent
          .where((e) => !e.envelope.isEssential || !essentialFirst)
          .where((e) => e.remaining > 0)
          .toList();

      final totalNeeded = others.fold<double>(0, (sum, e) => sum + e.remaining);

      if (totalNeeded > 0) {
        for (final env in others) {
          final proportion = env.remaining / totalNeeded;
          final toAllocate = (remaining * proportion).clamp(0, env.remaining);
          distribution[env.envelope.id] =
              (distribution[env.envelope.id] ?? 0) + toAllocate;
        }
      }
    }

    return distribution;
  }

  /// Check if adding an expense would overspend an envelope
  Future<EnvelopeOverageCheck> checkOverage(
    String categoryName,
    double amount,
  ) async {
    final envelope = await getEnvelopeForCategory(categoryName);

    if (envelope == null) {
      return EnvelopeOverageCheck(
        hasEnvelope: false,
        wouldOverspend: false,
        currentRemaining: 0,
        afterRemaining: 0,
      );
    }

    final afterRemaining = envelope.remaining - amount;

    return EnvelopeOverageCheck(
      hasEnvelope: true,
      wouldOverspend: afterRemaining < 0,
      currentRemaining: envelope.remaining,
      afterRemaining: afterRemaining,
      envelopeName: envelope.envelope.name,
    );
  }

  /// Get envelopes that need attention (low or empty)
  Future<List<EnvelopeWithSpent>> getEnvelopesNeedingAttention() async {
    final now = DateTime.now();
    final envelopes = await getEnvelopesWithSpent(now.year, now.month);

    return envelopes
        .where((e) =>
            e.status == EnvelopeStatus.danger ||
            e.status == EnvelopeStatus.warning ||
            e.status == EnvelopeStatus.empty)
        .toList();
  }
}

/// Summary data for envelope display
class EnvelopeSummary {
  final double totalAllocated;
  final double totalSpent;
  final double totalRemaining;
  final int envelopeCount;
  final int overspentCount;
  final int warningCount;

  const EnvelopeSummary({
    required this.totalAllocated,
    required this.totalSpent,
    required this.totalRemaining,
    required this.envelopeCount,
    required this.overspentCount,
    required this.warningCount,
  });

  double get percentSpent =>
      totalAllocated > 0 ? totalSpent / totalAllocated : 0;

  bool get isHealthy => overspentCount == 0 && warningCount == 0;
}

/// Result of checking if expense would overspend
class EnvelopeOverageCheck {
  final bool hasEnvelope;
  final bool wouldOverspend;
  final double currentRemaining;
  final double afterRemaining;
  final String? envelopeName;

  const EnvelopeOverageCheck({
    required this.hasEnvelope,
    required this.wouldOverspend,
    required this.currentRemaining,
    required this.afterRemaining,
    this.envelopeName,
  });
}
