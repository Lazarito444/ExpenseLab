import 'package:drift/drift.dart';
import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/helpers/uuid_factory.dart';
import 'package:expenselab/features/savings/data/datasources/savings_contributions_local_datasource.dart';

/// Drift-backed implementation of [SavingsContributionsLocalDataSource].
///
/// All read methods exclude soft-deleted rows (`isDeleted = true`).
/// [create] only assigns [id]; [createdAt], [updatedAt], and [isDeleted] are
/// handled by the [SoftDeleteTable] client defaults.
class SavingsContributionsLocalDataSourceImpl
    implements SavingsContributionsLocalDataSource {
  const SavingsContributionsLocalDataSourceImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<SavingsContribution>> watchAll() =>
      (_db.select(_db.savingsContributions)..where((t) => t.isDeleted.equals(false)))
          .watch();

  @override
  Stream<SavingsContribution?> watchById(String id) =>
      (_db.select(_db.savingsContributions)
            ..where((t) => t.id.equals(id) & t.isDeleted.equals(false)))
          .watchSingleOrNull();

  @override
  Future<List<SavingsContribution>> getAll() =>
      (_db.select(_db.savingsContributions)..where((t) => t.isDeleted.equals(false)))
          .get();

  @override
  Future<SavingsContribution?> getById(String id) =>
      (_db.select(_db.savingsContributions)
            ..where((t) => t.id.equals(id) & t.isDeleted.equals(false)))
          .getSingleOrNull();

  @override
  Stream<List<SavingsContribution>> watchByGoalId(String savingsGoalId) =>
      (_db.select(_db.savingsContributions)
            ..where((t) =>
                t.isDeleted.equals(false) &
                t.savingsGoalId.equals(savingsGoalId)))
          .watch();

  @override
  Future<String> create(SavingsContributionsCompanion data) async {
    final id = newId();
    await _db.into(_db.savingsContributions).insert(data.copyWith(id: Value(id)));
    return id;
  }

  @override
  Future<void> update(String id, SavingsContributionsCompanion data) =>
      (_db.update(_db.savingsContributions)..where((t) => t.id.equals(id)))
          .write(data.copyWith(updatedAt: Value(DateTime.now().toUtc())));

  @override
  Future<void> delete(String id) {
    final now = DateTime.now().toUtc();
    return (_db.update(_db.savingsContributions)..where((t) => t.id.equals(id))).write(
      SavingsContributionsCompanion(
        isDeleted: const Value(true),
        deletedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }
}
