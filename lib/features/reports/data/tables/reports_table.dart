import 'package:drift/drift.dart';
import 'package:expenselab/core/database/base_table.dart';

class Reports extends Table with SoftDeleteTable {
  IntColumn get year => integer()();
  IntColumn get month => integer()();
  DateTimeColumn get generatedAt => dateTime().clientDefault(() => DateTime.now().toUtc())();
}
