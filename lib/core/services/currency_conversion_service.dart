import 'package:expenselab/features/exchange_rates/data/repositories/exchange_rates_repository.dart';
import 'package:expenselab/features/exchange_rates/providers/exchange_rates_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrencyConversionService {
  const CurrencyConversionService(this._repository);

  final ExchangeRatesRepository _repository;

  /// Converts [amount] from [fromCode] to [toCode] using the rate closest to
  /// [date] (on or before). Falls back to the latest available rate.
  /// Returns [amount] unchanged when the currencies are equal.
  Future<double> convert(
    double amount,
    String fromCode,
    String toCode,
    DateTime date,
  ) async {
    if (fromCode == toCode) return amount;

    final rate = await _repository.getRateForDate(fromCode, toCode, date);
    if (rate != null) return amount * rate.rate;

    // Try the inverse rate (1 / rate) in case it was stored the other way.
    final inverseRate =
        await _repository.getRateForDate(toCode, fromCode, date);
    if (inverseRate != null && inverseRate.rate != 0) {
      return amount / inverseRate.rate;
    }

    // No rate available — return unconverted amount.
    return amount;
  }
}

final currencyConversionServiceProvider =
    Provider<CurrencyConversionService>((ref) {
  return CurrencyConversionService(
    ref.watch(exchangeRatesRepositoryProvider),
  );
});
