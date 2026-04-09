import 'package:isar/isar.dart';
import '../models/insight_model.dart';
import '../models/transaction_model.dart';
import '../models/smart_feature_models.dart';
import '../repositories/insight_repo.dart';

/// Service for generating smart insights about spending patterns
class InsightsService {
  final Isar isar;
  final InsightRepo _repo;

  InsightsService(this.isar) : _repo = InsightRepo(isar);

  /// Generate all insights for the current period
  Future<List<Insight>> generateInsights() async {
    final insights = <Insight>[];

    // Run all detection algorithms
    final spendingSpike = await detectSpendingSpike();
    if (spendingSpike != null) insights.add(spendingSpike);

    final streak = await detectStreak();
    if (streak != null) insights.add(streak);

    final monthlySummary = await generateMonthlySummary();
    if (monthlySummary != null) insights.add(monthlySummary);

    final savingsOpportunity = await detectSavingsOpportunity();
    if (savingsOpportunity != null) insights.add(savingsOpportunity);

    final unusualTransactions = await detectUnusualTransactions();
    insights.addAll(unusualTransactions);

    final positiveReinforcement = await detectPositiveReinforcement();
    if (positiveReinforcement != null) insights.add(positiveReinforcement);

    // Add insights to database (deduplicated by hash)
    final addedInsights = <Insight>[];
    for (final insight in insights) {
      final added = await _repo.addIfNew(insight);
      if (added != null) {
        addedInsights.add(added);
      }
    }

    return addedInsights;
  }

  /// T051: Detect spending spike (>30% above 3-month avg for a category)
  Future<Insight?> detectSpendingSpike() async {
    final now = DateTime.now();
    final currentMonthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';

    // Get current month expenses by category
    final currentMonthExpenses = await _getExpensesByCategory(
      now.year,
      now.month,
    );

    // Get 3-month average by category
    final threeMonthAvg = await _getThreeMonthAverage();

    // Find categories with >30% spike
    String? worstCategory;
    double worstSpikePercent = 0;
    double worstCurrentAmount = 0;
    double worstAvgAmount = 0;

    for (final entry in currentMonthExpenses.entries) {
      final category = entry.key;
      final currentAmount = entry.value;
      final avgAmount = threeMonthAvg[category] ?? 0;

      if (avgAmount > 0) {
        final spikePercent = ((currentAmount - avgAmount) / avgAmount) * 100;
        if (spikePercent > 30 && spikePercent > worstSpikePercent) {
          worstCategory = category;
          worstSpikePercent = spikePercent;
          worstCurrentAmount = currentAmount;
          worstAvgAmount = avgAmount;
        }
      }
    }

    if (worstCategory == null) return null;

    final hash = _generateHash('spending_spike', '$worstCategory-$currentMonthKey');

    return Insight()
      ..type = InsightType.spendingSpike.value
      ..titleAr = 'مصاريف $worstCategory زادت'
      ..descriptionAr = 'صرفت ${worstCurrentAmount.toStringAsFixed(0)} جنيه هذا الشهر مقارنة بمتوسط ${worstAvgAmount.toStringAsFixed(0)} جنيه (${worstSpikePercent.toStringAsFixed(0)}% زيادة)'
      ..priority = 1
      ..iconName = 'trending_up'
      ..colorHex = 'FF5252'
      ..actionRoute = '/transactions?category=$worstCategory'
      ..hash = hash
      ..monthKey = currentMonthKey
      ..generatedAt = DateTime.now();
  }

