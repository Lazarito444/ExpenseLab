import 'package:expenselab/core/database/app_database.dart';

class TransactionImageModel {
  const TransactionImageModel({
    required this.id,
    required this.transactionId,
    required this.localPath,
  });

  final String id;
  final String transactionId;
  final String localPath;

  factory TransactionImageModel.fromTransactionImage(
    TransactionImage image,
  ) => TransactionImageModel(
    id: image.id,
    transactionId: image.transactionId,
    localPath: image.localPath,
  );
}
