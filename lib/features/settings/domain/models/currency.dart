import 'package:intl/intl.dart';

class Currency {
  const Currency({
    required this.code,
    required this.symbol,
    required this.name,
  });

  final String code;
  final String symbol;
  final String name;

  String format(double amount) => NumberFormat.currency(symbol: symbol, decimalDigits: 2).format(amount);

  @override
  bool operator ==(Object other) => other is Currency && other.code == code;

  @override
  int get hashCode => code.hashCode;
}
