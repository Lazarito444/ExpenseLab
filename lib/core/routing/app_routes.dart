class AppRoutes {
  static const home = '/';
  static const budgets = '/budgets';
  static const budgetsCreate = '/budgets/create';
  static String budgetEdit(String id) => '/budgets/$id/edit';
  static const goals = '/goals';
  static const goalsCreate = '/goals/create';
  static String goalDetails(String id) => '/goals/$id';
  static String goalEdit(String id) => '/goals/$id/edit';
  static const settings = '/settings';
  static const addTransaction = '/add-transaction';
  static String addTransactionOnDate(DateTime date) =>
      '/add-transaction?date=${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  static const accounts = '/accounts';
  static const accountsCreate = '/accounts/create';
  static String accountEdit(String id) => '/accounts/$id/edit';
  static String creditCardPay(String id) => '/accounts/$id/pay';
  static const categories = '/categories';
  static const categoriesCreate = '/categories/create';
  static String categoryDetails(String id) => '/categories/$id';
  static String categoryEdit(String id) => '/categories/$id/edit';
  static String transactionEdit(String id) => '/transactions/$id/edit';
  static const settingsTheme = '/settings/theme';
  static const settingsLanguage = '/settings/language';
  static const settingsCurrency = '/settings/currency';
  static const settingsHomeView = '/settings/home-view';
  static const settingsStarredTransactions = '/settings/starred-transactions';
  static const settingsDataManagement = '/settings/data-management';
  static const analytics = '/analytics';
  static const exchangeRates = '/exchange-rates';
  static const exchangeRatesCreate = '/exchange-rates/create';
  static String exchangeRateEdit(String id) => '/exchange-rates/$id/edit';
  static String addTransactionWithStarred(String starredId) => '/add-transaction?starred=$starredId';
  static const settingsReports = '/settings/reports';
  static String reportDetails(String id) => '/settings/reports/$id';
}
