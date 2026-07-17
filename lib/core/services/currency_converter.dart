import 'package:expenselab/features/exchange_rates/domain/models/exchange_rate_model.dart';
import 'package:flutter/foundation.dart';

double convertSync(
  double amount,
  String from,
  String to,
  List<ExchangeRateModel> rates,
  DateTime date,
) {
  if (from == to) return amount;

  final direct = rates
      .where((r) => r.fromCurrencyCode == from && r.toCurrencyCode == to)
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));

  if (direct.isNotEmpty) {
    final onOrBefore = direct.where((r) => !r.date.isAfter(date)).firstOrNull;
    return amount * (onOrBefore ?? direct.first).rate;
  }

  final inverse = rates
      .where((r) => r.fromCurrencyCode == to && r.toCurrencyCode == from)
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));

  if (inverse.isNotEmpty) {
    final onOrBefore = inverse.where((r) => !r.date.isAfter(date)).firstOrNull;
    final rate = (onOrBefore ?? inverse.first).rate;
    if (rate != 0) return amount / rate;
  }

  debugPrint('CurrencyConverter: no rate found for $from -> $to');
  return amount;
}
