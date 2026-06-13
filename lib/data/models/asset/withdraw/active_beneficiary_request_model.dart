import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'active_beneficiary_request_model.freezed.dart';
part 'active_beneficiary_request_model.g.dart';

@freezed
class ActiveBeneficiaryRequestModel with _$ActiveBeneficiaryRequestModel {
  const factory ActiveBeneficiaryRequestModel({
    @JsonKey(name: "pin") required String pin,
    @JsonKey(name: "id") required int id,
  }) = _ActiveBeneficiaryRequestModel;

  factory ActiveBeneficiaryRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ActiveBeneficiaryRequestModelFromJson(json);
}
