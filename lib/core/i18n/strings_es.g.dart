///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsEs extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsEs({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.es,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <es>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsEs _root = this; // ignore: unused_field

	@override 
	TranslationsEs $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsEs(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAppEs app = _TranslationsAppEs._(_root);
	@override late final _TranslationsSettingsEs settings = _TranslationsSettingsEs._(_root);
	@override Map<String, String> get currencies => {
		'USD': 'Dólar estadounidense',
		'EUR': 'Euro',
		'GBP': 'Libra esterlina',
		'ARS': 'Peso argentino',
		'BRL': 'Real brasileño',
		'MXN': 'Peso mexicano',
		'DOP': 'Peso dominicano',
		'CLP': 'Peso chileno',
		'COP': 'Peso colombiano',
		'PEN': 'Sol peruano',
		'UYU': 'Peso uruguayo',
		'PYG': 'Guaraní paraguayo',
		'BOB': 'Boliviano boliviano',
		'JPY': 'Yen japonés',
		'CNY': 'Yuan chino',
		'CAD': 'Dólar canadiense',
		'AUD': 'Dólar australiano',
		'CHF': 'Franco suizo',
		'INR': 'Rupia india',
		'KRW': 'Won surcoreano',
		'ZAR': 'Rand sudafricano',
	};
	@override late final _TranslationsCommonEs common = _TranslationsCommonEs._(_root);
	@override late final _TranslationsAccountsEs accounts = _TranslationsAccountsEs._(_root);
	@override late final _TranslationsCreateAccountEs create_account = _TranslationsCreateAccountEs._(_root);
	@override late final _TranslationsTransactionsEs transactions = _TranslationsTransactionsEs._(_root);
	@override late final _TranslationsBudgetsEs budgets = _TranslationsBudgetsEs._(_root);
	@override late final _TranslationsSavingsEs savings = _TranslationsSavingsEs._(_root);
	@override late final _TranslationsEditAccountEs edit_account = _TranslationsEditAccountEs._(_root);
	@override late final _TranslationsAccountDetailsEs account_details = _TranslationsAccountDetailsEs._(_root);
	@override late final _TranslationsMyCategoriesEs my_categories = _TranslationsMyCategoriesEs._(_root);
}

// Path: app
class _TranslationsAppEs extends TranslationsAppEn {
	_TranslationsAppEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get name => 'ExpenseLab';
}

// Path: settings
class _TranslationsSettingsEs extends TranslationsSettingsEn {
	_TranslationsSettingsEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Configuración';
	@override late final _TranslationsSettingsThemeEs theme = _TranslationsSettingsThemeEs._(_root);
	@override late final _TranslationsSettingsLanguageEs language = _TranslationsSettingsLanguageEs._(_root);
	@override late final _TranslationsSettingsCurrencyEs currency = _TranslationsSettingsCurrencyEs._(_root);
}

// Path: common
class _TranslationsCommonEs extends TranslationsCommonEn {
	_TranslationsCommonEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get save => 'Guardar';
	@override String get cancel => 'Cancelar';
	@override String get confirm => 'Confirmar';
	@override String get delete => 'Eliminar';
	@override String get edit => 'Editar';
	@override String get close => 'Cerrar';
}

// Path: accounts
class _TranslationsAccountsEs extends TranslationsAccountsEn {
	_TranslationsAccountsEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Mis cuentas';
	@override String get subtitle => 'Tu resumen financiero de un vistazo.';
	@override String get total_net_worth => 'Patrimonio neto total';
	@override String get this_month => 'este mes';
	@override String get asset_accounts => 'Cuentas de activos';
	@override String get liability_accounts => 'Cuentas de pasivos';
	@override String get due_soon => 'Vence pronto';
	@override String get due_in_5_days => 'Vence en 5 días';
	@override String get limit => 'Límite: {limit}';
	@override String get cash_accounts => 'Cuentas de efectivo';
	@override String get bank_accounts => 'Cuentas bancarias';
	@override String get credit_cards => 'Tarjetas de crédito';
}

