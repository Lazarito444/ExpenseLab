import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:expense_lab/data/datasources/local/database.dart';
import 'package:expense_lab/domain/repositories/i_event_repository.dart';

class FinancialEventRepositoryImpl implements IEventRepository {
  final AppDatabase _db;

  FinancialEventRepositoryImpl(this._db);

  @override
  Future<void> recordEvent({
    required String aggregateId,
    required String eventType,
    required Map<String, dynamic> payload,
  }) async {
    await _db.transaction(() async {
      final lastEvent =
          await (_db.select(_db.financialEvents)
                ..where((t) => t.aggregateId.equals(aggregateId))
                ..orderBy([(t) => OrderingTerm(expression: t.version, mode: OrderingMode.desc)])
                ..limit(1))
              .getSingleOrNull();

      final int nextVersion = (lastEvent?.version ?? 0) + 1;

      await _db
          .into(_db.financialEvents)
          .insert(
            FinancialEventsCompanion(
              aggregateId: Value(aggregateId),
              eventType: Value(eventType),
              timestamp: Value(DateTime.now()),
              payloadJson: Value(jsonEncode(payload)),
              version: Value(nextVersion),
            ),
          );
    });
  }
}
