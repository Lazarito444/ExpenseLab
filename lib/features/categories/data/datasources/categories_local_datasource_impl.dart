import 'package:drift/drift.dart';
import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/helpers/uuid_factory.dart';
import 'package:expenselab/features/categories/data/datasources/categories_local_datasource.dart';
import 'package:expenselab/features/categories/data/tables/categories_table.dart';

/// Drift-backed implementation of [CategoriesLocalDataSource].
///
/// All read methods exclude soft-deleted rows (`isDeleted = true`).
/// [create] only assigns [id]; [createdAt], [updatedAt], and [isDeleted] are
/// handled by the [SoftDeleteTable] client defaults.
///
/// [watchByType] additionally filters to top-level categories
/// (`parentId IS NULL`) so subcategories are not double-counted.
class CategoriesLocalDataSourceImpl implements CategoriesLocalDataSource {
  const CategoriesLocalDataSourceImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Category>> watchAll() => (_db.select(_db.categories)..where((t) => t.isDeleted.equals(false))).watch();

  @override
  Stream<Category?> watchById(String id) => (_db.select(_db.categories)..where((t) => t.id.equals(id) & t.isDeleted.equals(false))).watchSingleOrNull();

  @override
  Future<List<Category>> getAll() => (_db.select(_db.categories)..where((t) => t.isDeleted.equals(false))).get();

  @override
  Future<Category?> getById(String id) => (_db.select(_db.categories)..where((t) => t.id.equals(id) & t.isDeleted.equals(false))).getSingleOrNull();

  @override
  Stream<List<Category>> watchByType(CategoryType type) => (_db.select(_db.categories)..where((t) => t.isDeleted.equals(false) & t.type.equals(type.index) & t.parentId.isNull())).watch();

  @override
  Stream<List<Category>> watchSubcategories(String parentId) => (_db.select(_db.categories)..where((t) => t.isDeleted.equals(false) & t.parentId.equals(parentId))).watch();

  @override
  Future<String> create(CategoriesCompanion data) async {
    final id = newId();
    await _db.into(_db.categories).insert(data.copyWith(id: Value(id)));
    return id;
  }

  @override
  Future<void> update(String id, CategoriesCompanion data) => (_db.update(_db.categories)..where((t) => t.id.equals(id))).write(data.copyWith(updatedAt: Value(DateTime.now().toUtc())));

  @override
  Future<void> delete(String id) {
    final now = DateTime.now().toUtc();
    return (_db.update(_db.categories)..where((t) => t.id.equals(id))).write(
      CategoriesCompanion(
        isDeleted: const Value(true),
        deletedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }
}
