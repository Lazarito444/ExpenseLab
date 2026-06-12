import 'package:drift/drift.dart';
import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
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
  static const _localeKey = 'settings_locale';

  Future<void> seedIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_seededKey) == true) return;
    final localeStr = prefs.getString(_localeKey);
    final locale = AppLocaleUtils.parse(localeStr ?? 'en');
    final t = await locale.build();
    await _seed(t);
    await prefs.setBool(_seededKey, true);
  }

  Future<void> _seed(Translations t) async {
    final s = t.seed;
    for (final c in _expenseCategories(s)) {
      await _categories.create(c);
    }
    for (final c in _incomeCategories(s)) {
      await _categories.create(c);
    }
    await _accounts.create(_cashAccount(s));
    await _accounts.create(_bankAccount(s));
  }
}

List<CategoriesCompanion> _expenseCategories(TranslationsSeedEn s) => [
      CategoriesCompanion(
        name: Value(s.categories.food_and_dining),
        icon: const Value('restaurant'),
        color: const Value(0xFFFF9800),
        type: const Value(CategoryType.expense),
      ),
      CategoriesCompanion(
        name: Value(s.categories.housing),
        icon: const Value('home'),
        color: const Value(0xFF607D8B),
        type: const Value(CategoryType.expense),
      ),
      CategoriesCompanion(
        name: Value(s.categories.transportation),
        icon: const Value('directions_car'),
        color: const Value(0xFF2196F3),
        type: const Value(CategoryType.expense),
      ),
      CategoriesCompanion(
        name: Value(s.categories.health),
        icon: const Value('medical_services'),
        color: const Value(0xFFF44336),
        type: const Value(CategoryType.expense),
      ),
      CategoriesCompanion(
        name: Value(s.categories.entertainment),
        icon: const Value('movie'),
        color: const Value(0xFF9C27B0),
        type: const Value(CategoryType.expense),
      ),
      CategoriesCompanion(
        name: Value(s.categories.shopping),
        icon: const Value('shopping_bag'),
        color: const Value(0xFFE91E63),
        type: const Value(CategoryType.expense),
      ),
      CategoriesCompanion(
        name: Value(s.categories.education),
        icon: const Value('school'),
        color: const Value(0xFF3F51B5),
        type: const Value(CategoryType.expense),
      ),
    ];

List<CategoriesCompanion> _incomeCategories(TranslationsSeedEn s) => [
      CategoriesCompanion(
        name: Value(s.categories.salary),
        icon: const Value('work'),
        color: const Value(0xFF4CAF50),
        type: const Value(CategoryType.income),
      ),
      CategoriesCompanion(
        name: Value(s.categories.freelance),
        icon: const Value('computer'),
        color: const Value(0xFF009688),
        type: const Value(CategoryType.income),
      ),
      CategoriesCompanion(
        name: Value(s.categories.investment),
        icon: const Value('trending_up'),
        color: const Value(0xFF2196F3),
        type: const Value(CategoryType.income),
      ),
    ];

AccountsCompanion _cashAccount(TranslationsSeedEn s) => AccountsCompanion(
      name: Value(s.accounts.cash),
      type: const Value(AccountType.cash),
      currencyCode: const Value('USD'),
      icon: const Value('account_balance_wallet'),
    );

AccountsCompanion _bankAccount(TranslationsSeedEn s) => AccountsCompanion(
      name: Value(s.accounts.bank_account),
      type: const Value(AccountType.bankAccount),
      currencyCode: const Value('USD'),
      icon: const Value('account_balance'),
    );
