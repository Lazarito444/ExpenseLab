import 'package:drift/drift.dart';
import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/helpers/uuid_factory.dart';
import 'package:expenselab/features/transactions/data/repositories/transactions_repository.dart';
import 'package:rrule/rrule.dart';

class RecurrenceService {
  const RecurrenceService(this._repo);

  final TransactionsRepository _repo;

  static const _horizonDays = 365;

  /// Generates occurrences for all templates up to one year from now.
  /// All new rows are inserted in a single DB transaction per template, so
  /// only one Riverpod stream emission fires per template — avoiding the
  /// pause-count assertion that triggered when creating rows one-by-one.
  Future<void> generateUpcoming() async {
    final templates = await _repo.getTemplates();
    final horizon = DateTime.now().toUtc().add(const Duration(days: _horizonDays));
    for (final template in templates) {
      await _generateForTemplate(template, horizon);
    }
  }

  Future<void> _generateForTemplate(Transaction template, DateTime horizon) async {
    final lastDate = await _repo.getLastOccurrenceDate(template.id);
    final startLocal = lastDate != null
        ? lastDate.add(const Duration(seconds: 1))
        : template.date;
    final startUtc = startLocal.toUtc();

    if (startUtc.isAfter(horizon)) return;

    final RecurrenceRule rule;
    try {
      rule = RecurrenceRule.fromString(template.rrule!);
    } catch (_) {
      return;
    }

    final dates = rule.getAllInstances(
      start: startUtc,
      before: horizon,
      includeBefore: true,
    );

    if (dates.isEmpty) return;

    // Build all companions first, then insert in one DB transaction so that
    // Drift emits a single stream update instead of N updates (which caused
    // Riverpod's pause-count assertion to fire).
    final companions = dates
        .map(
          (utcDate) => TransactionsCompanion(
            id: Value(newId()),
            type: Value(template.type),
            amount: Value(template.amount),
            date: Value(utcDate.toLocal()),
            accountId: Value(template.accountId),
            toAccountId: Value(template.toAccountId),
            categoryId: Value(template.categoryId),
            note: Value(template.note),
            exchangeRate: Value(template.exchangeRate),
            recurrenceId: Value(template.id),
          ),
        )
        .toList();

    await _repo.createBatch(companions);
  }
}
