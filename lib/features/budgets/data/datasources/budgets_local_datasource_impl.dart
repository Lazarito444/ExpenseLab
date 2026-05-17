import 'package:drift/drift.dart';
import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/helpers/uuid_factory.dart';
import 'package:expenselab/features/budgets/data/datasources/budgets_local_datasource.dart';

/// Drift-backed implementation of [BudgetsLocalDataSource].
///
/// All read methods exclude soft-deleted rows (`isDeleted = true`).
/// [create] only assigns [id]; [createdAt], [updatedAt], and [isDeleted] are
/// handled by the [SoftDeleteTable] client defaults.
class BudgetsLocalDataSourceImpl implements BudgetsLocalDataSource {
  const BudgetsLocalDataSourceImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Budget>> watchAll() => (_db.select(_db.budgets)..where((t) => t.isDeleted.equals(false))).watch();

  @override
  Stream<Budget?> watchById(String id) => (_db.select(_db.budgets)..where((t) => t.id.equals(id) & t.isDeleted.equals(false))).watchSingleOrNull();

  @override
  Future<List<Budget>> getAll() => (_db.select(_db.budgets)..where((t) => t.isDeleted.equals(false))).get();

  @override
  Future<Budget?> getById(String id) => (_db.select(_db.budgets)..where((t) => t.id.equals(id) & t.isDeleted.equals(false))).getSingleOrNull();

  @override
  Stream<List<Budget>> watchByCategoryId(String categoryId) => (_db.select(_db.budgets)..where((t) => t.isDeleted.equals(false) & t.categoryId.equals(categoryId))).watch();

  @override
  Future<String> create(BudgetsCompanion data) async {
    final id = newId();
    await _db.into(_db.budgets).insert(data.copyWith(id: Value(id)));
    return id;
  }

  @override
  Future<void> update(String id, BudgetsCompanion data) => (_db.update(_db.budgets)..where((t) => t.id.equals(id))).write(data.copyWith(updatedAt: Value(DateTime.now().toUtc())));

  @override
  Future<void> delete(String id) {
    final now = DateTime.now().toUtc();
    return (_db.update(_db.budgets)..where((t) => t.id.equals(id))).write(
      BudgetsCompanion(
        isDeleted: const Value(true),
        deletedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }
}
