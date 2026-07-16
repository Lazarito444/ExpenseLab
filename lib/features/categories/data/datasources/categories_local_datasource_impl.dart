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
  Stream<List<Category>> watchAll() => (_db.select(_db.categories)
    ..where((t) => t.isDeleted.equals(false))
    ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])
  ).watch();

  @override
  Stream<Category?> watchById(String id) => (_db.select(_db.categories)..where((t) => t.id.equals(id) & t.isDeleted.equals(false))).watchSingleOrNull();

  @override
  Future<List<Category>> getAll() => (_db.select(_db.categories)
    ..where((t) => t.isDeleted.equals(false))
    ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])
  ).get();

  @override
  Future<Category?> getById(String id) => (_db.select(_db.categories)..where((t) => t.id.equals(id) & t.isDeleted.equals(false))).getSingleOrNull();

  @override
  Stream<List<Category>> watchByType(CategoryType type) => (_db.select(_db.categories)
    ..where((t) => t.isDeleted.equals(false) & t.type.equals(type.index) & t.parentId.isNull())
    ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])
  ).watch();

  @override
  Stream<List<Category>> watchSubcategories(String parentId) => (_db.select(_db.categories)
    ..where((t) => t.isDeleted.equals(false) & t.parentId.equals(parentId))
    ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])
  ).watch();

  @override
  Future<String> create(CategoriesCompanion data) async {
    final id = newId();
    final count = await (_db.select(_db.categories)..where((t) => t.isDeleted.equals(false))).get().then((r) => r.length);
    await _db.into(_db.categories).insert(data.copyWith(id: Value(id), sortOrder: Value(count)));
    return id;
  }

  @override
  Future<void> update(String id, CategoriesCompanion data) => (_db.update(_db.categories)..where((t) => t.id.equals(id))).write(data.copyWith(updatedAt: Value(DateTime.now().toUtc())));

  @override
  Future<void> delete(String id) => _db.transaction(() async {
    final now = DateTime.now().toUtc();
    final softDelete = CategoriesCompanion(
      isDeleted: const Value(true),
      deletedAt: Value(now),
      updatedAt: Value(now),
    );

    // Cascade: soft-delete all subcategories of this category.
    await (_db.update(_db.categories)..where((t) => t.parentId.equals(id))).write(softDelete);

    // Cascade: soft-delete all budgets linked to this category.
    await (_db.update(_db.budgets)..where((t) => t.categoryId.equals(id))).write(
      BudgetsCompanion(
        isDeleted: const Value(true),
        deletedAt: Value(now),
        updatedAt: Value(now),
      ),
    );

    // Soft-delete the category itself.
    await (_db.update(_db.categories)..where((t) => t.id.equals(id))).write(softDelete);
  });

  @override
  Future<void> reorderCategory(String id, int oldIndex, int newIndex) => _db.transaction(() async {
    final all = await (_db.select(_db.categories)
      ..where((t) => t.isDeleted.equals(false) & t.parentId.isNull())
      ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])
    ).get();

    final moved = all.firstWhere((c) => c.id == id);
    final sameType = all.where((c) => c.type == moved.type).toList();
    final item = sameType.removeAt(oldIndex);
    sameType.insert(newIndex, item);

    for (var i = 0; i < sameType.length; i++) {
      await (_db.update(_db.categories)..where((t) => t.id.equals(sameType[i].id))).write(
        CategoriesCompanion(sortOrder: Value(i), updatedAt: Value(DateTime.now().toUtc())),
      );
    }
  });
}
