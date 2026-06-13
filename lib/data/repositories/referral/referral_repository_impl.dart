import 'package:alpha/data/models/referall_model/referral_response_model.dart';
import 'package:alpha/data/models/referall_model/top_ranking_response_model.dart';
import 'package:alpha/data/repositories/referral/referral_repository.dart';
import 'package:alpha/data/services/home/home_api_service.dart';

class ReferralRepositoryImpl implements ReferralRepository {
  final HomeApiService api;

  ReferralRepositoryImpl(this.api);

  @override
  Future<ReferralResponse> fetchReferrals() {
    return api.getReferral();
  }

  @override
  Future<TopRankingResponseModel> fetchTopRankings() {
    return api.getTopRankings();
  }
}
