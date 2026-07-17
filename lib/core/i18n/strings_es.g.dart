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
	@override late final _TranslationsHomeEs home = _TranslationsHomeEs._(_root);
	@override late final _TranslationsNavEs nav = _TranslationsNavEs._(_root);
	@override late final _TranslationsSettingsEs settings = _TranslationsSettingsEs._(_root);
	@override late final _TranslationsOnboardingEs onboarding = _TranslationsOnboardingEs._(_root);
	@override late final _TranslationsGoalsEs goals = _TranslationsGoalsEs._(_root);
	@override late final _TranslationsBudgetsEs budgets = _TranslationsBudgetsEs._(_root);
	@override late final _TranslationsAnalyticsEs analytics = _TranslationsAnalyticsEs._(_root);
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
	@override late final _TranslationsTransactionsEs transactions = _TranslationsTransactionsEs._(_root);
	@override late final _TranslationsCategoriesEs categories = _TranslationsCategoriesEs._(_root);
	@override late final _TranslationsSeedEs seed = _TranslationsSeedEs._(_root);
	@override late final _TranslationsSecurityEs security = _TranslationsSecurityEs._(_root);
	@override late final _TranslationsStarredTransactionsEs starred_transactions = _TranslationsStarredTransactionsEs._(_root);
	@override late final _TranslationsExchangeRatesEs exchange_rates = _TranslationsExchangeRatesEs._(_root);
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
	@override String get edit => 'Editar';
	@override String get error => 'Error';
	@override String get see_all => 'Ver Todo';
	@override String get preview => 'Vista Previa';
	@override String get yesterday => 'Ayer';
	@override String get show_as_transaction => 'Mostrar como movimiento';
	@override String get update_silently => 'Actualizar sin mostrar';
}

// Path: home
class _TranslationsHomeEs extends TranslationsHomeEn {
	_TranslationsHomeEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get total_balance => 'SALDO TOTAL';
	@override String get monthly_summary => 'Resumen mensual';
	@override String get income => 'Ingresos';
	@override String get expenses => 'Gastos';
	@override String get savings_rate => 'TASA DE AHORRO';
	@override String get recent_transactions => 'Transacciones recientes';
	@override String get view_all => 'Ver todo';
	@override String get no_transactions => 'Sin transacciones aún';
	@override String get pct_this_month => '{pct} este mes';
	@override String get no_transactions_day => 'Sin transacciones este día';
	@override String get add_transaction_on_day => 'Agregar una transacción en este día';
	@override String get financial_schedule => 'AGENDA FINANCIERA';
	@override String get transactions_for => 'Transacciones – {date}';
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
	@override late final _TranslationsSettingsDefaultCurrencyEs default_currency = _TranslationsSettingsDefaultCurrencyEs._(_root);
	@override late final _TranslationsSettingsDefaultHomeViewEs default_home_view = _TranslationsSettingsDefaultHomeViewEs._(_root);
	@override late final _TranslationsSettingsAccountsEs accounts = _TranslationsSettingsAccountsEs._(_root);
	@override late final _TranslationsSettingsCategoriesEs categories = _TranslationsSettingsCategoriesEs._(_root);
	@override late final _TranslationsSettingsStarredTransactionsEs starred_transactions = _TranslationsSettingsStarredTransactionsEs._(_root);
	@override late final _TranslationsSettingsSecurityEs security = _TranslationsSettingsSecurityEs._(_root);
	@override late final _TranslationsSettingsDataManagementEs data_management = _TranslationsSettingsDataManagementEs._(_root);
	@override late final _TranslationsSettingsDangerZoneEs danger_zone = _TranslationsSettingsDangerZoneEs._(_root);
}

// Path: onboarding
class _TranslationsOnboardingEs extends TranslationsOnboardingEn {
	_TranslationsOnboardingEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get skip => 'Omitir';
	@override String get next => 'Siguiente';
	@override String get get_started => 'Comenzar';
	@override late final _TranslationsOnboardingStep1Es step1 = _TranslationsOnboardingStep1Es._(_root);
	@override late final _TranslationsOnboardingStep2Es step2 = _TranslationsOnboardingStep2Es._(_root);
	@override late final _TranslationsOnboardingStep3Es step3 = _TranslationsOnboardingStep3Es._(_root);
	@override late final _TranslationsOnboardingStep4Es step4 = _TranslationsOnboardingStep4Es._(_root);
	@override late final _TranslationsOnboardingStep5Es step5 = _TranslationsOnboardingStep5Es._(_root);
}

// Path: goals
class _TranslationsGoalsEs extends TranslationsGoalsEn {
	_TranslationsGoalsEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Metas de ahorro';
	@override String get subtitle => 'Tu progreso hacia la libertad financiera';
	@override String get total_saved => 'TOTAL AHORRADO';
	@override String get target_reached => '{pct}% de la meta total alcanzada';
	@override String get no_goals => 'Sin metas de ahorro aún';
	@override String get no_goals_subtitle => 'Toca + para crear tu primera meta';
	@override String get view_details => 'Ver Detalles';
	@override String get saved => '{amount} ahorrado';
	@override String get target => 'Meta: {amount}';
	@override late final _TranslationsGoalsCreateEs create = _TranslationsGoalsCreateEs._(_root);
	@override late final _TranslationsGoalsEditEs edit = _TranslationsGoalsEditEs._(_root);
	@override late final _TranslationsGoalsDetailsEs details = _TranslationsGoalsDetailsEs._(_root);
	@override late final _TranslationsGoalsContributionEs contribution = _TranslationsGoalsContributionEs._(_root);
}

