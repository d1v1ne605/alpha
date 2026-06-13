import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'add_beneficiaries_request_model.freezed.dart';
part 'add_beneficiaries_request_model.g.dart';

@freezed
class AddBeneficiariesRequestModel with _$AddBeneficiariesRequestModel {
  const factory AddBeneficiariesRequestModel({
    @JsonKey(name: "currency") required String currency,
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "data") required String data,
  }) = _AddBeneficiariesRequestModel;

  factory AddBeneficiariesRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AddBeneficiariesRequestModelFromJson(json);
}
