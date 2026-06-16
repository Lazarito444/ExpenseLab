import 'package:flutter/material.dart';

enum RecurrenceScope { thisOnly, thisAndFuture, allOccurrences }

/// Shows a dialog asking the user which occurrences an edit or delete should
/// affect. Returns `null` if the user cancels.
Future<RecurrenceScope?> showRecurrenceScopeDialog(
  BuildContext context, {
  required bool isDelete,
}) {
  final cs = Theme.of(context).colorScheme;
  final action = isDelete ? 'Delete' : 'Edit';

  return showDialog<RecurrenceScope>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: cs.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        '$action recurring transaction',
        style: TextStyle(
          fontFamily: 'Epilogue',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: cs.onSurface,
        ),
      ),
      content: Text(
        'Which occurrences do you want to $action?',
        style: TextStyle(
          fontFamily: 'Epilogue',
          fontSize: 14,
          color: cs.onSurfaceVariant,
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      actionsPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      actionsAlignment: MainAxisAlignment.start,
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ScopeOption(
              label: 'Only this occurrence',
              onTap: () => Navigator.pop(ctx, RecurrenceScope.thisOnly),
              cs: cs,
            ),
            const SizedBox(height: 8),
            _ScopeOption(
              label: 'This and future occurrences',
              onTap: () => Navigator.pop(ctx, RecurrenceScope.thisAndFuture),
              cs: cs,
            ),
            const SizedBox(height: 8),
            _ScopeOption(
              label: 'All occurrences',
              onTap: () => Navigator.pop(ctx, RecurrenceScope.allOccurrences),
              cs: cs,
              isDestructive: isDelete,
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: TextStyle(fontFamily: 'Epilogue', color: cs.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _ScopeOption extends StatelessWidget {
  const _ScopeOption({
    required this.label,
    required this.onTap,
    required this.cs,
    this.isDestructive = false,
  });

  final String label;
  final VoidCallback onTap;
  final ColorScheme cs;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? cs.error : cs.primary;
    return Material(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
