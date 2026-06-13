import '../../../data/models/account_log_model/account_log_model.dart';
import '../../../data/repositories/account_log/account_log_reponsitory.dart';

class AccountLogUseCase {
  final AccountLogReponsitory _accountLogReponsitory;
  AccountLogUseCase(this._accountLogReponsitory);

  Future<List<AccountLogModel>> call() async {
    return await _accountLogReponsitory.getAccountLogs();
  }
}
