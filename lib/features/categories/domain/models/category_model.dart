import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/features/categories/data/tables/categories_table.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
    this.parentId,
  });

  final String id;
  final String name;
  final String icon;
  final Color color;
  final CategoryType type;
  final String? parentId;

  bool get isTopLevel => parentId == null;

  factory CategoryModel.fromCategory(Category category) => CategoryModel(
    id: category.id,
    name: category.name,
    icon: category.icon,
    color: Color(category.color),
    type: category.type,
    parentId: category.parentId,
  );
}
