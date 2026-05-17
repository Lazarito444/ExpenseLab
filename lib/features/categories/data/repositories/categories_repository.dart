import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/features/categories/data/datasources/categories_local_datasource.dart';
import 'package:expenselab/features/categories/data/tables/categories_table.dart';

/// Mediates access to [Category] data on behalf of application features.
///
/// Currently delegates all operations to [CategoriesLocalDataSource]. When a
/// remote data source is introduced, add it as a second field here and
/// implement an offline-first (or remote-first) strategy — callers and
/// providers are unaffected because they depend on this class, not on the
/// datasource directly.
class CategoriesRepository {
  const CategoriesRepository(this._local);

  final CategoriesLocalDataSource _local;

  /// Streams all non-deleted categories, re-emitting on every database change.
  Stream<List<Category>> watchAll() => _local.watchAll();

  /// Streams a single non-deleted category by [id], or `null` if not found.
  Stream<Category?> watchById(String id) => _local.watchById(id);

  /// Returns all non-deleted categories as a one-shot future.
  Future<List<Category>> getAll() => _local.getAll();

  /// Returns a single non-deleted category by [id], or `null` if not found.
  Future<Category?> getById(String id) => _local.getById(id);

  /// Streams all non-deleted top-level categories of [type].
  Stream<List<Category>> watchByType(CategoryType type) => _local.watchByType(type);

  /// Streams all non-deleted direct children of [parentId].
  Stream<List<Category>> watchSubcategories(String parentId) => _local.watchSubcategories(parentId);

  /// Inserts a new category and returns its generated [id].
  Future<String> create(CategoriesCompanion data) => _local.create(data);

  /// Overwrites the mutable fields of the category identified by [id].
  Future<void> update(String id, CategoriesCompanion data) => _local.update(id, data);

  /// Soft-deletes the category identified by [id].
  Future<void> delete(String id) => _local.delete(id);
}
