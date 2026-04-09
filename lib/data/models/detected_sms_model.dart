import 'package:isar/isar.dart';

part 'detected_sms_model.g.dart';

@collection
class DetectedSms {
  Id id = Isar.autoIncrement;

  double amount = 0;
  String type = 'debit'; // 'debit' | 'credit'
  String bank = '';
  String rawBody = '';

  @Index()
  DateTime timestamp = DateTime.now();

  @Index()
  String status = 'pending'; // 'pending' | 'confirmed' | 'dismissed'

  DateTime? confirmedAt;
  String? transactionId;
  int? categoryId;
}
