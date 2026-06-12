import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget buildSettingsCard(BuildContext context, {required Widget child}) {
  final appColors = context.appColors;
  return Container(
    decoration: BoxDecoration(
      color: appColors.cardSurface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: appColors.inputBorder,
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: child,
  );
}

Widget buildDivider(BuildContext context) {
  return Divider(
    height: 1,
    thickness: 1,
    color: context.appColors.inputBorder,
    indent: 56,
  );
}

Widget buildToggleTile({
  required BuildContext context,
  required String label,
  required String subtitle,
  required IconData icon,
  required bool value,
  required ValueChanged<bool> onChanged,
}) {
  final appColors = context.appColors;
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
        icon,
        color: context.colorScheme.primary,
        size: 20,
      ),
    ),
    title: Text(
      label,
      style: TextStyle(
        fontFamily: 'Epilogue',
        fontWeight: FontWeight.w500,
        fontSize: 15,
        color: appColors.primaryText,
      ),
    ),
    subtitle: Text(
      subtitle,
      style: TextStyle(
        fontFamily: 'Epilogue',
        fontSize: 12,
        color: appColors.secondaryLabel,
      ),
    ),
    trailing: Switch(
      value: value,
      onChanged: onChanged,
    ),
  );
}

Widget buildDangerTile({
  required BuildContext context,
  required String label,
  required String subtitle,
  required IconData icon,
  required VoidCallback onTap,
}) {
  const dangerColor = Color(0xFFD9534F);
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    leading: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: dangerColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: dangerColor,
        size: 20,
      ),
    ),
    title: Text(
      label,
      style: const TextStyle(
        fontFamily: 'Epilogue',
        fontWeight: FontWeight.w500,
        fontSize: 15,
        color: dangerColor,
      ),
    ),
    subtitle: Text(
      subtitle,
      style: TextStyle(
        fontFamily: 'Epilogue',
        fontSize: 12,
        color: dangerColor.withValues(alpha: 0.6),
      ),
    ),
    trailing: const Icon(
      Icons.chevron_right_rounded,
      color: dangerColor,
      size: 20,
    ),
    onTap: onTap,
  );
}

Widget buildOptionTile({
  required BuildContext context,
  required WidgetRef ref,
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
  IconData? icon,
}) {
  final appColors = context.appColors;
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
        color: isSelected ? context.colorScheme.primary : appColors.primaryText,
      ),
    ),
    trailing: isSelected
        ? Icon(Icons.check_circle_rounded, color: context.colorScheme.primary, size: 20)
        : Icon(
            Icons.circle_outlined,
            color: appColors.secondaryLabel,
            size: 20,
          ),
    onTap: onTap,
  );
}
