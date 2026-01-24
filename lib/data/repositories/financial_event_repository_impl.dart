import 'dart:convert';

import 'package:expense_lab/data/models/event/financial_event_model.dart';
import 'package:expense_lab/domain/repositories/i_event_repository.dart';
import 'package:isar/isar.dart';

class FinancialEventRepositoryImpl implements IEventRepository {
  final Isar _isar;

  FinancialEventRepositoryImpl(this._isar);

  @override
  Future<void> recordEvent({
    required String aggregateId,
    required String eventType,
    required Map<String, dynamic> payload,
  }) async {
    await _isar.writeTxn(() async {
      final FinancialEventModel? lastEvent = await _isar.financialEventModels.where().aggregateIdEqualTo(aggregateId).sortByVersionDesc().findFirst();

      final int nextVersion = (lastEvent?.version ?? 0) + 1;

      final FinancialEventModel eventRecord = FinancialEventModel()
        ..aggregateId = aggregateId
        ..eventType = eventType
        ..timestamp = DateTime.now()
        ..payloadJson = jsonEncode(payload)
        ..version = nextVersion;

      await _isar.financialEventModels.put(eventRecord);
    });
  }
}
