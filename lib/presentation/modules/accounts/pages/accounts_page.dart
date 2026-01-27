import 'package:expense_lab/presentation/modules/accounts/controllers/accounts_controller.dart';
import 'package:expense_lab/presentation/modules/accounts/lang/accounts_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountsPage extends GetView<AccountsController> {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;

    return Scaffold(
      //backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AccountsStrings.title.tr,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Net Worth Card
            _NetWorthCard(controller: controller),
            const SizedBox(height: 24),

            // Action Buttons
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _ActionButton(
                    icon: Icons.add_circle_outline,
                    label: AccountsStrings.addAccount.tr,
                    color: theme.colorScheme.primary,
                    onPressed: () {},
                    isPrimary: true,
                  ),
                  const SizedBox(width: 12),
                  _ActionButton(
                    icon: Icons.swap_horiz,
                    label: AccountsStrings.transfer.tr,
                    color: theme.colorScheme.surface,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 12),
                  _ActionButton(
                    icon: Icons.bar_chart,
                    label: AccountsStrings.reports.tr,
                    color: theme.colorScheme.surface,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Account Sections
            Obx(
              () => Column(
                children: controller.sections.map((section) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(section: section),
                      const SizedBox(height: 12),
                      ...section.accounts.map((account) => _AccountTile(account: account)),
                      const SizedBox(height: 24),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NetWorthCard extends StatelessWidget {
  final AccountsController controller;

  const _NetWorthCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 0,
      color: isDark ? const Color(0xFF11141D) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: isDark ? BorderSide(color: Colors.white.withValues(alpha: 0.08)) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  AccountsStrings.totalNetWorth.tr,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Obx(
                  () => Text(
                    controller.netWorth.value,
                    style: GoogleFonts.inter(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Obx(
                  () => Text(
                    controller.netWorthCurrency.value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF28A745).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.trending_up,
                    size: 16,
                    color: Color(0xFF28A745),
                  ),
                  const SizedBox(width: 4),
                  Obx(
                    () => Text(
                      controller.netWorthChange.value,
                      style: const TextStyle(
                        color: Color(0xFF28A745),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AccountsStrings.vsLastMonth.tr,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Custom button style to match design
    final bgColor = isPrimary ? theme.colorScheme.primary : (isDark ? const Color(0xFF1C1F2E) : Colors.grey.shade100);
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: !isPrimary && isDark ? Border.all(color: Colors.white.withValues(alpha: 0.08)) : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isPrimary ? Colors.white : theme.colorScheme.onSurface,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? Colors.white : theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final AccountSectionUiModel section;

  const _SectionHeader({required this.section});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          section.title.tr,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        Text(
          section.total,
          style: TextStyle(
            color: section.totalColor != null ? Color(int.parse(section.totalColor!)) : theme.colorScheme.onSurface, // Fallback if color parsing logic needed
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _AccountTile extends StatelessWidget {
  final AccountUiModel account;

  const _AccountTile({required this.account});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF11141D) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isDark ? Border.all(color: Colors.white.withValues(alpha: 0.05)) : null,
      ),
      child: Row(
        children: [
          // Icon Placeholder
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1C1F2E) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.account_balance_wallet, // Simplified icon logic
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      account.currency,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                    ),
                    if (account.status.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      const Text("•", style: TextStyle(color: Colors.grey, fontSize: 10)),
                      const SizedBox(width: 6),
                      Text(
                        account.status.tr,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                    if (account.endingIn != null) ...[
                      const SizedBox(width: 6),
                      const Text("•", style: TextStyle(color: Colors.grey, fontSize: 10)),
                      const SizedBox(width: 6),
                      Text(
                        "${AccountsStrings.endingIn.tr} ${account.endingIn}",
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
                if (account.returns != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        account.returns!,
                        style: const TextStyle(
                          color: Color(0xFFD4AF37),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AccountsStrings.annualReturn.tr,
                        style: const TextStyle(
                          color: Color(0xFFD4AF37),
                          fontSize: 10, // Slightly smaller for "ANNUAL" label
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                account.balance,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: account.balance.startsWith('-') ? theme.colorScheme.error : theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Icon(
                Icons.more_vert,
                size: 20,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
