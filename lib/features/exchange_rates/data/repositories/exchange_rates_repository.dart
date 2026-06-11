import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/features/exchange_rates/data/datasources/exchange_rates_local_datasource.dart';

class ExchangeRatesRepository {
  const ExchangeRatesRepository(this._local);

  final ExchangeRatesLocalDataSource _local;

  Stream<List<ExchangeRate>> watchAll() => _local.watchAll();

  Future<List<ExchangeRate>> getAll() => _local.getAll();

  Future<ExchangeRate?> getRateForDate(
    String fromCurrencyCode,
    String toCurrencyCode,
    DateTime date,
  ) => _local.getRateForDate(fromCurrencyCode, toCurrencyCode, date);

  Future<String> create(ExchangeRatesCompanion data) => _local.create(data);

  Future<void> update(String id, ExchangeRatesCompanion data) =>
      _local.update(id, data);

  Future<void> delete(String id) => _local.delete(id);
}
