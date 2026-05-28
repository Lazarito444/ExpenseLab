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

class CategoryDetailsScreen extends ConsumerStatefulWidget {
  const CategoryDetailsScreen({required this.categoryId, super.key});

  final String categoryId;

  @override
  ConsumerState<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends ConsumerState<CategoryDetailsScreen> {
  // Last non-null category received from the stream. Kept so we can continue
  // rendering the screen while the auto-pop is pending (prevents a 1-frame
  // blank flash after deletion).
  Category? _cachedCategory;

  // True once we have seen a non-null category. Guards against auto-popping
  // during the initial loading phase before data has arrived.
  bool _categoryWasLoaded = false;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final categoryAsync = ref.watch(categoryByIdProvider(widget.categoryId));
    final subcategoriesAsync = ref.watch(subcategoriesProvider(widget.categoryId));

    // Auto-pop when the category is soft-deleted while this screen is visible.
    ref.listen<AsyncValue<Category?>>(
      categoryByIdProvider(widget.categoryId),
      (_, next) {
        next.whenData((cat) {
          if (cat != null) {
            _categoryWasLoaded = true;
          } else if (_categoryWasLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && context.canPop()) context.pop();
            });
          }
        });
      },
    );

    final fallbackAppBar = ExpenseLabAppBar(
      title: t.categories.category,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: context.colorScheme.primary,
        ),
        onPressed: () => context.pop(),
      ),
    );

    return categoryAsync.when(
      loading: () => Scaffold(
        appBar: fallbackAppBar,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, stack) => Scaffold(
        appBar: fallbackAppBar,
        body: Center(child: Text(t.common.error)),
      ),
      data: (category) {
        // Cache the last known category so we keep rendering it while the
        // auto-pop is pending, preventing a blank-screen flash.
        if (category != null) _cachedCategory = category;
        final display = category ?? _cachedCategory;

        if (display == null) {
          // Still in initial load with no data yet — show a spinner.
          return Scaffold(
            appBar: fallbackAppBar,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final model = CategoryModel.fromCategory(display);
        final subcategories = subcategoriesAsync.value ?? [];

        return Scaffold(
          appBar: ExpenseLabAppBar(
            title: model.name,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: context.colorScheme.primary,
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.edit_outlined,
                  color: context.colorScheme.primary,
                ),
                onPressed: () => context.push(AppRoutes.categoryEdit(widget.categoryId)),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              _MonthlySpendCard(t: t, model: model),
              const SizedBox(height: 20),
              _SubcategoriesSection(subcategories: subcategories, t: t),
            ],
          ),
        );
      },
    );
  }
}

// ── Monthly spend card ────────────────────────────────────────────────────────

class _MonthlySpendCard extends StatelessWidget {
  const _MonthlySpendCard({required this.t, required this.model});

  final Translations t;
  final CategoryModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.type == CategoryType.income ? t.categories.total_monthly_income : t.categories.total_monthly_spend,
            style: const TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8E8E8E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            r'$0.00',
            style: TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: context.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '— ${t.accounts.this_month}',
            style: const TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 12,
              color: Color(0xFF8E8E8E),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Subcategories section ─────────────────────────────────────────────────────

class _SubcategoriesSection extends StatelessWidget {
  const _SubcategoriesSection({
    required this.subcategories,
    required this.t,
  });

  final List<Category> subcategories;
  final Translations t;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              t.categories.subcategories,
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: context.colorScheme.scrim,
              ),
            ),
            if (subcategories.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: context.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${subcategories.length}',
                  style: TextStyle(
                    fontFamily: 'Epilogue',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: context.colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (subcategories.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                t.categories.empty_subcategories,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 14,
                  color: context.colorScheme.outline,
                ),
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: context.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                for (int i = 0; i < subcategories.length; i++)
                  _SubcategoryItem(
                    category: subcategories[i],
                    isLast: i == subcategories.length - 1,
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SubcategoryItem extends StatelessWidget {
  const _SubcategoryItem({required this.category, required this.isLast});

  final Category category;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = Color(category.color);
    return GestureDetector(
      onTap: () => context.push(AppRoutes.categoryDetails(category.id)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    iconFromName(category.icon),
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    category.name,
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: context.colorScheme.scrim,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
          if (!isLast)
            Divider(
              height: 1,
              indent: 68,
              endIndent: 16,
              color: context.colorScheme.outline.withValues(alpha: 0.15),
            ),
        ],
      ),
    );
  }
}
