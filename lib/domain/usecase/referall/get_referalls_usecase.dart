import 'package:alpha/data/models/referall_model/referral_response_model.dart';
import 'package:alpha/data/repositories/referral/referral_repository.dart';

class GetReferallsUsecase {
  final ReferralRepository _repository;

  GetReferallsUsecase(this._repository);

  Future<ReferralResponse> call() {
    return _repository.fetchReferrals();
  }
}
