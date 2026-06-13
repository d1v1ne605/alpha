import 'package:alpha/data/models/earn/withdraw_request_model.dart';
import 'package:alpha/data/repositories/earn/earn_repository.dart';

class ExecuteWithdrawEarnUseCase {
  EarnRepository _earnRepository;

  ExecuteWithdrawEarnUseCase(this._earnRepository);

  Future<void> call(WithdrawRequestModel request) async {
    await _earnRepository.withdrawEarn(request);
  }
}
