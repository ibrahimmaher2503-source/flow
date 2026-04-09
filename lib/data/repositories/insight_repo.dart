import 'package:isar/isar.dart';
import '../models/insight_model.dart';

class InsightRepo {
  final Isar isar;

  InsightRepo(this.isar);

  Future<List<Insight>> getAll() async {
    return isar.insights.where().findAll();
  }

  /// Get active (non-dismissed) insights sorted by priority
  Future<List<Insight>> getActive() async {
    return isar.insights
        .filter()
        .isDismissedEqualTo(false)
        .sortByPriority()
        .thenByGeneratedAtDesc()
        .findAll();
  }

  /// Get active insights for a specific month
  Future<List<Insight>> getActiveByMonth(String monthKey) async {
    return isar.insights
        .filter()
        .isDismissedEqualTo(false)
        .monthKeyEqualTo(monthKey)
        .sortByPriority()
        .thenByGeneratedAtDesc()
        .findAll();
  }

  /// Get top N active insights for dashboard
  Future<List<Insight>> getTopActive({int limit = 5}) async {
    return isar.insights
        .filter()
        .isDismissedEqualTo(false)
        .sortByPriority()
        .thenByGeneratedAtDesc()
        .limit(limit)
        .findAll();
  }

  /// Get dismissed insights
  Future<List<Insight>> getDismissed() async {
    return isar.insights
        .filter()
        .isDismissedEqualTo(true)
        .sortByDismissedAtDesc()
        .findAll();
  }

  Future<Insight?> getById(int id) async {
    return isar.insights.get(id);
  }

  /// Check if insight with hash already exists
  Future<Insight?> getByHash(String hash) async {
    return isar.insights.filter().hashEqualTo(hash).findFirst();
  }

  Future<int> add(Insight insight) async {
    return isar.writeTxn(() async {
      return isar.insights.put(insight);
    });
  }

  /// Add insight only if it doesn't exist (by hash)
  Future<Insight?> addIfNew(Insight insight) async {
    final existing = await getByHash(insight.hash);
    if (existing != null) {
      return null; // Already exists
    }
    await add(insight);
    return insight;
  }

  Future<void> update(Insight insight) async {
    await isar.writeTxn(() async {
      await isar.insights.put(insight);
    });
  }

  Future<void> delete(int id) async {
    await isar.writeTxn(() async {
      await isar.insights.delete(id);
    });
  }

  /// Dismiss an insight
  Future<void> dismiss(int id) async {
    final insight = await getById(id);
    if (insight != null) {
      insight.isDismissed = true;
      insight.dismissedAt = DateTime.now();
      await update(insight);
    }
  }

  /// Undismiss an insight
  Future<void> undismiss(int id) async {
    final insight = await getById(id);
    if (insight != null) {
      insight.isDismissed = false;
      insight.dismissedAt = null;
      await update(insight);
    }
  }

  /// Get insights by type
  Future<List<Insight>> getByType(String type, {bool activeOnly = true}) async {
    var query = isar.insights.filter().typeEqualTo(type);
    if (activeOnly) {
      query = query.isDismissedEqualTo(false);
    }
    return query.sortByGeneratedAtDesc().findAll();
  }

  /// Get insights by priority
  Future<List<Insight>> getByPriority(int priority, {bool activeOnly = true}) async {
    var query = isar.insights.filter().priorityEqualTo(priority);
    if (activeOnly) {
      query = query.isDismissedEqualTo(false);
    }
    return query.sortByGeneratedAtDesc().findAll();
  }

  /// Get high priority (urgent) insights
  Future<List<Insight>> getHighPriority() async {
    return getByPriority(1, activeOnly: true);
  }

  /// Delete old dismissed insights (cleanup)
  Future<int> cleanupOldDismissed({int daysOld = 30}) async {
    final cutoff = DateTime.now().subtract(Duration(days: daysOld));

    final toDelete = await isar.insights
        .filter()
        .isDismissedEqualTo(true)
        .dismissedAtLessThan(cutoff)
        .findAll();

    await isar.writeTxn(() async {
      await isar.insights.deleteAll(toDelete.map((i) => i.id).toList());
    });

    return toDelete.length;
  }

  /// Delete all insights for a month
  Future<void> deleteByMonth(String monthKey) async {
    final toDelete = await isar.insights
        .filter()
        .monthKeyEqualTo(monthKey)
        .findAll();

    await isar.writeTxn(() async {
      await isar.insights.deleteAll(toDelete.map((i) => i.id).toList());
    });
  }

  /// Get count of active insights
  Future<int> getActiveCount() async {
    return isar.insights.filter().isDismissedEqualTo(false).count();
  }

  /// Get count of high priority insights
  Future<int> getHighPriorityCount() async {
    return isar.insights
        .filter()
        .isDismissedEqualTo(false)
        .priorityEqualTo(1)
        .count();
  }
}
