import 'package:expenselab/core/database/app_database.dart';

abstract class ReportsLocalDataSource {
  Stream<List<Report>> watchAll();
  Stream<Report?> watchById(String id);
  Future<List<Report>> getAll();
  Future<Report?> getById(String id);
  Future<Report?> findByYearMonth(int year, int month);
  Future<String> create(ReportsCompanion data);
  Future<void> delete(String id);
}
