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
	@override late final _TranslationsCommonEs common = _TranslationsCommonEs._(_root);
	@override late final _TranslationsNavEs nav = _TranslationsNavEs._(_root);
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
	@override late final _TranslationsAccountsEs accounts = _TranslationsAccountsEs._(_root);
	@override late final _TranslationsCategoriesEs categories = _TranslationsCategoriesEs._(_root);
}

// Path: app
class _TranslationsAppEs extends TranslationsAppEn {
	_TranslationsAppEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get name => 'ExpenseLab';
}

// Path: common
class _TranslationsCommonEs extends TranslationsCommonEn {
	_TranslationsCommonEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get save => 'Guardar';
	@override String get cancel => 'Cancelar';
	@override String get delete => 'Eliminar';
	@override String get error => 'Error';
	@override String get see_all => 'Ver Todo';
	@override String get preview => 'Vista Previa';
}

// Path: nav
class _TranslationsNavEs extends TranslationsNavEn {
	_TranslationsNavEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get home => 'Inicio';
	@override String get budgets => 'Presupuestos';
	@override String get goals => 'Metas';
	@override String get settings => 'Ajustes';
}

// Path: settings
class _TranslationsSettingsEs extends TranslationsSettingsEn {
	_TranslationsSettingsEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Configuración';
	@override String get preferences => 'Preferencias';
	@override String get app => 'App';
	@override late final _TranslationsSettingsThemeEs theme = _TranslationsSettingsThemeEs._(_root);
	@override late final _TranslationsSettingsLanguageEs language = _TranslationsSettingsLanguageEs._(_root);
	@override late final _TranslationsSettingsAccountsEs accounts = _TranslationsSettingsAccountsEs._(_root);
	@override late final _TranslationsSettingsCategoriesEs categories = _TranslationsSettingsCategoriesEs._(_root);
}

// Path: accounts
class _TranslationsAccountsEs extends TranslationsAccountsEn {
	_TranslationsAccountsEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Mis cuentas';
	@override String get empty_state => '¡Sin cuentas aún. Agrega una para comenzar!';
	@override String get total_net_worth => 'Patrimonio neto total';
	@override String get this_month => 'este mes';
	@override String get cash_accounts => 'Cuentas de efectivo';
	@override String get bank_accounts => 'Cuentas bancarias';
	@override String get credit_cards => 'Tarjetas de crédito';
	@override String get monthly_change => '{percentage} este mes';
	@override late final _TranslationsAccountsCreateEs create = _TranslationsAccountsCreateEs._(_root);
	@override late final _TranslationsAccountsEditEs edit = _TranslationsAccountsEditEs._(_root);
}

