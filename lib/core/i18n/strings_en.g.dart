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
	late final TranslationsCommonEn common = TranslationsCommonEn.internal(_root);
	late final TranslationsAccountsEn accounts = TranslationsAccountsEn.internal(_root);
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
	String get net_worth => 'Total Net Worth';

	/// en: '{percent} this month'
	String get monthly_change => '{percent} this month';

	/// en: 'Asset Accounts'
	String get asset_accounts => 'Asset Accounts';

	/// en: 'Checking'
	String get checking => 'Checking';

	/// en: 'Main Spending Account'
	String get checking_subtitle => 'Main Spending Account';

	/// en: 'Savings'
	String get savings => 'Savings';

	/// en: 'Emergency Fund'
	String get savings_subtitle => 'Emergency Fund';
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
			'common.save' => 'Save',
			'common.cancel' => 'Cancel',
			'common.confirm' => 'Confirm',
			'common.delete' => 'Delete',
			'common.edit' => 'Edit',
			'common.close' => 'Close',
			'accounts.title' => 'My Accounts',
			'accounts.subtitle' => 'Your financial overview at a glance.',
			'accounts.net_worth' => 'Total Net Worth',
			'accounts.monthly_change' => '{percent} this month',
			'accounts.asset_accounts' => 'Asset Accounts',
			'accounts.checking' => 'Checking',
			'accounts.checking_subtitle' => 'Main Spending Account',
			'accounts.savings' => 'Savings',
			'accounts.savings_subtitle' => 'Emergency Fund',
			'transactions.title' => 'Transactions',
			'budgets.title' => 'Budgets',
			'savings.title' => 'Savings',
			_ => null,
		};
	}
}
