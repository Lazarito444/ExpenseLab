import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/helpers/icon_mapper.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/categories/data/tables/categories_table.dart';
import 'package:expenselab/features/categories/providers/categories_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, bool> _expandedCategories = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF171B18) : const Color(0xFFF9FAF9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back,
            color: context.colorScheme.primary,
            size: 28,
          ),
        ),
        title: Text(
          t.my_categories.title,
          style: TextStyle(
            fontFamily: 'Epilogue',
            fontWeight: FontWeight.w800,
            fontSize: 24,
            color: isDark ? Colors.white : const Color(0xFF0F1E36),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/categories/create'),
            icon: Icon(
              Icons.add_rounded,
              color: context.colorScheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: context.colorScheme.primary,
          indicatorWeight: 3,
          labelColor: context.colorScheme.primary,
          unselectedLabelColor: isDark ? Colors.white60 : const Color(0xFF5D6B60),
          labelStyle: const TextStyle(
            fontFamily: 'Epilogue',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Epilogue',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          tabs: [
            Tab(text: t.my_categories.expenses),
            Tab(text: t.my_categories.income),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _CategoryTypeTab(
            type: CategoryType.expense,
            expandedCategories: _expandedCategories,
            onToggleExpand: (id) {
              setState(() {
                _expandedCategories[id] = !(_expandedCategories[id] ?? false);
              });
            },
          ),
          _CategoryTypeTab(
            type: CategoryType.income,
            expandedCategories: _expandedCategories,
            onToggleExpand: (id) {
              setState(() {
                _expandedCategories[id] = !(_expandedCategories[id] ?? false);
              });
            },
          ),
        ],
      ),
    );
  }
}

class _CategoryTypeTab extends ConsumerWidget {
  const _CategoryTypeTab({
    required this.type,
    required this.expandedCategories,
    required this.onToggleExpand,
  });

