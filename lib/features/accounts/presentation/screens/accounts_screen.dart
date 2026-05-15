import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
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
              const SizedBox(height: 16),
              Text(t.accounts.title, style: context.textTheme.headlineLarge),
              const SizedBox(height: 8),
              Text(t.accounts.subtitle, style: context.textTheme.headlineSmall),
              const SizedBox(height: 16),
              _totalNetWorthCard(context),
              _accountsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _totalNetWorthCard(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: context.colorScheme.primaryFixed,
      ),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          const SizedBox(height: 8),
          Text(
            t.accounts.total_net_worth,
            style: context.textTheme.labelSmall,
          ),
          const SizedBox(height: 8),
          Text(
            r"$12,345.67",
            style: context.textTheme.displayMedium,
          ),
        ],
      ),
    );
  }

  Widget _accountsList() {
    return const SizedBox();
  }
}
