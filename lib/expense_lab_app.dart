import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/core/routing/app_router.dart';
import 'package:expenselab/core/theme/app_theme.dart';
import 'package:expenselab/features/security/lock_provider.dart';
import 'package:expenselab/features/security/presentation/screens/lock_screen.dart';
import 'package:expenselab/features/settings/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseLabApp extends ConsumerStatefulWidget {
  const ExpenseLabApp({super.key});

  @override
  ConsumerState<ExpenseLabApp> createState() => _ExpenseLabAppState();
}

class _ExpenseLabAppState extends ConsumerState<ExpenseLabApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    _initLocale();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initLockState());
  }

  Future<void> _initLocale() async {
    final settings = await ref.read(settingsProvider.future);
    final locale = settings.locale;
    LocaleSettings.setLocale(locale);
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
    // If biometricLogin is true, isLockedProvider stays true and LockScreen handles auth.
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
        if (biometricEnabled && isLocked) {
          return const LockScreen();
        }
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
