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

    final result = await ref
        .read(biometricServiceProvider)
        .authenticate('Verify your identity to access ExpenseLab');

    if (!mounted) return;

    switch (result) {
      case BiometricResult.success:
        ref.read(isLockedProvider.notifier).unlock();

      case BiometricResult.notAvailable:
        // Biometrics were removed from the device — disable the setting and unlock.
        await ref.read(settingsProvider.notifier).setBiometricLogin(false);
        ref.read(isLockedProvider.notifier).unlock();

      case BiometricResult.failure:
        setState(() {
          _isAuthenticating = false;
          _notAvailable = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF111714) : const Color(0xFFF4F8F5),
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
                'ExpenseLab',
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1C221E),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _notAvailable
                    ? 'Biometrics unavailable on this device'
                    : 'Authenticate to continue',
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 14,
                  color: isDark ? Colors.white54 : const Color(0xFF9EAEA2),
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
                    'Try Again',
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      color: isDark ? Colors.white54 : const Color(0xFF9EAEA2),
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
