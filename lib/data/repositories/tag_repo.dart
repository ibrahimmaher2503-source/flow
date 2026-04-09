import 'package:isar/isar.dart';
import '../models/transaction_tag_model.dart';
import '../models/transaction_model.dart';

class TagRepo {
  final Isar isar;

  TagRepo(this.isar);

  Future<List<TransactionTag>> getAll() async {
    return isar.transactionTags.where().findAll();
  }

  /// Get tags sorted by usage count (most used first)
  Future<List<TransactionTag>> getAllByUsage() async {
    return isar.transactionTags.where().sortByUsageCountDesc().findAll();
  }

  /// Get tags sorted by recency (most recent first)
  Future<List<TransactionTag>> getAllByRecency() async {
    return isar.transactionTags.where().sortByLastUsedAtDesc().findAll();
  }

  Future<TransactionTag?> getById(int id) async {
    return isar.transactionTags.get(id);
  }

  Future<TransactionTag?> getByName(String name) async {
    return isar.transactionTags.filter().nameEqualTo(name).findFirst();
  }

  Future<int> add(TransactionTag tag) async {
    return isar.writeTxn(() async {
      return isar.transactionTags.put(tag);
    });
  }

  Future<void> update(TransactionTag tag) async {
    await isar.writeTxn(() async {
      await isar.transactionTags.put(tag);
    });
  }

  Future<void> delete(int id) async {
    await isar.writeTxn(() async {
      await isar.transactionTags.delete(id);
    });
  }

  /// Create tag if it doesn't exist, otherwise update usage stats
  Future<TransactionTag> getOrCreate(String name) async {
    var tag = await getByName(name);
    if (tag != null) {
      return tag;
    }

    tag = TransactionTag()
      ..name = name
      ..usageCount = 0
      ..createdAt = DateTime.now();

    await add(tag);
    return tag;
  }

  /// Increment usage count and update last used timestamp
  Future<void> recordUsage(String name) async {
    final tag = await getByName(name);
    if (tag != null) {
      tag.usageCount++;
      tag.lastUsedAt = DateTime.now();
      await update(tag);
    }
  }

  /// Rename tag in metadata and all transactions
  Future<void> rename(String oldName, String newName) async {
    await isar.writeTxn(() async {
      // Update the tag metadata
      final tag = await isar.transactionTags.filter().nameEqualTo(oldName).findFirst();
      if (tag != null) {
        tag.name = newName;
        await isar.transactionTags.put(tag);
      }

      // Update all transactions with this tag
      final transactions = await isar.transactions
          .filter()
          .tagsElementEqualTo(oldName)
          .findAll();

      for (final txn in transactions) {
        txn.tags = txn.tags.map((t) => t == oldName ? newName : t).toList();
      }
      await isar.transactions.putAll(transactions);
    });
  }

  /// Delete tag from metadata and remove from all transactions
  Future<void> deleteWithTransactions(int tagId) async {
    final tag = await getById(tagId);
    if (tag == null) return;

    final tagName = tag.name;

    await isar.writeTxn(() async {
      // Remove tag from all transactions
      final transactions = await isar.transactions
          .filter()
          .tagsElementEqualTo(tagName)
          .findAll();

      for (final txn in transactions) {
        txn.tags = txn.tags.where((t) => t != tagName).toList();
      }
      await isar.transactions.putAll(transactions);

      // Delete the tag metadata
      await isar.transactionTags.delete(tagId);
    });
  }

  /// Get transactions for a specific tag
  Future<List<Transaction>> getTransactionsByTag(String tagName) async {
    return isar.transactions
        .filter()
        .tagsElementEqualTo(tagName)
        .sortByDateDesc()
        .findAll();
  }

  /// Get total amount spent for a tag
  Future<double> getTotalAmountByTag(String tagName) async {
    final transactions = await getTransactionsByTag(tagName);
    return transactions
        .where((t) => t.type == 'expense')
        .fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  /// Search tags by partial name (for autocomplete)
  Future<List<TransactionTag>> search(String query) async {
    if (query.isEmpty) {
      return getAllByUsage();
    }
    return isar.transactionTags
        .filter()
        .nameContains(query, caseSensitive: false)
        .sortByUsageCountDesc()
        .findAll();
  }
}
