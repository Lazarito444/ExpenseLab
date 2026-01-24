import 'package:expense_lab/domain/entities/account.dart';
import 'package:expense_lab/domain/repositories/i_account_repository.dart';

class GetAccountsUseCase {
  final IAccountRepository _accountRepository;

  GetAccountsUseCase(this._accountRepository);

  Future<List<Account>> execute() async {
    final List<Account> allAccounts = await _accountRepository.getAll();

    return allAccounts.where((Account acc) => !acc.isArchived).toList();
  }
}
