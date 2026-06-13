import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'member_levels_response_model.freezed.dart';
part 'member_levels_response_model.g.dart';

String memberLevelsResponseModelToJson(MemberLevelsResponseModel data) =>
    json.encode(data.toJson());

@freezed
class MemberLevelsResponseModel with _$MemberLevelsResponseModel {
  const factory MemberLevelsResponseModel({
    @JsonKey(name: "deposit") required Deposit deposit,
    @JsonKey(name: "withdraw") required Deposit withdraw,
    @JsonKey(name: "trading") required Deposit trading,
  }) = _MemberLevelsResponseModel;

  factory MemberLevelsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MemberLevelsResponseModelFromJson(json);
}

@freezed
class Deposit with _$Deposit {
  const factory Deposit({
    @JsonKey(name: "minimum_level") required int minimumLevel,
  }) = _Deposit;

  factory Deposit.fromJson(Map<String, dynamic> json) =>
      _$DepositFromJson(json);
}
