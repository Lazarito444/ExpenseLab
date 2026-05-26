import 'package:expenselab/widgets/scaffold/expense_lab_app_bar.dart';
import 'package:expenselab/widgets/scaffold/expense_lab_nav_bar.dart';
import 'package:flutter/material.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ExpenseLabAppBar(),
      bottomNavigationBar: const ExpenseLabNavBar(),
      body: child,
    );
  }
}
