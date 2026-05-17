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
	late final TranslationsCommonEn common = TranslationsCommonEn.internal(_root);
	late final TranslationsAccountsEn accounts = TranslationsAccountsEn.internal(_root);
	late final TranslationsCreateAccountEn create_account = TranslationsCreateAccountEn.internal(_root);
	late final TranslationsTransactionsEn transactions = TranslationsTransactionsEn.internal(_root);
	late final TranslationsBudgetsEn budgets = TranslationsBudgetsEn.internal(_root);
	late final TranslationsSavingsEn savings = TranslationsSavingsEn.internal(_root);
}

// Path: app
class TranslationsAppEn {
	TranslationsAppEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'ExpenseLab'
	String get name => 'ExpenseLab';
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
}

// Path: create_account
class TranslationsCreateAccountEn {
	TranslationsCreateAccountEn.internal(this._root);

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

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.name' => 'ExpenseLab',
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
			'common.save' => 'Save',
			'common.cancel' => 'Cancel',
			'common.confirm' => 'Confirm',
			'common.delete' => 'Delete',
			'common.edit' => 'Edit',
			'common.close' => 'Close',
			'accounts.title' => 'My Accounts',
			'accounts.subtitle' => 'Your financial overview at a glance.',
			'accounts.total_net_worth' => 'Total Net Worth',
			'create_account.title' => 'New Account',
			'create_account.icon' => 'Account Icon',
			'create_account.name' => 'Account Name',
			'create_account.name_hint' => 'e.g., Main Savings',
			'create_account.type' => 'Account Type',
			'create_account.type_savings' => 'Bank Account',
			'create_account.type_cash' => 'Cash',
			'create_account.type_credit_card' => 'Credit Card',
			'create_account.currency' => 'Currency',
			'create_account.select_currency_title' => 'Select Currency',
			'create_account.search_currency_hint' => 'Search currency code or name...',
			'create_account.no_currencies_found' => 'No currencies found',
			'create_account.initial_balance' => 'Initial Balance',
			'create_account.pro_tip' => 'Pro Tip: Grouping your savings into specific accounts helps you visualize progress toward long-term financial goals.',
			'create_account.create_button' => 'Create Account',
			'create_account.name_required' => 'Please enter an account name',
			'create_account.balance_invalid' => 'Please enter a valid balance',
			'create_account.success' => 'Account created successfully',
			'transactions.title' => 'Transactions',
			'budgets.title' => 'Budgets',
			'savings.title' => 'Savings',
			_ => null,
		};
	}
}
