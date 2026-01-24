class Account {
  final int? id;
  final String name;
  final String currencyCode;
  final double currentBalance;
  final String colorHex;
  final int iconCodePoint;
  final bool isArchived;

  Account({
    required this.name,
    required this.currencyCode,
    required this.currentBalance,
    required this.colorHex,
    required this.iconCodePoint,
    this.id,
    this.isArchived = false,
  });
}
