class ExportData {
  final int version;
  final DateTime exportedAt;
  final String appVersion;
  final bool hasImages;
  final Map<String, dynamic> data;

  const ExportData({
    required this.version,
    required this.exportedAt,
    required this.appVersion,
    required this.hasImages,
    required this.data,
  });

  Map<String, dynamic> toJson() => {
    'version': version,
    'exportedAt': exportedAt.toIso8601String(),
    'appVersion': appVersion,
    'hasImages': hasImages,
    'data': data,
  };

  factory ExportData.fromJson(Map<String, dynamic> json) => ExportData(
    version: json['version'] as int,
    exportedAt: DateTime.parse(json['exportedAt'] as String),
    appVersion: json['appVersion'] as String,
    hasImages: json['hasImages'] as bool? ?? false,
    data: Map<String, dynamic>.from(json['data'] as Map),
  );
}

class ImportSummary {
  final int accounts;
  final int categories;
  final int transactions;
  final int transactionImages;
  final int starredTransactions;
  final int budgets;
  final int savingsGoals;
  final int savingsContributions;
  final int exchangeRates;
  final bool hasSettings;
  final bool hasImages;

  const ImportSummary({
    required this.accounts,
    required this.categories,
    required this.transactions,
    required this.transactionImages,
    required this.starredTransactions,
    required this.budgets,
    required this.savingsGoals,
    required this.savingsContributions,
    required this.exchangeRates,
    required this.hasSettings,
    required this.hasImages,
  });

  bool get isEmpty =>
    accounts == 0 &&
    categories == 0 &&
    transactions == 0 &&
    transactionImages == 0 &&
    starredTransactions == 0 &&
    budgets == 0 &&
    savingsGoals == 0 &&
    savingsContributions == 0 &&
    exchangeRates == 0;
}