// Path: create_account
class _TranslationsCreateAccountEs extends TranslationsCreateAccountEn {
	_TranslationsCreateAccountEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Nueva cuenta';
	@override String get icon => 'Icono de cuenta';
	@override String get name => 'Nombre de cuenta';
	@override String get name_hint => 'ej., Ahorros principales';
	@override String get type => 'Tipo de cuenta';
	@override String get type_savings => 'Cuenta bancaria';
	@override String get type_cash => 'Efectivo';
	@override String get type_credit_card => 'Tarjeta de crédito';
	@override String get currency => 'Moneda';
	@override String get select_currency_title => 'Seleccionar moneda';
	@override String get search_currency_hint => 'Buscar código o nombre de moneda...';
	@override String get no_currencies_found => 'No se encontraron monedas';
	@override String get initial_balance => 'Saldo inicial';
	@override String get pro_tip => 'Consejo profesional: Agrupar tus ahorros en cuentas específicas te ayuda a visualizar el progreso hacia metas financieras a largo plazo.';
	@override String get create_button => 'Crear cuenta';
	@override String get name_required => 'Por favor ingresa un nombre de cuenta';
	@override String get balance_invalid => 'Por favor ingresa un saldo válido';
	@override String get success => 'Cuenta creada con éxito';
}

// Path: transactions
class _TranslationsTransactionsEs extends TranslationsTransactionsEn {
	_TranslationsTransactionsEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Transacciones';
}

// Path: budgets
class _TranslationsBudgetsEs extends TranslationsBudgetsEn {
	_TranslationsBudgetsEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Presupuestos';
}

// Path: savings
class _TranslationsSavingsEs extends TranslationsSavingsEn {
	_TranslationsSavingsEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ahorros';
}

// Path: edit_account
class _TranslationsEditAccountEs extends TranslationsEditAccountEn {
	_TranslationsEditAccountEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Editar cuenta';
	@override String get edit_button => 'Editar cuenta';
	@override String get delete_button => 'Eliminar cuenta';
	@override String get delete_title => 'Eliminar cuenta';
	@override String get delete_message => '¿Estás seguro de que deseas eliminar esta cuenta? Esta acción no se puede deshacer.';
	@override String get error_loading => 'Error al cargar la cuenta';
	@override String get success_update => 'Cuenta actualizada con éxito';
	@override String get success_delete => 'Cuenta eliminada con éxito';
}

// Path: account_details
class _TranslationsAccountDetailsEs extends TranslationsAccountDetailsEn {
	_TranslationsAccountDetailsEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Detalles de la cuenta';
	@override String get edit_account => 'Editar cuenta';
	@override String get delete_account => 'Eliminar cuenta';
	@override String get recent_transactions => 'Transacciones recientes';
	@override String get view_all => 'Ver todo';
	@override String get no_transactions => 'No se encontraron transacciones';
	@override String get growth_this_month => '{percentage} este mes';
	@override String get error_loading => 'Error al cargar detalles';
}

// Path: my_categories
class _TranslationsMyCategoriesEs extends TranslationsMyCategoriesEn {
	_TranslationsMyCategoriesEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Mis Categorías';
	@override String get subtitle => 'Lleva al día en qué se te está volando la plata.';
	@override String get expenses => 'Gastos';
	@override String get income => 'Ingresos';
	@override String get category => 'Categoría';
	@override String get subcategory => 'Subcategoría';
	@override String get add_category => 'Añadir Categoría';
	@override String get edit_category => 'Editar Categoría';
	@override String get delete_category => 'Eliminar Categoría';
	@override String get delete_message => '¿Estás seguro de que deseas eliminar esta categoría? Todas sus subcategorías pasarán a ser categorías principales.';
	@override String get empty_state => '¡No hay cajoncitos! No dejes que la lana se te esfume.';
	@override String get empty_subcategories => 'Sin subcategorías aún. ¡Toca + para agregar!';
	@override String get name => 'Nombre de la Categoría';
	@override String get name_hint => 'ej., Tragadera, Tigres...';
	@override String get type => 'Tipo de Categoría';
	@override String get color => 'Color de la Categoría';
	@override String get icon => 'Icono de la Categoría';
	@override String get parent => 'Categoría Padre';
	@override String get parent_none => 'Ninguno (Principal)';
	@override String get pro_tip => 'Consejo: ¡Organiza tu lana en cajonecitos para no gastarte toda la plata de un solo jalón!';
	@override String get success_create => '¡Categoría creada con éxito!';
	@override String get success_update => '¡Categoría actualizada con éxito!';
	@override String get success_delete => '¡Categoría eliminada con éxito!';
	@override String get name_required => 'Por favor ingresa un nombre para la categoría';
}

