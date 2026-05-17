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
			_ => null,
		};
	}
}
