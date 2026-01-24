import 'package:expense_lab/domain/entities/account.dart';
import 'package:expense_lab/domain/repositories/i_account_repository.dart';
import 'package:expense_lab/domain/repositories/i_event_repository.dart';

class CreateAccountUseCase {
  final IAccountRepository _accountRepository;
  final IEventRepository _eventRepository;

  static const String eventType = 'ACCOUNT_CREATED';

  CreateAccountUseCase(this._accountRepository, this._eventRepository);

  Future<void> execute(Account account) async {
    final int accountId = await _accountRepository.upsert(account);

    await _eventRepository.recordEvent(
      aggregateId: accountId.toString(),
      eventType: eventType,
      payload: <String, dynamic>{
        'name': account.name,
        'initialBalance': account.currentBalance,
        'currency': account.currencyCode,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }
}
