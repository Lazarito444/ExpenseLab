import 'package:drift/drift.dart';
import 'package:expenselab/core/database/base_table.dart';

enum AccountType {
  cash,
  bankAccount,
  creditCard,
}

class Accounts extends Table with SoftDeleteTable {
  TextColumn get name => text()();

  /// Stored as int index of [AccountType].
  IntColumn get type => intEnum<AccountType>()();

  /// ISO 4217 code, e.g. "USD".
  TextColumn get currencyCode => text()();

  /// Icon name from [Icons] class.
  TextColumn get icon => text()();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  // ── Credit-card-specific fields (nullable for cash/bank accounts) ──

  /// Credit limit amount (e.g. 5000.00). Null if not set.
  RealColumn get creditLimit => real().nullable()();

  /// Statement closing day of month (1–28). Null for non-credit-card accounts.
  IntColumn get statementDay => integer().nullable()();

  /// Payment due day of month (1–28). Null for non-credit-card accounts.
  IntColumn get dueDay => integer().nullable()();

  /// Annual percentage rate (e.g. 24.99). Null if not set.
  RealColumn get apr => real().nullable()();

  /// Fixed minimum payment amount. Null if using percentage-based minimum.
  RealColumn get minPaymentFixed => real().nullable()();

  /// Minimum payment as a percentage of the outstanding balance (e.g. 2.0 for 2%).
  RealColumn get minPaymentPercent => real().nullable()();

  /// Reward type: 'cashback', 'points', 'miles', or null.
  TextColumn get rewardType => text().nullable()();

  /// Reward rate (e.g. 0.02 for 2% cashback, 1.0 for 1 point per dollar).
  RealColumn get rewardRate => real().nullable()();
}