// Path: budgets
class _TranslationsBudgetsEs extends TranslationsBudgetsEn {
	_TranslationsBudgetsEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Presupuestos Mensuales';
	@override String get subtitle => 'Controla tus gastos por categoría';
	@override String get no_budgets => 'Sin presupuestos aún';
	@override String get no_budgets_subtitle => 'Toca + para crear tu primer presupuesto';
	@override String get categories => 'Categorías';
	@override String get total_spent => 'TOTAL GASTADO';
	@override String get remaining => 'RESTANTE';
	@override String get on_track => 'En buen camino';
	@override String get almost => 'Casi';
	@override String get over_budget => 'Excedido';
	@override String get of_limit => '{pct}% del límite de {limit}';
	@override String get of_amount => 'de {amount}';
	@override String get over_by => 'Excedido por {amount}';
	@override String transaction_count({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n,
		one: '1 transacción',
		other: '${n} transacciones',
	);
	@override late final _TranslationsBudgetsCreateEs create = _TranslationsBudgetsCreateEs._(_root);
	@override late final _TranslationsBudgetsEditEs edit = _TranslationsBudgetsEditEs._(_root);
}

// Path: analytics
class _TranslationsAnalyticsEs extends TranslationsAnalyticsEn {
	_TranslationsAnalyticsEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Análisis';
	@override String get insights_for => 'Perspectivas de {period}';
	@override String get cash_flow => 'Flujo de Caja';
	@override String get net_income => 'INGRESO NETO';
	@override String get spending_by_category => 'Gastos por Categoría';
	@override String get income_by_category => 'Ingresos por Categoría';
	@override String get no_data => 'Sin datos para este período';
	@override String get total => 'Total';
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

// Path: transactions
class _TranslationsTransactionsEs extends TranslationsTransactionsEn {
	_TranslationsTransactionsEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get add_title => 'Nuevo Movimiento';
	@override String get edit_title => 'Editar Movimiento';
	@override String get enter_amount => '¿CUÁNTO FUE?';
	@override String get tab_expense => 'Gasto';
	@override String get tab_income => 'Ingreso';
	@override String get tab_transfer => 'Traspaso';
	@override String get category => 'CATEGORÍA';
	@override String get no_category => '¿En qué cayó?';
	@override String get account => 'CUENTA';
	@override String get no_account => '¿De dónde salió?';
	@override String get to_account => 'DESTINO';
	@override String get no_to_account => '¿Adónde va?';
	@override String get date_time => 'FECHA Y HORA';
	@override String get notes => 'NOTA';
	@override String get notes_hint => '¿Pa\' qué fue esto?';
	@override String get attachments => 'ADJUNTOS';
	@override String get attachments_hint => 'Sube el ticket o una foto';
	@override String get save_button => 'Guardar Movimiento';
	@override String get amount_required => '¡Mete un monto primero!';
	@override String get category_required => '¡Elige una categoría primero!';
	@override String get account_required => 'Selecciona una cuenta';
	@override String get success => '¡Movimiento guardado!';
	@override String get select_category => 'Elige una Categoría';
	@override String get select_account => '¿Qué Cuenta?';
	@override String get select_to_account => '¿Adónde Va?';
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

// Path: seed
class _TranslationsSeedEs extends TranslationsSeedEn {
	_TranslationsSeedEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSeedCategoriesEs categories = _TranslationsSeedCategoriesEs._(_root);
	@override late final _TranslationsSeedAccountsEs accounts = _TranslationsSeedAccountsEs._(_root);
}

// Path: security
class _TranslationsSecurityEs extends TranslationsSecurityEn {
	_TranslationsSecurityEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSecurityLockScreenEs lock_screen = _TranslationsSecurityLockScreenEs._(_root);
}

// Path: starred_transactions
class _TranslationsStarredTransactionsEs extends TranslationsStarredTransactionsEn {
	_TranslationsStarredTransactionsEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Transacciones destacadas';
	@override String get save_current => 'Guardar actual como plantilla';
	@override String get saved => 'Plantilla guardada';
	@override String get deleted => 'Plantilla eliminada';
	@override String get delete_title => '¿Eliminar plantilla?';
	@override String get delete_message => 'Esta plantilla se eliminará de forma permanente.';
	@override String get empty => 'Sin plantillas aún';
	@override String get empty_subtitle => 'Toca el ícono ⭐ al crear una transacción para guardar una plantilla';
}

// Path: exchange_rates
class _TranslationsExchangeRatesEs extends TranslationsExchangeRatesEn {
	_TranslationsExchangeRatesEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tasas de Cambio';
	@override String get empty_state_title => 'Sin tasas de cambio';
	@override String get empty_state_subtitle => 'Agrega tasas para convertir saldos y presupuestos entre monedas.';
	@override String get add_title => 'Agregar Tasa de Cambio';
	@override String get edit_title => 'Editar Tasa de Cambio';
	@override String get from_currency => 'Moneda de origen';
	@override String get to_currency => 'Moneda de destino';
	@override String get date_label => 'Fecha';
	@override String get add_button => 'Agregar Tasa';
	@override String get save_button => 'Guardar';
	@override String get delete_title => '¿Eliminar tasa?';
	@override String get delete_message => 'Esta tasa de cambio se eliminará de forma permanente.';
	@override String get error_rate_invalid => 'Ingresa una tasa válida mayor que 0.';
	@override String get error_same_currency => 'Las monedas de origen y destino deben ser diferentes.';
	@override String get success_add => 'Tipo de cambio agregado.';
	@override String get success_update => 'Tipo de cambio actualizado.';
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

// Path: settings.default_currency
class _TranslationsSettingsDefaultCurrencyEs extends TranslationsSettingsDefaultCurrencyEn {
	_TranslationsSettingsDefaultCurrencyEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Moneda predeterminada';
}

// Path: settings.default_home_view
class _TranslationsSettingsDefaultHomeViewEs extends TranslationsSettingsDefaultHomeViewEn {
	_TranslationsSettingsDefaultHomeViewEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Vista de inicio predeterminada';
	@override String get dashboard => 'Panel';
	@override String get calendar => 'Calendario';
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

// Path: settings.starred_transactions
class _TranslationsSettingsStarredTransactionsEs extends TranslationsSettingsStarredTransactionsEn {
	_TranslationsSettingsStarredTransactionsEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Transacciones destacadas';
}

// Path: settings.security
class _TranslationsSettingsSecurityEs extends TranslationsSettingsSecurityEn {
	_TranslationsSettingsSecurityEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Seguridad';
	@override late final _TranslationsSettingsSecurityBiometricLoginEs biometric_login = _TranslationsSettingsSecurityBiometricLoginEs._(_root);
}

// Path: settings.data_management
class _TranslationsSettingsDataManagementEs extends TranslationsSettingsDataManagementEn {
	_TranslationsSettingsDataManagementEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Gestión de Datos';
	@override String get export_title => 'Exportar Datos';
	@override String get export_subtitle => 'Guarda todos tus datos como un archivo JSON de respaldo';
	@override String get export_button => 'Exportar Datos';
	@override String get export_include_images => 'Incluir imágenes de recibos';
	@override String get export_image_warning => 'Los archivos de exportación con imágenes son mucho más grandes y pueden tardar más en generarse.';
	@override String get export_in_progress => 'Exportando...';
	@override String get export_success => 'Datos exportados con éxito';
	@override String get export_error => 'Error al exportar datos';
	@override String get import_title => 'Importar Datos';
	@override String get import_subtitle => 'Restaurar datos desde un archivo de respaldo';
	@override String get import_recent => 'Respaldos recientes';
	@override String get import_no_backups => 'No se encontraron respaldos recientes';
	@override String get import_browse => 'Buscar archivos...';
	@override String get import_tap_restore => 'Toca un respaldo para restaurarlo';
	@override String get import_button => 'Importar Datos';
	@override String get import_in_progress => 'Importando...';
	@override String get import_confirm_title => '¿Importar Datos?';
	@override String get import_summary => 'Esto importará:';
	@override String get import_accounts_count => '{count} cuentas';
	@override String get import_categories_count => '{count} categorías';
	@override String get import_transactions_count => '{count} transacciones';
	@override String get import_images_count => '{count} imágenes de recibos';
	@override String get import_starred_count => '{count} plantillas destacadas';
	@override String get import_budgets_count => '{count} presupuestos';
	@override String get import_goals_count => '{count} metas de ahorro';
	@override String get import_contributions_count => '{count} contribuciones de ahorro';
	@override String get import_rates_count => '{count} tasas de cambio';
	@override String get import_settings => 'Configuración de la app';
	@override String get import_images_included => 'Incluye imágenes de recibos';
	@override String get import_confirm_message => 'Esto reemplazará TODOS tus datos existentes. Esta acción no se puede deshacer.';
	@override String get import_confirm_button => 'Importar Datos';
	@override String get import_success => 'Datos importados con éxito. Algunos ajustes se aplicarán al reiniciar la app.';
	@override String get import_error => 'Error al importar datos';
	@override String get import_invalid_file => 'El archivo seleccionado no contiene datos o no es una copia de seguridad válida.';
}

// Path: settings.danger_zone
class _TranslationsSettingsDangerZoneEs extends TranslationsSettingsDangerZoneEn {
	_TranslationsSettingsDangerZoneEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Zona de peligro';
	@override late final _TranslationsSettingsDangerZoneEraseDataEs erase_data = _TranslationsSettingsDangerZoneEraseDataEs._(_root);
}

// Path: onboarding.step1
class _TranslationsOnboardingStep1Es extends TranslationsOnboardingStep1En {
	_TranslationsOnboardingStep1Es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Bienvenido a ExpenseLab';
	@override String get description => 'Tu compañero de finanzas personales. Registra gastos, planifica presupuestos y alcanza tus metas — todo en un solo lugar.';
}

// Path: onboarding.step2
class _TranslationsOnboardingStep2Es extends TranslationsOnboardingStep2En {
	_TranslationsOnboardingStep2Es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Registra cada transacción';
	@override String get description => 'Anota gastos, ingresos y transferencias en segundos. Adjunta recibos y agrega notas para mantenerte organizado.';
}

// Path: onboarding.step3
class _TranslationsOnboardingStep3Es extends TranslationsOnboardingStep3En {
	_TranslationsOnboardingStep3Es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Presupuesta con confianza';
	@override String get description => 'Establece presupuestos mensuales por categoría y obtén retroalimentación instantánea sobre a dónde va tu dinero.';
}

// Path: onboarding.step4
class _TranslationsOnboardingStep4Es extends TranslationsOnboardingStep4En {
	_TranslationsOnboardingStep4Es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Construye tus ahorros';
	@override String get description => 'Crea metas de ahorro, registra contribuciones y sigue tu progreso hacia lo que más importa.';
}

// Path: onboarding.step5
class _TranslationsOnboardingStep5Es extends TranslationsOnboardingStep5En {
	_TranslationsOnboardingStep5Es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => '¡Todo listo!';
	@override String get description => 'Tus cuentas y categorías están listas. Empieza a registrar y toma el control de tus finanzas hoy.';
}

// Path: goals.create
class _TranslationsGoalsCreateEs extends TranslationsGoalsCreateEn {
	_TranslationsGoalsCreateEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Nueva Meta';
	@override String get name => 'Nombre de la Meta';
	@override String get name_hint => 'ej., Vacaciones soñadas';
	@override String get target_amount => 'Monto Objetivo';
	@override String get target_date => 'Fecha Objetivo (Opcional)';
	@override String get source_account => 'Cuenta Fuente';
	@override String get select_account => 'Selecciona una cuenta';
	@override String get create_button => 'Crear Meta';
	@override String get name_required => 'Por favor ingresa un nombre para la meta';
	@override String get amount_required => 'Por favor ingresa un monto objetivo';
	@override String get amount_invalid => 'Por favor ingresa un monto válido';
	@override String get account_required => 'Por favor selecciona una cuenta fuente';
	@override String get success => '¡Meta creada con éxito!';
}

// Path: goals.edit
class _TranslationsGoalsEditEs extends TranslationsGoalsEditEn {
	_TranslationsGoalsEditEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Editar Meta';
	@override String get associated_account => 'Cuenta Asociada';
	@override String get save_button => 'Guardar Cambios';
	@override String get delete_button => 'Eliminar Meta';
	@override String get delete_title => 'Eliminar Meta';
	@override String get delete_message => '¿Estás seguro de que deseas eliminar esta meta? Esta acción no se puede deshacer.';
	@override String get error_loading => 'Error al cargar la meta';
	@override String get success_update => '¡Meta actualizada con éxito!';
	@override String get success_delete => '¡Meta eliminada con éxito!';
}

// Path: goals.details
class _TranslationsGoalsDetailsEs extends TranslationsGoalsDetailsEn {
	_TranslationsGoalsDetailsEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get saved_label => 'TOTAL AHORRADO';
	@override String get target_label => 'META';
	@override String get deadline => 'Fecha límite: {date}';
	@override String get no_deadline => 'Sin fecha límite';
	@override String get contributions_title => 'Contribuciones';
	@override String get no_contributions => 'Sin contribuciones aún';
	@override String get no_contributions_subtitle => 'Toca + para registrar tu primera contribución';
	@override String get contribution_label => 'Contribución';
}

// Path: goals.contribution
class _TranslationsGoalsContributionEs extends TranslationsGoalsContributionEn {
	_TranslationsGoalsContributionEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get add_title => 'Agregar Contribución';
	@override String get amount => 'Monto';
	@override String get date => 'Fecha';
	@override String get note => 'Nota (Opcional)';
	@override String get note_hint => '¿Para qué fue esto?';
	@override String get save_button => 'Guardar Contribución';
	@override String get amount_required => 'Por favor ingresa un monto';
	@override String get amount_invalid => 'Por favor ingresa un monto válido';
	@override String get success => '¡Contribución agregada!';
}

// Path: budgets.create
class _TranslationsBudgetsCreateEs extends TranslationsBudgetsCreateEn {
	_TranslationsBudgetsCreateEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Nuevo Presupuesto';
	@override String get category => 'Categoría';
	@override String get select_category => 'Seleccionar categoría';
	@override String get currency => 'Moneda';
	@override String get amount => 'Monto';
	@override String get create_button => 'Crear presupuesto';
	@override String get category_required => 'Por favor selecciona una categoría';
	@override String get amount_required => 'Por favor ingresa un monto de presupuesto';
	@override String get amount_invalid => 'Por favor ingresa un monto válido';
	@override String get success => '¡Presupuesto creado con éxito!';
}

// Path: budgets.edit
class _TranslationsBudgetsEditEs extends TranslationsBudgetsEditEn {
	_TranslationsBudgetsEditEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Editar presupuesto';
	@override String get edit_button => 'Editar presupuesto';
	@override String get delete_button => 'Eliminar presupuesto';
	@override String get delete_title => 'Eliminar presupuesto';
	@override String get delete_message => '¿Estás seguro de que deseas eliminar este presupuesto? Esta acción no se puede deshacer.';
	@override String get error_loading => 'Error al cargar el presupuesto';
	@override String get success_update => '¡Presupuesto actualizado con éxito!';
	@override String get success_delete => '¡Presupuesto eliminado con éxito!';
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
	@override String get initial_balance_note => 'Saldo inicial';
	@override String get pro_tip_label => 'Consejo profesional';
	@override String get pro_tip => 'Agrupar tus ahorros en cuentas específicas te ayuda a visualizar el progreso hacia metas financieras a largo plazo.';
	@override String get create_button => 'Crear cuenta';
	@override String get name_required => 'Por favor ingresa un nombre de cuenta';
	@override String get balance_invalid => 'Por favor ingresa un saldo válido';
	@override String get success => 'Cuenta creada con éxito';
	@override String get balance_adjusted_title => 'Saldo Inicial';
	@override String get balance_adjusted_message => '¿Cómo debemos registrar este saldo inicial?';
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
	@override String get balance_adjustment_note => 'Ajuste de saldo';
	@override String get balance_adjusted_title => 'Saldo Ajustado';
	@override String get balance_adjusted_message => '¿Cómo debemos registrar este ajuste?';
	@override String get success_update => 'Cuenta actualizada con éxito';
	@override String get success_delete => 'Cuenta eliminada con éxito';
}

// Path: seed.categories
class _TranslationsSeedCategoriesEs extends TranslationsSeedCategoriesEn {
	_TranslationsSeedCategoriesEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get food_and_dining => 'Comida y Restaurantes';
	@override String get housing => 'Vivienda';
	@override String get transportation => 'Transporte';
	@override String get health => 'Salud';
	@override String get entertainment => 'Entretenimiento';
	@override String get shopping => 'Compras';
	@override String get education => 'Educación';
	@override String get salary => 'Sueldo';
	@override String get freelance => 'Freelance';
	@override String get investment => 'Inversiones';
}

// Path: seed.accounts
class _TranslationsSeedAccountsEs extends TranslationsSeedAccountsEn {
	_TranslationsSeedAccountsEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get cash => 'Efectivo';
	@override String get bank_account => 'Cuenta de Banco';
}

// Path: security.lock_screen
class _TranslationsSecurityLockScreenEs extends TranslationsSecurityLockScreenEn {
	_TranslationsSecurityLockScreenEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get subtitle_authenticate => 'Autentícate para continuar';
	@override String get subtitle_unavailable => 'Biometría no disponible en este dispositivo';
	@override String get try_again => 'Intentar de nuevo';
	@override String get reason => 'Verifica tu identidad para acceder a ExpenseLab';
}

// Path: settings.security.biometric_login
class _TranslationsSettingsSecurityBiometricLoginEs extends TranslationsSettingsSecurityBiometricLoginEn {
	_TranslationsSettingsSecurityBiometricLoginEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Inicio biométrico';
	@override String get subtitle => 'Usa Face ID o huella para desbloquear';
	@override String get unavailable_snackbar => 'No hay biometría ni bloqueo de pantalla configurado en este dispositivo.';
}

// Path: settings.danger_zone.erase_data
class _TranslationsSettingsDangerZoneEraseDataEs extends TranslationsSettingsDangerZoneEraseDataEn {
	_TranslationsSettingsDangerZoneEraseDataEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Borrar todos los datos';
	@override String get subtitle => 'Elimina permanentemente todos tus datos';
	@override String get confirm_title => '¿Borrar todos los datos?';
	@override String get confirm_message => 'Esto eliminará permanentemente todas tus transacciones, cuentas, categorías y configuración. Esta acción no se puede deshacer.';
	@override String get confirm_button => 'Borrar todo';
	@override String get type_to_confirm => 'Escribe "ExpenseLab" para confirmar';
	@override String get restart_title => 'Reinicio requerido';
	@override String get restart_message => 'Tus datos han sido borrados. Cierra la app y vuelve a abrirla para ver la introducción.';
	@override String get close_app_button => 'Cerrar app';
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
			'common.edit' => 'Editar',
			'common.error' => 'Error',
			'common.see_all' => 'Ver Todo',
			'common.preview' => 'Vista Previa',
			'common.yesterday' => 'Ayer',
			'common.show_as_transaction' => 'Mostrar como movimiento',
			'common.update_silently' => 'Actualizar sin mostrar',
			'home.total_balance' => 'SALDO TOTAL',
			'home.monthly_summary' => 'Resumen mensual',
			'home.income' => 'Ingresos',
			'home.expenses' => 'Gastos',
			'home.savings_rate' => 'TASA DE AHORRO',
			'home.recent_transactions' => 'Transacciones recientes',
			'home.view_all' => 'Ver todo',
			'home.no_transactions' => 'Sin transacciones aún',
			'home.pct_this_month' => '{pct} este mes',
			'home.no_transactions_day' => 'Sin transacciones este día',
			'home.add_transaction_on_day' => 'Agregar una transacción en este día',
			'home.financial_schedule' => 'AGENDA FINANCIERA',
			'home.transactions_for' => 'Transacciones – {date}',
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
			'settings.default_currency.title' => 'Moneda predeterminada',
			'settings.default_home_view.title' => 'Vista de inicio predeterminada',
			'settings.default_home_view.dashboard' => 'Panel',
			'settings.default_home_view.calendar' => 'Calendario',
			'settings.accounts.title' => 'Cuentas',
			'settings.categories.title' => 'Categorías',
			'settings.starred_transactions.title' => 'Transacciones destacadas',
			'settings.security.title' => 'Seguridad',
			'settings.security.biometric_login.title' => 'Inicio biométrico',
			'settings.security.biometric_login.subtitle' => 'Usa Face ID o huella para desbloquear',
			'settings.security.biometric_login.unavailable_snackbar' => 'No hay biometría ni bloqueo de pantalla configurado en este dispositivo.',
			'settings.data_management.title' => 'Gestión de Datos',
			'settings.data_management.export_title' => 'Exportar Datos',
			'settings.data_management.export_subtitle' => 'Guarda todos tus datos como un archivo JSON de respaldo',
			'settings.data_management.export_button' => 'Exportar Datos',
			'settings.data_management.export_include_images' => 'Incluir imágenes de recibos',
			'settings.data_management.export_image_warning' => 'Los archivos de exportación con imágenes son mucho más grandes y pueden tardar más en generarse.',
			'settings.data_management.export_in_progress' => 'Exportando...',
			'settings.data_management.export_success' => 'Datos exportados con éxito',
			'settings.data_management.export_error' => 'Error al exportar datos',
			'settings.data_management.import_title' => 'Importar Datos',
			'settings.data_management.import_subtitle' => 'Restaurar datos desde un archivo de respaldo',
			'settings.data_management.import_recent' => 'Respaldos recientes',
			'settings.data_management.import_no_backups' => 'No se encontraron respaldos recientes',
			'settings.data_management.import_browse' => 'Buscar archivos...',
			'settings.data_management.import_tap_restore' => 'Toca un respaldo para restaurarlo',
			'settings.data_management.import_button' => 'Importar Datos',
			'settings.data_management.import_in_progress' => 'Importando...',
			'settings.data_management.import_confirm_title' => '¿Importar Datos?',
			'settings.data_management.import_summary' => 'Esto importará:',
			'settings.data_management.import_accounts_count' => '{count} cuentas',
			'settings.data_management.import_categories_count' => '{count} categorías',
			'settings.data_management.import_transactions_count' => '{count} transacciones',
			'settings.data_management.import_images_count' => '{count} imágenes de recibos',
			'settings.data_management.import_starred_count' => '{count} plantillas destacadas',
			'settings.data_management.import_budgets_count' => '{count} presupuestos',
			'settings.data_management.import_goals_count' => '{count} metas de ahorro',
			'settings.data_management.import_contributions_count' => '{count} contribuciones de ahorro',
			'settings.data_management.import_rates_count' => '{count} tasas de cambio',
			'settings.data_management.import_settings' => 'Configuración de la app',
			'settings.data_management.import_images_included' => 'Incluye imágenes de recibos',
			'settings.data_management.import_confirm_message' => 'Esto reemplazará TODOS tus datos existentes. Esta acción no se puede deshacer.',
			'settings.data_management.import_confirm_button' => 'Importar Datos',
			'settings.data_management.import_success' => 'Datos importados con éxito. Algunos ajustes se aplicarán al reiniciar la app.',
			'settings.data_management.import_error' => 'Error al importar datos',
			'settings.data_management.import_invalid_file' => 'El archivo seleccionado no contiene datos o no es una copia de seguridad válida.',
			'settings.danger_zone.title' => 'Zona de peligro',
			'settings.danger_zone.erase_data.title' => 'Borrar todos los datos',
			'settings.danger_zone.erase_data.subtitle' => 'Elimina permanentemente todos tus datos',
			'settings.danger_zone.erase_data.confirm_title' => '¿Borrar todos los datos?',
			'settings.danger_zone.erase_data.confirm_message' => 'Esto eliminará permanentemente todas tus transacciones, cuentas, categorías y configuración. Esta acción no se puede deshacer.',
			'settings.danger_zone.erase_data.confirm_button' => 'Borrar todo',
			'settings.danger_zone.erase_data.type_to_confirm' => 'Escribe "ExpenseLab" para confirmar',
			'settings.danger_zone.erase_data.restart_title' => 'Reinicio requerido',
			'settings.danger_zone.erase_data.restart_message' => 'Tus datos han sido borrados. Cierra la app y vuelve a abrirla para ver la introducción.',
			'settings.danger_zone.erase_data.close_app_button' => 'Cerrar app',
			'onboarding.skip' => 'Omitir',
			'onboarding.next' => 'Siguiente',
			'onboarding.get_started' => 'Comenzar',
			'onboarding.step1.title' => 'Bienvenido a ExpenseLab',
			'onboarding.step1.description' => 'Tu compañero de finanzas personales. Registra gastos, planifica presupuestos y alcanza tus metas — todo en un solo lugar.',
			'onboarding.step2.title' => 'Registra cada transacción',
			'onboarding.step2.description' => 'Anota gastos, ingresos y transferencias en segundos. Adjunta recibos y agrega notas para mantenerte organizado.',
			'onboarding.step3.title' => 'Presupuesta con confianza',
			'onboarding.step3.description' => 'Establece presupuestos mensuales por categoría y obtén retroalimentación instantánea sobre a dónde va tu dinero.',
			'onboarding.step4.title' => 'Construye tus ahorros',
			'onboarding.step4.description' => 'Crea metas de ahorro, registra contribuciones y sigue tu progreso hacia lo que más importa.',
			'onboarding.step5.title' => '¡Todo listo!',
			'onboarding.step5.description' => 'Tus cuentas y categorías están listas. Empieza a registrar y toma el control de tus finanzas hoy.',
			'goals.title' => 'Metas de ahorro',
			'goals.subtitle' => 'Tu progreso hacia la libertad financiera',
			'goals.total_saved' => 'TOTAL AHORRADO',
			'goals.target_reached' => '{pct}% de la meta total alcanzada',
			'goals.no_goals' => 'Sin metas de ahorro aún',
			'goals.no_goals_subtitle' => 'Toca + para crear tu primera meta',
			'goals.view_details' => 'Ver Detalles',
			'goals.saved' => '{amount} ahorrado',
			'goals.target' => 'Meta: {amount}',
			'goals.create.title' => 'Nueva Meta',
			'goals.create.name' => 'Nombre de la Meta',
			'goals.create.name_hint' => 'ej., Vacaciones soñadas',
			'goals.create.target_amount' => 'Monto Objetivo',
			'goals.create.target_date' => 'Fecha Objetivo (Opcional)',
			'goals.create.source_account' => 'Cuenta Fuente',
			'goals.create.select_account' => 'Selecciona una cuenta',
			'goals.create.create_button' => 'Crear Meta',
			'goals.create.name_required' => 'Por favor ingresa un nombre para la meta',
			'goals.create.amount_required' => 'Por favor ingresa un monto objetivo',
			'goals.create.amount_invalid' => 'Por favor ingresa un monto válido',
			'goals.create.account_required' => 'Por favor selecciona una cuenta fuente',
			'goals.create.success' => '¡Meta creada con éxito!',
			'goals.edit.title' => 'Editar Meta',
			'goals.edit.associated_account' => 'Cuenta Asociada',
			'goals.edit.save_button' => 'Guardar Cambios',
			'goals.edit.delete_button' => 'Eliminar Meta',
			'goals.edit.delete_title' => 'Eliminar Meta',
			'goals.edit.delete_message' => '¿Estás seguro de que deseas eliminar esta meta? Esta acción no se puede deshacer.',
			'goals.edit.error_loading' => 'Error al cargar la meta',
			'goals.edit.success_update' => '¡Meta actualizada con éxito!',
			'goals.edit.success_delete' => '¡Meta eliminada con éxito!',
			'goals.details.saved_label' => 'TOTAL AHORRADO',
			'goals.details.target_label' => 'META',
			'goals.details.deadline' => 'Fecha límite: {date}',
			'goals.details.no_deadline' => 'Sin fecha límite',
			'goals.details.contributions_title' => 'Contribuciones',
			'goals.details.no_contributions' => 'Sin contribuciones aún',
			'goals.details.no_contributions_subtitle' => 'Toca + para registrar tu primera contribución',
			'goals.details.contribution_label' => 'Contribución',
			'goals.contribution.add_title' => 'Agregar Contribución',
			'goals.contribution.amount' => 'Monto',
			'goals.contribution.date' => 'Fecha',
			'goals.contribution.note' => 'Nota (Opcional)',
			'goals.contribution.note_hint' => '¿Para qué fue esto?',
			'goals.contribution.save_button' => 'Guardar Contribución',
			'goals.contribution.amount_required' => 'Por favor ingresa un monto',
			'goals.contribution.amount_invalid' => 'Por favor ingresa un monto válido',
			'goals.contribution.success' => '¡Contribución agregada!',
			'budgets.title' => 'Presupuestos Mensuales',
			'budgets.subtitle' => 'Controla tus gastos por categoría',
			'budgets.no_budgets' => 'Sin presupuestos aún',
			'budgets.no_budgets_subtitle' => 'Toca + para crear tu primer presupuesto',
			'budgets.categories' => 'Categorías',
			'budgets.total_spent' => 'TOTAL GASTADO',
			'budgets.remaining' => 'RESTANTE',
			'budgets.on_track' => 'En buen camino',
			'budgets.almost' => 'Casi',
			'budgets.over_budget' => 'Excedido',
			'budgets.of_limit' => '{pct}% del límite de {limit}',
			'budgets.of_amount' => 'de {amount}',
			'budgets.over_by' => 'Excedido por {amount}',
			'budgets.transaction_count' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n, one: '1 transacción', other: '${n} transacciones', ), 
			'budgets.create.title' => 'Nuevo Presupuesto',
			'budgets.create.category' => 'Categoría',
			'budgets.create.select_category' => 'Seleccionar categoría',
			'budgets.create.currency' => 'Moneda',
			'budgets.create.amount' => 'Monto',
			'budgets.create.create_button' => 'Crear presupuesto',
			'budgets.create.category_required' => 'Por favor selecciona una categoría',
			'budgets.create.amount_required' => 'Por favor ingresa un monto de presupuesto',
			'budgets.create.amount_invalid' => 'Por favor ingresa un monto válido',
			'budgets.create.success' => '¡Presupuesto creado con éxito!',
			'budgets.edit.title' => 'Editar presupuesto',
			'budgets.edit.edit_button' => 'Editar presupuesto',
			'budgets.edit.delete_button' => 'Eliminar presupuesto',
			'budgets.edit.delete_title' => 'Eliminar presupuesto',
			'budgets.edit.delete_message' => '¿Estás seguro de que deseas eliminar este presupuesto? Esta acción no se puede deshacer.',
			'budgets.edit.error_loading' => 'Error al cargar el presupuesto',
			'budgets.edit.success_update' => '¡Presupuesto actualizado con éxito!',
			'budgets.edit.success_delete' => '¡Presupuesto eliminado con éxito!',
			'analytics.title' => 'Análisis',
			'analytics.insights_for' => 'Perspectivas de {period}',
			'analytics.cash_flow' => 'Flujo de Caja',
			'analytics.net_income' => 'INGRESO NETO',
			'analytics.spending_by_category' => 'Gastos por Categoría',
			'analytics.income_by_category' => 'Ingresos por Categoría',
			'analytics.no_data' => 'Sin datos para este período',
			'analytics.total' => 'Total',
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
			'accounts.create.initial_balance_note' => 'Saldo inicial',
			'accounts.create.pro_tip_label' => 'Consejo profesional',
			'accounts.create.pro_tip' => 'Agrupar tus ahorros en cuentas específicas te ayuda a visualizar el progreso hacia metas financieras a largo plazo.',
			'accounts.create.create_button' => 'Crear cuenta',
			'accounts.create.name_required' => 'Por favor ingresa un nombre de cuenta',
			'accounts.create.balance_invalid' => 'Por favor ingresa un saldo válido',
			'accounts.create.success' => 'Cuenta creada con éxito',
			'accounts.create.balance_adjusted_title' => 'Saldo Inicial',
			'accounts.create.balance_adjusted_message' => '¿Cómo debemos registrar este saldo inicial?',
			'accounts.edit.title' => 'Editar cuenta',
			'accounts.edit.edit_button' => 'Editar cuenta',
			'accounts.edit.delete_button' => 'Eliminar cuenta',
			'accounts.edit.delete_title' => 'Eliminar cuenta',
			'accounts.edit.delete_message' => '¿Estás seguro de que deseas eliminar esta cuenta? Esta acción no se puede deshacer.',
			'accounts.edit.error_loading' => 'Error al cargar la cuenta',
			'accounts.edit.balance_adjustment_note' => 'Ajuste de saldo',
			'accounts.edit.balance_adjusted_title' => 'Saldo Ajustado',
			'accounts.edit.balance_adjusted_message' => '¿Cómo debemos registrar este ajuste?',
			'accounts.edit.success_update' => 'Cuenta actualizada con éxito',
			'accounts.edit.success_delete' => 'Cuenta eliminada con éxito',
			'transactions.add_title' => 'Nuevo Movimiento',
			'transactions.edit_title' => 'Editar Movimiento',
			'transactions.enter_amount' => '¿CUÁNTO FUE?',
			'transactions.tab_expense' => 'Gasto',
			'transactions.tab_income' => 'Ingreso',
			'transactions.tab_transfer' => 'Traspaso',
			'transactions.category' => 'CATEGORÍA',
			'transactions.no_category' => '¿En qué cayó?',
			'transactions.account' => 'CUENTA',
			'transactions.no_account' => '¿De dónde salió?',
			'transactions.to_account' => 'DESTINO',
			'transactions.no_to_account' => '¿Adónde va?',
			'transactions.date_time' => 'FECHA Y HORA',
			'transactions.notes' => 'NOTA',
			'transactions.notes_hint' => '¿Pa\' qué fue esto?',
			'transactions.attachments' => 'ADJUNTOS',
			'transactions.attachments_hint' => 'Sube el ticket o una foto',
			'transactions.save_button' => 'Guardar Movimiento',
			'transactions.amount_required' => '¡Mete un monto primero!',
			'transactions.category_required' => '¡Elige una categoría primero!',
			'transactions.account_required' => 'Selecciona una cuenta',
			'transactions.success' => '¡Movimiento guardado!',
			'transactions.select_category' => 'Elige una Categoría',
			'transactions.select_account' => '¿Qué Cuenta?',
			'transactions.select_to_account' => '¿Adónde Va?',
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
			'seed.categories.food_and_dining' => 'Comida y Restaurantes',
			'seed.categories.housing' => 'Vivienda',
			'seed.categories.transportation' => 'Transporte',
			'seed.categories.health' => 'Salud',
			'seed.categories.entertainment' => 'Entretenimiento',
			'seed.categories.shopping' => 'Compras',
			'seed.categories.education' => 'Educación',
			'seed.categories.salary' => 'Sueldo',
			'seed.categories.freelance' => 'Freelance',
			'seed.categories.investment' => 'Inversiones',
			'seed.accounts.cash' => 'Efectivo',
			'seed.accounts.bank_account' => 'Cuenta de Banco',
			'security.lock_screen.subtitle_authenticate' => 'Autentícate para continuar',
			'security.lock_screen.subtitle_unavailable' => 'Biometría no disponible en este dispositivo',
			'security.lock_screen.try_again' => 'Intentar de nuevo',
			'security.lock_screen.reason' => 'Verifica tu identidad para acceder a ExpenseLab',
			'starred_transactions.title' => 'Transacciones destacadas',
			'starred_transactions.save_current' => 'Guardar actual como plantilla',
			'starred_transactions.saved' => 'Plantilla guardada',
			'starred_transactions.deleted' => 'Plantilla eliminada',
			'starred_transactions.delete_title' => '¿Eliminar plantilla?',
			'starred_transactions.delete_message' => 'Esta plantilla se eliminará de forma permanente.',
			'starred_transactions.empty' => 'Sin plantillas aún',
			'starred_transactions.empty_subtitle' => 'Toca el ícono ⭐ al crear una transacción para guardar una plantilla',
			'exchange_rates.title' => 'Tasas de Cambio',
			'exchange_rates.empty_state_title' => 'Sin tasas de cambio',
			'exchange_rates.empty_state_subtitle' => 'Agrega tasas para convertir saldos y presupuestos entre monedas.',
			'exchange_rates.add_title' => 'Agregar Tasa de Cambio',
			'exchange_rates.edit_title' => 'Editar Tasa de Cambio',
			'exchange_rates.from_currency' => 'Moneda de origen',
			'exchange_rates.to_currency' => 'Moneda de destino',
			'exchange_rates.date_label' => 'Fecha',
			'exchange_rates.add_button' => 'Agregar Tasa',
			'exchange_rates.save_button' => 'Guardar',
			'exchange_rates.delete_title' => '¿Eliminar tasa?',
			'exchange_rates.delete_message' => 'Esta tasa de cambio se eliminará de forma permanente.',
			'exchange_rates.error_rate_invalid' => 'Ingresa una tasa válida mayor que 0.',
			'exchange_rates.error_same_currency' => 'Las monedas de origen y destino deben ser diferentes.',
			'exchange_rates.success_add' => 'Tipo de cambio agregado.',
			'exchange_rates.success_update' => 'Tipo de cambio actualizado.',
			_ => null,
		};
	}
}
