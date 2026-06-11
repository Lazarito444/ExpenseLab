import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/database/database_providers.dart';
import 'package:expenselab/features/exchange_rates/data/datasources/exchange_rates_local_datasource.dart';
import 'package:expenselab/features/exchange_rates/data/datasources/exchange_rates_local_datasource_impl.dart';
import 'package:expenselab/features/exchange_rates/data/repositories/exchange_rates_repository.dart';
import 'package:expenselab/features/exchange_rates/domain/models/exchange_rate_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exchangeRatesLocalDataSourceProvider =
    Provider<ExchangeRatesLocalDataSource>((ref) {
  return ExchangeRatesLocalDataSourceImpl(ref.watch(appDatabaseProvider));
});

final exchangeRatesRepositoryProvider =
    Provider<ExchangeRatesRepository>((ref) {
  return ExchangeRatesRepository(
    ref.watch(exchangeRatesLocalDataSourceProvider),
  );
});

/// Streams all exchange rates ordered by date descending.
final exchangeRatesProvider = StreamProvider<List<ExchangeRate>>((ref) {
  return ref.watch(exchangeRatesRepositoryProvider).watchAll();
});

/// All rates mapped to [ExchangeRateModel].
final exchangeRateModelsProvider = Provider<List<ExchangeRateModel>>((ref) {
  final rates = ref
      .watch(exchangeRatesProvider)
      .maybeWhen(data: (v) => v, orElse: () => <ExchangeRate>[]);
  return rates.map(ExchangeRateModel.fromRow).toList();
});
