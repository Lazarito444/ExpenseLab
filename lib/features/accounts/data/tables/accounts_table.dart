import 'package:drift/drift.dart';
import 'package:expenselab/core/database/base_table.dart';

enum AccountType { cash, debit, credit, investment }

class Accounts extends Table with SoftDeleteTable {
  TextColumn get name => text()();

  /// Stored as int index of [AccountType].
  IntColumn get type => intEnum<AccountType>()();

  /// ISO 4217 code, e.g. "USD".
  TextColumn get currencyCode => text()();

  /// Icon name from [Icons] class.
  TextColumn get icon => text()();
}
