import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/features/transactions/data/tables/transactions_table.dart';

class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.accountId,
    this.toAccountId,
    this.categoryId,
    this.note,
    this.rrule,
  });

  final String id;
  final TransactionType type;
  final double amount;
  final DateTime date;
  final String accountId;
  final String? toAccountId;
  final String? categoryId;
  final String? note;
  final String? rrule;

  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;
  bool get isTransfer => type == TransactionType.transfer;

  factory TransactionModel.fromTransaction(Transaction tx) => TransactionModel(
    id: tx.id,
    type: tx.type,
    amount: tx.amount,
    date: tx.date,
    accountId: tx.accountId,
    toAccountId: tx.toAccountId,
    categoryId: tx.categoryId,
    note: tx.note,
    rrule: tx.rrule,
  );
}