  final CategoryType type;
  final Map<String, bool> expandedCategories;
  final ValueChanged<String> onToggleExpand;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesByTypeProvider(type));

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) {
          return _buildEmptyState(context);
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          itemCount: categories.length + 1, // +1 for the Pro Tip card at the bottom
          itemBuilder: (context, index) {
            if (index == categories.length) {
              return _buildProTipCard(context);
            }

            final category = categories[index];
            final isExpanded = expandedCategories[category.id] ?? false;

            return _CategoryItemCard(
              category: category,
              isExpanded: isExpanded,
              onToggleExpand: () => onToggleExpand(category.id),
            );
          },
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(
          color: context.colorScheme.primary,
        ),
      ),
      error: (err, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, color: Colors.red.shade400, size: 48),
            const SizedBox(height: 16),
            Text(
              err.toString(),
              style: const TextStyle(fontFamily: 'Epilogue', fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final t = context.t;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withValues(alpha: isDark ? 0.15 : 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                type == CategoryType.expense ? Icons.money_off_rounded : Icons.account_balance_wallet_rounded,
                size: 72,
                color: context.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              t.my_categories.empty_state,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: isDark ? Colors.white : const Color(0xFF0F1E36),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              t.my_categories.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 14,
                color: isDark ? Colors.white60 : const Color(0xFF5D6B60),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.push('/categories/create?type=${type.name}'),
              icon: const Icon(Icons.add_rounded),
              label: Text(
                t.my_categories.add_category,
                style: const TextStyle(fontFamily: 'Epilogue', fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProTipCard(BuildContext context) {
    final t = context.t;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 40),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2420) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.colorScheme.primary.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.primary.withValues(alpha: isDark ? 0.05 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: context.colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.my_categories.pro_tip,
                  style: TextStyle(
                    fontFamily: 'Epilogue',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                    color: isDark ? Colors.white70 : const Color(0xFF333D35),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryItemCard extends ConsumerWidget {
  const _CategoryItemCard({
    required this.category,
    required this.isExpanded,
    required this.onToggleExpand,
  });

  final Category category;
  final bool isExpanded;
  final VoidCallback onToggleExpand;

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    final t = context.t;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            t.my_categories.delete_category,
            style: const TextStyle(fontFamily: 'Epilogue', fontWeight: FontWeight.bold),
          ),
          content: Text(
            t.my_categories.delete_message,
            style: const TextStyle(fontFamily: 'Epilogue'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                t.common.cancel,
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await ref.read(categoriesRepositoryProvider).delete(category.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(t.my_categories.success_delete),
                        backgroundColor: context.colorScheme.primary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${e.toString()}'),
                        backgroundColor: context.colorScheme.error,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colorScheme.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                t.common.delete,
                style: const TextStyle(
                  fontFamily: 'Epilogue',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subcategoriesAsync = ref.watch(subcategoriesProvider(category.id));

    final categoryColor = Color(category.color);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2420) : Colors.white,
        borderRadius: BorderRadius.circular(24),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Parent category row
          InkWell(
            onTap: onToggleExpand,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(24),
              topRight: const Radius.circular(24),
              bottomLeft: Radius.circular(isExpanded ? 0 : 24),
              bottomRight: Radius.circular(isExpanded ? 0 : 24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon container with dynamic background glow matching color
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: categoryColor.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        iconFromName(category.icon),
                        color: categoryColor,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: TextStyle(
                            fontFamily: 'Epilogue',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: isDark ? Colors.white : const Color(0xFF1C221E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        subcategoriesAsync.when(
                          data: (subs) => Text(
                            subs.isEmpty
                                ? t.my_categories.empty_subcategories
                                : '${subs.length} ${subs.length == 1 ? t.my_categories.subcategory.toLowerCase() : '${t.my_categories.subcategory.toLowerCase()}s'}',
                            style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white60 : const Color(0xFF5D6B60),
                            ),
                          ),
                          loading: () => const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(strokeWidth: 1.5),
                          ),
                          error: (err, stack) => const SizedBox(),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => context.push('/categories/edit/${category.id}'),
                        icon: Icon(
                          Icons.edit_outlined,
                          color: isDark ? Colors.white54 : const Color(0xFF5D6B60),
                          size: 20,
                        ),
                        tooltip: t.common.edit,
                      ),
                      IconButton(
                        onPressed: () => _showDeleteDialog(context, ref),
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.red.shade400,
                          size: 20,
                        ),
                        tooltip: t.common.delete,
                      ),
                      Icon(
                        isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                        color: isDark ? Colors.white38 : const Color(0xFF9EAEA2),
                        size: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Subcategories drawer
          if (isExpanded)
            subcategoriesAsync.when(
              data: (subcategories) {
                return Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF171B18).withValues(alpha: 0.5) : const Color(0xFFF4F7F5),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (subcategories.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            t.my_categories.empty_subcategories,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 13,
                              color: isDark ? Colors.white38 : const Color(0xFF9EAEA2),
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: subcategories.length,
                          itemBuilder: (context, index) {
                            final sub = subcategories[index];
                            final subColor = Color(sub.color);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  const SizedBox(width: 8),
                                  // Subcategory indicator line
                                  Container(
                                    width: 2,
                                    height: 32,
                                    color: context.colorScheme.primary.withValues(alpha: 0.3),
                                  ),
                                  const SizedBox(width: 12),
                                  // Subcategory icon
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: subColor.withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        iconFromName(sub.icon),
                                        color: subColor,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      sub.name,
                                      style: TextStyle(
                                        fontFamily: 'Epilogue',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF333D35),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => context.push('/categories/edit/${sub.id}'),
                                    icon: Icon(
                                      Icons.edit_outlined,
                                      color: isDark ? Colors.white38 : const Color(0xFF9EAEA2),
                                      size: 16,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  const SizedBox(width: 12),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            title: Text(
                                              t.my_categories.delete_category,
                                              style: const TextStyle(
                                                  fontFamily: 'Epilogue', fontWeight: FontWeight.bold),
                                            ),
                                            content: Text(
                                              t.my_categories.delete_message,
                                              style: const TextStyle(fontFamily: 'Epilogue'),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: Text(
                                                  t.common.cancel,
                                                  style: TextStyle(
                                                    fontFamily: 'Epilogue',
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  try {
                                                    await ref
                                                        .read(categoriesRepositoryProvider)
                                                        .delete(sub.id);
                                                    if (context.mounted) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text(t.my_categories.success_delete),
                                                          backgroundColor: context.colorScheme.primary,
                                                          behavior: SnackBarBehavior.floating,
                                                        ),
                                                      );
                                                    }
                                                  } catch (e) {
                                                    if (context.mounted) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text('Error: ${e.toString()}'),
                                                          backgroundColor: context.colorScheme.error,
                                                          behavior: SnackBarBehavior.floating,
                                                        ),
                                                      );
                                                    }
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: context.colorScheme.error,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                ),
                                                child: Text(
                                                  t.common.delete,
                                                  style: const TextStyle(
                                                    fontFamily: 'Epilogue',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      Icons.delete_outline_rounded,
                                      color: Colors.red.shade300,
                                      size: 16,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      const SizedBox(height: 8),
                      // Quick add subcategory action button
                      ElevatedButton.icon(
                        onPressed: () {
                          context.push(
                              '/categories/create?type=${category.type.name}&parentId=${category.id}');
                        },
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: Text(
                          '${t.my_categories.add_category} (${t.my_categories.subcategory})',
                          style: const TextStyle(
                            fontFamily: 'Epilogue',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: context.colorScheme.primary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: context.colorScheme.primary.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              error: (err, stack) => const SizedBox(),
            ),
        ],
      ),
    );
  }
}
