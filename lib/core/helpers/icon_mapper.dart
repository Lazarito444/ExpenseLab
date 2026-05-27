import 'package:flutter/material.dart';

const _icons = <String, IconData>{
  // Accounts / Finance
  'account_balance': Icons.account_balance,
  'account_balance_wallet': Icons.account_balance_wallet,
  'account_box': Icons.account_box,
  'account_circle': Icons.account_circle,
  'add': Icons.add,
  'attach_money': Icons.attach_money,
  'analytics': Icons.analytics,
  'business_center': Icons.business_center,
  'card_giftcard': Icons.card_giftcard,
  'card_travel': Icons.card_travel,
  'cash': Icons.attach_money,
  'credit_card': Icons.credit_card,
  'currency_exchange': Icons.currency_exchange,
  'euro': Icons.euro,
  'local_atm': Icons.local_atm,
  'money': Icons.money,
  'paid': Icons.paid,
  'payments': Icons.payments,
  'savings': Icons.savings,
  'show_chart': Icons.show_chart,
  'trending_up': Icons.trending_up,
  'wallet': Icons.wallet,
  // Food & Dining
  'cake': Icons.cake,
  'fastfood': Icons.fastfood,
  'local_bar': Icons.local_bar,
  'local_cafe': Icons.local_cafe,
  'local_grocery_store': Icons.local_grocery_store,
  'lunch_dining': Icons.lunch_dining,
  'restaurant': Icons.restaurant,
  'wine_bar': Icons.wine_bar,
  // Transport
  'directions_bike': Icons.directions_bike,
  'directions_bus': Icons.directions_bus,
  'directions_car': Icons.directions_car,
  'flight': Icons.flight,
  'local_gas_station': Icons.local_gas_station,
  'local_taxi': Icons.local_taxi,
  'motorcycle': Icons.motorcycle,
  'train': Icons.train,
  // Home & Utilities
  'bolt': Icons.bolt,
  'home': Icons.home,
  'phone': Icons.phone,
  'plumbing': Icons.plumbing,
  'water_drop': Icons.water_drop,
  'wifi': Icons.wifi,
  // Health & Wellness
  'fitness_center': Icons.fitness_center,
  'health_and_safety': Icons.health_and_safety,
  'medical_services': Icons.medical_services,
  'self_improvement': Icons.self_improvement,
  'spa': Icons.spa,
  // Entertainment
  'camera_alt': Icons.camera_alt,
  'celebration': Icons.celebration,
  'movie': Icons.movie,
  'music_note': Icons.music_note,
  'nightlife': Icons.nightlife,
  'sports_basketball': Icons.sports_basketball,
  'sports_esports': Icons.sports_esports,
  'sports_soccer': Icons.sports_soccer,
  // Shopping
  'shopping_bag': Icons.shopping_bag,
  'shopping_cart': Icons.shopping_cart,
  'storefront': Icons.storefront,
  // Education & Work
  'computer': Icons.computer,
  'construction': Icons.construction,
  'menu_book': Icons.menu_book,
  'school': Icons.school,
  'science': Icons.science,
  'work': Icons.work,
  // Travel
  'beach_access': Icons.beach_access,
  'hotel': Icons.hotel,
  'luggage': Icons.luggage,
  // Family & Other
  'child_care': Icons.child_care,
  'pets': Icons.pets,
  'volunteer_activism': Icons.volunteer_activism,
};

IconData iconFromName(String name, {IconData fallback = Icons.account_balance_wallet}) {
  return _icons[name] ?? fallback;
}
