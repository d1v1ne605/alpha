import 'package:freezed_annotation/freezed_annotation.dart';

part 'commission_model.freezed.dart';
part 'commission_model.g.dart';

@freezed
class CommissionModel with _$CommissionModel {
  const factory CommissionModel({
    required String id,
    required String referral_email,
    required String referral_uid,
    required double total,
    required String currency_id,
    required String currency_icon,
    required String date,
    required String usd_value,
    required String status,
    required String createdAt,
  }) = _CommissionModel;

  factory CommissionModel.fromJson(Map<String, dynamic> json) =>
      _$CommissionModelFromJson(json);
}
