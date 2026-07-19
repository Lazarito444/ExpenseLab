import 'package:drift/drift.dart';
import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/helpers/uuid_factory.dart';
import 'package:expenselab/features/reports/data/datasources/reports_local_datasource.dart';

class ReportsLocalDataSourceImpl implements ReportsLocalDataSource {
  const ReportsLocalDataSourceImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Report>> watchAll() =>
      (_db.select(_db.reports)..where((t) => t.isDeleted.equals(false))).watch();

  @override
  Stream<Report?> watchById(String id) =>
      (_db.select(_db.reports)..where((t) => t.id.equals(id) & t.isDeleted.equals(false)))
          .watchSingleOrNull();

  @override
  Future<List<Report>> getAll() =>
      (_db.select(_db.reports)..where((t) => t.isDeleted.equals(false))).get();

  @override
  Future<Report?> getById(String id) =>
      (_db.select(_db.reports)..where((t) => t.id.equals(id) & t.isDeleted.equals(false)))
          .getSingleOrNull();

  @override
  Future<Report?> findByYearMonth(int year, int month) async {
    final results = await (_db.select(_db.reports)
          ..where((t) => t.isDeleted.equals(false) & t.year.equals(year) & t.month.equals(month)))
        .get();
    return results.isNotEmpty ? results.first : null;
  }

  @override
  Future<String> create(ReportsCompanion data) async {
    final id = newId();
    await _db.into(_db.reports).insert(data.copyWith(id: Value(id)));
    return id;
  }

  @override
  Future<void> delete(String id) {
    final now = DateTime.now().toUtc();
    return (_db.update(_db.reports)..where((t) => t.id.equals(id))).write(
      ReportsCompanion(
        isDeleted: const Value(true),
        deletedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }
}
