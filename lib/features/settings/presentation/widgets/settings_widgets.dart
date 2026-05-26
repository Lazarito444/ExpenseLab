import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget buildSettingsCard(bool isDark, {required Widget child}) {
  return Container(
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF1E2420) : Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: isDark ? Colors.white10 : const Color(0xFFEAF0EB),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: child,
  );
}

Widget buildDivider(bool isDark) {
  return Divider(
    height: 1,
    thickness: 1,
    color: isDark ? Colors.white10 : const Color(0xFFEAF0EB),
    indent: 56,
  );
}

Widget buildOptionTile({
  required BuildContext context,
  required WidgetRef ref,
  required String label,
  required bool isSelected,
  required bool isDark,
  required VoidCallback onTap,
  IconData? icon,
}) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    leading: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: context.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon ?? Icons.language_rounded,
        color: context.colorScheme.primary,
        size: 20,
      ),
    ),
    title: Text(
      label,
      style: TextStyle(
        fontFamily: 'Epilogue',
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        fontSize: 15,
        color: isSelected ? context.colorScheme.primary : (isDark ? Colors.white : const Color(0xFF1C221E)),
      ),
    ),
    trailing: isSelected
        ? Icon(Icons.check_circle_rounded, color: context.colorScheme.primary, size: 20)
        : Icon(
            Icons.circle_outlined,
            color: isDark ? Colors.white24 : const Color(0xFFBDCDBF),
            size: 20,
          ),
    onTap: onTap,
  );
}
