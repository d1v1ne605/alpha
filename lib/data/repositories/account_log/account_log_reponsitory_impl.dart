import '../../models/account_log_model/account_log_model.dart';
import '../../services/account_log/account_log_api_service.dart';
import 'account_log_reponsitory.dart';

class AccountLogRepositoryImpl implements AccountLogReponsitory {
  final AccountLogApiService api;

  AccountLogRepositoryImpl(this.api);

  @override
  Future<List<AccountLogModel>> getAccountLogs() async {
    return await api.getAccountLogs();
  }
}
