import 'package:drift/drift.dart';
import 'package:expenselab/core/database/base_table.dart';
import 'package:expenselab/features/transactions/data/tables/transactions_table.dart';

class TransactionImages extends Table with TimestampedTable {
  /// ID of the transaction.
  TextColumn get transactionId => text().references(Transactions, #id)();

  /// Local path to the image.
  TextColumn get localPath => text()();
}
