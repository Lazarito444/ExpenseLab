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

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final incomeAsync = ref.watch(categoriesByTypeProvider(CategoryType.income));
    final expenseAsync = ref.watch(categoriesByTypeProvider(CategoryType.expense));

    return Scaffold(
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

          final income = (incomeAsync.value ?? []).map(CategoryModel.fromCategory).toList();
          final expenses = (expenseAsync.value ?? []).map(CategoryModel.fromCategory).toList();

          if (income.isEmpty && expenses.isEmpty) {
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
              if (income.isNotEmpty) ...[
                _SectionHeader(
                  title: t.categories.income,
                  count: income.length,
                  isIncome: true,
                ),
                const SizedBox(height: 12),
                ...income.map(
                  (model) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _CategoryCard(model: model),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (expenses.isNotEmpty) ...[
                _SectionHeader(
                  title: t.categories.expenses,
                  count: expenses.length,
                  isIncome: false,
                ),
                const SizedBox(height: 12),
                ...expenses.map(
                  (model) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _CategoryCard(model: model),
                  ),
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
          color: isIncome ? const Color(0xFF2D6831) : const Color(0xFFEF5350),
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
  const _CategoryCard({required this.model});

  final CategoryModel model;

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
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
