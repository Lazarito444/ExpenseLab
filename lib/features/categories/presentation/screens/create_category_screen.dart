import 'package:drift/drift.dart' as drift;
import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/helpers/icon_mapper.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/categories/data/tables/categories_table.dart';
import 'package:expenselab/features/categories/providers/categories_providers.dart';
import 'package:expenselab/widgets/scaffold/expense_lab_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// ── Icon categories for the picker ───────────────────────────────────────────

final _kIconCategories = <(String, List<String>)>[
  (
    'Finance',
    [
      'account_balance_wallet',
      'savings',
      'account_balance',
      'credit_card',
      'cash',
      'wallet',
      'payments',
      'local_atm',
      'attach_money',
      'currency_exchange',
      'paid',
      'money',
      'euro',
    ],
  ),
  (
    'Food & Dining',
    [
      'restaurant',
      'fastfood',
      'local_cafe',
      'local_grocery_store',
      'lunch_dining',
      'cake',
      'local_bar',
      'wine_bar',
    ],
  ),
  (
    'Transport',
    [
      'directions_car',
      'flight',
      'train',
      'directions_bus',
      'directions_bike',
      'motorcycle',
      'local_taxi',
      'local_gas_station',
    ],
  ),
  ('Home', ['home', 'bolt', 'wifi', 'phone', 'water_drop', 'plumbing']),
  (
    'Health',
    [
      'medical_services',
      'fitness_center',
      'health_and_safety',
      'spa',
      'self_improvement',
    ],
  ),
  (
    'Entertainment',
    [
      'movie',
      'music_note',
      'sports_esports',
      'sports_basketball',
      'sports_soccer',
      'camera_alt',
      'celebration',
      'nightlife',
    ],
  ),
  (
    'Shopping',
    [
      'shopping_bag',
      'shopping_cart',
      'storefront',
      'card_giftcard',
    ],
  ),
  (
    'Work & Education',
    [
      'work',
      'school',
      'computer',
      'menu_book',
      'science',
      'construction',
      'business_center',
    ],
  ),
  ('Travel', ['hotel', 'luggage', 'beach_access', 'card_travel']),
  (
    'Other',
    [
      'pets',
      'child_care',
      'volunteer_activism',
      'show_chart',
      'trending_up',
      'analytics',
    ],
  ),
];

// ── Colour palette ────────────────────────────────────────────────────────────

