import 'envelope_model.dart';

// ===== Safe-to-Spend Models =====

enum SpendingVelocity { slow, normal, fast }
enum HealthStatus { healthy, caution, danger }
enum ObligationType { installment, recurring, goal }

class ObligationItem {
  final String name;
  final double amount;
  final DateTime? dueDate;
  final ObligationType type;

  const ObligationItem({
    required this.name,
    required this.amount,
    this.dueDate,
    required this.type,
  });
}

class SafeToSpendData {
  final double safeAmount;
  final double totalBalance;
  final double upcomingInstallments;
  final double upcomingRecurring;
  final double unmetGoalContributions;
  final double percentOfBalance;
  final SpendingVelocity velocity;
  final List<ObligationItem> breakdown;

  const SafeToSpendData({
    required this.safeAmount,
    required this.totalBalance,
    required this.upcomingInstallments,
    required this.upcomingRecurring,
    required this.unmetGoalContributions,
    required this.percentOfBalance,
    required this.velocity,
    required this.breakdown,
  });

  bool get isNegative => safeAmount <= 0;

  HealthStatus get healthStatus {
    if (percentOfBalance > 0.30) return HealthStatus.healthy;
    if (percentOfBalance > 0.10) return HealthStatus.caution;
    return HealthStatus.danger;
  }

  /// Empty state for loading/error scenarios
  static const empty = SafeToSpendData(
    safeAmount: 0,
    totalBalance: 0,
    upcomingInstallments: 0,
    upcomingRecurring: 0,
    unmetGoalContributions: 0,
    percentOfBalance: 0,
    velocity: SpendingVelocity.normal,
    breakdown: [],
  );
}

// ===== Envelope with Spent Models =====

enum EnvelopeStatus { healthy, warning, danger, empty }

class EnvelopeWithSpent {
  final Envelope envelope;
  final double spentAmount;

  const EnvelopeWithSpent({
    required this.envelope,
    required this.spentAmount,
  });

  double get remaining => envelope.allocatedAmount - spentAmount;

  double get percentRemaining =>
      envelope.allocatedAmount > 0 ? remaining / envelope.allocatedAmount : 0;

  double get percentSpent =>
      envelope.allocatedAmount > 0 ? spentAmount / envelope.allocatedAmount : 0;

  EnvelopeStatus get status {
    if (percentRemaining <= 0) return EnvelopeStatus.empty;
    if (percentRemaining < 0.20) return EnvelopeStatus.danger;
    if (percentRemaining < 0.50) return EnvelopeStatus.warning;
    return EnvelopeStatus.healthy;
  }

  bool get isOverspent => spentAmount > envelope.allocatedAmount;
}

// ===== Forecast Models =====

enum ForecastEventType { income, expense, installment, bill }
enum ForecastScenario { optimistic, realistic, pessimistic }

class ForecastEvent {
  final String name;
  final double amount;
  final ForecastEventType type;

  const ForecastEvent({
    required this.name,
    required this.amount,
    required this.type,
  });
}

class ForecastDay {
  final DateTime date;
  final double optimisticBalance;
  final double realisticBalance;
  final double pessimisticBalance;
  final List<ForecastEvent> events;

  const ForecastDay({
    required this.date,
    required this.optimisticBalance,
    required this.realisticBalance,
    required this.pessimisticBalance,
    required this.events,
  });
}

class ForecastSummary {
  final double expectedMonthEndBalance;
  final ForecastEvent? nextObligation;
  final int safetyDays; // Days until pessimistic goes negative

  const ForecastSummary({
    required this.expectedMonthEndBalance,
    this.nextObligation,
    required this.safetyDays,
  });
}

class ForecastAssumptions {
  final double dailySpendingOptimistic;
  final double dailySpendingRealistic;
  final double dailySpendingPessimistic;
  final List<String> includedRecurring;
  final List<String> includedInstallments;

