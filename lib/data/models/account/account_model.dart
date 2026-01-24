import 'package:isar/isar.dart';

part 'account_model.g.dart';

@collection
class AccountModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, caseSensitive: false)
  late String name;

  late String currencyCode;

  late double currentBalance;

  late String colorHex;

  late int iconCodePoint;

  @Index()
  late bool isArchived;
}
