import 'package:drift/drift.dart';
import 'package:expenselab/core/database/base_table.dart';

enum CategoryType { income, expense }

class Categories extends Table with SoftDeleteTable {
  /// Nullable self-reference for subcategories.
  TextColumn get parentId => text().nullable().references(Categories, #id)();

  /// Name of the category.
  TextColumn get name => text()();

  /// Icon name from [Icons] class.
  TextColumn get icon => text()();

  /// ARGB color packed as int, e.g. 0xFF4CAF50.
  IntColumn get color => integer()();

  /// Type of the category (income, expense).
  IntColumn get type => intEnum<CategoryType>()();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}
