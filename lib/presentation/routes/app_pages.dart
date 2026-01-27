import 'package:expense_lab/presentation/modules/accounts/pages/accounts_page.dart';
import 'package:expense_lab/presentation/modules/categories/pages/categories_page.dart';
import 'package:expense_lab/presentation/routes/app_routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppPages {
  static final String initial = AppRoutes.accounts;

  static final List<GetPage> pages = <GetPage>[
    GetPage(
      name: AppRoutes.accounts,
      page: () => const AccountsPage(),
    ),
    GetPage(
      name: AppRoutes.categories,
      page: () => const CategoriesPage(),
    ),
  ];
}
