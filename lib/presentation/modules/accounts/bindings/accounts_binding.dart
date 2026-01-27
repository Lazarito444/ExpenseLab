import 'package:expense_lab/presentation/modules/accounts/controllers/accounts_controller.dart';
import 'package:get/get.dart';

class AccountsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountsController>(() => AccountsController());
  }
}
