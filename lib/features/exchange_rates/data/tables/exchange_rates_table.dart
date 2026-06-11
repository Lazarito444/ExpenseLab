import 'package:drift/drift.dart';
import 'package:expenselab/core/database/base_table.dart';

class ExchangeRates extends Table with TimestampedTable {
  /// ISO 4217 source currency, e.g. "USD".
  TextColumn get fromCurrencyCode => text()();

  /// ISO 4217 target currency, e.g. "EUR".
  TextColumn get toCurrencyCode => text()();

  /// Units of [toCurrencyCode] per one unit of [fromCurrencyCode].
  RealColumn get rate => real()();

  /// The date this rate applies to (stored in UTC, time portion ignored).
  DateTimeColumn get date => dateTime()();
}
