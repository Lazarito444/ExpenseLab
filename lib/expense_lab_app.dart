import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/core/routing/app_router.dart';
import 'package:expenselab/core/seed/seed_data_provider.dart';
import 'package:expenselab/core/theme/app_theme.dart';
import 'package:expenselab/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:expenselab/features/security/lock_provider.dart';
import 'package:expenselab/features/security/presentation/screens/lock_screen.dart';
import 'package:expenselab/features/settings/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseLabApp extends ConsumerStatefulWidget {
  const ExpenseLabApp({super.key});

  @override
  ConsumerState<ExpenseLabApp> createState() => _ExpenseLabAppState();
}

class _ExpenseLabAppState extends ConsumerState<ExpenseLabApp> with WidgetsBindingObserver {
  bool? _onboardingCompleted;

  static const _onboardingKey = 'onboarding_completed';

  @override
  void initState() {
    super.initState();
    _initLocale();
    _initOnboarding();
    ref.read(seedDataServiceProvider).seedIfNeeded();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initLockState());
  }

  Future<void> _initLocale() async {
    final settings = await ref.read(settingsProvider.future);
    final locale = settings.locale;
    LocaleSettings.setLocale(locale);
  }

  Future<void> _initOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final done = prefs.getBool(_onboardingKey) ?? false;
    if (mounted) setState(() => _onboardingCompleted = done);
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
    if (mounted) setState(() => _onboardingCompleted = true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _initLockState() async {
    final settings = await ref.read(settingsProvider.future);
    if (!settings.biometricLogin) {
      ref.read(isLockedProvider.notifier).unlock();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final biometricEnabled = ref.read(settingsProvider).value?.biometricLogin ?? false;
    if (!biometricEnabled) return;

    if (state == AppLifecycleState.paused) {
      ref.read(isLockedProvider.notifier).lock();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final biometricEnabled = ref.watch(settingsProvider).value?.biometricLogin ?? false;
    final isLocked = ref.watch(isLockedProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: routerConfig,
      builder: (context, child) {
        if (_onboardingCompleted == false) {
          return OnboardingScreen(onComplete: _completeOnboarding);
        }
        if (_onboardingCompleted == null) {
          return const SizedBox.shrink();
        }
        if (biometricEnabled && isLocked) {
          return const LockScreen();
        }
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
