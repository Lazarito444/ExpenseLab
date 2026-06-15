import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:expenselab/core/i18n/strings.g.dart';
import 'package:expenselab/features/security/biometric_service.dart';
import 'package:expenselab/features/security/lock_provider.dart';
import 'package:expenselab/features/settings/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  bool _isAuthenticating = false;
  bool _notAvailable = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _authenticate());
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating || !mounted) return;
    setState(() {
      _isAuthenticating = true;
      _notAvailable = false;
    });

    final reason = context.t.security.lock_screen.reason;
    final result = await ref
        .read(biometricServiceProvider)
        .authenticate(reason);

    if (!mounted) return;

    switch (result) {
      case BiometricResult.success:
        ref.read(isLockedProvider.notifier).unlock();

      case BiometricResult.notAvailable:
        setState(() {
          _notAvailable = true;
          _isAuthenticating = false;
        });
        // Biometrics were removed from the device — disable the setting and unlock.
        await ref.read(settingsProvider.notifier).setBiometricLogin(false);
        if (mounted) ref.read(isLockedProvider.notifier).unlock();

      case BiometricResult.failure:
        setState(() {
          _isAuthenticating = false;
          _notAvailable = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final primary = context.colorScheme.primary;

    return Scaffold(
      backgroundColor: appColors.scaffoldBackground,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(Icons.lock_rounded, size: 40, color: primary),
              ),
              const SizedBox(height: 28),
              Text(
                context.t.app.name,
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: appColors.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _notAvailable
                    ? context.t.security.lock_screen.subtitle_unavailable
                    : context.t.security.lock_screen.subtitle_authenticate,
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 14,
                  color: appColors.secondaryLabel,
                ),
              ),
              const SizedBox(height: 56),
              if (_isAuthenticating)
                SizedBox(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(
                    color: primary,
                    strokeWidth: 2.5,
                  ),
                )
              else
                GestureDetector(
                  onTap: _authenticate,
                  child: Icon(
                    Icons.fingerprint_rounded,
                    size: 72,
                    color: primary,
                  ),
                ),
              const SizedBox(height: 20),
              if (!_isAuthenticating)
                TextButton(
                  onPressed: _authenticate,
                  child: Text(
                    context.t.security.lock_screen.try_again,
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      color: appColors.secondaryLabel,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
