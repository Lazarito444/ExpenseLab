///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsAppEn app = TranslationsAppEn.internal(_root);
	late final TranslationsCommonEn common = TranslationsCommonEn.internal(_root);
	late final TranslationsNavEn nav = TranslationsNavEn.internal(_root);
	late final TranslationsSettingsEn settings = TranslationsSettingsEn.internal(_root);
	Map<String, String> get currencies => {
		'USD': 'US Dollar',
		'EUR': 'Euro',
		'GBP': 'British Pound',
		'ARS': 'Argentine Peso',
		'BRL': 'Brazilian Real',
		'MXN': 'Mexican Peso',
		'DOP': 'Dominican Peso',
		'CLP': 'Chilean Peso',
		'COP': 'Colombian Peso',
		'PEN': 'Peruvian Sol',
		'UYU': 'Uruguayan Peso',
		'PYG': 'Paraguayan Guaraní',
		'BOB': 'Bolivian Boliviano',
		'JPY': 'Japanese Yen',
		'CNY': 'Chinese Yuan',
		'CAD': 'Canadian Dollar',
		'AUD': 'Australian Dollar',
		'CHF': 'Swiss Franc',
		'INR': 'Indian Rupee',
		'KRW': 'South Korean Won',
		'ZAR': 'South African Rand',
	};
	late final TranslationsAccountsEn accounts = TranslationsAccountsEn.internal(_root);
	late final TranslationsTransactionsEn transactions = TranslationsTransactionsEn.internal(_root);
	late final TranslationsBudgetsEn budgets = TranslationsBudgetsEn.internal(_root);
	late final TranslationsSavingsEn savings = TranslationsSavingsEn.internal(_root);
	late final TranslationsCategoriesEn categories = TranslationsCategoriesEn.internal(_root);
}

// Path: app
class TranslationsAppEn {
	TranslationsAppEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'ExpenseLab'
	String get name => 'ExpenseLab';
}

// Path: common
class TranslationsCommonEn {
	TranslationsCommonEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Confirm'
	String get confirm => 'Confirm';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'Close'
	String get close => 'Close';

	/// en: 'Error'
	String get error => 'Error';
}

// Path: nav
class TranslationsNavEn {
	TranslationsNavEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Home'
	String get home => 'Home';

	/// en: 'Budgets'
	String get budgets => 'Budgets';

	/// en: 'Goals'
	String get goals => 'Goals';

	/// en: 'Settings'
	String get settings => 'Settings';
}

// Path: settings
class TranslationsSettingsEn {
	TranslationsSettingsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	late final TranslationsSettingsThemeEn theme = TranslationsSettingsThemeEn.internal(_root);
	late final TranslationsSettingsLanguageEn language = TranslationsSettingsLanguageEn.internal(_root);
	late final TranslationsSettingsCurrencyEn currency = TranslationsSettingsCurrencyEn.internal(_root);
}

// Path: accounts
class TranslationsAccountsEn {
	TranslationsAccountsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'My Accounts'
	String get title => 'My Accounts';

	/// en: 'Your financial overview at a glance.'
	String get subtitle => 'Your financial overview at a glance.';

	/// en: 'Total Net Worth'
	String get total_net_worth => 'Total Net Worth';

	/// en: 'this month'
	String get this_month => 'this month';

	/// en: 'Asset Accounts'
	String get asset_accounts => 'Asset Accounts';

	/// en: 'Liability Accounts'
	String get liability_accounts => 'Liability Accounts';

	/// en: 'Due soon'
	String get due_soon => 'Due soon';

	/// en: 'Due in 5 days'
	String get due_in_5_days => 'Due in 5 days';

	/// en: 'Limit: {limit}'
	String get limit => 'Limit: {limit}';

	/// en: 'Cash Accounts'
	String get cash_accounts => 'Cash Accounts';

	/// en: 'Bank Accounts'
	String get bank_accounts => 'Bank Accounts';

	/// en: 'Credit Cards'
	String get credit_cards => 'Credit Cards';

	late final TranslationsAccountsCreateEn create = TranslationsAccountsCreateEn.internal(_root);
	late final TranslationsAccountsEditEn edit = TranslationsAccountsEditEn.internal(_root);
	late final TranslationsAccountsDetailsEn details = TranslationsAccountsDetailsEn.internal(_root);
}

