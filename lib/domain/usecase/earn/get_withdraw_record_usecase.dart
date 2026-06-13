import 'package:alpha/data/models/earn/transaction_earn/withdraw_record/withdraw_record_earn.dart';
import 'package:alpha/data/repositories/earn/earn_repository.dart';

class GetWithdrawRecordUsecase {
  EarnRepository _earnRepository;

  GetWithdrawRecordUsecase(this._earnRepository);

  Future<WithdrawRecordEarn> call(int page, int limit, String language) async {
    return await _earnRepository.getWithdrawEarnHistory(page, limit, language);
  }
}
