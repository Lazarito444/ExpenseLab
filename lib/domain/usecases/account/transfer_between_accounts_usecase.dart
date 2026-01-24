import 'package:expense_lab/domain/entities/account.dart';
import 'package:expense_lab/domain/repositories/i_account_repository.dart';
import 'package:expense_lab/domain/repositories/i_event_repository.dart';

class TransferBetweenAccountsUseCase {
  final IAccountRepository _accountRepository;
  final IEventRepository _eventRepository;

  static const String eventType = 'FUNDS_TRANSFERRED';

  TransferBetweenAccountsUseCase(this._accountRepository, this._eventRepository);

  Future<void> execute({
    required Account sourceAccount,
    required Account destinationAccount,
    required double amount,
    required double exchangeRate,
  }) async {
    final double newSourceBalance = sourceAccount.currentBalance - amount;
    final double newDestBalance = destinationAccount.currentBalance + (amount * exchangeRate);

    await _accountRepository.upsert(
      sourceAccount.copyWith(currentBalance: newSourceBalance),
    );
    await _accountRepository.upsert(
      destinationAccount.copyWith(currentBalance: newDestBalance),
    );

    await _eventRepository.recordEvent(
      aggregateId: '${sourceAccount.id}_${destinationAccount.id}',
      eventType: eventType,
      payload: <String, dynamic>{
        'fromId': sourceAccount.id,
        'toId': destinationAccount.id,
        'amount': amount,
        'rate': exchangeRate,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }
}
