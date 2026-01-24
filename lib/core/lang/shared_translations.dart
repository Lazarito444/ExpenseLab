import 'package:expense_lab/core/lang/app_translations.dart';

class SharedStrings {
  static const success = "success";
  static const warning = "warning";
  static const error = "error";
}

class SharedTranslations {
  static Map<String, Map<String, String>> get keys => {
    AppLocales.english: {
      SharedStrings.success: "Success",
      SharedStrings.warning: "Warning",
      SharedStrings.error: "Error",
    },
    AppLocales.spanish: {
      SharedStrings.success: "Éxito",
      SharedStrings.warning: "Advertencia",
      SharedStrings.error: "Error",
    },
  };
}
