import 'package:drift/drift.dart';
import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/helpers/uuid_factory.dart';
import 'package:expenselab/features/savings/data/datasources/savings_goals_local_datasource.dart';

/// Drift-backed implementation of [SavingsGoalsLocalDataSource].
///
/// All read methods exclude soft-deleted rows (`isDeleted = true`).
/// [create] only assigns [id]; [createdAt], [updatedAt], and [isDeleted] are
/// handled by the [SoftDeleteTable] client defaults.
class SavingsGoalsLocalDataSourceImpl implements SavingsGoalsLocalDataSource {
  const SavingsGoalsLocalDataSourceImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<SavingsGoal>> watchAll() =>
      (_db.select(_db.savingsGoals)..where((t) => t.isDeleted.equals(false))).watch();

  @override
  Stream<SavingsGoal?> watchById(String id) => (_db.select(_db.savingsGoals)
        ..where((t) => t.id.equals(id) & t.isDeleted.equals(false)))
      .watchSingleOrNull();

  @override
  Future<List<SavingsGoal>> getAll() =>
      (_db.select(_db.savingsGoals)..where((t) => t.isDeleted.equals(false))).get();

  @override
  Future<SavingsGoal?> getById(String id) => (_db.select(_db.savingsGoals)
        ..where((t) => t.id.equals(id) & t.isDeleted.equals(false)))
      .getSingleOrNull();

  @override
  Future<String> create(SavingsGoalsCompanion data) async {
    final id = newId();
    await _db.into(_db.savingsGoals).insert(data.copyWith(id: Value(id)));
    return id;
  }

  @override
  Future<void> update(String id, SavingsGoalsCompanion data) =>
      (_db.update(_db.savingsGoals)..where((t) => t.id.equals(id)))
          .write(data.copyWith(updatedAt: Value(DateTime.now().toUtc())));

  @override
  Future<void> delete(String id) {
    final now = DateTime.now().toUtc();
    return (_db.update(_db.savingsGoals)..where((t) => t.id.equals(id))).write(
      SavingsGoalsCompanion(
        isDeleted: const Value(true),
        deletedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }
}
