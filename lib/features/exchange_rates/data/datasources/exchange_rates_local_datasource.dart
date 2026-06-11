import 'package:expenselab/core/database/app_database.dart';

abstract class ExchangeRatesLocalDataSource {
  /// Streams all exchange rates, re-emitting on every change.
  Stream<List<ExchangeRate>> watchAll();

  /// Returns all exchange rates as a one-shot future.
  Future<List<ExchangeRate>> getAll();

  /// Returns the most recent rate on or before [date] for the given pair,
  /// or the latest available rate if none exists for/before [date].
  /// Returns null if no rates exist for the pair at all.
  Future<ExchangeRate?> getRateForDate(
    String fromCurrencyCode,
    String toCurrencyCode,
    DateTime date,
  );

  /// Inserts a new exchange rate. Returns the generated id.
  Future<String> create(ExchangeRatesCompanion data);

  /// Overwrites the mutable fields of the rate identified by [id].
  Future<void> update(String id, ExchangeRatesCompanion data);

  /// Permanently deletes the exchange rate identified by [id].
  Future<void> delete(String id);
}