// Path: transactions
class TranslationsTransactionsEn {
	TranslationsTransactionsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Transactions'
	String get title => 'Transactions';
}

// Path: budgets
class TranslationsBudgetsEn {
	TranslationsBudgetsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Budgets'
	String get title => 'Budgets';
}

// Path: savings
class TranslationsSavingsEn {
	TranslationsSavingsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Savings'
	String get title => 'Savings';
}

// Path: categories
class TranslationsCategoriesEn {
	TranslationsCategoriesEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'My Categories'
	String get title => 'My Categories';

	/// en: 'Keep track of where your hard-earned paper is going.'
	String get subtitle => 'Keep track of where your hard-earned paper is going.';

	/// en: 'Expenses'
	String get expenses => 'Expenses';

	/// en: 'Income'
	String get income => 'Income';

	/// en: 'Category'
	String get category => 'Category';

	/// en: 'Subcategory'
	String get subcategory => 'Subcategory';

	/// en: 'Add Category'
	String get add_category => 'Add Category';

	/// en: 'Edit Category'
	String get edit_category => 'Edit Category';

	/// en: 'Delete Category'
	String get delete_category => 'Delete Category';

	/// en: 'Are you sure you want to delete this category? All its subcategories will become top-level categories.'
	String get delete_message => 'Are you sure you want to delete this category? All its subcategories will become top-level categories.';

	/// en: 'No categories here! Don't let your moolah vanish.'
	String get empty_state => 'No categories here! Don\'t let your moolah vanish.';

	/// en: 'No subcategories yet. Tap + to add some!'
	String get empty_subcategories => 'No subcategories yet. Tap + to add some!';

	/// en: 'Category Name'
	String get name => 'Category Name';

	/// en: 'e.g., Munchies & Grub, Side Hustle...'
	String get name_hint => 'e.g., Munchies & Grub, Side Hustle...';

	/// en: 'Category Type'
	String get type => 'Category Type';

	/// en: 'Category Color'
	String get color => 'Category Color';

	/// en: 'Category Icon'
	String get icon => 'Category Icon';

	/// en: 'Parent Category'
	String get parent => 'Parent Category';

	/// en: 'None (Top-level)'
	String get parent_none => 'None (Top-level)';

	/// en: 'Pro Tip: Split your outgoings so you don't burn through all your dough at once!'
	String get pro_tip => 'Pro Tip: Split your outgoings so you don\'t burn through all your dough at once!';

	/// en: 'Category created successfully!'
	String get success_create => 'Category created successfully!';

	/// en: 'Category updated successfully!'
	String get success_update => 'Category updated successfully!';

	/// en: 'Category deleted successfully!'
	String get success_delete => 'Category deleted successfully!';

	/// en: 'Please enter a category name'
	String get name_required => 'Please enter a category name';

	/// en: '(one) {1 Category} (other) {{n} Categories}'
	String count({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '1 Category',
		other: '{n} Categories',
	);
}

// Path: settings.theme
class TranslationsSettingsThemeEn {
	TranslationsSettingsThemeEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Theme'
	String get title => 'Theme';

	/// en: 'System'
	String get system => 'System';

	/// en: 'Light'
	String get light => 'Light';

	/// en: 'Dark'
	String get dark => 'Dark';
}

// Path: settings.language
class TranslationsSettingsLanguageEn {
	TranslationsSettingsLanguageEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Language'
	String get title => 'Language';
}

// Path: settings.currency
class TranslationsSettingsCurrencyEn {
	TranslationsSettingsCurrencyEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Currency'
	String get title => 'Currency';
}

// Path: accounts.create
class TranslationsAccountsCreateEn {
	TranslationsAccountsCreateEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'New Account'
	String get title => 'New Account';

	/// en: 'Account Icon'
	String get icon => 'Account Icon';

	/// en: 'Account Name'
	String get name => 'Account Name';

	/// en: 'e.g., Main Savings'
	String get name_hint => 'e.g., Main Savings';

	/// en: 'Account Type'
	String get type => 'Account Type';

	/// en: 'Bank Account'
	String get type_savings => 'Bank Account';

	/// en: 'Cash'
	String get type_cash => 'Cash';

	/// en: 'Credit Card'
	String get type_credit_card => 'Credit Card';

	/// en: 'Currency'
	String get currency => 'Currency';

	/// en: 'Select Currency'
	String get select_currency_title => 'Select Currency';

