class AppRoutes {
  static const home = '/';
  static const budgets = '/budgets';
  static const goals = '/goals';
  static const settings = '/settings';
  static const addTransaction = '/add-transaction';
  static const accounts = '/accounts';
  static const accountsCreate = '/accounts/create';
  static String accountEdit(String id) => '/accounts/$id/edit';
  static const categories = '/categories';
  static const categoriesCreate = '/categories/create';
  static String categoryDetails(String id) => '/categories/$id';
  static String categoryEdit(String id) => '/categories/$id/edit';
  static String transactionEdit(String id) => '/transactions/$id/edit';
}
