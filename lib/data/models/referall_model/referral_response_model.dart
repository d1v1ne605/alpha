import 'package:alpha/data/models/referall_model/commission_model.dart';
import 'package:alpha/data/models/referall_model/rewards_model.dart';
import 'package:alpha/data/models/referall_model/referral_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'referral_response_model.freezed.dart';
part 'referral_response_model.g.dart';

@freezed
class ReferralResponse with _$ReferralResponse {
  const factory ReferralResponse({
    required bool cached,
    required dynamic query,
    required List<ReferralModel> referral_history,
    required int referral_count,
    required List<CommissionModel> commissions,
    required String estimated_earnings,
    required int traded_referral_count,
    required dynamic rank,
    required List<RewardsModel> reward_histories,
    required List<CommissionModel> today_commissions,
  }) = _ReferralResponse;

  factory ReferralResponse.fromJson(Map<String, dynamic> json) =>
      _$ReferralResponseFromJson(json);
}
