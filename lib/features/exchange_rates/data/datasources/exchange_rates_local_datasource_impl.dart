import 'package:drift/drift.dart';
import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/helpers/uuid_factory.dart';
import 'package:expenselab/features/exchange_rates/data/datasources/exchange_rates_local_datasource.dart';

class ExchangeRatesLocalDataSourceImpl implements ExchangeRatesLocalDataSource {
  const ExchangeRatesLocalDataSourceImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<ExchangeRate>> watchAll() =>
      (_db.select(_db.exchangeRates)..orderBy([(t) => OrderingTerm.desc(t.date)])).watch();

  @override
  Future<List<ExchangeRate>> getAll() =>
      (_db.select(_db.exchangeRates)..orderBy([(t) => OrderingTerm.desc(t.date)])).get();

  @override
  Future<ExchangeRate?> getRateForDate(
    String fromCurrencyCode,
    String toCurrencyCode,
    DateTime date,
  ) async {
    final dateUtc = DateTime.utc(date.year, date.month, date.day, 23, 59, 59);

    // Most recent rate on or before the given date.
    final onOrBefore = await (_db.select(_db.exchangeRates)
          ..where(
            (t) =>
                t.fromCurrencyCode.equals(fromCurrencyCode) &
                t.toCurrencyCode.equals(toCurrencyCode) &
                t.date.isSmallerOrEqualValue(dateUtc),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(1))
        .getSingleOrNull();

    if (onOrBefore != null) return onOrBefore;

    // Fallback: latest available rate regardless of date.
    return (_db.select(_db.exchangeRates)
          ..where(
            (t) =>
                t.fromCurrencyCode.equals(fromCurrencyCode) &
                t.toCurrencyCode.equals(toCurrencyCode),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(1))
        .getSingleOrNull();
  }

  @override
  Future<String> create(ExchangeRatesCompanion data) async {
    final id = newId();
    await _db.into(_db.exchangeRates).insert(data.copyWith(id: Value(id)));
    return id;
  }

  @override
  Future<void> update(String id, ExchangeRatesCompanion data) =>
      (_db.update(_db.exchangeRates)..where((t) => t.id.equals(id))).write(
        data.copyWith(updatedAt: Value(DateTime.now().toUtc())),
      );

  @override
  Future<void> delete(String id) =>
      (_db.delete(_db.exchangeRates)..where((t) => t.id.equals(id))).go();
}
