import 'package:isar/isar.dart';
import '../models/detected_sms_model.dart';

class DetectedSmsRepo {
  final Isar _isar;

  DetectedSmsRepo(this._isar);

  Future<List<DetectedSms>> getPending() async {
    return _isar.detectedSms
        .where()
        .statusEqualTo('pending')
        .sortByTimestampDesc()
        .findAll();
  }

  Future<List<DetectedSms>> getByDateRange(DateTime start, DateTime end) async {
    return _isar.detectedSms
        .where()
        .timestampBetween(start, end)
        .sortByTimestampDesc()
        .findAll();
  }

  Future<List<DetectedSms>> getAll() async {
    return _isar.detectedSms.where().sortByTimestampDesc().findAll();
  }

  Future<DetectedSms?> getById(int id) async {
    return _isar.detectedSms.get(id);
  }

  Future<int> countPending() async {
    return _isar.detectedSms.where().statusEqualTo('pending').count();
  }

  Future<int> save(DetectedSms sms) async {
    return _isar.writeTxn(() async {
      return _isar.detectedSms.put(sms);
    });
  }

  Future<void> updateStatus(
    int id,
    String status, {
    String? transactionId,
    int? categoryId,
  }) async {
    await _isar.writeTxn(() async {
      final sms = await _isar.detectedSms.get(id);
      if (sms != null) {
        sms.status = status;
        sms.confirmedAt = DateTime.now();
        if (transactionId != null) sms.transactionId = transactionId;
        if (categoryId != null) sms.categoryId = categoryId;
        await _isar.detectedSms.put(sms);
      }
    });
  }

  Future<void> delete(int id) async {
    await _isar.writeTxn(() async {
      await _isar.detectedSms.delete(id);
    });
  }
}
