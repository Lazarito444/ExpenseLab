import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/categories/data/tables/categories_table.dart';
import 'package:expenselab/features/categories/providers/categories_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final categoriesAsyncValue = ref.watch(categoriesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: _buildAppBar(context, theme),
      body: categoriesAsyncValue.when(
        data: (allCategories) {
          final topLevelCategories = allCategories.where((c) => c.parentId == null).toList();

          final incomes = topLevelCategories.where((c) => c.type == CategoryType.income).toList();
          final expenses = topLevelCategories.where((c) => c.type == CategoryType.expense).toList();

          if (incomes.isEmpty && expenses.isEmpty) {
            return const _EmptyCategoriesPlaceholder();
          }

          return CustomScrollView(
            slivers: [
              if (incomes.isNotEmpty)
                _CategorySection(
                  title: t.my_categories.income,
                  icon: Icons.trending_up,
                  iconColor: Colors.green,
                  categories: incomes,
                  allCategories: allCategories, // Pasamos la lista completa para buscar subcategorías
                ),
              if (expenses.isNotEmpty)
                _CategorySection(
                  title: t.my_categories.expenses,
                  icon: Icons.trending_down,
                  iconColor: Colors.red,
                  categories: expenses,
                  allCategories: allCategories,
                ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text(t.common.error)),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
        onPressed: () => context.pop(),
      ),
      title: Text(
        t.my_categories.title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: theme.dividerColor),
            ),
            child: IconButton(
              icon: Icon(Icons.add, color: theme.colorScheme.primary),
              onPressed: () => context.push('/add-category'),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategorySection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<Category> categories;
  final List<Category> allCategories;

  const _CategorySection({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.categories,
    required this.allCategories,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: iconColor),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    t.my_categories.count(n: categories.length),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final category = categories[index];
                // Buscamos las subcategorías vinculadas a este padre
                final subcategories = allCategories.where((c) => c.parentId == category.id).map((c) => c.name).join(', ');

                return _CategoryCard(
                  category: category,
                  subcategoriesText: subcategories,
                );
              },
              childCount: categories.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final Category category;
  final String subcategoriesText;

  const _CategoryCard({
    required this.category,
    required this.subcategoriesText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryColor = Color(category.color); // ARGB procesado directo de la BD

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: theme.colorScheme.surface,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: categoryColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _getIconFromString(category.icon), // Resolución del String a IconData
            color: categoryColor,
          ),
        ),
        title: Text(
          category.name,
          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: subcategoriesText.isNotEmpty
            ? Text(
                subcategoriesText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Icon(
          Icons.chevron_right,
          color: theme.dividerColor,
        ),
        onTap: () {
          context.push('/category-detail/${category.id}');
        },
      ),
    );
  }

  /// Función auxiliar para convertir el String de la BD a un IconData real.
  /// Si el catálogo de iconos es muy grande, se recomienda un paquete como `material_design_icons_flutter`
  /// o un mapa generado estáticamente.
  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'restaurant':
        return Icons.restaurant;
      case 'directions_car':
        return Icons.directions_car;
      case 'theater_comedy':
        return Icons.theater_comedy;
      case 'home':
        return Icons.home;
      case 'medical_services':
        return Icons.medical_services;
      case 'payments':
        return Icons.payments;
      case 'trending_up':
        return Icons.trending_up;
      case 'redeem':
        return Icons.redeem;
      default:
        return Icons.category; // Icono por defecto (fallback)
    }
  }
}

class _EmptyCategoriesPlaceholder extends StatelessWidget {
  const _EmptyCategoriesPlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono representativo
            Icon(
              Icons.category_outlined,
              size: 80,
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 24),

            // Texto del estado vacío (usa tu JSON de Slang)
            Text(
              t.my_categories.empty_state,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.surface.withValues(alpha: 0.7),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),

            // Botón de llamada a la acción
            FilledButton.icon(
              onPressed: () => context.push('/add-category'),
              icon: const Icon(Icons.add),
              label: Text(t.my_categories.add_category),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
