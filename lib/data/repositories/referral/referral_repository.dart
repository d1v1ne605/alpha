import 'package:alpha/data/models/referall_model/referral_response_model.dart';
import 'package:alpha/data/models/referall_model/top_ranking_response_model.dart';

abstract class ReferralRepository {
  Future<ReferralResponse> fetchReferrals();
  Future<TopRankingResponseModel> fetchTopRankings();
}
