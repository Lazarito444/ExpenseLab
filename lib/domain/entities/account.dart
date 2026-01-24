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

  Account copyWith({
    int? id,
    String? name,
    String? currencyCode,
    double? currentBalance,
    String? colorHex,
    int? iconCodePoint,
    bool? isArchived,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      currencyCode: currencyCode ?? this.currencyCode,
      currentBalance: currentBalance ?? this.currentBalance,
      colorHex: colorHex ?? this.colorHex,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}
