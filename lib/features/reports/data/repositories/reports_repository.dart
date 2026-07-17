import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/features/reports/data/datasources/reports_local_datasource.dart';
import 'package:expenselab/features/reports/domain/models/report_model.dart';

class ReportsRepository {
  const ReportsRepository(this._local);

  final ReportsLocalDataSource _local;

  Stream<List<ReportModel>> watchAll() =>
      _local.watchAll().map((list) => list.map(ReportModel.fromReport).toList());

  Stream<ReportModel?> watchById(String id) =>
      _local.watchById(id).map((r) => r != null ? ReportModel.fromReport(r) : null);

  Future<List<ReportModel>> getAll() async =>
      (await _local.getAll()).map(ReportModel.fromReport).toList();

  Future<ReportModel?> getById(String id) async {
    final r = await _local.getById(id);
    return r != null ? ReportModel.fromReport(r) : null;
  }

  Future<ReportModel?> findByYearMonth(int year, int month) async {
    final r = await _local.findByYearMonth(year, month);
    return r != null ? ReportModel.fromReport(r) : null;
  }

  Future<String> create(ReportsCompanion data) => _local.create(data);

  Future<void> delete(String id) => _local.delete(id);
}
