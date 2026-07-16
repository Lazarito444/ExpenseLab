import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/helpers/icon_mapper.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/core/routing/app_routes.dart';
import 'package:expenselab/features/categories/data/tables/categories_table.dart';
import 'package:expenselab/features/categories/domain/models/category_model.dart';
import 'package:expenselab/features/categories/providers/categories_providers.dart';
import 'package:expenselab/widgets/scaffold/expense_lab_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  List<CategoryModel> _income = [];
  List<CategoryModel> _expenses = [];

  static bool _idOrderMatches(List<CategoryModel> a, List<CategoryModel> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) return false;
    }
    return true;
  }

  void _syncIncome(List<Category> cats) {
    final models = cats.map(CategoryModel.fromCategory).toList();
    if (!_idOrderMatches(_income, models)) {
      setState(() => _income = models);
    }
  }

  void _syncExpenses(List<Category> cats) {
    final models = cats.map(CategoryModel.fromCategory).toList();
    if (!_idOrderMatches(_expenses, models)) {
      setState(() => _expenses = models);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    ref.listen(categoriesByTypeProvider(CategoryType.income), (prev, next) {
      next.whenData(_syncIncome);
    });
    ref.listen(categoriesByTypeProvider(CategoryType.expense), (prev, next) {
      next.whenData(_syncExpenses);
    });

    final incomeAsync = ref.watch(categoriesByTypeProvider(CategoryType.income));
    final expenseAsync = ref.watch(categoriesByTypeProvider(CategoryType.expense));

    if (_income.isEmpty) {
      incomeAsync.whenData((cats) {
        if (_income.isEmpty) _income = cats.map(CategoryModel.fromCategory).toList();
      });
    }
    if (_expenses.isEmpty) {
      expenseAsync.whenData((cats) {
        if (_expenses.isEmpty) _expenses = cats.map(CategoryModel.fromCategory).toList();
      });
    }

    return Scaffold(
      backgroundColor: context.appColors.scaffoldBackground,
      appBar: ExpenseLabAppBar(
        title: t.categories.title,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: context.colorScheme.primary,
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.categoriesCreate),
            icon: Icon(Icons.add_rounded, color: context.colorScheme.primary),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (incomeAsync.isLoading || expenseAsync.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (incomeAsync.hasError) {
            return Center(child: Text(incomeAsync.error.toString()));
          }
          if (expenseAsync.hasError) {
            return Center(child: Text(expenseAsync.error.toString()));
          }

          if (_income.isEmpty && _expenses.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  t.categories.empty_state,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Epilogue',
                    fontSize: 15,
                    color: context.colorScheme.outline,
                  ),
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              const SizedBox(height: 12),
              if (_income.isNotEmpty) ...[
                _SectionHeader(
                  title: t.categories.income,
                  count: _income.length,
                  isIncome: true,
                ),
                const SizedBox(height: 12),
                ReorderableListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  buildDefaultDragHandles: false,
                  onReorderItem: (oldIndex, newIndex) {
                    final item = _income.removeAt(oldIndex);
                    _income.insert(newIndex, item);
                    setState(() {});
                    ref.read(categoriesRepositoryProvider).reorderCategory(
                      item.id, oldIndex, newIndex,
                    );
                  },
                  children: [
                    for (var i = 0; i < _income.length; i++)
                      Padding(
                        key: ValueKey(_income[i].id),
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _CategoryCard(model: _income[i], index: i),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              if (_expenses.isNotEmpty) ...[
                _SectionHeader(
                  title: t.categories.expenses,
                  count: _expenses.length,
                  isIncome: false,
                ),
                const SizedBox(height: 12),
                ReorderableListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  buildDefaultDragHandles: false,
                  onReorderItem: (oldIndex, newIndex) {
                    final item = _expenses.removeAt(oldIndex);
                    _expenses.insert(newIndex, item);
                    setState(() {});
                    ref.read(categoriesRepositoryProvider).reorderCategory(
                      item.id, oldIndex, newIndex,
                    );
                  },
                  children: [
                    for (var i = 0; i < _expenses.length; i++)
                      Padding(
                        key: ValueKey(_expenses[i].id),
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _CategoryCard(model: _expenses[i], index: i),
                      ),
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.count,
    required this.isIncome,
  });

  final String title;
  final int count;
  final bool isIncome;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Row(
      children: [
        Icon(
          isIncome ? Icons.trending_up_rounded : Icons.trending_down_rounded,
          color: isIncome ? context.appColors.incomeColor : context.appColors.expenseColor,
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: context.textTheme.titleMedium!.copyWith(
            color: context.colorScheme.scrim,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: context.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            t.categories.count(n: count),
            style: TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: context.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends ConsumerWidget {
  const _CategoryCard({required this.model, required this.index});

  final CategoryModel model;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final subcategoriesAsync = ref.watch(subcategoriesProvider(model.id));
    final subcategoryCount = subcategoriesAsync.value?.length ?? 0;
    final iconData = iconFromName(model.icon);

    return GestureDetector(
      onTap: () => context.push(AppRoutes.categoryDetails(model.id)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: context.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: model.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(iconData, color: model.color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: context.colorScheme.scrim,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    t.categories.subcategory_count(n: subcategoryCount),
                    style: const TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                ],
              ),
            ),
            ReorderableDragStartListener(
              index: index,
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.drag_indicator,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
