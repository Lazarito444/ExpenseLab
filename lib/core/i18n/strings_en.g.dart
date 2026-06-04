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
	late final TranslationsHomeEn home = TranslationsHomeEn.internal(_root);
	late final TranslationsNavEn nav = TranslationsNavEn.internal(_root);
	late final TranslationsSettingsEn settings = TranslationsSettingsEn.internal(_root);
	late final TranslationsGoalsEn goals = TranslationsGoalsEn.internal(_root);
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

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Error'
	String get error => 'Error';

	/// en: 'See All'
	String get see_all => 'See All';

	/// en: 'Preview'
	String get preview => 'Preview';

	/// en: 'Yesterday'
	String get yesterday => 'Yesterday';
}

// Path: home
class TranslationsHomeEn {
	TranslationsHomeEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'TOTAL BALANCE'
	String get total_balance => 'TOTAL BALANCE';

	/// en: 'Monthly Summary'
	String get monthly_summary => 'Monthly Summary';

	/// en: 'Income'
	String get income => 'Income';

	/// en: 'Expenses'
	String get expenses => 'Expenses';

	/// en: 'SAVINGS RATE'
	String get savings_rate => 'SAVINGS RATE';

	/// en: 'Recent Transactions'
	String get recent_transactions => 'Recent Transactions';

	/// en: 'View All'
	String get view_all => 'View All';

	/// en: 'No transactions yet'
	String get no_transactions => 'No transactions yet';

	/// en: '{pct} this month'
	String get pct_this_month => '{pct} this month';

	/// en: 'No transactions on this day'
	String get no_transactions_day => 'No transactions on this day';

	/// en: 'Add a transaction on this day'
	String get add_transaction_on_day => 'Add a transaction on this day';

	/// en: 'FINANCIAL SCHEDULE'
	String get financial_schedule => 'FINANCIAL SCHEDULE';

	/// en: 'Transactions – {date}'
	String get transactions_for => 'Transactions – {date}';
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

	/// en: 'Preferences'
	String get preferences => 'Preferences';

	/// en: 'App'
	String get app => 'App';

	late final TranslationsSettingsThemeEn theme = TranslationsSettingsThemeEn.internal(_root);
	late final TranslationsSettingsLanguageEn language = TranslationsSettingsLanguageEn.internal(_root);
	late final TranslationsSettingsDefaultCurrencyEn default_currency = TranslationsSettingsDefaultCurrencyEn.internal(_root);
	late final TranslationsSettingsDefaultHomeViewEn default_home_view = TranslationsSettingsDefaultHomeViewEn.internal(_root);
	late final TranslationsSettingsAccountsEn accounts = TranslationsSettingsAccountsEn.internal(_root);
	late final TranslationsSettingsCategoriesEn categories = TranslationsSettingsCategoriesEn.internal(_root);
}

// Path: goals
class TranslationsGoalsEn {
	TranslationsGoalsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Savings Goals'
	String get title => 'Savings Goals';

	/// en: 'Your progress toward financial freedom'
	String get subtitle => 'Your progress toward financial freedom';

	/// en: 'TOTAL SAVED'
	String get total_saved => 'TOTAL SAVED';

	/// en: '{pct}% of total target reached'
	String get target_reached => '{pct}% of total target reached';

	/// en: 'No savings goals yet'
	String get no_goals => 'No savings goals yet';

	/// en: 'Tap + to create your first goal'
	String get no_goals_subtitle => 'Tap + to create your first goal';

	/// en: 'View Details'
	String get view_details => 'View Details';

	/// en: '{amount} saved'
	String get saved => '{amount} saved';

	/// en: 'Target: {amount}'
	String get target => 'Target: {amount}';

	late final TranslationsGoalsCreateEn create = TranslationsGoalsCreateEn.internal(_root);
	late final TranslationsGoalsEditEn edit = TranslationsGoalsEditEn.internal(_root);
	late final TranslationsGoalsDetailsEn details = TranslationsGoalsDetailsEn.internal(_root);
	late final TranslationsGoalsContributionEn contribution = TranslationsGoalsContributionEn.internal(_root);
}

// Path: accounts
class TranslationsAccountsEn {
	TranslationsAccountsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'My Accounts'
	String get title => 'My Accounts';

	/// en: 'No accounts yet. Add one to get started!'
	String get empty_state => 'No accounts yet. Add one to get started!';

	/// en: 'Total Net Worth'
	String get total_net_worth => 'Total Net Worth';

	/// en: 'this month'
	String get this_month => 'this month';

