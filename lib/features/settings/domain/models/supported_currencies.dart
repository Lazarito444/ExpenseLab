import 'package:expenselab/features/settings/domain/models/currency.dart';
import 'package:intl/intl.dart';

const kUsdCurrency = Currency(code: 'USD', symbol: r'$', name: 'US Dollar');

const kSupportedCurrencies = <Currency>[
  kUsdCurrency,
  Currency(code: 'EUR', symbol: '€', name: 'Euro'),
  Currency(code: 'GBP', symbol: '£', name: 'British Pound'),
  Currency(code: 'ARS', symbol: r'$', name: 'Argentine Peso'),
  Currency(code: 'BRL', symbol: 'R\$', name: 'Brazilian Real'),
  Currency(code: 'MXN', symbol: r'$', name: 'Mexican Peso'),
  Currency(code: 'DOP', symbol: 'RD\$', name: 'Dominican Peso'),
  Currency(code: 'CLP', symbol: r'$', name: 'Chilean Peso'),
  Currency(code: 'COP', symbol: r'$', name: 'Colombian Peso'),
  Currency(code: 'PEN', symbol: 'S/', name: 'Peruvian Sol'),
  Currency(code: 'UYU', symbol: r'$U', name: 'Uruguayan Peso'),
  Currency(code: 'PYG', symbol: '₲', name: 'Paraguayan Guaraní'),
  Currency(code: 'BOB', symbol: 'Bs.', name: 'Bolivian Boliviano'),
  Currency(code: 'JPY', symbol: '¥', name: 'Japanese Yen'),
  Currency(code: 'CNY', symbol: '¥', name: 'Chinese Yuan'),
  Currency(code: 'CAD', symbol: r'$', name: 'Canadian Dollar'),
  Currency(code: 'AUD', symbol: r'$', name: 'Australian Dollar'),
  Currency(code: 'CHF', symbol: 'CHF', name: 'Swiss Franc'),
  Currency(code: 'INR', symbol: '₹', name: 'Indian Rupee'),
  Currency(code: 'KRW', symbol: '₩', name: 'South Korean Won'),
  Currency(code: 'ZAR', symbol: 'R', name: 'South African Rand'),
];

String currencyCodeToSymbol(String code) {
  return kSupportedCurrencies.firstWhere((c) => c.code == code).symbol;
}

String formatCurrency(double amount, String currencyCode) {
  return NumberFormat.currency(
    locale: 'en_US',
    symbol: currencyCodeToSymbol(currencyCode),
  ).format(amount);
}