	/// en: 'Search currency code or name...'
	String get search_currency_hint => 'Search currency code or name...';

	/// en: 'No currencies found'
	String get no_currencies_found => 'No currencies found';

	/// en: 'Initial Balance'
	String get initial_balance => 'Initial Balance';

	/// en: 'Pro Tip: Grouping your savings into specific accounts helps you visualize progress toward long-term financial goals.'
	String get pro_tip => 'Pro Tip: Grouping your savings into specific accounts helps you visualize progress toward long-term financial goals.';

	/// en: 'Create Account'
	String get create_button => 'Create Account';

	/// en: 'Please enter an account name'
	String get name_required => 'Please enter an account name';

	/// en: 'Please enter a valid balance'
	String get balance_invalid => 'Please enter a valid balance';

	/// en: 'Account created successfully'
	String get success => 'Account created successfully';
}

// Path: accounts.edit
class TranslationsAccountsEditEn {
	TranslationsAccountsEditEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Edit Account'
	String get title => 'Edit Account';

	/// en: 'Edit Account'
	String get edit_button => 'Edit Account';

	/// en: 'Delete Account'
	String get delete_button => 'Delete Account';

	/// en: 'Delete Account'
	String get delete_title => 'Delete Account';

	/// en: 'Are you sure you want to delete this account? This action cannot be undone.'
	String get delete_message => 'Are you sure you want to delete this account? This action cannot be undone.';

	/// en: 'Error loading account'
	String get error_loading => 'Error loading account';

	/// en: 'Account updated successfully'
	String get success_update => 'Account updated successfully';

	/// en: 'Account deleted successfully'
	String get success_delete => 'Account deleted successfully';
}

// Path: accounts.details
class TranslationsAccountsDetailsEn {
	TranslationsAccountsDetailsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Account Details'
	String get title => 'Account Details';

	/// en: 'Edit Account'
	String get edit_account => 'Edit Account';

	/// en: 'Delete Account'
	String get delete_account => 'Delete Account';

	/// en: 'Recent Transactions'
	String get recent_transactions => 'Recent Transactions';

	/// en: 'View All'
	String get view_all => 'View All';

	/// en: 'No transactions found'
	String get no_transactions => 'No transactions found';

	/// en: '{percentage} this month'
	String get growth_this_month => '{percentage} this month';

