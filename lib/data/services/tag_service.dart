import 'package:isar/isar.dart';
import '../models/transaction_tag_model.dart';
import '../models/transaction_model.dart';
import '../models/smart_feature_models.dart';

/// Service for managing transaction tags
class TagService {
  final Isar isar;

  TagService(this.isar);

  /// Get or create a tag, updating usage stats
  Future<TransactionTag> getOrCreateTag(String name) async {
    var tag = await isar.transactionTags.filter().nameEqualTo(name).findFirst();

    if (tag == null) {
      tag = TransactionTag()
        ..name = name
        ..usageCount = 0
        ..colorHex = _assignColor(name)
        ..createdAt = DateTime.now();

      await isar.writeTxn(() async {
        await isar.transactionTags.put(tag!);
      });
    }

    return tag;
  }

  /// Record tag usage when adding/updating a transaction
  Future<void> recordTagUsage(List<String> tagNames) async {
    if (tagNames.isEmpty) return;

    await isar.writeTxn(() async {
      for (final name in tagNames) {
        var tag = await isar.transactionTags.filter().nameEqualTo(name).findFirst();

        if (tag == null) {
          tag = TransactionTag()
            ..name = name
            ..usageCount = 1
            ..lastUsedAt = DateTime.now()
            ..colorHex = _assignColor(name)
            ..createdAt = DateTime.now();
        } else {
          tag.usageCount++;
          tag.lastUsedAt = DateTime.now();
        }

        await isar.transactionTags.put(tag);
      }
    });
  }

  /// Rename a tag across all transactions
  Future<void> renameTag(String oldName, String newName) async {
    if (oldName == newName) return;

    // Check if new name already exists
    final existingTag = await isar.transactionTags
        .filter()
        .nameEqualTo(newName)
        .findFirst();

    await isar.writeTxn(() async {
      // Get the tag to rename
      final tag = await isar.transactionTags
          .filter()
          .nameEqualTo(oldName)
          .findFirst();

      if (tag == null) return;

      // Update all transactions with this tag
      final transactions = await isar.transactions
          .filter()
          .tagsElementEqualTo(oldName)
          .findAll();

      for (final txn in transactions) {
        txn.tags = txn.tags.map((t) => t == oldName ? newName : t).toList();
      }
      await isar.transactions.putAll(transactions);

      if (existingTag != null) {
        // Merge into existing tag
        existingTag.usageCount += tag.usageCount;
        existingTag.lastUsedAt = DateTime.now();
        await isar.transactionTags.put(existingTag);
        await isar.transactionTags.delete(tag.id);
      } else {
        // Just rename
        tag.name = newName;
        await isar.transactionTags.put(tag);
      }
    });
  }

  /// Delete a tag and remove from all transactions
  Future<void> deleteTag(String tagName) async {
    await isar.writeTxn(() async {
      // Remove from all transactions
      final transactions = await isar.transactions
          .filter()
          .tagsElementEqualTo(tagName)
          .findAll();

      for (final txn in transactions) {
        txn.tags = txn.tags.where((t) => t != tagName).toList();
      }
      await isar.transactions.putAll(transactions);

      // Delete the tag metadata
      final tag = await isar.transactionTags
          .filter()
          .nameEqualTo(tagName)
          .findFirst();

      if (tag != null) {
        await isar.transactionTags.delete(tag.id);
      }
    });
  }

  /// Get analytics for a specific tag
  Future<TagAnalytics> getTagAnalytics(String tagName) async {
    final transactions = await isar.transactions
        .filter()
        .tagsElementEqualTo(tagName)
        .findAll();

    // Calculate totals
    double totalAmount = 0;
    final categoryBreakdown = <String, double>{};
    DateTime? firstUsed;
    DateTime? lastUsed;

    for (final txn in transactions) {
      if (txn.type == 'expense') {
        totalAmount += txn.amount;
        categoryBreakdown[txn.category] =
            (categoryBreakdown[txn.category] ?? 0) + txn.amount;
      }

      if (firstUsed == null || txn.date.isBefore(firstUsed)) {
        firstUsed = txn.date;
      }
      if (lastUsed == null || txn.date.isAfter(lastUsed)) {
        lastUsed = txn.date;
      }
    }

    final averageAmount =
        transactions.isNotEmpty ? totalAmount / transactions.length : 0.0;

    return TagAnalytics(
      tagName: tagName,
      transactionCount: transactions.length,
      totalAmount: totalAmount,
      averageAmount: averageAmount,
      firstUsed: firstUsed,
      lastUsed: lastUsed,
      categoryBreakdown: categoryBreakdown,
    );
  }

  /// Get all tags with their analytics
  Future<List<TagAnalytics>> getAllTagAnalytics() async {
    final tags = await isar.transactionTags
        .where()
        .sortByUsageCountDesc()
        .findAll();

    final analyticsList = <TagAnalytics>[];
    for (final tag in tags) {
      final analytics = await getTagAnalytics(tag.name);
      analyticsList.add(analytics);
    }

    return analyticsList;
  }

  /// Search tags for autocomplete
  Future<List<TransactionTag>> searchTags(String query) async {
    if (query.isEmpty) {
      // Return most used tags
      return isar.transactionTags
          .where()
          .sortByUsageCountDesc()
          .limit(10)
          .findAll();
    }

    return isar.transactionTags
        .filter()
        .nameContains(query, caseSensitive: false)
        .sortByUsageCountDesc()
        .limit(10)
        .findAll();
  }

  /// Get suggested tags based on category
  Future<List<String>> getSuggestedTags(String category) async {
    // Find transactions in this category that have tags
    final transactions = await isar.transactions
        .filter()
        .categoryEqualTo(category)
        .tagsIsNotEmpty()
        .limit(50)
        .findAll();

    // Count tag frequency
    final tagCounts = <String, int>{};
    for (final txn in transactions) {
      for (final tag in txn.tags) {
        tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
      }
    }

    // Sort by frequency and return top 5
    final sortedTags = tagCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedTags.take(5).map((e) => e.key).toList();
  }

  /// Assign a color from palette based on tag name hash
  String _assignColor(String name) {
    final colors = [
      '#6C63FF', // Primary purple
      '#2DD4BF', // Teal
      '#F59E0B', // Amber
      '#10B981', // Green
      '#EF4444', // Red
      '#8B5CF6', // Violet
      '#EC4899', // Pink
      '#06B6D4', // Cyan
      '#F97316', // Orange
      '#84CC16', // Lime
    ];

    final index = name.hashCode.abs() % colors.length;
    return colors[index];
  }

  /// Decrement usage count when removing tag from transaction
  Future<void> decrementTagUsage(List<String> tagNames) async {
    if (tagNames.isEmpty) return;

    await isar.writeTxn(() async {
      for (final name in tagNames) {
        final tag = await isar.transactionTags
            .filter()
            .nameEqualTo(name)
            .findFirst();

        if (tag != null && tag.usageCount > 0) {
          tag.usageCount--;
          await isar.transactionTags.put(tag);
        }
      }
    });
  }
}
