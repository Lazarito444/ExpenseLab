import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:expenselab/core/database/app_database.dart';
import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/helpers/icon_mapper.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/accounts/providers/accounts_providers.dart';
import 'package:expenselab/features/categories/data/tables/categories_table.dart';
import 'package:expenselab/features/categories/domain/models/category_model.dart';
import 'package:expenselab/features/categories/providers/categories_providers.dart';
import 'package:expenselab/features/settings/domain/models/supported_currencies.dart';
import 'package:expenselab/features/settings/providers/settings_providers.dart';
import 'package:expenselab/features/transactions/data/tables/transactions_table.dart';
import 'package:expenselab/features/transactions/domain/models/transaction_image_model.dart';
import 'package:expenselab/features/transactions/providers/transactions_providers.dart';
import 'package:expenselab/widgets/scaffold/expense_lab_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({this.transactionId, this.initialDate, super.key});

  /// When set, the screen loads this transaction and switches to edit mode.
  final String? transactionId;

  /// When set (and not editing), pre-selects this date for the new transaction.
  final DateTime? initialDate;

  bool get isEditing => transactionId != null;

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  TransactionType _type = TransactionType.expense;
  String _amountString = '0';
  String? _selectedCategoryId;
  CategoryModel? _selectedCategoryModel;
  String? _selectedAccountId;
  String? _selectedToAccountId;
  DateTime _selectedDate = DateTime.now();
  final _noteController = TextEditingController();
  final _notesFocusNode = FocusNode();
  bool _isLoading = false;
  bool _showNumpad = true;
  bool _isLoadingTransaction = false;
  // Pending local paths for new images; populated before save.
  final List<String> _pendingImagePaths = [];
  // Existing image records loaded in edit mode.
  List<TransactionImageModel> _existingImages = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null && !widget.isEditing) {
      final now = DateTime.now();
      final d = widget.initialDate!;
      _selectedDate = DateTime(d.year, d.month, d.day, now.hour, now.minute);
    }
    _notesFocusNode.addListener(() {
      if (_notesFocusNode.hasFocus && _showNumpad) {
        setState(() => _showNumpad = false);
      }
    });
    if (widget.isEditing) {
      _loadTransaction();
    }
  }

  Future<void> _loadTransaction() async {
    setState(() => _isLoadingTransaction = true);
    try {
      final tx = await ref.read(transactionsRepositoryProvider).getById(widget.transactionId!);
      if (tx != null && mounted) {
        CategoryModel? categoryModel;
        if (tx.categoryId != null) {
          final cat = await ref.read(categoriesRepositoryProvider).getById(tx.categoryId!);
          if (cat != null) categoryModel = CategoryModel.fromCategory(cat);
        }
        final images = await ref.read(transactionImagesRepositoryProvider).getAll().then(
          (all) => all.where((img) => img.transactionId == widget.transactionId!).toList(),
        );
        if (mounted) {
          setState(() {
            _type = tx.type;
            _amountString = tx.amount.toStringAsFixed(
              tx.amount.truncateToDouble() == tx.amount ? 0 : 2,
            );
            _selectedCategoryId = tx.categoryId;
            _selectedCategoryModel = categoryModel;
            _selectedAccountId = tx.accountId;
            _selectedToAccountId = tx.toAccountId;
            _selectedDate = tx.date;
            _noteController.text = tx.note ?? '';
            _showNumpad = false;
            _existingImages = images;
          });
        }
      }
    } finally {
      if (mounted) setState(() => _isLoadingTransaction = false);
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    _notesFocusNode.dispose();
    super.dispose();
  }

  void _openNumpad() {
    FocusScope.of(context).unfocus();
    setState(() => _showNumpad = true);
  }

  void _closeNumpad() {
    setState(() => _showNumpad = false);
  }

  double get _amount => double.tryParse(_amountString) ?? 0.0;

  String get _formattedAmount {
    final parts = _amountString.split('.');
    final intPart = parts[0];
    final buf = StringBuffer();
    for (int i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) buf.write(',');
      buf.write(intPart[i]);
    }
    if (parts.length > 1) {
      buf.write('.');
      buf.write(parts[1]);
    }
    return buf.toString();
  }

  // ── Number pad ─────────────────────────────────────────────────────────────

  void _onKeyTap(String digit) {
    FocusScope.of(context).unfocus();
    setState(() {
      if (digit == '⌫') {
        if (_amountString.length > 1) {
          _amountString = _amountString.substring(0, _amountString.length - 1);
        } else {
          _amountString = '0';
        }
      } else if (digit == '.') {
        if (!_amountString.contains('.')) {
          _amountString += '.';
        }
      } else {
        if (_amountString.contains('.')) {
          final parts = _amountString.split('.');
          if (parts[1].length >= 2) return;
        }
        _amountString = _amountString == '0' ? digit : _amountString + digit;
      }
    });
  }

  // ── Submit ─────────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    final t = context.t;

    if (_amount <= 0) {
      _showSnack(t.transactions.amount_required);
      return;
    }
    if (_type != TransactionType.transfer && _selectedCategoryId == null) {
      _showSnack(t.transactions.category_required);
      return;
    }
    if (_selectedAccountId == null) {
      _showSnack(t.transactions.account_required);
      return;
    }

    if (_showNumpad) {
      _closeNumpad();
    }

    setState(() => _isLoading = true);
    final companion = TransactionsCompanion(
      type: drift.Value(_type),
      amount: drift.Value(_amount),
      date: drift.Value(_selectedDate),
      accountId: drift.Value(_selectedAccountId!),
      toAccountId: _type == TransactionType.transfer ? drift.Value(_selectedToAccountId) : const drift.Value(null),
      categoryId: _selectedCategoryId != null ? drift.Value(_selectedCategoryId) : const drift.Value(null),
      note: _noteController.text.trim().isNotEmpty ? drift.Value(_noteController.text.trim()) : const drift.Value(null),
    );
    try {
      final repo = ref.read(transactionsRepositoryProvider);
      final imagesRepo = ref.read(transactionImagesRepositoryProvider);
      String txId;
      if (widget.isEditing) {
        await repo.update(widget.transactionId!, companion);
        txId = widget.transactionId!;
      } else {
        txId = await repo.create(companion);
      }

      for (final path in _pendingImagePaths) {
        await imagesRepo.create(
          TransactionImagesCompanion(
            transactionId: drift.Value(txId),
            localPath: drift.Value(path),
          ),
        );
      }

      if (mounted) {
        _showSnack(
          t.transactions.success,
          backgroundColor: context.colorScheme.primary,
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) _showSnack(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String msg, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: backgroundColor,
      ),
    );
  }

  // ── Date / time picker ─────────────────────────────────────────────────────

  Future<void> _pickDateTime() async {
    _closeNumpad();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );
    if (!mounted) return;

    setState(() {
      _selectedDate = DateTime(
        date.year,
        date.month,
        date.day,
        time?.hour ?? _selectedDate.hour,
        time?.minute ?? _selectedDate.minute,
      );
    });
  }

  // ── Bottom sheets ──────────────────────────────────────────────────────────

  Future<void> _showCategorySheet(List<Category> topLevelCategories) async {
    final allCategories = ref.read(categoriesProvider).value ?? [];
    _closeNumpad();
    final selected = await showModalBottomSheet<Category>(
      context: context,
      backgroundColor: context.colorScheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _CategoryPickerSheet(
        topLevelCategories: topLevelCategories,
        allCategories: allCategories,
        selectedCategoryId: _selectedCategoryId,
      ),
    );
    if (selected != null && mounted) {
      setState(() {
        _selectedCategoryId = selected.id;
        _selectedCategoryModel = CategoryModel.fromCategory(selected);
      });
    }
  }

  void _showAccountSheet({bool isTo = false}) {
    final t = context.t;
    final accounts = ref.read(accountModelsProvider);
    final currentSelected = isTo ? _selectedToAccountId : _selectedAccountId;

    _closeNumpad();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.colorScheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, sc) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            children: [
              const _SheetHandle(),
              const SizedBox(height: 12),
              Text(
                isTo ? t.transactions.select_to_account : t.transactions.select_account,
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: context.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: accounts.isEmpty
                    ? Center(
                        child: Text(
                          t.accounts.empty_state,
                          style: TextStyle(
                            fontFamily: 'Epilogue',
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: sc,
                        itemCount: accounts.length,
                        itemBuilder: (_, i) {
                          final account = accounts[i];
                          final isSelected = account.id == currentSelected;
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: context.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                iconFromName(account.icon),
                                color: context.colorScheme.primary,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              account.name,
                              style: TextStyle(
                                fontFamily: 'Epilogue',
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                color: isSelected ? context.colorScheme.primary : context.colorScheme.onSurface,
                              ),
                            ),
                            subtitle: Text(
                              account.currencyCode,
                              style: TextStyle(
                                fontFamily: 'Epilogue',
                                fontSize: 12,
                                color: context.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            trailing: isSelected
                                ? Icon(
                                    Icons.check_rounded,
                                    color: context.colorScheme.primary,
                                  )
                                : null,
                            onTap: () {
                              setState(() {
                                if (isTo) {
                                  _selectedToAccountId = account.id;
                                } else {
                                  _selectedAccountId = account.id;
                                }
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Attachments ────────────────────────────────────────────────────────────

  Future<void> _showAttachmentsSheet() async {
    _closeNumpad();
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _AttachmentsSheet(
        existingImages: _existingImages,
        pendingPaths: _pendingImagePaths,
        onPickCamera: () async {
          Navigator.pop(ctx);
          await _pickImage(ImageSource.camera);
        },
        onPickGallery: () async {
          Navigator.pop(ctx);
          await _pickImage(ImageSource.gallery);
        },
        onRemoveExisting: (img) async {
          await ref.read(transactionImagesRepositoryProvider).delete(img.id);
          final file = File(img.localPath);
          if (await file.exists()) await file.delete();
          if (mounted) setState(() => _existingImages.remove(img));
        },
        onRemovePending: (path) {
          if (mounted) setState(() => _pendingImagePaths.remove(path));
        },
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 85);
    if (picked == null || !mounted) return;
    final saved = await _copyImageToAppDir(picked.path);
    setState(() => _pendingImagePaths.add(saved));
  }

  Future<String> _copyImageToAppDir(String sourcePath) async {
    final dir = await getApplicationDocumentsDirectory();
    final dest = p.join(dir.path, 'tx_images', '${DateTime.now().millisecondsSinceEpoch}${p.extension(sourcePath)}');
    await Directory(p.dirname(dest)).create(recursive: true);
    await File(sourcePath).copy(dest);
    return dest;
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final cs = context.colorScheme;
    final currency = ref.watch(currencyProvider);

    final accounts = ref.watch(accountModelsProvider);
    final selectedAccount = accounts.where((a) => a.id == _selectedAccountId).firstOrNull;
    final selectedToAccount = accounts.where((a) => a.id == _selectedToAccountId).firstOrNull;

    // Use the selected account's currency symbol; fall back to the app-wide currency.
    final accountCurrency = selectedAccount != null
        ? kSupportedCurrencies.firstWhere(
            (c) => c.code == selectedAccount.currencyCode,
            orElse: () => currency,
          )
        : currency;

    final categoryType = _type == TransactionType.income ? CategoryType.income : CategoryType.expense;
    final categories = ref.watch(categoriesByTypeProvider(categoryType)).value ?? [];
    final selectedCategoryModel = _selectedCategoryModel;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: ExpenseLabAppBar(
        title: widget.isEditing ? t.transactions.edit_title : t.transactions.add_title,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: cs.primary),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isLoadingTransaction
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  // ── Scrollable section ────────────────────────────────────────
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Column(
                        children: [
                          // Amount — tap to bring back the numpad
                          GestureDetector(
                            onTap: _openNumpad,
                            behavior: HitTestBehavior.opaque,
                            child: _AmountHeader(
                              amountString: _formattedAmount,
                              currencySymbol: accountCurrency.symbol,
                              label: t.transactions.enter_amount,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Type tabs
                          _TypeTabs(
                            selected: _type,
                            onChanged: (type) => setState(() {
                              _type = type;
                              _selectedCategoryId = null;
                              _selectedCategoryModel = null;
                            }),
                          ),
                          const SizedBox(height: 16),

                          // Category + Account cards (or two accounts for transfer)
                          if (_type != TransactionType.transfer)
                            Row(
                              children: [
                                Expanded(
                                  child: _PickerCard(
                                    label: t.transactions.category,
                                    value: selectedCategoryModel?.name ?? t.transactions.no_category,
                                    icon: selectedCategoryModel != null ? iconFromName(selectedCategoryModel.icon) : Icons.category_rounded,
                                    iconBgColor: selectedCategoryModel != null ? selectedCategoryModel.color.withValues(alpha: 0.15) : cs.primaryContainer,
                                    iconColor: selectedCategoryModel?.color ?? cs.primary,
                                    onTap: () => _showCategorySheet(categories),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _PickerCard(
                                    label: t.transactions.account,
                                    value: selectedAccount?.name ?? t.transactions.no_account,
                                    icon: selectedAccount != null ? iconFromName(selectedAccount.icon) : Icons.account_balance_wallet_rounded,
                                    iconBgColor: cs.primaryContainer,
                                    iconColor: cs.primary,
                                    onTap: () => _showAccountSheet(),
                                  ),
                                ),
                              ],
                            )
                          else
                            Row(
                              children: [
                                Expanded(
                                  child: _PickerCard(
                                    label: t.transactions.account,
                                    value: selectedAccount?.name ?? t.transactions.no_account,
                                    icon: selectedAccount != null ? iconFromName(selectedAccount.icon) : Icons.account_balance_wallet_rounded,
                                    iconBgColor: cs.primaryContainer,
                                    iconColor: cs.primary,
                                    onTap: () => _showAccountSheet(),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _PickerCard(
                                    label: t.transactions.to_account,
                                    value: selectedToAccount?.name ?? t.transactions.no_to_account,
                                    icon: selectedToAccount != null ? iconFromName(selectedToAccount.icon) : Icons.arrow_forward_rounded,
                                    iconBgColor: cs.secondaryContainer,
                                    iconColor: cs.secondary,
                                    onTap: () => _showAccountSheet(isTo: true),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 12),

                          // Date & Time
                          _DateRow(
                            date: _selectedDate,
                            label: t.transactions.date_time,
                            onTap: _pickDateTime,
                          ),
                          const SizedBox(height: 12),

                          // Notes card
                          _CardShell(
                            child: _NotesField(
                              controller: _noteController,
                              focusNode: _notesFocusNode,
                              label: t.transactions.notes,
                              hint: t.transactions.notes_hint,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Attachments card
                          _CardShell(
                            child: _AttachmentsRow(
                              label: t.transactions.attachments,
                              hint: t.transactions.attachments_hint,
                              imageCount: _existingImages.length + _pendingImagePaths.length,
                              onTap: _showAttachmentsSheet,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),

                  // ── Number pad (animated show/hide) ──────────────────────────
                  AnimatedSize(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    child: _showNumpad ? _NumberPad(onKeyTap: _onKeyTap) : const SizedBox(width: double.infinity),
                  ),

                  // ── Save button ───────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _submit,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.check_circle_outline_rounded,
                                size: 20,
                              ),
                        label: Text(
                          t.transactions.save_button,
                          style: const TextStyle(
                            fontFamily: 'Epilogue',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cs.primary,
                          foregroundColor: cs.onPrimary,
                          shape: const StadiumBorder(),
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

// ── Private widgets ───────────────────────────────────────────────────────────

class _AmountHeader extends StatefulWidget {
  const _AmountHeader({
    required this.amountString,
    required this.currencySymbol,
    required this.label,
  });

  final String amountString;
  final String currencySymbol;
  final String label;

  @override
  State<_AmountHeader> createState() => _AmountHeaderState();
}

class _AmountHeaderState extends State<_AmountHeader> with SingleTickerProviderStateMixin {
  late final AnimationController _blink;

  @override
  void initState() {
    super.initState();
    _blink = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _blink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return Column(
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontFamily: 'Epilogue',
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: cs.primary.withValues(alpha: 0.65),
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '${widget.currencySymbol} ',
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: cs.primary,
              ),
            ),
            Text(
              widget.amountString,
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 52,
                fontWeight: FontWeight.w700,
                color: cs.primary,
              ),
            ),
            // Blinking cursor
            AnimatedBuilder(
              animation: _blink,
              builder: (context, _) => Opacity(
                opacity: _blink.value < 0.5 ? 1.0 : 0.0,
                child: Text(
                  '|',
                  style: TextStyle(
                    fontFamily: 'Epilogue',
                    fontSize: 44,
                    fontWeight: FontWeight.w300,
                    color: cs.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Type tabs ─────────────────────────────────────────────────────────────────

class _TypeTabs extends StatelessWidget {
  const _TypeTabs({required this.selected, required this.onChanged});

  final TransactionType selected;
  final ValueChanged<TransactionType> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final cs = context.colorScheme;

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? cs.surfaceContainerHighest : const Color(0xFFE8F2E8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _TypeTab(
            icon: Icons.trending_down_rounded,
            label: t.transactions.tab_expense,
            isSelected: selected == TransactionType.expense,
            onTap: () => onChanged(TransactionType.expense),
          ),
          const SizedBox(width: 4),
          _TypeTab(
            icon: Icons.trending_up_rounded,
            label: t.transactions.tab_income,
            isSelected: selected == TransactionType.income,
            onTap: () => onChanged(TransactionType.income),
          ),
          const SizedBox(width: 4),
          _TypeTab(
            icon: Icons.swap_horiz_rounded,
            label: t.transactions.tab_transfer,
            isSelected: selected == TransactionType.transfer,
            onTap: () => onChanged(TransactionType.transfer),
          ),
        ],
      ),
    );
  }
}

class _TypeTab extends StatelessWidget {
  const _TypeTab({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? cs.primary.withValues(alpha: 95) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 15,
                  color: isSelected ? cs.onPrimary : cs.onSurfaceVariant,
                ),
                const SizedBox(width: 5),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Epilogue',
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? cs.onPrimary : cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Picker card ───────────────────────────────────────────────────────────────

class _PickerCard extends StatelessWidget {
  const _PickerCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: cs.primary,
                letterSpacing: 0.9,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Date row ──────────────────────────────────────────────────────────────────

class _DateRow extends StatelessWidget {
  const _DateRow({
    required this.date,
    required this.label,
    required this.onTap,
  });

  final DateTime date;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final dateStr = DateFormat('MMM dd, yyyy').format(date);
    final timeStr = DateFormat('hh:mm a').format(date);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.calendar_month_rounded,
                color: cs.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
                      letterSpacing: 0.9,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    dateStr,
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                  Text(
                    timeStr,
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: cs.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: cs.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Notes field ───────────────────────────────────────────────────────────────

class _NotesField extends StatelessWidget {
  const _NotesField({
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.hint,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.notes_rounded, color: cs.onSurfaceVariant, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Epilogue',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: cs.primary,
                    letterSpacing: 0.9,
                  ),
                ),
                TextField(
                  controller: controller,
                  focusNode: focusNode,
                  autofocus: false,
                  minLines: 1,
                  maxLines: 3,
                  style: TextStyle(
                    fontFamily: 'Epilogue',
                    fontSize: 13,
                    color: cs.onSurface,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.only(top: 4),
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 13,
                      color: cs.onSurfaceVariant,
                    ),
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

// ── Attachments row ───────────────────────────────────────────────────────────

class _AttachmentsRow extends StatelessWidget {
  const _AttachmentsRow({
    required this.label,
    required this.hint,
    required this.imageCount,
    required this.onTap,
  });

  final String label;
  final String hint;
  final int imageCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Icon(Icons.camera_alt_outlined, color: cs.onSurfaceVariant, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
                      letterSpacing: 0.9,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    imageCount > 0 ? '$imageCount attachment${imageCount == 1 ? '' : 's'}' : hint,
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 13,
                      color: imageCount > 0 ? cs.onSurface : cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Card shell ────────────────────────────────────────────────────────────────

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ── Number pad ────────────────────────────────────────────────────────────────

class _NumberPad extends StatelessWidget {
  const _NumberPad({required this.onKeyTap});

  final ValueChanged<String> onKeyTap;

  static const _rows = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['.', '0', '⌫'],
  ];

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(
          top: BorderSide(color: cs.outlineVariant, width: 0.8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          children: _rows
              .map(
                (row) => Row(
                  children: row
                      .map(
                        (digit) => Expanded(
                          child: _NumKey(
                            symbol: digit,
                            onTap: () => onKeyTap(digit),
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _NumKey extends StatelessWidget {
  const _NumKey({required this.symbol, required this.onTap});

  final String symbol;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final isBackspace = symbol == '⌫';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 58,
          child: Center(
            child: isBackspace
                ? Icon(
                    Icons.backspace_outlined,
                    color: cs.onSurface,
                    size: 22,
                  )
                : Text(
                    symbol,
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: cs.onSurface,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// ── Category picker sheet ─────────────────────────────────────────────────────

class _CategoryPickerSheet extends StatefulWidget {
  const _CategoryPickerSheet({
    required this.topLevelCategories,
    required this.allCategories,
    required this.selectedCategoryId,
  });

  final List<Category> topLevelCategories;
  final List<Category> allCategories;
  final String? selectedCategoryId;

  @override
  State<_CategoryPickerSheet> createState() => _CategoryPickerSheetState();
}

class _CategoryPickerSheetState extends State<_CategoryPickerSheet> {
  Category? _drilledParent;

  List<Category> get _drillItems {
    if (_drilledParent == null) return widget.topLevelCategories;
    final subs = widget.allCategories.where((c) => c.parentId == _drilledParent!.id).toList();
    return [_drilledParent!, ...subs];
  }

  bool _hasSubcategories(Category cat) => widget.allCategories.any((c) => c.parentId == cat.id);

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final cs = context.colorScheme;

    final items = _drillItems;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, sc) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          children: [
            const _SheetHandle(),
            const SizedBox(height: 12),
            Row(
              children: [
                if (_drilledParent != null)
                  GestureDetector(
                    onTap: () => setState(() => _drilledParent = null),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: cs.onSurface),
                    ),
                  ),
                Expanded(
                  child: Text(
                    _drilledParent == null ? t.transactions.select_category : _drilledParent!.name,
                    textAlign: _drilledParent != null ? TextAlign.start : TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                if (_drilledParent != null) const SizedBox(width: 26),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text(
                        t.categories.empty_state,
                        style: TextStyle(
                          fontFamily: 'Epilogue',
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: sc,
                      itemCount: items.length,
                      itemBuilder: (_, i) {
                        final cat = items[i];
                        final model = CategoryModel.fromCategory(cat);
                        final isSelected = cat.id == widget.selectedCategoryId;
                        final hasSubs = _drilledParent == null && _hasSubcategories(cat);

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: model.color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(iconFromName(model.icon), color: model.color, size: 20),
                          ),
                          title: Text(
                            model.name,
                            style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: isSelected ? cs.primary : cs.onSurface,
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(Icons.check_rounded, color: cs.primary)
                              : hasSubs
                              ? Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant)
                              : null,
                          onTap: () {
                            if (hasSubs) {
                              setState(() => _drilledParent = cat);
                            } else {
                              Navigator.pop(context, cat);
                            }
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sheet handle ──────────────────────────────────────────────────────────────

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: context.colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

// ── Attachments sheet ─────────────────────────────────────────────────────────

class _AttachmentsSheet extends StatelessWidget {
  const _AttachmentsSheet({
    required this.existingImages,
    required this.pendingPaths,
    required this.onPickCamera,
    required this.onPickGallery,
    required this.onRemoveExisting,
    required this.onRemovePending,
  });

  final List<TransactionImageModel> existingImages;
  final List<String> pendingPaths;
  final VoidCallback onPickCamera;
  final VoidCallback onPickGallery;
  final void Function(TransactionImageModel) onRemoveExisting;
  final void Function(String) onRemovePending;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final allPaths = [
      ...existingImages.map((img) => (path: img.localPath, existing: true, img: img)),
      ...pendingPaths.map((path) => (path: path, existing: false, img: null as TransactionImageModel?)),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _SheetHandle(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _AttachOption(
                  icon: Icons.camera_alt_outlined,
                  label: 'Camera',
                  onTap: onPickCamera,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _AttachOption(
                  icon: Icons.photo_library_outlined,
                  label: 'Gallery',
                  onTap: onPickGallery,
                ),
              ),
            ],
          ),
          if (allPaths.isNotEmpty) ...[
            const SizedBox(height: 16),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: allPaths.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final entry = allPaths[i];
                  return Stack(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => _FullScreenImageViewer(path: entry.path),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(entry.path),
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              width: 80,
                              height: 80,
                              color: cs.surfaceContainerHighest,
                              child: Icon(Icons.broken_image_outlined, color: cs.onSurfaceVariant),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 2,
                        right: 2,
                        child: GestureDetector(
                          onTap: () {
                            if (entry.existing && entry.img != null) {
                              onRemoveExisting(entry.img!);
                            } else {
                              onRemovePending(entry.path);
                            }
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: cs.error,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.close, size: 13, color: cs.onError),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AttachOption extends StatelessWidget {
  const _AttachOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return Material(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: cs.primary, size: 28),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Full-screen image viewer ───────────────────────────────────────────────────

class _FullScreenImageViewer extends StatelessWidget {
  const _FullScreenImageViewer({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 5,
          child: Image.file(
            File(path),
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const Icon(
              Icons.broken_image_outlined,
              color: Colors.white54,
              size: 64,
            ),
          ),
        ),
      ),
    );
  }
}
