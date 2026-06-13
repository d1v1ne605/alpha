import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'beneficiaries_model.freezed.dart';
part 'beneficiaries_model.g.dart';

@freezed
class BeneficiariesModel with _$BeneficiariesModel {
  const factory BeneficiariesModel({
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "currency") required String currency,
    @JsonKey(name: "uid") required String uid,
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "description") required dynamic description,
    @JsonKey(name: "data") required AddressData addressData,
    @JsonKey(name: "state") required String state,
    @JsonKey(name: "sent_at") required DateTime sentAt,
  }) = _BeneficiariesModel;

  factory BeneficiariesModel.fromJson(Map<String, dynamic> json) =>
      _$BeneficiariesModelFromJson(json);
}

@freezed
class AddressData with _$AddressData {
  const factory AddressData({
    @JsonKey(name: "address") required String address,
  }) = _AddressData;

  factory AddressData.fromJson(Map<String, dynamic> json) =>
      _$AddressDataFromJson(json);
}
