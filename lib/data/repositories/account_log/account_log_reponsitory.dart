
import '../../models/account_log_model/account_log_model.dart';

abstract class AccountLogReponsitory {
  Future<List<AccountLogModel>> getAccountLogs();
}
