import 'dart:io';

import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/core/theme/app_colors.dart';
import 'package:expenselab/features/data_manager/domain/models/export_data.dart';
import 'package:expenselab/features/data_manager/providers/import_export_providers.dart';
import 'package:expenselab/features/settings/presentation/widgets/settings_widgets.dart';
import 'package:expenselab/widgets/scaffold/expense_lab_app_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

class ImportExportScreen extends ConsumerStatefulWidget {
  const ImportExportScreen({super.key});

  @override
  ConsumerState<ImportExportScreen> createState() => _ImportExportScreenState();
}

class _ImportExportScreenState extends ConsumerState<ImportExportScreen> {
  bool _includeImages = false;
  bool _isExporting = false;
  bool _isImporting = false;
  List<FileSystemEntity> _backupFiles = [];
  bool _loadingBackups = true;

  @override
  void initState() {
    super.initState();
    _loadBackups();
  }

  Future<void> _loadBackups() async {
    setState(() => _loadingBackups = true);
    try {
      final service = ref.read(exportServiceProvider);
      final files = await service.listBackupFiles();
      if (mounted) setState(() => _backupFiles = files);
    } catch (_) {
      if (mounted) setState(() => _backupFiles = []);
    } finally {
      if (mounted) setState(() => _loadingBackups = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final tsdm = context.t.settings.data_management;

    return Scaffold(
      backgroundColor: appColors.scaffoldBackground,
      appBar: ExpenseLabAppBar(
        title: tsdm.title,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.colorScheme.primary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _sectionHeader(tsdm.export_title, context),
              const SizedBox(height: 12),
              buildSettingsCard(
                context,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tsdm.export_subtitle,
                        style: TextStyle(fontSize: 14, color: appColors.secondaryLabel),
                      ),
                      const SizedBox(height: 16),
                      _buildImageToggle(tsdm),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _isExporting ? null : _handleExport,
                          icon: _isExporting
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.file_upload_outlined),
                          label: Text(_isExporting ? tsdm.export_in_progress : tsdm.export_button),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _sectionHeader(tsdm.import_title, context),
              const SizedBox(height: 12),
              buildSettingsCard(
                context,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tsdm.import_subtitle,
                        style: TextStyle(fontSize: 14, color: appColors.secondaryLabel),
                      ),
                      const SizedBox(height: 16),
                      _buildBackupList(tsdm, appColors),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, BuildContext context) {
    return Text(title.toUpperCase(), style: context.textTheme.displaySmall);
  }

  Widget _buildImageToggle(dynamic tsdm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            tsdm.export_include_images as String,
            style: const TextStyle(fontSize: 14),
          ),
          value: _includeImages,
          onChanged: (v) => setState(() => _includeImages = v),
        ),
        if (_includeImages)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              tsdm.export_image_warning as String,
              style: TextStyle(fontSize: 12, color: Colors.orange.shade700),
            ),
          ),
      ],
    );
  }

  Widget _buildBackupList(dynamic tsdm, AppColors appColors) {
    if (_isImporting) {
      return SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: null,
          icon: const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          label: Text(tsdm.import_in_progress as String),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tsdm.import_recent as String,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: appColors.secondaryLabel,
          ),
        ),
        const SizedBox(height: 8),
        if (_loadingBackups)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
          )
        else if (_backupFiles.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              tsdm.import_no_backups as String,
              style: TextStyle(fontSize: 13, color: appColors.secondaryLabel),
            ),
          )
        else ...[
          Text(
            tsdm.import_tap_restore as String,
            style: TextStyle(fontSize: 12, color: appColors.secondaryLabel),
          ),
          const SizedBox(height: 8),
          ...(_backupFiles.take(5).map((entity) {
            final file = entity as File;
            final stat = file.statSync();
            final size = stat.size;
            final modified = stat.modified;
            final name = p.basename(file.path);
            final dateStr = DateFormat('yyyy-MM-dd HH:mm').format(modified);
            final sizeStr = size > 1024 * 1024
                ? '${(size / (1024 * 1024)).toStringAsFixed(1)} MB'
                : size > 1024
                    ? '${(size / 1024).toStringAsFixed(1)} KB'
                    : '$size B';
            return Card(
              margin: const EdgeInsets.only(bottom: 6),
              color: appColors.cardSurfaceElevated,
              child: ListTile(
                dense: true,
                leading: Icon(Icons.restore_page_rounded, color: context.colorScheme.primary, size: 20),
                title: Text(name, style: const TextStyle(fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text('$dateStr  ·  $sizeStr', style: const TextStyle(fontSize: 11)),
                trailing: Icon(Icons.chevron_right_rounded, color: appColors.secondaryLabel, size: 18),
                onTap: () => _handleImportFile(file.path),
              ),
            );
          })),
        ],
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              _handleImport();
            },
            icon: const Icon(Icons.folder_open_outlined),
            label: Text(tsdm.import_browse as String),
          ),
        ),
      ],
    );
  }

  Future<void> _handleExport() async {
    final messenger = ScaffoldMessenger.of(context);
    final errorMsg = context.t.settings.data_management.export_error;

    setState(() => _isExporting = true);
    try {
      final service = ref.read(exportServiceProvider);
      final filePath = await service.exportData(includeImages: _includeImages);

      await Share.shareXFiles([XFile(filePath)]);
      await _loadBackups();

    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(SnackBar(content: Text('$errorMsg: $e')));
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _handleImport() async {
    final pickResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (pickResult == null || pickResult.files.single.path == null) return;

    final filePath = pickResult.files.single.path!;
    await _handleImportFile(filePath);
  }

  Future<void> _handleImportFile(String filePath) async {
    final messenger = ScaffoldMessenger.of(context);
    final tsdm = context.t.settings.data_management;
    final cancelLabel = context.t.common.cancel;
    final secondaryLabel = context.appColors.secondaryLabel;

    setState(() => _isImporting = true);
    try {
      final service = ref.read(importServiceProvider);
      final summary = await service.getSummary(filePath);

      if (!mounted) return;

      if (summary.isEmpty) {
        messenger.showSnackBar(SnackBar(content: Text(tsdm.import_invalid_file)));
        setState(() => _isImporting = false);
        return;
      }

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => _ImportConfirmationDialog(
          summary: summary,
          tsdm: tsdm,
          cancelLabel: cancelLabel,
          secondaryLabel: secondaryLabel,
        ),
      );
      if (confirmed != true) {
        if (mounted) setState(() => _isImporting = false);
        return;
      }

      if (!mounted) return;
      await service.importData(filePath);

    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(SnackBar(content: Text('$tsdm.import_error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }
}

class _ImportConfirmationDialog extends StatefulWidget {
  const _ImportConfirmationDialog({
    required this.summary,
    required this.tsdm,
    required this.cancelLabel,
    required this.secondaryLabel,
  });

  final ImportSummary summary;
  final TranslationsSettingsDataManagementEn tsdm;
  final String cancelLabel;
  final Color secondaryLabel;

  @override
  State<_ImportConfirmationDialog> createState() => _ImportConfirmationDialogState();
}

class _ImportConfirmationDialogState extends State<_ImportConfirmationDialog> {
  final _controller = TextEditingController();
  bool _matches = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final matches = _controller.text == 'ExpenseLab';
      if (matches != _matches) setState(() => _matches = matches);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final summary = w.summary;
    final tsdm = w.tsdm;
    final secondaryLabel = w.secondaryLabel;

    final lines = <Widget>[
      Text(tsdm.import_summary),
      const SizedBox(height: 12),
      _summaryLine(_fmt(tsdm.import_accounts_count, summary.accounts), secondaryLabel),
      _summaryLine(_fmt(tsdm.import_categories_count, summary.categories), secondaryLabel),
      _summaryLine(_fmt(tsdm.import_transactions_count, summary.transactions), secondaryLabel),
      if (summary.transactionImages > 0)
        _summaryLine(_fmt(tsdm.import_images_count, summary.transactionImages), secondaryLabel),
      if (summary.starredTransactions > 0)
        _summaryLine(_fmt(tsdm.import_starred_count, summary.starredTransactions), secondaryLabel),
      if (summary.budgets > 0)
        _summaryLine(_fmt(tsdm.import_budgets_count, summary.budgets), secondaryLabel),
      if (summary.savingsGoals > 0)
        _summaryLine(_fmt(tsdm.import_goals_count, summary.savingsGoals), secondaryLabel),
      if (summary.savingsContributions > 0)
        _summaryLine(_fmt(tsdm.import_contributions_count, summary.savingsContributions), secondaryLabel),
      if (summary.exchangeRates > 0)
        _summaryLine(_fmt(tsdm.import_rates_count, summary.exchangeRates), secondaryLabel),
      if (summary.hasSettings) _summaryLine(tsdm.import_settings, secondaryLabel),
      if (summary.hasImages) _summaryLine(tsdm.import_images_included, secondaryLabel),
      const SizedBox(height: 16),
      Text(
        tsdm.import_confirm_message,
        style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w500, fontSize: 13),
      ),
      const SizedBox(height: 16),
      TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Type "ExpenseLab" to confirm',
          border: OutlineInputBorder(),
        ),
      ),
    ];

    return AlertDialog(
      title: Text(tsdm.import_confirm_title),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: lines),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(w.cancelLabel),
        ),
        TextButton(
          onPressed: _matches ? () => Navigator.pop(context, true) : null,
          style: TextButton.styleFrom(foregroundColor: const Color(0xFFD9534F)),
          child: Text(tsdm.import_confirm_button),
        ),
      ],
    );
  }

  String _fmt(String template, int count) => template.replaceAll('{count}', count.toString());

  Widget _summaryLine(String text, Color secondaryLabel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, size: 16, color: secondaryLabel),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
