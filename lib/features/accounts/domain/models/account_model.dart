import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/features/accounts/data/tables/accounts_table.dart';

class AccountModel {
  const AccountModel({
    required this.id,
    required this.name,
    required this.type,
    required this.currencyCode,
    required this.icon,
    required this.balance,
    this.creditLimit,
    this.statementDay,
    this.dueDay,
    this.apr,
    this.minPaymentFixed,
    this.minPaymentPercent,
    this.rewardType,
    this.rewardRate,
  });

  final String id;
  final String name;
  final AccountType type;
  final String currencyCode;
  final String icon;
  final double balance;

  // Credit-card-specific fields
  final double? creditLimit;
  final int? statementDay;
  final int? dueDay;
  final double? apr;
  final double? minPaymentFixed;
  final double? minPaymentPercent;
  final String? rewardType;
  final double? rewardRate;

  /// For credit cards, invert the raw balance so that outstanding debt
  /// displays as a positive number (e.g. $500 owed instead of -$500).
  /// For cash/bank accounts, returns the raw balance unchanged.
  double get displayBalance =>
      type == AccountType.creditCard ? -balance : balance;

  /// Utilization ratio (0.0–1.0) or null if no credit limit is set.
  double? get utilization {
    if (creditLimit == null || creditLimit! <= 0) return null;
    final used = type == AccountType.creditCard ? -balance : balance;
    if (used <= 0) return 0.0;
    return (used / creditLimit!).clamp(0.0, 1.0);
  }

  /// Available credit (credit limit - outstanding) or null.
  double? get availableCredit {
    if (creditLimit == null) return null;
    final used = type == AccountType.creditCard ? -balance : balance;
    return (creditLimit! - used).clamp(0.0, creditLimit!);
  }

  /// Minimum payment due, computed from fixed or percentage settings.
  double? get minimumPayment {
    if (type != AccountType.creditCard) return null;
    final outstanding = -balance;
    if (outstanding <= 0) return 0.0;

    if (minPaymentFixed != null && minPaymentFixed! > 0) {
      return minPaymentFixed!;
    }
    if (minPaymentPercent != null && minPaymentPercent! > 0) {
      return outstanding * (minPaymentPercent! / 100);
    }
    return null;
  }

  /// Next payment date computed from [dueDay] and today's date.
  DateTime? get nextPaymentDate {
    if (dueDay == null) return null;
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month, dueDay!.clamp(1, 28));
    return thisMonth.isBefore(now)
        ? DateTime(now.year, now.month + 1, dueDay!.clamp(1, 28))
        : thisMonth;
  }

  /// Next statement closing date computed from [statementDay].
  DateTime? get nextStatementDate {
    if (statementDay == null) return null;
    final now = DateTime.now();
    final thisMonth =
        DateTime(now.year, now.month, statementDay!.clamp(1, 28));
    return thisMonth.isBefore(now)
        ? DateTime(now.year, now.month + 1, statementDay!.clamp(1, 28))
        : thisMonth;
  }

  factory AccountModel.fromAccount(Account account, double balance) =>
      AccountModel(
        id: account.id,
        name: account.name,
        type: account.type,
        currencyCode: account.currencyCode,
        icon: account.icon,
        balance: balance,
        creditLimit: account.creditLimit,
        statementDay: account.statementDay,
        dueDay: account.dueDay,
        apr: account.apr,
        minPaymentFixed: account.minPaymentFixed,
        minPaymentPercent: account.minPaymentPercent,
        rewardType: account.rewardType,
        rewardRate: account.rewardRate,
      );
}