// Path: categories
class _TranslationsCategoriesEs extends TranslationsCategoriesEn {
	_TranslationsCategoriesEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Mis Categorías';
	@override String get expenses => 'Gastos';
	@override String get income => 'Ingresos';
	@override String get category => 'Categoría';
	@override String get subcategory => 'Subcategoría';
	@override String get subcategories => 'Subcategorías';
	@override String get add_category => 'Añadir Categoría';
	@override String get edit_category => 'Editar Categoría';
	@override String get delete_category => 'Eliminar Categoría';
	@override String get delete_message => '¿Estás seguro de que deseas eliminar esta categoría? Todas sus subcategorías pasarán a ser categorías principales.';
	@override String get empty_state => '¡No hay categorías! Intenta agregar una.';
	@override String get empty_subcategories => 'Sin subcategorías aún.';
	@override String get name => 'Nombre de la Categoría';
	@override String get name_hint => 'ej., Tragadera, Tigres...';
	@override String get type => 'Tipo de Categoría';
	@override String get color => 'Color de la Categoría';
	@override String get icon => 'Icono de la Categoría';
	@override String get parent => 'Categoría Padre';
	@override String get parent_none => 'Ninguno (Principal)';
	@override String get success_create => '¡Categoría creada con éxito!';
	@override String get success_update => '¡Categoría actualizada con éxito!';
	@override String get success_delete => '¡Categoría eliminada con éxito!';
	@override String get name_required => 'Por favor ingresa un nombre para la categoría';
	@override String get total_monthly_spend => 'Gasto total del mes';
	@override String get total_monthly_income => 'Ingreso total del mes';
	@override String count({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n,
		one: '1 Categoría',
		other: '${n} Categorías',
	);
	@override String subcategory_count({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n,
		zero: 'Sin subcategorías',
		one: '1 subcategoría',
		other: '${n} subcategorías',
	);
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

// Path: settings.accounts
class _TranslationsSettingsAccountsEs extends TranslationsSettingsAccountsEn {
	_TranslationsSettingsAccountsEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Cuentas';
}

// Path: settings.categories
class _TranslationsSettingsCategoriesEs extends TranslationsSettingsCategoriesEn {
	_TranslationsSettingsCategoriesEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Categorías';
}

// Path: accounts.create
class _TranslationsAccountsCreateEs extends TranslationsAccountsCreateEn {
	_TranslationsAccountsCreateEs._(TranslationsEs root) : this._root = root, super.internal(root);

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
	@override String get initial_balance => 'Saldo inicial';
	@override String get pro_tip_label => 'Consejo profesional';
	@override String get pro_tip => 'Agrupar tus ahorros en cuentas específicas te ayuda a visualizar el progreso hacia metas financieras a largo plazo.';
	@override String get create_button => 'Crear cuenta';
	@override String get name_required => 'Por favor ingresa un nombre de cuenta';
	@override String get balance_invalid => 'Por favor ingresa un saldo válido';
	@override String get success => 'Cuenta creada con éxito';
}

// Path: accounts.edit
class _TranslationsAccountsEditEs extends TranslationsAccountsEditEn {
	_TranslationsAccountsEditEs._(TranslationsEs root) : this._root = root, super.internal(root);

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

/// The flat map containing all translations for locale <es>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEs {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.name' => 'ExpenseLab',
			'common.save' => 'Guardar',
			'common.cancel' => 'Cancelar',
			'common.delete' => 'Eliminar',
			'common.error' => 'Error',
			'common.see_all' => 'Ver Todo',
			'common.preview' => 'Vista Previa',
			'nav.home' => 'Inicio',
			'nav.budgets' => 'Presupuestos',
			'nav.goals' => 'Metas',
			'nav.settings' => 'Ajustes',
			'settings.title' => 'Configuración',
			'settings.preferences' => 'Preferencias',
			'settings.app' => 'App',
			'settings.theme.title' => 'Tema',
			'settings.theme.system' => 'Sistema',
			'settings.theme.light' => 'Claro',
			'settings.theme.dark' => 'Oscuro',
			'settings.language.title' => 'Idioma',
			'settings.accounts.title' => 'Cuentas',
			'settings.categories.title' => 'Categorías',
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
			'accounts.title' => 'Mis cuentas',
			'accounts.empty_state' => '¡Sin cuentas aún. Agrega una para comenzar!',
			'accounts.total_net_worth' => 'Patrimonio neto total',
			'accounts.this_month' => 'este mes',
			'accounts.cash_accounts' => 'Cuentas de efectivo',
			'accounts.bank_accounts' => 'Cuentas bancarias',
			'accounts.credit_cards' => 'Tarjetas de crédito',
			'accounts.monthly_change' => '{percentage} este mes',
			'accounts.create.title' => 'Nueva cuenta',
			'accounts.create.icon' => 'Icono de cuenta',
			'accounts.create.name' => 'Nombre de cuenta',
			'accounts.create.name_hint' => 'ej., Ahorros principales',
			'accounts.create.type' => 'Tipo de cuenta',
			'accounts.create.type_savings' => 'Cuenta bancaria',
			'accounts.create.type_cash' => 'Efectivo',
			'accounts.create.type_credit_card' => 'Tarjeta de crédito',
			'accounts.create.currency' => 'Moneda',
			'accounts.create.select_currency_title' => 'Seleccionar moneda',
			'accounts.create.initial_balance' => 'Saldo inicial',
			'accounts.create.pro_tip_label' => 'Consejo profesional',
			'accounts.create.pro_tip' => 'Agrupar tus ahorros en cuentas específicas te ayuda a visualizar el progreso hacia metas financieras a largo plazo.',
			'accounts.create.create_button' => 'Crear cuenta',
			'accounts.create.name_required' => 'Por favor ingresa un nombre de cuenta',
			'accounts.create.balance_invalid' => 'Por favor ingresa un saldo válido',
			'accounts.create.success' => 'Cuenta creada con éxito',
			'accounts.edit.title' => 'Editar cuenta',
			'accounts.edit.edit_button' => 'Editar cuenta',
			'accounts.edit.delete_button' => 'Eliminar cuenta',
			'accounts.edit.delete_title' => 'Eliminar cuenta',
			'accounts.edit.delete_message' => '¿Estás seguro de que deseas eliminar esta cuenta? Esta acción no se puede deshacer.',
			'accounts.edit.error_loading' => 'Error al cargar la cuenta',
			'accounts.edit.success_update' => 'Cuenta actualizada con éxito',
			'accounts.edit.success_delete' => 'Cuenta eliminada con éxito',
			'categories.title' => 'Mis Categorías',
			'categories.expenses' => 'Gastos',
			'categories.income' => 'Ingresos',
			'categories.category' => 'Categoría',
			'categories.subcategory' => 'Subcategoría',
			'categories.subcategories' => 'Subcategorías',
			'categories.add_category' => 'Añadir Categoría',
			'categories.edit_category' => 'Editar Categoría',
			'categories.delete_category' => 'Eliminar Categoría',
			'categories.delete_message' => '¿Estás seguro de que deseas eliminar esta categoría? Todas sus subcategorías pasarán a ser categorías principales.',
			'categories.empty_state' => '¡No hay categorías! Intenta agregar una.',
			'categories.empty_subcategories' => 'Sin subcategorías aún.',
			'categories.name' => 'Nombre de la Categoría',
			'categories.name_hint' => 'ej., Tragadera, Tigres...',
			'categories.type' => 'Tipo de Categoría',
			'categories.color' => 'Color de la Categoría',
			'categories.icon' => 'Icono de la Categoría',
			'categories.parent' => 'Categoría Padre',
			'categories.parent_none' => 'Ninguno (Principal)',
			'categories.success_create' => '¡Categoría creada con éxito!',
			'categories.success_update' => '¡Categoría actualizada con éxito!',
			'categories.success_delete' => '¡Categoría eliminada con éxito!',
			'categories.name_required' => 'Por favor ingresa un nombre para la categoría',
			'categories.total_monthly_spend' => 'Gasto total del mes',
			'categories.total_monthly_income' => 'Ingreso total del mes',
			'categories.count' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n, one: '1 Categoría', other: '${n} Categorías', ), 
			'categories.subcategory_count' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n, zero: 'Sin subcategorías', one: '1 subcategoría', other: '${n} subcategorías', ), 
			_ => null,
		};
	}
}
