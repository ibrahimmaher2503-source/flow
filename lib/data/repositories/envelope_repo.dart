import 'package:isar/isar.dart';
import '../models/envelope_model.dart';

class EnvelopeRepo {
  final Isar isar;

  EnvelopeRepo(this.isar);

  Future<List<Envelope>> getAll() async {
    return isar.envelopes.where().findAll();
  }

  Future<List<Envelope>> getByMonth(int year, int month) async {
    return isar.envelopes
        .filter()
        .yearEqualTo(year)
        .monthEqualTo(month)
        .sortBySortOrder()
        .findAll();
  }

  Future<Envelope?> getById(int id) async {
    return isar.envelopes.get(id);
  }

  Future<Envelope?> getByCategory(String categoryName, int year, int month) async {
    return isar.envelopes
        .filter()
        .categoryNameEqualTo(categoryName)
        .yearEqualTo(year)
        .monthEqualTo(month)
        .findFirst();
  }

  Future<int> add(Envelope envelope) async {
    return isar.writeTxn(() async {
      return isar.envelopes.put(envelope);
    });
  }

  Future<void> update(Envelope envelope) async {
    await isar.writeTxn(() async {
      await isar.envelopes.put(envelope);
    });
  }

  Future<void> delete(int id) async {
    await isar.writeTxn(() async {
      await isar.envelopes.delete(id);
    });
  }

  /// Copy envelopes from previous month for rollover
  Future<List<Envelope>> copyFromPreviousMonth(int year, int month) async {
    final prevYear = month == 1 ? year - 1 : year;
    final prevMonth = month == 1 ? 12 : month - 1;

    final previousEnvelopes = await getByMonth(prevYear, prevMonth);
    final newEnvelopes = <Envelope>[];

    await isar.writeTxn(() async {
      for (final env in previousEnvelopes) {
        final newEnvelope = Envelope()
          ..name = env.name
          ..categoryName = env.categoryName
          ..allocatedAmount = env.allocatedAmount
          ..iconName = env.iconName
          ..colorHex = env.colorHex
          ..isEssential = env.isEssential
          ..rolloverEnabled = env.rolloverEnabled
          ..sortOrder = env.sortOrder
          ..year = year
          ..month = month
          ..createdAt = DateTime.now();

        await isar.envelopes.put(newEnvelope);
        newEnvelopes.add(newEnvelope);
      }
    });

    return newEnvelopes;
  }

  /// Get total allocated for a month
  Future<double> getTotalAllocated(int year, int month) async {
    final envelopes = await getByMonth(year, month);
    return envelopes.fold<double>(0.0, (sum, e) => sum + e.allocatedAmount);
  }

  /// Get essential envelopes for a month
  Future<List<Envelope>> getEssential(int year, int month) async {
    return isar.envelopes
        .filter()
        .yearEqualTo(year)
        .monthEqualTo(month)
        .isEssentialEqualTo(true)
        .sortBySortOrder()
        .findAll();
  }
}
