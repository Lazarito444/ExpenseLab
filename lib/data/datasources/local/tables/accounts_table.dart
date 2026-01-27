import 'package:drift/drift.dart';

@DataClassName('AccountDbModel')
class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get currencyCode => text()();
  RealColumn get currentBalance => real()();
  TextColumn get colorHex => text()();
  IntColumn get iconCodePoint => integer()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
}
