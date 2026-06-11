import 'package:drift/drift.dart';
import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/features/accounts/data/repositories/accounts_repository.dart';
import 'package:expenselab/features/accounts/data/tables/accounts_table.dart';
import 'package:expenselab/features/categories/data/repositories/categories_repository.dart';
import 'package:expenselab/features/categories/data/tables/categories_table.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeedDataService {
  const SeedDataService(this._categories, this._accounts);

  final CategoriesRepository _categories;
  final AccountsRepository _accounts;

  static const _seededKey = 'app_seeded';

  Future<void> seedIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_seededKey) == true) return;
    await _seed();
    await prefs.setBool(_seededKey, true);
  }

  Future<void> _seed() async {
    for (final c in _defaultExpenseCategories) {
      await _categories.create(c);
    }
    for (final c in _defaultIncomeCategories) {
      await _categories.create(c);
    }
    await _accounts.create(_defaultCashAccount);
  }
}

const _defaultExpenseCategories = <CategoriesCompanion>[
  CategoriesCompanion(
    name: Value('Food & Dining'),
    icon: Value('restaurant'),
    color: Value(0xFFFF9800),
    type: Value(CategoryType.expense),
  ),
  CategoriesCompanion(
    name: Value('Housing'),
    icon: Value('home'),
    color: Value(0xFF607D8B),
    type: Value(CategoryType.expense),
  ),
  CategoriesCompanion(
    name: Value('Transportation'),
    icon: Value('directions_car'),
    color: Value(0xFF2196F3),
    type: Value(CategoryType.expense),
  ),
  CategoriesCompanion(
    name: Value('Health'),
    icon: Value('medical_services'),
    color: Value(0xFFF44336),
    type: Value(CategoryType.expense),
  ),
  CategoriesCompanion(
    name: Value('Entertainment'),
    icon: Value('movie'),
    color: Value(0xFF9C27B0),
    type: Value(CategoryType.expense),
  ),
  CategoriesCompanion(
    name: Value('Shopping'),
    icon: Value('shopping_bag'),
    color: Value(0xFFE91E63),
    type: Value(CategoryType.expense),
  ),
  CategoriesCompanion(
    name: Value('Education'),
    icon: Value('school'),
    color: Value(0xFF3F51B5),
    type: Value(CategoryType.expense),
  ),
];

const _defaultIncomeCategories = <CategoriesCompanion>[
  CategoriesCompanion(
    name: Value('Salary'),
    icon: Value('work'),
    color: Value(0xFF4CAF50),
    type: Value(CategoryType.income),
  ),
  CategoriesCompanion(
    name: Value('Freelance'),
    icon: Value('computer'),
    color: Value(0xFF009688),
    type: Value(CategoryType.income),
  ),
  CategoriesCompanion(
    name: Value('Investment'),
    icon: Value('trending_up'),
    color: Value(0xFF2196F3),
    type: Value(CategoryType.income),
  ),
];

const _defaultCashAccount = AccountsCompanion(
  name: Value('Cash'),
  type: Value(AccountType.cash),
  currencyCode: Value('USD'),
  icon: Value('account_balance_wallet'),
);
