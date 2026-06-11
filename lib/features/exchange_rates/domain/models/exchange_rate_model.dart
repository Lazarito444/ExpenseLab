import 'package:expenselab/core/database/app_database.dart';

class ExchangeRateModel {
  const ExchangeRateModel({
    required this.id,
    required this.fromCurrencyCode,
    required this.toCurrencyCode,
    required this.rate,
    required this.date,
  });

  final String id;
  final String fromCurrencyCode;
  final String toCurrencyCode;
  final double rate;
  final DateTime date;

  factory ExchangeRateModel.fromRow(ExchangeRate row) => ExchangeRateModel(
    id: row.id,
    fromCurrencyCode: row.fromCurrencyCode,
    toCurrencyCode: row.toCurrencyCode,
    rate: row.rate,
    date: row.date,
  );
}
