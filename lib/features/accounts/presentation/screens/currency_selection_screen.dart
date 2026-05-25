import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/settings/domain/models/supported_currencies.dart';
import 'package:flutter/material.dart';

class CurrencySelectionScreen extends StatefulWidget {
  final String currentSelectedCode;

  const CurrencySelectionScreen({
    required this.currentSelectedCode,
    super.key,
  });

  @override
  State<CurrencySelectionScreen> createState() => _CurrencySelectionScreenState();
}

class _CurrencySelectionScreenState extends State<CurrencySelectionScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredCurrencies = kSupportedCurrencies.where((currency) {
      final query = _searchQuery.toLowerCase().trim();
      if (query.isEmpty) return true;

      // Access slang localized name map
      final localizedName = (t.currencies[currency.code] ?? currency.name).toLowerCase();
      final code = currency.code.toLowerCase();
      return code.contains(query) || localizedName.contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF171B18) : const Color(0xFFF9FAF9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: context.colorScheme.primary,
            size: 28,
          ),
        ),
        title: Text(
          t.accounts.create.select_currency_title,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Input Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextFormField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : const Color(0xFF1C221E),
                ),
                decoration: InputDecoration(
                  hintText: t.accounts.create.search_currency_hint,
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white38 : const Color(0xFF9EAEA2),
                    fontFamily: 'Epilogue',
                    fontWeight: FontWeight.normal,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: context.colorScheme.primary,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E2420) : Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: isDark ? Colors.white10 : const Color(0xFFDCE3DF),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: isDark ? Colors.white10 : const Color(0xFFDCE3DF),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: context.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Currency List
            Expanded(
              child: filteredCurrencies.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: isDark ? Colors.white24 : const Color(0xFFDCE3DF),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            t.accounts.create.no_currencies_found,
                            style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white38 : const Color(0xFF9EAEA2),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredCurrencies.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        final currency = filteredCurrencies[index];
                        final isSelected = widget.currentSelectedCode == currency.code;
                        final localizedName = t.currencies[currency.code] ?? currency.name;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? context.colorScheme.primary.withValues(alpha: 0.1) : (isDark ? const Color(0xFF1E2420) : Colors.white),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? context.colorScheme.primary : (isDark ? Colors.white10 : const Color(0xFFEAF0EB)),
                              width: 1.5,
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context, currency.code);
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              child: Row(
                                children: [
                                  // Code and Name
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          currency.code,
                                          style: TextStyle(
                                            fontFamily: 'Epilogue',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: isDark ? Colors.white : const Color(0xFF1C221E),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          localizedName,
                                          style: TextStyle(
                                            fontFamily: 'Epilogue',
                                            fontWeight: FontWeight.normal,
                                            fontSize: 13,
                                            color: isDark ? Colors.white60 : const Color(0xFF5D6B60),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Symbol or Selection Indicator
                                  Row(
                                    children: [
                                      Text(
                                        currency.symbol,
                                        style: TextStyle(
                                          fontFamily: 'Epilogue',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: isSelected ? context.colorScheme.primary : (isDark ? Colors.white38 : const Color(0xFF9EAEA2)),
                                        ),
                                      ),
                                      if (isSelected) ...[
                                        const SizedBox(width: 12),
                                        Icon(
                                          Icons.check_circle_rounded,
                                          color: context.colorScheme.primary,
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
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