  /// T052: Detect streak (7+ consecutive days logging)
  Future<Insight?> detectStreak() async {
    final now = DateTime.now();
    final currentMonthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';

    // Get distinct transaction dates in last 30 days
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    final transactions = await isar.transactions
        .filter()
        .dateGreaterThan(thirtyDaysAgo)
        .sortByDateDesc()
        .findAll();

    if (transactions.isEmpty) return null;

    // Find consecutive days streak
    final distinctDays = <String>{};
    for (final t in transactions) {
      final key = '${t.date.year}-${t.date.month}-${t.date.day}';
      distinctDays.add(key);
    }

    int currentStreak = 0;
    int maxStreak = 0;
    DateTime checkDate = DateTime(now.year, now.month, now.day);

    // Count backwards from today
    for (int i = 0; i < 30; i++) {
      final key = '${checkDate.year}-${checkDate.month}-${checkDate.day}';
      if (distinctDays.contains(key)) {
        currentStreak++;
        if (currentStreak > maxStreak) maxStreak = currentStreak;
      } else {
        if (i == 0) {
          // Today has no transactions, but check yesterday
          currentStreak = 0;
        } else {
          break; // Streak broken
        }
      }
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    if (maxStreak < 7) return null;

    final hash = _generateHash('streak', '$maxStreak-$currentMonthKey');

    String message;
    int priority;
    if (maxStreak >= 30) {
      message = 'شهر كامل! بتسجل كل يوم 🔥';
      priority = 3;
    } else if (maxStreak >= 14) {
      message = 'أسبوعين متواصلين! استمر 💪';
      priority = 3;
    } else {
      message = 'أسبوع متواصل من التسجيل';
      priority = 3;
    }

    return Insight()
      ..type = InsightType.streak.value
      ..titleAr = '$maxStreak يوم streak!'
      ..descriptionAr = message
      ..priority = priority
      ..iconName = 'local_fire_department'
      ..colorHex = 'FF9800'
      ..hash = hash
      ..monthKey = currentMonthKey
      ..generatedAt = DateTime.now();
  }

  /// T053: Generate monthly summary
  Future<Insight?> generateMonthlySummary() async {
    final now = DateTime.now();

    // Only generate at end of month (last 3 days) or start of new month (first 3 days)
    if (now.day > 3 && now.day < 28) return null;

    final targetYear = now.day <= 3 && now.month > 1 ? now.year : now.year;
    final targetMonth = now.day <= 3 && now.month > 1 ? now.month - 1 : now.month;
    final monthKey = '$targetYear-${targetMonth.toString().padLeft(2, '0')}';

    // Get month totals
    final expenses = await _getTotalExpenses(targetYear, targetMonth);
    final income = await _getTotalIncome(targetYear, targetMonth);
    final savings = income - expenses;
    final transactionCount = await _getTransactionCount(targetYear, targetMonth);

    if (transactionCount == 0) return null;

    final hash = _generateHash('monthly_summary', monthKey);

    final monthNames = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];

    String savingsText;
    int priority;
    String colorHex;

    if (savings > 0) {
      savingsText = 'وفرت ${savings.toStringAsFixed(0)} جنيه';
      priority = 3;
      colorHex = '4CAF50';
    } else if (savings == 0) {
      savingsText = 'التعادل - مصروفاتك = دخلك';
      priority = 2;
      colorHex = 'FFC107';
    } else {
      savingsText = 'تجاوزت ميزانيتك بـ ${savings.abs().toStringAsFixed(0)} جنيه';
      priority = 1;
      colorHex = 'FF5252';
    }

    return Insight()
      ..type = InsightType.monthlySummary.value
      ..titleAr = 'ملخص ${monthNames[targetMonth - 1]}'
      ..descriptionAr = 'دخل: ${income.toStringAsFixed(0)} جنيه | مصاريف: ${expenses.toStringAsFixed(0)} جنيه\n$savingsText'
      ..priority = priority
      ..iconName = 'summarize'
      ..colorHex = colorHex
      ..hash = hash
      ..monthKey = monthKey
      ..generatedAt = DateTime.now();
  }

  /// T054: Detect savings opportunity
  Future<Insight?> detectSavingsOpportunity() async {
    final now = DateTime.now();
    final currentMonthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';

    // Find category with highest discretionary spending
    final expenses = await _getExpensesByCategory(now.year, now.month);

    // Define discretionary categories (exclude essentials like rent, utilities)
    const essentialCategories = {'إيجار', 'كهرباء', 'غاز', 'مياه', 'انترنت', 'صحة'};

    String? highestCategory;
    double highestAmount = 0;

    for (final entry in expenses.entries) {
      if (!essentialCategories.contains(entry.key) && entry.value > highestAmount) {
        highestCategory = entry.key;
        highestAmount = entry.value;
      }
    }

    if (highestCategory == null || highestAmount < 500) return null;

    // Calculate potential savings (10% reduction)
    final potentialSavings = highestAmount * 0.1;

    final hash = _generateHash('savings_opportunity', '$highestCategory-$currentMonthKey');

    return Insight()
      ..type = InsightType.savingsOpportunity.value
      ..titleAr = 'فرصة توفير في $highestCategory'
      ..descriptionAr = 'لو قللت 10% من $highestCategory ممكن توفر ${potentialSavings.toStringAsFixed(0)} جنيه الشهر ده'
      ..priority = 3
      ..iconName = 'savings'
      ..colorHex = '4CAF50'
      ..actionRoute = '/transactions?category=$highestCategory'
      ..hash = hash
      ..monthKey = currentMonthKey
      ..generatedAt = DateTime.now();
  }

  /// T055: Detect unusual transactions (>3x category avg)
  Future<List<Insight>> detectUnusualTransactions() async {
    final now = DateTime.now();
    final currentMonthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    final insights = <Insight>[];

    // Get average transaction amount by category
    final categoryAvg = await _getCategoryTransactionAverage();

    // Get recent transactions (last 7 days)
    final weekAgo = now.subtract(const Duration(days: 7));
    final recentTransactions = await isar.transactions
        .filter()
        .typeEqualTo('expense')
        .dateGreaterThan(weekAgo)
        .findAll();

    for (final t in recentTransactions) {
      final avgAmount = categoryAvg[t.category] ?? 0;
      if (avgAmount > 0 && t.amount > avgAmount * 3) {
        final hash = _generateHash('unusual_transaction', '${t.id}-${t.amount}');

        // Check if already exists
        final existing = await _repo.getByHash(hash);
        if (existing != null) continue;

        insights.add(Insight()
          ..type = InsightType.unusualTransaction.value
          ..titleAr = 'معاملة غير عادية'
          ..descriptionAr = '${t.amount.toStringAsFixed(0)} جنيه في ${t.category} - أكثر من 3 أضعاف المتوسط (${avgAmount.toStringAsFixed(0)} جنيه)'
          ..priority = 2
          ..iconName = 'warning_amber'
          ..colorHex = 'FFC107'
          ..actionRoute = '/transactions/${t.id}'
          ..hash = hash
          ..monthKey = currentMonthKey
          ..generatedAt = DateTime.now());
      }
    }

    return insights;
  }

