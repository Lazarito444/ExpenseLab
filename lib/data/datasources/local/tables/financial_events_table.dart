import 'package:drift/drift.dart';

@DataClassName('FinancialEventDbModel')
class FinancialEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get aggregateId => text()();
  TextColumn get eventType => text()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get payloadJson => text()();
  IntColumn get version => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {aggregateId, version},
  ];
}
