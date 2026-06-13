import 'package:alpha/data/models/referall_model/referral_response_model.dart';
import 'package:alpha/data/models/referall_model/top_ranking_response_model.dart';
import 'package:alpha/data/repositories/referral/referral_repository.dart';

class GetRankingUsecase {
  final ReferralRepository _repository;

  GetRankingUsecase(this._repository);

  Future<TopRankingResponseModel> call() {
    return _repository.fetchTopRankings();
  }
}
