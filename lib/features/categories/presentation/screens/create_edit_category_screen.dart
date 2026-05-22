import 'package:drift/drift.dart' show Value;
import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/helpers/icon_mapper.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/categories/data/tables/categories_table.dart';
import 'package:expenselab/features/categories/providers/categories_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateEditCategoryScreen extends ConsumerStatefulWidget {
  const CreateEditCategoryScreen({
    super.key,
    this.categoryId,
    this.initialType,
    this.initialParentId,
  });

  final String? categoryId;
  final CategoryType? initialType;
  final String? initialParentId;

  @override
  ConsumerState<CreateEditCategoryScreen> createState() => _CreateEditCategoryScreenState();
}

class _CreateEditCategoryScreenState extends ConsumerState<CreateEditCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  CategoryType _selectedType = CategoryType.expense;
  String? _selectedParentId;
  String _selectedIconName = 'shopping_bag';
  int _selectedColorInt = 0xFF2E7D32; // Default Emerald Green

  bool _isLoading = false;
  bool _isInitialized = false;

  // Curated list of high-quality colors
  final List<int> _presetColors = [
    0xFF2E7D32, // Emerald Green
    0xFF81C784, // Mint Green
    0xFF008080, // Teal
    0xFF0288D1, // Sky Blue
    0xFF3F51B5, // Indigo Blue
    0xFF673AB7, // Purple
    0xFF9C27B0, // Violet
    0xFFE91E63, // Crimson Rose
    0xFFD32F2F, // Deep Red
    0xFFF57C00, // Warm Orange
    0xFFFFB300, // Amber Gold
    0xFF8D6E63, // Sand Brown
    0xFF607D8B, // Steel Blue
    0xFF37474F, // Charcoal
  ];

  // Curated list of selectable icons
  final List<String> _selectableIcons = [
    'shopping_bag',
    'restaurant',
    'directions_car',
    'bolt',
    'school',
    'health_and_safety',
    'movie',
    'flight',
    'pets',
    'fitness_center',
    'work',
    'savings',
    'wallet',
    'payments',
    'card_giftcard',
    'home',
    'local_grocery_store',
    'card_travel',
    'currency_exchange',
    'account_balance',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialType != null) {
      _selectedType = widget.initialType!;
    }
    if (widget.initialParentId != null) {
      _selectedParentId = widget.initialParentId!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _isEditMode => widget.categoryId != null;

  void _initializeData(Category category) {
    if (_isInitialized) return;
    _nameController.text = category.name;
    _selectedType = category.type;
    _selectedParentId = category.parentId;
    _selectedIconName = category.icon;
    _selectedColorInt = category.color;
    _isInitialized = true;
  }

  void _showIconPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2420) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.t.my_categories.icon,
                    style: const TextStyle(
                      fontFamily: 'Epilogue',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: _selectableIcons.length,
                  itemBuilder: (context, index) {
                    final iconName = _selectableIcons[index];
                    final isSelected = _selectedIconName == iconName;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIconName = iconName;
                        });
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color(_selectedColorInt)
                              : (isDark ? const Color(0xFF171B18) : const Color(0xFFF0F4F1)),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Color(_selectedColorInt)
                                : (isDark ? Colors.white12 : const Color(0xFFDCE3DF)),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          iconFromName(iconName),
                          color: isSelected ? Colors.white : (isDark ? Colors.white70 : Color(_selectedColorInt)),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final name = _nameController.text.trim();
      final repository = ref.read(categoriesRepositoryProvider);

      final companion = CategoriesCompanion(
        name: Value(name),
        parentId: Value(_selectedParentId),
        icon: Value(_selectedIconName),
        color: Value(_selectedColorInt),
        type: Value(_selectedType),
      );

      if (_isEditMode) {
        await repository.update(widget.categoryId!, companion);
      } else {
        await repository.create(companion);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditMode ? context.t.my_categories.success_update : context.t.my_categories.success_create),
            backgroundColor: context.colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: context.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final labelStyle = TextStyle(
      fontFamily: 'Epilogue',
      fontWeight: FontWeight.w600,
      fontSize: 14,
      color: isDark ? Colors.white70 : const Color(0xFF333D35),
    );

    final inputTextStyle = TextStyle(
      fontFamily: 'Epilogue',
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: isDark ? Colors.white : const Color(0xFF1C221E),
    );

    if (_isEditMode) {
      return ref.watch(categoryByIdProvider(widget.categoryId!)).when(
        data: (category) {
          if (category == null) {
            return Scaffold(
              body: Center(child: Text(t.edit_account.error_loading)),
            );
          }
          _initializeData(category);
          return _buildForm(context, isDark, labelStyle, inputTextStyle);
        },
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (err, _) => Scaffold(
          body: Center(child: Text(err.toString())),
        ),
      );
    }

    return _buildForm(context, isDark, labelStyle, inputTextStyle);
  }

  Widget _buildForm(
    BuildContext context,
    bool isDark,
    TextStyle labelStyle,
    TextStyle inputTextStyle,
  ) {
    final t = context.t;
    // We fetch parent categories of the currently selected type.
    // However, if we are editing, we must exclude the current category from the candidates to prevent self-reference or circular references.
    final parentsAsync = ref.watch(categoriesByTypeProvider(_selectedType));

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
          _isEditMode ? t.my_categories.edit_category : t.my_categories.add_category,
          style: TextStyle(
            fontFamily: 'Epilogue',
            fontWeight: FontWeight.w800,
            fontSize: 24,
            color: isDark ? Colors.white : const Color(0xFF0F1E36),
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: context.colorScheme.primary,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Icon and color preview container
                    Center(
                      child: Column(
                        children: [
                          InkWell(
                            onTap: _showIconPicker,
                            borderRadius: BorderRadius.circular(28),
                            child: Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                color: Color(_selectedColorInt).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                  color: Color(_selectedColorInt),
                                  width: 2.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(_selectedColorInt).withValues(alpha: 0.25),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Icon(
                                iconFromName(_selectedIconName),
                                color: Color(_selectedColorInt),
                                size: 48,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            t.my_categories.icon,
                            style: const TextStyle(
                              fontFamily: 'Epilogue',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Name field
                    Text(t.my_categories.name, style: labelStyle),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      style: inputTextStyle,
                      decoration: InputDecoration(
                        hintText: t.my_categories.name_hint,
                        hintStyle: TextStyle(
                          fontFamily: 'Epilogue',
                          color: isDark ? Colors.white30 : const Color(0xFF9EAEA2),
                        ),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF1E2420) : Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: isDark ? Colors.white10 : const Color(0xFFEAF0EB),
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: isDark ? Colors.white10 : const Color(0xFFEAF0EB),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: context.colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: context.colorScheme.error,
                            width: 1.5,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return t.my_categories.name_required;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Segmented Type Selector (serious names: Expenses / Income)
                    Text(t.my_categories.type, style: labelStyle),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E2420) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? Colors.white10 : const Color(0xFFEAF0EB),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: _isEditMode
                                  ? null // Type shouldn't change during editing once set (standard practice, but can enable if needed)
                                  : () {
                                      setState(() {
                                        _selectedType = CategoryType.expense;
                                        _selectedParentId = null; // Reset parent choice
                                      });
                                    },
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: _selectedType == CategoryType.expense
                                      ? context.colorScheme.primary.withValues(alpha: 0.1)
                                      : Colors.transparent,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  t.my_categories.expenses,
                                  style: TextStyle(
                                    fontFamily: 'Epilogue',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: _selectedType == CategoryType.expense
                                        ? context.colorScheme.primary
                                        : (isDark ? Colors.white60 : const Color(0xFF5D6B60)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 1.5,
                            height: 32,
                            color: isDark ? Colors.white10 : const Color(0xFFEAF0EB),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: _isEditMode
                                  ? null
                                  : () {
                                      setState(() {
                                        _selectedType = CategoryType.income;
                                        _selectedParentId = null;
                                      });
                                    },
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: _selectedType == CategoryType.income
                                      ? context.colorScheme.primary.withValues(alpha: 0.1)
                                      : Colors.transparent,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  t.my_categories.income,
                                  style: TextStyle(
                                    fontFamily: 'Epilogue',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: _selectedType == CategoryType.income
                                        ? context.colorScheme.primary
                                        : (isDark ? Colors.white60 : const Color(0xFF5D6B60)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Parent Category dropdown selector
                    Text(t.my_categories.parent, style: labelStyle),
                    const SizedBox(height: 8),
                    parentsAsync.when(
                      data: (parentCategories) {
                        // Filter out the current category so a category cannot be its own parent
                        final candidates = parentCategories
                            .where((cat) => cat.id != widget.categoryId && cat.parentId == null)
                            .toList();

                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E2420) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark ? Colors.white10 : const Color(0xFFEAF0EB),
                              width: 1.5,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String?>(
                              value: _selectedParentId,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down_rounded, size: 32),
                              dropdownColor: isDark ? const Color(0xFF1E2420) : Colors.white,
                              style: inputTextStyle,
                              onChanged: (value) {
                                setState(() {
                                  _selectedParentId = value;
                                });
                              },
                              items: [
                                DropdownMenuItem<String?>(
                                  value: null,
                                  child: Text(
                                    t.my_categories.parent_none,
                                    style: TextStyle(
                                      fontFamily: 'Epilogue',
                                      color: isDark ? Colors.white54 : const Color(0xFF5D6B60),
                                    ),
                                  ),
                                ),
                                ...candidates.map((cat) {
                                  return DropdownMenuItem<String?>(
                                    value: cat.id,
                                    child: Row(
                                      children: [
                                        Icon(
                                          iconFromName(cat.icon),
                                          color: Color(cat.color),
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(cat.name),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        );
                      },
                      loading: () => const LinearProgressIndicator(),
                      error: (err, _) => Text('Error loading parents: $err'),
                    ),
                    const SizedBox(height: 24),

                    // Color picker grid
                    Text(t.my_categories.color, style: labelStyle),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: _presetColors.length,
                      itemBuilder: (context, index) {
                        final colorVal = _presetColors[index];
                        final isSelected = _selectedColorInt == colorVal;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedColorInt = colorVal;
                            });
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(colorVal),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? (isDark ? Colors.white : Colors.black87)
                                    : Colors.transparent,
                                width: 2.5,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Color(colorVal).withValues(alpha: 0.4),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      )
                                    ]
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 48),

                    // Create / Update Button
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        _isEditMode ? t.common.save : t.my_categories.add_category,
                        style: const TextStyle(
                          fontFamily: 'Epilogue',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
