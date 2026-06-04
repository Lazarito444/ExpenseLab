import 'package:flutter_riverpod/flutter_riverpod.dart';

class LockNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void lock() => state = true;
  void unlock() => state = false;
}

final isLockedProvider = NotifierProvider<LockNotifier, bool>(LockNotifier.new);
