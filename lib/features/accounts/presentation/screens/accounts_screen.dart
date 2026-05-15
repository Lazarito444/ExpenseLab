import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          t.app.name,
          style: context.textTheme.titleMedium,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              const Text("My Accounts"),
              const Text("Your financial overview at a glance"),
              _totalNetWorthCard(),
              _accountsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _totalNetWorthCard() {
    return const SizedBox(height: 150, child: Placeholder());
  }

  Widget _accountsList() {
    return const SizedBox();
  }
}
