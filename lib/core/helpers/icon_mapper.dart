import 'package:flutter/material.dart';

const _icons = <String, IconData>{
  'account_balance': Icons.account_balance,
  'account_balance_wallet': Icons.account_balance_wallet,
  'account_box': Icons.account_box,
  'account_circle': Icons.account_circle,
  'add': Icons.add,
  'attach_money': Icons.attach_money,
  'card_giftcard': Icons.card_giftcard,
  'card_travel': Icons.card_travel,
  'cash': Icons.attach_money,
  'credit_card': Icons.credit_card,
  'currency_exchange': Icons.currency_exchange,
  'euro': Icons.euro,
  'home': Icons.home,
  'local_atm': Icons.local_atm,
  'money': Icons.money,
  'payments': Icons.payments,
  'savings': Icons.savings,
  'shopping_bag': Icons.shopping_bag,
  'shopping_cart': Icons.shopping_cart,
  'show_chart': Icons.show_chart,
  'trending_up': Icons.trending_up,
  'wallet': Icons.wallet,
  'work': Icons.work,
};

IconData iconFromName(String name, {IconData fallback = Icons.account_balance_wallet}) {
  return _icons[name] ?? fallback;
}
