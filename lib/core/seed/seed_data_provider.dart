import 'package:expenselab/core/seed/seed_data_service.dart';
import 'package:expenselab/features/accounts/providers/accounts_providers.dart';
import 'package:expenselab/features/categories/providers/categories_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final seedDataServiceProvider = Provider<SeedDataService>((ref) {
  return SeedDataService(
    ref.watch(categoriesRepositoryProvider),
    ref.watch(accountsRepositoryProvider),
  );
});
