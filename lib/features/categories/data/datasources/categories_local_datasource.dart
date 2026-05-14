import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/features/categories/data/tables/categories_table.dart';

/// Contract for local storage access to [Category] records.
///
/// Implementations must apply soft-delete semantics: [watchAll] and [getAll]
/// only surface rows where `isDeleted = false`, and [delete] flags rows as
/// deleted rather than removing them permanently.
///
/// Categories support a single level of nesting: top-level categories have
/// `parentId = null`; subcategories reference a parent via `parentId`.
/// [watchByType] only returns top-level categories — use [watchSubcategories]
/// to retrieve children.
abstract class CategoriesLocalDataSource {
  /// Streams all non-deleted categories (including subcategories), re-emitting
  /// the full list on every database change.
  Stream<List<Category>> watchAll();

  /// Streams a single non-deleted category by [id], or `null` if not found or
  /// soft-deleted. Re-emits whenever the record is modified.
  Stream<Category?> watchById(String id);

  /// Returns all non-deleted categories as a one-shot future.
  Future<List<Category>> getAll();

  /// Returns a single non-deleted category by [id], or `null` if not found.
  Future<Category?> getById(String id);

  /// Streams all non-deleted top-level categories of the given [type]
  /// (`parentId IS NULL`). Re-emits on every change.
  Stream<List<Category>> watchByType(CategoryType type);

  /// Streams all non-deleted direct children of [parentId]. Re-emits on every
  /// change.
  Stream<List<Category>> watchSubcategories(String parentId);

  /// Inserts a new category. [id], [createdAt], and [updatedAt] are assigned
  /// automatically — do not set them in [data]. Returns the generated [id].
  Future<String> create(CategoriesCompanion data);

  /// Overwrites the mutable fields of the category with the given [id].
  /// [updatedAt] is stamped to the current time automatically.
  Future<void> update(String id, CategoriesCompanion data);

  /// Soft-deletes the category: sets `isDeleted = true` and stamps `deletedAt`
  /// and `updatedAt` to the current time. The row is retained in the database.
  Future<void> delete(String id);
}
