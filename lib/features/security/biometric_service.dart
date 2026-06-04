import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

final biometricServiceProvider = Provider<BiometricService>((_) => BiometricService());

enum BiometricResult { success, failure, notAvailable }

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Returns true only when the device has enrolled biometrics AND a passcode
  /// set up — i.e. calling [authenticate] will not throw NotAvailable.
  Future<bool> canAuthenticate() async {
    try {
      if (!await _auth.isDeviceSupported()) return false;
      if (!await _auth.canCheckBiometrics) return false;
      final enrolled = await _auth.getAvailableBiometrics();
      return enrolled.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<BiometricResult> authenticate(String reason) async {
    try {
      // Guard before calling authenticate so the platform never sees the
      // NotAvailable / PasscodeNotSet state and throws a PlatformException.
      if (!await canAuthenticate()) return BiometricResult.notAvailable;

      final success = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
      return success ? BiometricResult.success : BiometricResult.failure;
    } on PlatformException catch (e) {
      if (e.code == 'NotAvailable' ||
          e.code == 'NotEnrolled' ||
          e.code == 'PasscodeNotSet') {
        return BiometricResult.notAvailable;
      }
      return BiometricResult.failure;
    } catch (_) {
      return BiometricResult.failure;
    }
  }
}
