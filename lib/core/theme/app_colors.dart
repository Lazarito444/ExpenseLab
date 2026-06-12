import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.scaffoldBackground,
    required this.cardSurface,
    required this.cardSurfaceElevated,
    required this.inputFill,
    required this.inputBorder,
    required this.primaryText,
    required this.secondaryLabel,
    required this.incomeColor,
    required this.incomeBg,
    required this.expenseColor,
    required this.expenseBg,
    required this.transferColor,
    required this.navArrowBg,
    required this.sheetHandle,
    required this.balanceCardPositiveBg,
    required this.balanceCardNegativeBg,
  });

  final Color scaffoldBackground;
  final Color cardSurface;
  final Color cardSurfaceElevated;
  final Color inputFill;
  final Color inputBorder;
  final Color primaryText;
  final Color secondaryLabel;
  final Color incomeColor;
  final Color incomeBg;
  final Color expenseColor;
  final Color expenseBg;
  final Color transferColor;
  final Color navArrowBg;
  final Color sheetHandle;
  final Color balanceCardPositiveBg;
  final Color balanceCardNegativeBg;

  static const light = AppColors(
    scaffoldBackground: Color(0xFFF8F8F8),
    cardSurface: Colors.white,
    cardSurfaceElevated: Colors.white,
    inputFill: Colors.white,
    inputBorder: Color(0xFFE5E5E5),
    primaryText: Color(0xFF0F1E36),
    secondaryLabel: Color(0xFF9EAEA2),
    incomeColor: Color(0xFF2E7D32),
    incomeBg: Color(0xFFE8F5E9),
    expenseColor: Color(0xFFC62828),
    expenseBg: Color(0xFFFFEBEE),
    transferColor: Color(0xFF757575),
    navArrowBg: Color(0xFFF2F2F2),
    sheetHandle: Color(0xFFE0E0E0),
    balanceCardPositiveBg: Color(0xFF2D6831),
    balanceCardNegativeBg: Color(0xFFC62828),
  );

  static const dark = AppColors(
    scaffoldBackground: Color(0xFF171B18),
    cardSurface: Color(0xFF1E2420),
    cardSurfaceElevated: Color(0xFF2A312C),
    inputFill: Color(0xFF2A312C),
    inputBorder: Color(0x1FFFFFFF),
    primaryText: Colors.white,
    secondaryLabel: Color(0x61FFFFFF),
    incomeColor: Color(0xFF66BB6A),
    incomeBg: Color(0x1A66BB6A),
    expenseColor: Color(0xFFEF5350),
    expenseBg: Color(0x1AEF5350),
    transferColor: Color(0xFF9E9E9E),
    navArrowBg: Color(0xFF2A2F2B),
    sheetHandle: Color(0x3DFFFFFF),
    balanceCardPositiveBg: Color(0xFF1A3B1D),
    balanceCardNegativeBg: Color(0xFF7B1A1A),
  );

  @override
  AppColors copyWith({
    Color? scaffoldBackground,
    Color? cardSurface,
    Color? cardSurfaceElevated,
    Color? inputFill,
    Color? inputBorder,
    Color? primaryText,
    Color? secondaryLabel,
    Color? incomeColor,
    Color? incomeBg,
    Color? expenseColor,
    Color? expenseBg,
    Color? transferColor,
    Color? navArrowBg,
    Color? sheetHandle,
    Color? balanceCardPositiveBg,
    Color? balanceCardNegativeBg,
  }) {
    return AppColors(
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      cardSurface: cardSurface ?? this.cardSurface,
      cardSurfaceElevated: cardSurfaceElevated ?? this.cardSurfaceElevated,
      inputFill: inputFill ?? this.inputFill,
      inputBorder: inputBorder ?? this.inputBorder,
      primaryText: primaryText ?? this.primaryText,
      secondaryLabel: secondaryLabel ?? this.secondaryLabel,
      incomeColor: incomeColor ?? this.incomeColor,
      incomeBg: incomeBg ?? this.incomeBg,
      expenseColor: expenseColor ?? this.expenseColor,
      expenseBg: expenseBg ?? this.expenseBg,
      transferColor: transferColor ?? this.transferColor,
      navArrowBg: navArrowBg ?? this.navArrowBg,
      sheetHandle: sheetHandle ?? this.sheetHandle,
      balanceCardPositiveBg: balanceCardPositiveBg ?? this.balanceCardPositiveBg,
      balanceCardNegativeBg: balanceCardNegativeBg ?? this.balanceCardNegativeBg,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      scaffoldBackground: Color.lerp(scaffoldBackground, other.scaffoldBackground, t)!,
      cardSurface: Color.lerp(cardSurface, other.cardSurface, t)!,
      cardSurfaceElevated: Color.lerp(cardSurfaceElevated, other.cardSurfaceElevated, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      inputBorder: Color.lerp(inputBorder, other.inputBorder, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryLabel: Color.lerp(secondaryLabel, other.secondaryLabel, t)!,
      incomeColor: Color.lerp(incomeColor, other.incomeColor, t)!,
      incomeBg: Color.lerp(incomeBg, other.incomeBg, t)!,
      expenseColor: Color.lerp(expenseColor, other.expenseColor, t)!,
      expenseBg: Color.lerp(expenseBg, other.expenseBg, t)!,
      transferColor: Color.lerp(transferColor, other.transferColor, t)!,
      navArrowBg: Color.lerp(navArrowBg, other.navArrowBg, t)!,
      sheetHandle: Color.lerp(sheetHandle, other.sheetHandle, t)!,
      balanceCardPositiveBg: Color.lerp(balanceCardPositiveBg, other.balanceCardPositiveBg, t)!,
      balanceCardNegativeBg: Color.lerp(balanceCardNegativeBg, other.balanceCardNegativeBg, t)!,
    );
  }
}
