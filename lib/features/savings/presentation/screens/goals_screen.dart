import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF171B18) : const Color(0xFFF9FAF9),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.savings_outlined,
                size: 72,
                color: context.colorScheme.primary.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 20),
              Text(
                'Goals',
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontWeight: FontWeight.w800,
                  fontSize: 28,
                  color: isDark ? Colors.white : const Color(0xFF0F1E36),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Coming soon...',
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 15,
                  color: isDark ? Colors.white38 : const Color(0xFF9EAEA2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
