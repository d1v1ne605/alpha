import 'package:freezed_annotation/freezed_annotation.dart';

part 'referral_model.freezed.dart';
part 'referral_model.g.dart';

@freezed
class ReferralModel with _$ReferralModel {
  const factory ReferralModel({
    required String id,
    required String email,
    required String uid,
    required String date,
  }) = _ReferralModel;

  factory ReferralModel.fromJson(Map<String, dynamic> json) =>
      _$ReferralModelFromJson(json);
}
