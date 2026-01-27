import 'package:expense_lab/core/lang/app_translations.dart';
import 'package:expense_lab/presentation/modules/accounts/lang/accounts_strings.dart';

class AccountsTranslations {
  static Map<String, Map<String, String>> get keys => {
    AppLocales.english: {
      AccountsStrings.title: "Accounts",
      AccountsStrings.totalNetWorth: "Total Net Worth",
      AccountsStrings.vsLastMonth: "vs last month",
      AccountsStrings.addAccount: "Add Account",
      AccountsStrings.transfer: "Transfer",
      AccountsStrings.reports: "Reports",
      AccountsStrings.sectionCash: "CASH & LIQUIDITY",
      AccountsStrings.sectionCredit: "CREDIT & LIABILITIES",
      AccountsStrings.sectionInvestments: "INVESTMENTS",
      AccountsStrings.active: "ACTIVE",
      AccountsStrings.locked: "LOCKED",
      AccountsStrings.endingIn: "ENDING IN",
      AccountsStrings.annualReturn: "ANNUAL",
    },
    AppLocales.spanish: {
      AccountsStrings.title: "Cuentas",
      AccountsStrings.totalNetWorth: "Patrimonio Neto",
      AccountsStrings.vsLastMonth: "vs mes anterior",
      AccountsStrings.addAccount: "Agregar Cuenta",
      AccountsStrings.transfer: "Transferir",
      AccountsStrings.reports: "Reportes",
      AccountsStrings.sectionCash: "EFECTIVO Y LIQUIDEZ",
      AccountsStrings.sectionCredit: "CRÉDITO Y PASIVOS",
      AccountsStrings.sectionInvestments: "INVERSIONES",
      AccountsStrings.active: "ACTIVA",
      AccountsStrings.locked: "BLOQUEADA",
      AccountsStrings.endingIn: "TERMINA EN",
      AccountsStrings.annualReturn: "ANUAL",
    },
  };
}
