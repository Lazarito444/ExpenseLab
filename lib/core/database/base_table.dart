import 'package:drift/drift.dart';

/// Full soft-delete base: id, created_at, updated_at, is_deleted, deleted_at.
/// Used by: Accounts, Categories, Transactions, Budgets, SavingsGoals, SavingsContributions.
mixin SoftDeleteTable on Table {
  TextColumn get id => text()();

  /// Set automatically on insert via [clientDefault]; always stored in UTC.
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now().toUtc())();

  /// Set automatically on insert via [clientDefault]; always stored in UTC.
  /// Must be updated manually on every subsequent write using [DateTime.now().toUtc()].
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now().toUtc())();

  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Timestamps only: id, created_at, updated_at — no soft-delete columns.
/// Used by: TransactionImages.
mixin TimestampedTable on Table {
  TextColumn get id => text()();

  /// Set automatically on insert via [clientDefault]; always stored in UTC.
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now().toUtc())();

  /// Set automatically on insert via [clientDefault]; always stored in UTC.
  /// Must be updated manually on every subsequent write using [DateTime.now().toUtc()].
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now().toUtc())();

  @override
  Set<Column> get primaryKey => {id};
}