	/// en: 'Cash Accounts'
	String get cash_accounts => 'Cash Accounts';

	/// en: 'Bank Accounts'
	String get bank_accounts => 'Bank Accounts';

	/// en: 'Credit Cards'
	String get credit_cards => 'Credit Cards';

	/// en: '{percentage} this month'
	String get monthly_change => '{percentage} this month';

	late final TranslationsAccountsCreateEn create = TranslationsAccountsCreateEn.internal(_root);
	late final TranslationsAccountsEditEn edit = TranslationsAccountsEditEn.internal(_root);
}

// Path: transactions
class TranslationsTransactionsEn {
	TranslationsTransactionsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add Transaction'
	String get add_title => 'Add Transaction';

	/// en: 'Edit Transaction'
	String get edit_title => 'Edit Transaction';

	/// en: 'ENTER AMOUNT'
	String get enter_amount => 'ENTER AMOUNT';

	/// en: 'Expense'
	String get tab_expense => 'Expense';

	/// en: 'Income'
	String get tab_income => 'Income';

	/// en: 'Transfer'
	String get tab_transfer => 'Transfer';

	/// en: 'CATEGORY'
	String get category => 'CATEGORY';

	/// en: 'Pick a vibe'
	String get no_category => 'Pick a vibe';

	/// en: 'ACCOUNT'
	String get account => 'ACCOUNT';

	/// en: 'Which wallet?'
	String get no_account => 'Which wallet?';

	/// en: 'TO ACCOUNT'
	String get to_account => 'TO ACCOUNT';

	/// en: 'Send it where?'
	String get no_to_account => 'Send it where?';

	/// en: 'DATE & TIME'
	String get date_time => 'DATE & TIME';

	/// en: 'NOTES'
	String get notes => 'NOTES';

	/// en: 'What was this for?'
	String get notes_hint => 'What was this for?';

	/// en: 'ATTACHMENTS'
	String get attachments => 'ATTACHMENTS';

	/// en: 'Snap or upload a receipt'
	String get attachments_hint => 'Snap or upload a receipt';

	/// en: 'Save Transaction'
	String get save_button => 'Save Transaction';

	/// en: 'Toss in an amount first!'
	String get amount_required => 'Toss in an amount first!';

	/// en: 'Pick a category first!'
	String get category_required => 'Pick a category first!';

	/// en: 'Choose an account to drop it in'
	String get account_required => 'Choose an account to drop it in';

	/// en: 'Transaction dropped!'
	String get success => 'Transaction dropped!';

	/// en: 'Pick Your Category'
	String get select_category => 'Pick Your Category';

	/// en: 'Which Account?'
	String get select_account => 'Which Account?';

	/// en: 'Where's It Going?'
	String get select_to_account => 'Where\'s It Going?';
}

// Path: categories
class TranslationsCategoriesEn {
	TranslationsCategoriesEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'My Categories'
	String get title => 'My Categories';

	/// en: 'Expenses'
	String get expenses => 'Expenses';

	/// en: 'Income'
	String get income => 'Income';

	/// en: 'Category'
	String get category => 'Category';

	/// en: 'Subcategory'
	String get subcategory => 'Subcategory';

	/// en: 'Subcategories'
	String get subcategories => 'Subcategories';

	/// en: 'Add Category'
	String get add_category => 'Add Category';

	/// en: 'Edit Category'
	String get edit_category => 'Edit Category';

	/// en: 'Delete Category'
	String get delete_category => 'Delete Category';

	/// en: 'Are you sure you want to delete this category? All its subcategories will become top-level categories.'
	String get delete_message => 'Are you sure you want to delete this category? All its subcategories will become top-level categories.';

	/// en: 'No categories here! Try to create one!'
	String get empty_state => 'No categories here! Try to create one!';

	/// en: 'No subcategories yet.'
	String get empty_subcategories => 'No subcategories yet.';

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

	/// en: 'Category created successfully!'
	String get success_create => 'Category created successfully!';

	/// en: 'Category updated successfully!'
	String get success_update => 'Category updated successfully!';

	/// en: 'Category deleted successfully!'
	String get success_delete => 'Category deleted successfully!';

	/// en: 'Please enter a category name'
	String get name_required => 'Please enter a category name';

	/// en: 'Total Monthly Spend'
	String get total_monthly_spend => 'Total Monthly Spend';

	/// en: 'Total Monthly Income'
	String get total_monthly_income => 'Total Monthly Income';

