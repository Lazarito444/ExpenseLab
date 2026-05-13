import 'package:drift/drift.dart';

/// Full soft-delete base: id, created_at, updated_at, is_deleted, deleted_at.
/// Used by: Accounts, Categories, Transactions, Budgets, SavingsGoals, SavingsContributions.
mixin SoftDeleteTable on Table {
  TextColumn get id => text()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Timestamps only: id, created_at, updated_at — no soft-delete columns.
/// Used by: TransactionImages.
mixin TimestampedTable on Table {
  TextColumn get id => text()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
