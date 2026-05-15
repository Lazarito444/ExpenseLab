import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/database/database_providers.dart';
import 'package:expenselab/features/categories/data/datasources/categories_local_datasource.dart';
import 'package:expenselab/features/categories/data/datasources/categories_local_datasource_impl.dart';
import 'package:expenselab/features/categories/data/repositories/categories_repository.dart';
import 'package:expenselab/features/categories/data/tables/categories_table.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides [CategoriesLocalDataSourceImpl] bound to the
/// [CategoriesLocalDataSource] interface. Swap the implementation here to
/// change the storage backend without touching any repository or UI code.
final categoriesLocalDataSourceProvider = Provider<CategoriesLocalDataSource>((ref) {
  return CategoriesLocalDataSourceImpl(ref.watch(appDatabaseProvider));
});

/// Provides the singleton [CategoriesRepository], wired to
/// [categoriesLocalDataSourceProvider].
final categoriesRepositoryProvider = Provider<CategoriesRepository>((ref) {
  return CategoriesRepository(ref.watch(categoriesLocalDataSourceProvider));
});

/// Streams all non-deleted [Category] records (including subcategories).
/// Automatically re-emits whenever the underlying table changes.
///
/// Usage: `ref.watch(categoriesProvider)` returns `AsyncValue<List<Category>>`.
final categoriesProvider = StreamProvider<List<Category>>((ref) {
  return ref.watch(categoriesRepositoryProvider).watchAll();
});

/// Streams a single [Category] by [id], or `null` if not found or
/// soft-deleted. Re-emits whenever the record changes.
final categoryByIdProvider = StreamProvider.family<Category?, String>((ref, id) {
  return ref.watch(categoriesRepositoryProvider).watchById(id);
});

/// Streams all non-deleted top-level categories of [type] (`parentId IS NULL`).
/// Re-emits on every change.
///
/// Usage: `ref.watch(categoriesByTypeProvider(CategoryType.expense))`.
final categoriesByTypeProvider = StreamProvider.family<List<Category>, CategoryType>((ref, type) {
  return ref.watch(categoriesRepositoryProvider).watchByType(type);
});

/// Streams all non-deleted direct children of [parentId]. Re-emits on every
/// change.
///
/// Usage: `ref.watch(subcategoriesProvider('parent-id'))`.
final subcategoriesProvider = StreamProvider.family<List<Category>, String>((ref, parentId) {
  return ref.watch(categoriesRepositoryProvider).watchSubcategories(parentId);
});