	/// en: '(one) {1 Category} (other) {$n Categories}'
	String count({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '1 Category',
		other: '${n} Categories',
	);

	/// en: '(zero) {No subcategories} (one) {1 subcategory} (other) {$n subcategories}'
	String subcategory_count({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		zero: 'No subcategories',
		one: '1 subcategory',
		other: '${n} subcategories',
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

// Path: settings.default_currency
class TranslationsSettingsDefaultCurrencyEn {
	TranslationsSettingsDefaultCurrencyEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Default Currency'
	String get title => 'Default Currency';
}

// Path: settings.default_home_view
class TranslationsSettingsDefaultHomeViewEn {
	TranslationsSettingsDefaultHomeViewEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Default Home View'
	String get title => 'Default Home View';

	/// en: 'Dashboard'
	String get dashboard => 'Dashboard';

	/// en: 'Calendar'
	String get calendar => 'Calendar';
}

// Path: settings.accounts
class TranslationsSettingsAccountsEn {
	TranslationsSettingsAccountsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Accounts'
	String get title => 'Accounts';
}

// Path: settings.categories
class TranslationsSettingsCategoriesEn {
	TranslationsSettingsCategoriesEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Categories'
	String get title => 'Categories';
}

// Path: goals.create
class TranslationsGoalsCreateEn {
	TranslationsGoalsCreateEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'New Goal'
	String get title => 'New Goal';

	/// en: 'Goal Name'
	String get name => 'Goal Name';

	/// en: 'e.g., Dream Vacation'
	String get name_hint => 'e.g., Dream Vacation';

	/// en: 'Target Amount'
	String get target_amount => 'Target Amount';

	/// en: 'Target Date (Optional)'
	String get target_date => 'Target Date (Optional)';

	/// en: 'Source Account'
	String get source_account => 'Source Account';

	/// en: 'Select an account'
	String get select_account => 'Select an account';

	/// en: 'Create Goal'
	String get create_button => 'Create Goal';

	/// en: 'Please enter a goal name'
	String get name_required => 'Please enter a goal name';

	/// en: 'Please enter a target amount'
	String get amount_required => 'Please enter a target amount';

	/// en: 'Please enter a valid amount'
	String get amount_invalid => 'Please enter a valid amount';

	/// en: 'Please select a source account'
	String get account_required => 'Please select a source account';

	/// en: 'Goal created successfully'
	String get success => 'Goal created successfully';
}

// Path: goals.edit
class TranslationsGoalsEditEn {
	TranslationsGoalsEditEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Edit Goal'
	String get title => 'Edit Goal';

	/// en: 'Associated Account'
	String get associated_account => 'Associated Account';

	/// en: 'Save Changes'
	String get save_button => 'Save Changes';

	/// en: 'Delete Goal'
	String get delete_button => 'Delete Goal';

	/// en: 'Delete Goal'
	String get delete_title => 'Delete Goal';

	/// en: 'Are you sure you want to delete this goal? This action cannot be undone.'
	String get delete_message => 'Are you sure you want to delete this goal? This action cannot be undone.';

	/// en: 'Error loading goal'
	String get error_loading => 'Error loading goal';

	/// en: 'Goal updated successfully'
	String get success_update => 'Goal updated successfully';

	/// en: 'Goal deleted successfully'
	String get success_delete => 'Goal deleted successfully';
}

// Path: goals.details
class TranslationsGoalsDetailsEn {
	TranslationsGoalsDetailsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'TOTAL SAVED'
	String get saved_label => 'TOTAL SAVED';

	/// en: 'TARGET'
	String get target_label => 'TARGET';

	/// en: 'Deadline: {date}'
	String get deadline => 'Deadline: {date}';

	/// en: 'No deadline set'
	String get no_deadline => 'No deadline set';

	/// en: 'Contributions'
	String get contributions_title => 'Contributions';

	/// en: 'No contributions yet'
	String get no_contributions => 'No contributions yet';

	/// en: 'Tap + to log your first contribution'
	String get no_contributions_subtitle => 'Tap + to log your first contribution';

	/// en: 'Contribution'
	String get contribution_label => 'Contribution';
}

// Path: goals.contribution
class TranslationsGoalsContributionEn {
	TranslationsGoalsContributionEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add Contribution'
	String get add_title => 'Add Contribution';

	/// en: 'Amount'
	String get amount => 'Amount';

	/// en: 'Date'
	String get date => 'Date';

	/// en: 'Note (Optional)'
	String get note => 'Note (Optional)';

	/// en: 'What's this for?'
	String get note_hint => 'What\'s this for?';

	/// en: 'Save Contribution'
	String get save_button => 'Save Contribution';

	/// en: 'Please enter an amount'
	String get amount_required => 'Please enter an amount';

	/// en: 'Please enter a valid amount'
	String get amount_invalid => 'Please enter a valid amount';

	/// en: 'Contribution added'
	String get success => 'Contribution added';
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

	/// en: 'Initial Balance'
	String get initial_balance => 'Initial Balance';

	/// en: 'Pro Tip'
	String get pro_tip_label => 'Pro Tip';

	/// en: 'Grouping your savings into specific accounts helps you visualize progress toward long-term financial goals.'
	String get pro_tip => 'Grouping your savings into specific accounts helps you visualize progress toward long-term financial goals.';

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
			'common.delete' => 'Delete',
			'common.error' => 'Error',
			'common.see_all' => 'See All',
			'common.preview' => 'Preview',
			'common.yesterday' => 'Yesterday',
			'home.total_balance' => 'TOTAL BALANCE',
			'home.monthly_summary' => 'Monthly Summary',
			'home.income' => 'Income',
			'home.expenses' => 'Expenses',
			'home.savings_rate' => 'SAVINGS RATE',
			'home.recent_transactions' => 'Recent Transactions',
			'home.view_all' => 'View All',
			'home.no_transactions' => 'No transactions yet',
			'home.pct_this_month' => '{pct} this month',
			'home.no_transactions_day' => 'No transactions on this day',
			'home.add_transaction_on_day' => 'Add a transaction on this day',
			'home.financial_schedule' => 'FINANCIAL SCHEDULE',
			'home.transactions_for' => 'Transactions – {date}',
			'nav.home' => 'Home',
			'nav.budgets' => 'Budgets',
			'nav.goals' => 'Goals',
			'nav.settings' => 'Settings',
			'settings.title' => 'Settings',
			'settings.preferences' => 'Preferences',
			'settings.app' => 'App',
			'settings.theme.title' => 'Theme',
			'settings.theme.system' => 'System',
			'settings.theme.light' => 'Light',
			'settings.theme.dark' => 'Dark',
			'settings.language.title' => 'Language',
			'settings.default_currency.title' => 'Default Currency',
			'settings.default_home_view.title' => 'Default Home View',
			'settings.default_home_view.dashboard' => 'Dashboard',
			'settings.default_home_view.calendar' => 'Calendar',
			'settings.accounts.title' => 'Accounts',
			'settings.categories.title' => 'Categories',
			'goals.title' => 'Savings Goals',
			'goals.subtitle' => 'Your progress toward financial freedom',
			'goals.total_saved' => 'TOTAL SAVED',
			'goals.target_reached' => '{pct}% of total target reached',
			'goals.no_goals' => 'No savings goals yet',
			'goals.no_goals_subtitle' => 'Tap + to create your first goal',
			'goals.view_details' => 'View Details',
			'goals.saved' => '{amount} saved',
			'goals.target' => 'Target: {amount}',
			'goals.create.title' => 'New Goal',
			'goals.create.name' => 'Goal Name',
			'goals.create.name_hint' => 'e.g., Dream Vacation',
			'goals.create.target_amount' => 'Target Amount',
			'goals.create.target_date' => 'Target Date (Optional)',
			'goals.create.source_account' => 'Source Account',
			'goals.create.select_account' => 'Select an account',
			'goals.create.create_button' => 'Create Goal',
			'goals.create.name_required' => 'Please enter a goal name',
			'goals.create.amount_required' => 'Please enter a target amount',
			'goals.create.amount_invalid' => 'Please enter a valid amount',
			'goals.create.account_required' => 'Please select a source account',
			'goals.create.success' => 'Goal created successfully',
			'goals.edit.title' => 'Edit Goal',
			'goals.edit.associated_account' => 'Associated Account',
			'goals.edit.save_button' => 'Save Changes',
			'goals.edit.delete_button' => 'Delete Goal',
			'goals.edit.delete_title' => 'Delete Goal',
			'goals.edit.delete_message' => 'Are you sure you want to delete this goal? This action cannot be undone.',
			'goals.edit.error_loading' => 'Error loading goal',
			'goals.edit.success_update' => 'Goal updated successfully',
			'goals.edit.success_delete' => 'Goal deleted successfully',
			'goals.details.saved_label' => 'TOTAL SAVED',
			'goals.details.target_label' => 'TARGET',
			'goals.details.deadline' => 'Deadline: {date}',
			'goals.details.no_deadline' => 'No deadline set',
			'goals.details.contributions_title' => 'Contributions',
			'goals.details.no_contributions' => 'No contributions yet',
			'goals.details.no_contributions_subtitle' => 'Tap + to log your first contribution',
			'goals.details.contribution_label' => 'Contribution',
			'goals.contribution.add_title' => 'Add Contribution',
			'goals.contribution.amount' => 'Amount',
			'goals.contribution.date' => 'Date',
			'goals.contribution.note' => 'Note (Optional)',
			'goals.contribution.note_hint' => 'What\'s this for?',
			'goals.contribution.save_button' => 'Save Contribution',
			'goals.contribution.amount_required' => 'Please enter an amount',
			'goals.contribution.amount_invalid' => 'Please enter a valid amount',
			'goals.contribution.success' => 'Contribution added',
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
			'accounts.empty_state' => 'No accounts yet. Add one to get started!',
			'accounts.total_net_worth' => 'Total Net Worth',
			'accounts.this_month' => 'this month',
			'accounts.cash_accounts' => 'Cash Accounts',
			'accounts.bank_accounts' => 'Bank Accounts',
			'accounts.credit_cards' => 'Credit Cards',
			'accounts.monthly_change' => '{percentage} this month',
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
			'accounts.create.initial_balance' => 'Initial Balance',
			'accounts.create.pro_tip_label' => 'Pro Tip',
			'accounts.create.pro_tip' => 'Grouping your savings into specific accounts helps you visualize progress toward long-term financial goals.',
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
			'transactions.add_title' => 'Add Transaction',
			'transactions.edit_title' => 'Edit Transaction',
			'transactions.enter_amount' => 'ENTER AMOUNT',
			'transactions.tab_expense' => 'Expense',
			'transactions.tab_income' => 'Income',
			'transactions.tab_transfer' => 'Transfer',
			'transactions.category' => 'CATEGORY',
			'transactions.no_category' => 'Pick a vibe',
			'transactions.account' => 'ACCOUNT',
			'transactions.no_account' => 'Which wallet?',
			'transactions.to_account' => 'TO ACCOUNT',
			'transactions.no_to_account' => 'Send it where?',
			'transactions.date_time' => 'DATE & TIME',
			'transactions.notes' => 'NOTES',
			'transactions.notes_hint' => 'What was this for?',
			'transactions.attachments' => 'ATTACHMENTS',
			'transactions.attachments_hint' => 'Snap or upload a receipt',
			'transactions.save_button' => 'Save Transaction',
			'transactions.amount_required' => 'Toss in an amount first!',
			'transactions.category_required' => 'Pick a category first!',
			'transactions.account_required' => 'Choose an account to drop it in',
			'transactions.success' => 'Transaction dropped!',
			'transactions.select_category' => 'Pick Your Category',
			'transactions.select_account' => 'Which Account?',
			'transactions.select_to_account' => 'Where\'s It Going?',
			'categories.title' => 'My Categories',
			'categories.expenses' => 'Expenses',
			'categories.income' => 'Income',
			'categories.category' => 'Category',
			'categories.subcategory' => 'Subcategory',
			'categories.subcategories' => 'Subcategories',
			'categories.add_category' => 'Add Category',
			'categories.edit_category' => 'Edit Category',
			'categories.delete_category' => 'Delete Category',
			'categories.delete_message' => 'Are you sure you want to delete this category? All its subcategories will become top-level categories.',
			'categories.empty_state' => 'No categories here! Try to create one!',
			'categories.empty_subcategories' => 'No subcategories yet.',
			'categories.name' => 'Category Name',
			'categories.name_hint' => 'e.g., Munchies & Grub, Side Hustle...',
			'categories.type' => 'Category Type',
			'categories.color' => 'Category Color',
			'categories.icon' => 'Category Icon',
			'categories.parent' => 'Parent Category',
			'categories.parent_none' => 'None (Top-level)',
			'categories.success_create' => 'Category created successfully!',
			'categories.success_update' => 'Category updated successfully!',
			'categories.success_delete' => 'Category deleted successfully!',
			'categories.name_required' => 'Please enter a category name',
			'categories.total_monthly_spend' => 'Total Monthly Spend',
			'categories.total_monthly_income' => 'Total Monthly Income',
			'categories.count' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '1 Category', other: '${n} Categories', ), 
			'categories.subcategory_count' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, zero: 'No subcategories', one: '1 subcategory', other: '${n} subcategories', ), 
			_ => null,
		};
	}
}
