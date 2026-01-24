import 'package:isar/isar.dart';

part 'financial_event_model.g.dart';

@collection
class FinancialEventModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String aggregateId;

  late String eventType;

  late DateTime timestamp;

  late String payloadJson;

  late int version;
}