// Path: settings.theme
class _TranslationsSettingsThemeEs extends TranslationsSettingsThemeEn {
	_TranslationsSettingsThemeEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tema';
	@override String get system => 'Sistema';
	@override String get light => 'Claro';
	@override String get dark => 'Oscuro';
}

// Path: settings.language
class _TranslationsSettingsLanguageEs extends TranslationsSettingsLanguageEn {
	_TranslationsSettingsLanguageEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Idioma';
}

// Path: settings.currency
class _TranslationsSettingsCurrencyEs extends TranslationsSettingsCurrencyEn {
	_TranslationsSettingsCurrencyEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Moneda';
}

/// The flat map containing all translations for locale <es>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEs {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.name' => 'ExpenseLab',
			'settings.title' => 'Configuración',
			'settings.theme.title' => 'Tema',
			'settings.theme.system' => 'Sistema',
			'settings.theme.light' => 'Claro',
			'settings.theme.dark' => 'Oscuro',
			'settings.language.title' => 'Idioma',
			'settings.currency.title' => 'Moneda',
			'currencies.USD' => 'Dólar estadounidense',
			'currencies.EUR' => 'Euro',
			'currencies.GBP' => 'Libra esterlina',
			'currencies.ARS' => 'Peso argentino',
			'currencies.BRL' => 'Real brasileño',
			'currencies.MXN' => 'Peso mexicano',
			'currencies.DOP' => 'Peso dominicano',
			'currencies.CLP' => 'Peso chileno',
			'currencies.COP' => 'Peso colombiano',
			'currencies.PEN' => 'Sol peruano',
			'currencies.UYU' => 'Peso uruguayo',
			'currencies.PYG' => 'Guaraní paraguayo',
			'currencies.BOB' => 'Boliviano boliviano',
			'currencies.JPY' => 'Yen japonés',
			'currencies.CNY' => 'Yuan chino',
			'currencies.CAD' => 'Dólar canadiense',
			'currencies.AUD' => 'Dólar australiano',
			'currencies.CHF' => 'Franco suizo',
			'currencies.INR' => 'Rupia india',
			'currencies.KRW' => 'Won surcoreano',
			'currencies.ZAR' => 'Rand sudafricano',
			'common.save' => 'Guardar',
			'common.cancel' => 'Cancelar',
			'common.confirm' => 'Confirmar',
			'common.delete' => 'Eliminar',
			'common.edit' => 'Editar',
			'common.close' => 'Cerrar',
			'accounts.title' => 'Mis cuentas',
			'accounts.subtitle' => 'Tu resumen financiero de un vistazo.',
			'accounts.total_net_worth' => 'Patrimonio neto total',
			'accounts.this_month' => 'este mes',
			'accounts.asset_accounts' => 'Cuentas de activos',
			'accounts.liability_accounts' => 'Cuentas de pasivos',
			'accounts.due_soon' => 'Vence pronto',
			'accounts.due_in_5_days' => 'Vence en 5 días',
			'accounts.limit' => 'Límite: {limit}',
			'accounts.cash_accounts' => 'Cuentas de efectivo',
			'accounts.bank_accounts' => 'Cuentas bancarias',
			'accounts.credit_cards' => 'Tarjetas de crédito',
			'create_account.title' => 'Nueva cuenta',
			'create_account.icon' => 'Icono de cuenta',
			'create_account.name' => 'Nombre de cuenta',
			'create_account.name_hint' => 'ej., Ahorros principales',
			'create_account.type' => 'Tipo de cuenta',
			'create_account.type_savings' => 'Cuenta bancaria',
			'create_account.type_cash' => 'Efectivo',
			'create_account.type_credit_card' => 'Tarjeta de crédito',
			'create_account.currency' => 'Moneda',
			'create_account.select_currency_title' => 'Seleccionar moneda',
			'create_account.search_currency_hint' => 'Buscar código o nombre de moneda...',
			'create_account.no_currencies_found' => 'No se encontraron monedas',
			'create_account.initial_balance' => 'Saldo inicial',
			'create_account.pro_tip' => 'Consejo profesional: Agrupar tus ahorros en cuentas específicas te ayuda a visualizar el progreso hacia metas financieras a largo plazo.',
			'create_account.create_button' => 'Crear cuenta',
			'create_account.name_required' => 'Por favor ingresa un nombre de cuenta',
			'create_account.balance_invalid' => 'Por favor ingresa un saldo válido',
			'create_account.success' => 'Cuenta creada con éxito',
			'transactions.title' => 'Transacciones',
			'budgets.title' => 'Presupuestos',
			'savings.title' => 'Ahorros',
			'edit_account.title' => 'Editar cuenta',
			'edit_account.edit_button' => 'Editar cuenta',
			'edit_account.delete_button' => 'Eliminar cuenta',
			'edit_account.delete_title' => 'Eliminar cuenta',
			'edit_account.delete_message' => '¿Estás seguro de que deseas eliminar esta cuenta? Esta acción no se puede deshacer.',
			'edit_account.error_loading' => 'Error al cargar la cuenta',
			'edit_account.success_update' => 'Cuenta actualizada con éxito',
			'edit_account.success_delete' => 'Cuenta eliminada con éxito',
			'account_details.title' => 'Detalles de la cuenta',
			'account_details.edit_account' => 'Editar cuenta',
			'account_details.delete_account' => 'Eliminar cuenta',
			'account_details.recent_transactions' => 'Transacciones recientes',
			'account_details.view_all' => 'Ver todo',
			'account_details.no_transactions' => 'No se encontraron transacciones',
			'account_details.growth_this_month' => '{percentage} este mes',
			'account_details.error_loading' => 'Error al cargar detalles',
			'my_categories.title' => 'Mis Categorías',
			'my_categories.subtitle' => 'Lleva al día en qué se te está volando la plata.',
			'my_categories.expenses' => 'Gastos',
			'my_categories.income' => 'Ingresos',
			'my_categories.category' => 'Categoría',
			'my_categories.subcategory' => 'Subcategoría',
			'my_categories.add_category' => 'Añadir Categoría',
			'my_categories.edit_category' => 'Editar Categoría',
			'my_categories.delete_category' => 'Eliminar Categoría',
			'my_categories.delete_message' => '¿Estás seguro de que deseas eliminar esta categoría? Todas sus subcategorías pasarán a ser categorías principales.',
			'my_categories.empty_state' => '¡No hay cajoncitos! No dejes que la lana se te esfume.',
			'my_categories.empty_subcategories' => 'Sin subcategorías aún. ¡Toca + para agregar!',
			'my_categories.name' => 'Nombre de la Categoría',
			'my_categories.name_hint' => 'ej., Tragadera, Tigres...',
			'my_categories.type' => 'Tipo de Categoría',
			'my_categories.color' => 'Color de la Categoría',
			'my_categories.icon' => 'Icono de la Categoría',
			'my_categories.parent' => 'Categoría Padre',
			'my_categories.parent_none' => 'Ninguno (Principal)',
			'my_categories.pro_tip' => 'Consejo: ¡Organiza tu lana en cajonecitos para no gastarte toda la plata de un solo jalón!',
			'my_categories.success_create' => '¡Categoría creada con éxito!',
			'my_categories.success_update' => '¡Categoría actualizada con éxito!',
			'my_categories.success_delete' => '¡Categoría eliminada con éxito!',
			'my_categories.name_required' => 'Por favor ingresa un nombre para la categoría',
			_ => null,
		};
	}
}