  const ForecastAssumptions({
    required this.dailySpendingOptimistic,
    required this.dailySpendingRealistic,
    required this.dailySpendingPessimistic,
    required this.includedRecurring,
    required this.includedInstallments,
  });
}

class ForecastWarning {
  final DateTime date;
  final String messageAr;
  final ForecastScenario scenario;

  const ForecastWarning({
    required this.date,
    required this.messageAr,
    required this.scenario,
  });
}

class ForecastData {
  final List<ForecastDay> days;
  final ForecastSummary summary;
  final ForecastAssumptions assumptions;
  final List<ForecastWarning> warnings;

  const ForecastData({
    required this.days,
    required this.summary,
    required this.assumptions,
    required this.warnings,
  });

  /// Empty state for loading/error scenarios
  static final empty = ForecastData(
    days: [],
    summary: const ForecastSummary(
      expectedMonthEndBalance: 0,
      safetyDays: 0,
    ),
    assumptions: const ForecastAssumptions(
      dailySpendingOptimistic: 0,
      dailySpendingRealistic: 0,
      dailySpendingPessimistic: 0,
      includedRecurring: [],
      includedInstallments: [],
    ),
    warnings: [],
  );
}

// ===== Bill Reminder Models =====

enum CoverageStatus { comfortable, tight, needsTransfer, critical }

class BillContext {
  final String name;
  final double amount;
  final DateTime dueDate;
  final int daysUntil;
  final CoverageStatus coverage;
  final String messageAr;
  final bool isPredicted; // From SMS detection vs. confirmed recurring

  const BillContext({
    required this.name,
    required this.amount,
    required this.dueDate,
    required this.daysUntil,
    required this.coverage,
    required this.messageAr,
    this.isPredicted = false,
  });

  bool get isDueSoon => daysUntil <= 3;
  bool get isDueToday => daysUntil == 0;
  bool get isOverdue => daysUntil < 0;
}

// ===== Tag Analytics Models =====

class TagAnalytics {
  final String tagName;
  final int transactionCount;
  final double totalAmount;
  final double averageAmount;
  final DateTime? firstUsed;
  final DateTime? lastUsed;
  final Map<String, double> categoryBreakdown;

  const TagAnalytics({
    required this.tagName,
    required this.transactionCount,
    required this.totalAmount,
    required this.averageAmount,
    this.firstUsed,
    this.lastUsed,
    required this.categoryBreakdown,
  });
}

// ===== Insight Display Models =====

enum InsightType {
  spendingSpike,
  savingsOpportunity,
  streak,
  dayPattern,
  categoryShift,
  goalProgress,
  monthlySummary,
  unusualTransaction,
  positiveReinforcement,
}

extension InsightTypeExtension on InsightType {
  String get value {
    switch (this) {
      case InsightType.spendingSpike:
        return 'spending_spike';
      case InsightType.savingsOpportunity:
        return 'savings_opportunity';
      case InsightType.streak:
        return 'streak';
      case InsightType.dayPattern:
        return 'day_pattern';
      case InsightType.categoryShift:
        return 'category_shift';
      case InsightType.goalProgress:
        return 'goal_progress';
      case InsightType.monthlySummary:
        return 'monthly_summary';
      case InsightType.unusualTransaction:
        return 'unusual_transaction';
      case InsightType.positiveReinforcement:
        return 'positive_reinforcement';
    }
  }

  static InsightType fromValue(String value) {
    switch (value) {
      case 'spending_spike':
        return InsightType.spendingSpike;
      case 'savings_opportunity':
        return InsightType.savingsOpportunity;
      case 'streak':
        return InsightType.streak;
      case 'day_pattern':
        return InsightType.dayPattern;
      case 'category_shift':
        return InsightType.categoryShift;
      case 'goal_progress':
        return InsightType.goalProgress;
      case 'monthly_summary':
        return InsightType.monthlySummary;
      case 'unusual_transaction':
        return InsightType.unusualTransaction;
      case 'positive_reinforcement':
        return InsightType.positiveReinforcement;
      default:
        return InsightType.monthlySummary;
    }
  }
}
