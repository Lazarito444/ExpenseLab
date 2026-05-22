import 'package:expenselab/features/accounts/presentation/screens/account_details_screen.dart';
import 'package:expenselab/features/accounts/presentation/screens/accounts_screen.dart';
import 'package:expenselab/features/accounts/presentation/screens/create_account_screen.dart';
import 'package:expenselab/features/accounts/presentation/screens/edit_account_screen.dart';
import 'package:expenselab/features/categories/data/tables/categories_table.dart';
import 'package:expenselab/features/categories/presentation/screens/categories_screen.dart';
import 'package:expenselab/features/categories/presentation/screens/create_edit_category_screen.dart';
import 'package:go_router/go_router.dart';

final routerConfig = GoRouter(
  initialLocation: '/accounts',
  routes: [
    GoRoute(
      path: '/accounts',
      builder: (context, state) => const AccountsScreen(),
    ),
    GoRoute(
      path: '/accounts/create',
      builder: (context, state) => const CreateAccountScreen(),
    ),
    GoRoute(
      path: '/accounts/details/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return AccountDetailsScreen(accountId: id);
      },
    ),
    GoRoute(
      path: '/accounts/edit/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return EditAccountScreen(accountId: id);
      },
    ),
    GoRoute(
      path: '/categories',
      builder: (context, state) => const CategoriesScreen(),
    ),
    GoRoute(
      path: '/categories/create',
      builder: (context, state) {
        final typeStr = state.uri.queryParameters['type'];
        final parentId = state.uri.queryParameters['parentId'];
        CategoryType? initialType;
        if (typeStr == 'expense') {
          initialType = CategoryType.expense;
        } else if (typeStr == 'income') {
          initialType = CategoryType.income;
        }
        return CreateEditCategoryScreen(
          initialType: initialType,
          initialParentId: parentId,
        );
      },
    ),
    GoRoute(
      path: '/categories/edit/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return CreateEditCategoryScreen(categoryId: id);
      },
    ),
  ],
);