	/// en: 'Error loading details'
	String get error_loading => 'Error loading details';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.name' => 'ExpenseLab',
			'common.save' => 'Save',
			'common.cancel' => 'Cancel',
			'common.confirm' => 'Confirm',
			'common.delete' => 'Delete',
			'common.edit' => 'Edit',
			'common.close' => 'Close',
			'common.error' => 'Error',
			'nav.home' => 'Home',
			'nav.budgets' => 'Budgets',
			'nav.goals' => 'Goals',
			'nav.settings' => 'Settings',
			'settings.title' => 'Settings',
			'settings.theme.title' => 'Theme',
			'settings.theme.system' => 'System',
			'settings.theme.light' => 'Light',
			'settings.theme.dark' => 'Dark',
			'settings.language.title' => 'Language',
			'settings.currency.title' => 'Currency',
			'currencies.USD' => 'US Dollar',
			'currencies.EUR' => 'Euro',
			'currencies.GBP' => 'British Pound',
			'currencies.ARS' => 'Argentine Peso',
			'currencies.BRL' => 'Brazilian Real',
			'currencies.MXN' => 'Mexican Peso',
			'currencies.DOP' => 'Dominican Peso',
			'currencies.CLP' => 'Chilean Peso',
			'currencies.COP' => 'Colombian Peso',
			'currencies.PEN' => 'Peruvian Sol',
			'currencies.UYU' => 'Uruguayan Peso',
			'currencies.PYG' => 'Paraguayan Guaraní',
			'currencies.BOB' => 'Bolivian Boliviano',
			'currencies.JPY' => 'Japanese Yen',
			'currencies.CNY' => 'Chinese Yuan',
			'currencies.CAD' => 'Canadian Dollar',
			'currencies.AUD' => 'Australian Dollar',
			'currencies.CHF' => 'Swiss Franc',
			'currencies.INR' => 'Indian Rupee',
			'currencies.KRW' => 'South Korean Won',
			'currencies.ZAR' => 'South African Rand',
			'accounts.title' => 'My Accounts',
			'accounts.subtitle' => 'Your financial overview at a glance.',
			'accounts.total_net_worth' => 'Total Net Worth',
			'accounts.this_month' => 'this month',
			'accounts.asset_accounts' => 'Asset Accounts',
			'accounts.liability_accounts' => 'Liability Accounts',
			'accounts.due_soon' => 'Due soon',
			'accounts.due_in_5_days' => 'Due in 5 days',
			'accounts.limit' => 'Limit: {limit}',
			'accounts.cash_accounts' => 'Cash Accounts',
			'accounts.bank_accounts' => 'Bank Accounts',
			'accounts.credit_cards' => 'Credit Cards',
			'accounts.create.title' => 'New Account',
			'accounts.create.icon' => 'Account Icon',
			'accounts.create.name' => 'Account Name',
			'accounts.create.name_hint' => 'e.g., Main Savings',
			'accounts.create.type' => 'Account Type',
			'accounts.create.type_savings' => 'Bank Account',
			'accounts.create.type_cash' => 'Cash',
			'accounts.create.type_credit_card' => 'Credit Card',
			'accounts.create.currency' => 'Currency',
			'accounts.create.select_currency_title' => 'Select Currency',
			'accounts.create.search_currency_hint' => 'Search currency code or name...',
			'accounts.create.no_currencies_found' => 'No currencies found',
			'accounts.create.initial_balance' => 'Initial Balance',
			'accounts.create.pro_tip' => 'Pro Tip: Grouping your savings into specific accounts helps you visualize progress toward long-term financial goals.',
			'accounts.create.create_button' => 'Create Account',
			'accounts.create.name_required' => 'Please enter an account name',
			'accounts.create.balance_invalid' => 'Please enter a valid balance',
			'accounts.create.success' => 'Account created successfully',
			'accounts.edit.title' => 'Edit Account',
			'accounts.edit.edit_button' => 'Edit Account',
			'accounts.edit.delete_button' => 'Delete Account',
			'accounts.edit.delete_title' => 'Delete Account',
			'accounts.edit.delete_message' => 'Are you sure you want to delete this account? This action cannot be undone.',
			'accounts.edit.error_loading' => 'Error loading account',
			'accounts.edit.success_update' => 'Account updated successfully',
			'accounts.edit.success_delete' => 'Account deleted successfully',
			'accounts.details.title' => 'Account Details',
			'accounts.details.edit_account' => 'Edit Account',
			'accounts.details.delete_account' => 'Delete Account',
			'accounts.details.recent_transactions' => 'Recent Transactions',
			'accounts.details.view_all' => 'View All',
			'accounts.details.no_transactions' => 'No transactions found',
			'accounts.details.growth_this_month' => '{percentage} this month',
			'accounts.details.error_loading' => 'Error loading details',
			'transactions.title' => 'Transactions',
			'budgets.title' => 'Budgets',
			'savings.title' => 'Savings',
			'categories.title' => 'My Categories',
			'categories.subtitle' => 'Keep track of where your hard-earned paper is going.',
			'categories.expenses' => 'Expenses',
			'categories.income' => 'Income',
			'categories.category' => 'Category',
			'categories.subcategory' => 'Subcategory',
			'categories.add_category' => 'Add Category',
			'categories.edit_category' => 'Edit Category',
			'categories.delete_category' => 'Delete Category',
			'categories.delete_message' => 'Are you sure you want to delete this category? All its subcategories will become top-level categories.',
			'categories.empty_state' => 'No categories here! Don\'t let your moolah vanish.',
			'categories.empty_subcategories' => 'No subcategories yet. Tap + to add some!',
			'categories.name' => 'Category Name',
			'categories.name_hint' => 'e.g., Munchies & Grub, Side Hustle...',
			'categories.type' => 'Category Type',
			'categories.color' => 'Category Color',
			'categories.icon' => 'Category Icon',
			'categories.parent' => 'Parent Category',
			'categories.parent_none' => 'None (Top-level)',
			'categories.pro_tip' => 'Pro Tip: Split your outgoings so you don\'t burn through all your dough at once!',
			'categories.success_create' => 'Category created successfully!',
			'categories.success_update' => 'Category updated successfully!',
			'categories.success_delete' => 'Category deleted successfully!',
			'categories.name_required' => 'Please enter a category name',
			'categories.count' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '1 Category', other: '{n} Categories', ), 
			_ => null,
		};
	}
}