const _kQuickColors = [
  Color(0xFF2D6831),
  Color(0xFF4CAF50),
  Color(0xFFFF9800),
  Color(0xFF2196F3),
  Color(0xFF9C27B0),
  Color(0xFFF44336),
  Color(0xFFFF5722),
  Color(0xFF607D8B),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class CreateCategoryScreen extends ConsumerStatefulWidget {
  const CreateCategoryScreen({super.key});

  @override
  ConsumerState<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends ConsumerState<CreateCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  String _selectedIcon = _kIconCategories.first.$2.first;
  Color _selectedColor = _kQuickColors[0];
  CategoryType _selectedType = CategoryType.expense;
  String? _selectedParentId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onNameChanged);
  }

  void _onNameChanged() => setState(() {});

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    super.dispose();
  }

  // ── Submit ─────────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref
          .read(categoriesRepositoryProvider)
          .create(
            CategoriesCompanion(
              name: drift.Value(_nameController.text.trim()),
              icon: drift.Value(_selectedIcon),
              color: drift.Value(_selectedColor.toARGB32()),
              type: drift.Value(_selectedType),
              parentId: drift.Value<String?>(_selectedParentId),
            ),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.t.categories.success_create),
            backgroundColor: const Color(0xFF2D6831),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Bottom sheets ──────────────────────────────────────────────────────────

  void _showIconPicker(BuildContext context, Translations t) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: this.context.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.92,
        expand: false,
        builder: (_, scrollController) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            children: [
              const _SheetHandle(),
              const SizedBox(height: 12),
              Text(
                t.categories.icon,
                style: const TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    for (final (category, icons) in _kIconCategories) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 8),
                        child: Text(
                          category,
                          style: const TextStyle(
                            fontFamily: 'Epilogue',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF9EAEA2),
                          ),
                        ),
                      ),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: icons.map((name) {
                          final selected = name == _selectedIcon;
                          return GestureDetector(
                            onTap: () {
                              setState(() => _selectedIcon = name);
                              Navigator.pop(sheetContext);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: selected ? _selectedColor : const Color(0xFFF0F0F0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                iconFromName(name),
                                color: selected ? Colors.white : const Color(0xFF8E8E8E),
                                size: 22,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context, Translations t) {
    Color pickerColor = _selectedColor;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: this.context.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => StatefulBuilder(
        builder: (_, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 12,
            bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _SheetHandle(),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      t.categories.color,
                      style: const TextStyle(
                        fontFamily: 'Epilogue',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _selectedColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE5E5E5)),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: pickerColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE5E5E5)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: (c) => setSheetState(() => pickerColor = c),
                pickerAreaHeightPercent: 0.55,
                enableAlpha: false,
                hexInputBar: true,
                labelTypes: const [],
                pickerAreaBorderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => _selectedColor = pickerColor);
                    Navigator.pop(sheetCtx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                  child: Text(
                    t.common.save,
                    style: const TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showParentSelector(
    BuildContext context,
    Translations t,
    List<Category> parents,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: this.context.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _SheetHandle(),
            const SizedBox(height: 12),
            Text(
              t.categories.parent,
              style: const TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                t.categories.parent_none,
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 14,
                  fontWeight: _selectedParentId == null ? FontWeight.w600 : FontWeight.w400,
                  color: _selectedParentId == null ? const Color(0xFF2D6831) : const Color(0xFF1A1A1A),
                ),
              ),
              trailing: _selectedParentId == null ? const Icon(Icons.check_rounded, color: Color(0xFF2D6831)) : null,
              onTap: () {
                setState(() => _selectedParentId = null);
                Navigator.pop(context);
              },
            ),
            ...parents.map((cat) {
              final isSelected = cat.id == _selectedParentId;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Color(cat.color).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    iconFromName(cat.icon),
                    color: Color(cat.color),
                    size: 18,
                  ),
                ),
                title: Text(
                  cat.name,
                  style: TextStyle(
                    fontFamily: 'Epilogue',
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? const Color(0xFF2D6831) : const Color(0xFF1A1A1A),
                  ),
                ),
                trailing: isSelected ? const Icon(Icons.check_rounded, color: Color(0xFF2D6831)) : null,
                onTap: () {
                  setState(() => _selectedParentId = cat.id);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _parentLabel(Translations t, List<Category> parents) {
    if (_selectedParentId == null) return t.categories.parent_none;
    final match = parents.where((c) => c.id == _selectedParentId).firstOrNull;
    return match?.name ?? t.categories.parent_none;
  }

  InputDecoration _fieldDecoration({String? hint}) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      fontFamily: 'Epilogue',
      color: Color(0xFFBDBDBD),
      fontSize: 14,
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF2D6831), width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
    ),
  );

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final parentsAsync = ref.watch(categoriesByTypeProvider(_selectedType));
    final parents = parentsAsync.value ?? [];

    return Scaffold(
      backgroundColor: context.appColors.scaffoldBackground,
      appBar: ExpenseLabAppBar(
        title: t.categories.add_category,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: context.colorScheme.primary,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Preview card ─────────────────────────────────
                      _PreviewCard(
                        icon: _selectedIcon,
                        color: _selectedColor,
                        name: _nameController.text.trim(),
                        t: t,
                      ),
                      const SizedBox(height: 24),

                      // ── Category name ─────────────────────────────────
                      _SectionLabel(label: t.categories.name),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.sentences,
                        style: const TextStyle(
                          fontFamily: 'Epilogue',
                          fontSize: 14,
                        ),
                        decoration: _fieldDecoration(
                          hint: t.categories.name_hint,
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return t.categories.name_required;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // ── Type toggle ───────────────────────────────────
                      _SectionLabel(label: t.categories.type),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _TypeChip(
                              label: t.categories.expenses,
                              icon: Icons.trending_down_rounded,
                              isSelected: _selectedType == CategoryType.expense,
                              onTap: () => setState(() {
                                _selectedType = CategoryType.expense;
                                _selectedParentId = null;
                              }),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _TypeChip(
                              label: t.categories.income,
                              icon: Icons.trending_up_rounded,
                              isSelected: _selectedType == CategoryType.income,
                              onTap: () => setState(() {
                                _selectedType = CategoryType.income;
                                _selectedParentId = null;
                              }),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ── Parent category ───────────────────────────────
                      _SectionLabel(label: t.categories.parent),
                      const SizedBox(height: 8),
                      _SelectorField(
                        value: _parentLabel(t, parents),
                        onTap: () => _showParentSelector(context, t, parents),
                      ),
                      const SizedBox(height: 20),

                      // ── Icon selector ─────────────────────────────────
                      _SectionLabel(label: t.categories.icon),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _showIconPicker(context, t),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFE5E5E5),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _selectedColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  iconFromName(_selectedIcon),
                                  color: _selectedColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  toBeginningOfSentenceCase(_selectedIcon.replaceAll('_', ' ')),
                                  style: const TextStyle(
                                    fontFamily: 'Epilogue',
                                    fontSize: 14,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.grey.shade500,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Color palette ─────────────────────────────────
                      _SectionLabel(label: t.categories.color),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 44,
                        child: Row(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: _kQuickColors.length,
                                separatorBuilder: (_, index) => const SizedBox(width: 10),
                                itemBuilder: (_, i) {
                                  final color = _kQuickColors[i];
                                  final selected = color.toARGB32() == _selectedColor.toARGB32();
                                  return GestureDetector(
                                    onTap: () => setState(
                                      () => _selectedColor = color,
                                    ),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 180),
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                        border: selected
                                            ? Border.all(
                                                color: Colors.white,
                                                width: 2.5,
                                              )
                                            : null,
                                        boxShadow: selected
                                            ? [
                                                BoxShadow(
                                                  color: color.withValues(
                                                    alpha: 0.5,
                                                  ),
                                                  blurRadius: 6,
                                                  spreadRadius: 1,
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: selected
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 16,
                                            )
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () => _showColorPicker(context, t),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFE5E5E5),
                                  ),
                                  color: Colors.white,
                                ),
                                child: const Icon(
                                  Icons.edit_outlined,
                                  size: 18,
                                  color: Color(0xFF8E8E8E),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // ── Create button ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D6831),
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          t.categories.add_category,
                          style: const TextStyle(
                            fontFamily: 'Epilogue',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.icon,
    required this.color,
    required this.name,
    required this.t,
  });

  final String icon;
  final Color color;
  final String name;
  final Translations t;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(iconFromName(icon), color: color, size: 28),
          ),
          const SizedBox(height: 10),
          Text(
            t.common.preview.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: Color(0xFF2D6831),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            name.isEmpty ? t.categories.category : name,
            style: TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.colorScheme.scrim,
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2D6831).withValues(alpha: 0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF2D6831) : const Color(0xFFE5E5E5),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? const Color(0xFF2D6831) : const Color(0xFF9E9E9E),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? const Color(0xFF2D6831) : const Color(0xFF9E9E9E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'Epilogue',
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Color(0xFF2D6831),
      ),
    );
  }
}

class _SelectorField extends StatelessWidget {
  const _SelectorField({required this.value, required this.onTap});

  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E5E5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 14,
                color: Color(0xFF1A1A1A),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.grey.shade500,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
