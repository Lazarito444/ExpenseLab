import 'package:expense_lab/presentation/modules/accounts/lang/accounts_strings.dart';
import 'package:get/get.dart';

class AccountUiModel {
  final String name;
  final String balance;
  final String currency;
  final String status;
  final String? returns;
  final String? endingIn;

  AccountUiModel({
    required this.name,
    required this.balance,
    required this.currency,
    required this.status,
    this.returns,
    this.endingIn,
  });
}

class AccountSectionUiModel {
  final String title;
  final String total;
  final String? totalColor;
  final List<AccountUiModel> accounts;

  AccountSectionUiModel({
    required this.title,
    required this.total,
    required this.accounts,
    this.totalColor,
  });
}

class AccountsController extends GetxController {
  final hasAccounts = false.obs;
  final netWorth = "\$124,500.00".obs;
  final netWorthCurrency = "USD".obs;
  final netWorthChange = "+2.4%".obs;

  final sections = <AccountSectionUiModel>[
    AccountSectionUiModel(
      title: AccountsStrings.sectionCash,
      total: "\$16,250.00",
      accounts: [
        AccountUiModel(
          name: "Physical Wallet",
          balance: "\$4,250.00",
          currency: "USD",
          status: AccountsStrings.active,
        ),
        AccountUiModel(
          name: "Emergency Fund",
          balance: "€12,000.00",
          currency: "EUR",
          status: AccountsStrings.locked,
        ),
      ],
    ),
    AccountSectionUiModel(
      title: AccountsStrings.sectionCredit,
      total: "-\$2,415.50",
      totalColor: "0xFFFF5C5C", // Error color
      accounts: [
        AccountUiModel(
          name: "Sapphire Reserve",
          balance: "-\$1,240.50",
          currency: "USD",
          status: "",
          endingIn: "•••42",
        ),
      ],
    ),
    AccountSectionUiModel(
      title: AccountsStrings.sectionInvestments,
      total: "\$110,665.50",
      accounts: [
        AccountUiModel(
          name: "Brokerage Account",
          balance: "\$92,450.50",
          currency: "USD",
          status: "",
          returns: "+12.4%", // Value only
        ),
        AccountUiModel(
          name: "Cold Wallet",
          balance: "\$18,215.00",
          currency: "BTC, ETH, SOL",
          status: "",
        ),
      ],
    ),
  ].obs;
}
