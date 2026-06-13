import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'delete_beneficiary_request_model.freezed.dart';
part 'delete_beneficiary_request_model.g.dart';

@freezed
class DeleteBeneficiaryRequestModel with _$DeleteBeneficiaryRequestModel {
  const factory DeleteBeneficiaryRequestModel({
    @JsonKey(name: "address") required String address,
  }) = _DeleteBeneficiaryRequestModel;

  factory DeleteBeneficiaryRequestModel.fromJson(Map<String, dynamic> json) =>
      _$DeleteBeneficiaryRequestModelFromJson(json);
}