  /// T056: Detect positive reinforcement (spending down vs last month)
  Future<Insight?> detectPositiveReinforcement() async {
    final now = DateTime.now();

    // Only check after mid-month
    if (now.day < 15) return null;

    final currentMonthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';

    // Compare spending pace with last month
    final currentExpenses = await _getTotalExpenses(now.year, now.month);

    final lastMonthYear = now.month == 1 ? now.year - 1 : now.year;
    final lastMonth = now.month == 1 ? 12 : now.month - 1;
    final lastMonthExpenses = await _getTotalExpenses(lastMonthYear, lastMonth);

    if (lastMonthExpenses == 0) return null;

    // Adjust for day of month (pace comparison)
    final daysInCurrentMonth = DateTime(now.year, now.month + 1, 0).day;
    final projectedMonthEnd = (currentExpenses / now.day) * daysInCurrentMonth;

    final percentChange = ((projectedMonthEnd - lastMonthExpenses) / lastMonthExpenses) * 100;

    // Only show if spending is down by >10%
    if (percentChange > -10) return null;

    final hash = _generateHash('positive_reinforcement', currentMonthKey);

    return Insight()
      ..type = InsightType.positiveReinforcement.value
      ..titleAr = 'مصاريفك أقل هذا الشهر!'
      ..descriptionAr = 'بناءً على معدلك الحالي، هتصرف ${percentChange.abs().toStringAsFixed(0)}% أقل من الشهر اللي فات'
      ..priority = 3
      ..iconName = 'thumb_up'
      ..colorHex = '4CAF50'
      ..hash = hash
      ..monthKey = currentMonthKey
      ..generatedAt = DateTime.now();
  }

  // Helper methods

  Future<Map<String, double>> _getExpensesByCategory(int year, int month) async {
    final monthKey = '$year-${month.toString().padLeft(2, '0')}';
    final transactions = await isar.transactions
        .filter()
        .monthKeyEqualTo(monthKey)
        .typeEqualTo('expense')
        .findAll();

    final result = <String, double>{};
    for (final t in transactions) {
      result[t.category] = (result[t.category] ?? 0) + t.amount;
    }
    return result;
  }

  Future<Map<String, double>> _getThreeMonthAverage() async {
    final now = DateTime.now();
    final result = <String, double>{};
    final counts = <String, int>{};

    for (int i = 1; i <= 3; i++) {
      final targetDate = DateTime(now.year, now.month - i, 1);
      final expenses = await _getExpensesByCategory(targetDate.year, targetDate.month);

      for (final entry in expenses.entries) {
        result[entry.key] = (result[entry.key] ?? 0) + entry.value;
        counts[entry.key] = (counts[entry.key] ?? 0) + 1;
      }
    }

    // Calculate averages
    for (final key in result.keys) {
      result[key] = result[key]! / (counts[key] ?? 1);
    }

    return result;
  }

  Future<double> _getTotalExpenses(int year, int month) async {
    final monthKey = '$year-${month.toString().padLeft(2, '0')}';
    final transactions = await isar.transactions
        .filter()
        .monthKeyEqualTo(monthKey)
        .typeEqualTo('expense')
        .findAll();
    return transactions.fold<double>(0, (sum, t) => sum + t.amount);
  }

  Future<double> _getTotalIncome(int year, int month) async {
    final monthKey = '$year-${month.toString().padLeft(2, '0')}';
    final transactions = await isar.transactions
        .filter()
        .monthKeyEqualTo(monthKey)
        .typeEqualTo('income')
        .findAll();
    return transactions.fold<double>(0, (sum, t) => sum + t.amount);
  }

  Future<int> _getTransactionCount(int year, int month) async {
    final monthKey = '$year-${month.toString().padLeft(2, '0')}';
    return isar.transactions
        .filter()
        .monthKeyEqualTo(monthKey)
        .count();
  }

  Future<Map<String, double>> _getCategoryTransactionAverage() async {
    final now = DateTime.now();
    final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);

    final transactions = await isar.transactions
        .filter()
        .typeEqualTo('expense')
        .dateGreaterThan(threeMonthsAgo)
        .findAll();

    final totals = <String, double>{};
    final counts = <String, int>{};

    for (final t in transactions) {
      totals[t.category] = (totals[t.category] ?? 0) + t.amount;
      counts[t.category] = (counts[t.category] ?? 0) + 1;
    }

    final averages = <String, double>{};
    for (final key in totals.keys) {
      averages[key] = totals[key]! / counts[key]!;
    }

    return averages;
  }

  String _generateHash(String type, String params) {
    final input = '$type:$params';
    // Use Dart's built-in hashCode for deduplication
    return input.hashCode.toRadixString(16);
  }
}
