import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'withdraw_limit_model.freezed.dart';
part 'withdraw_limit_model.g.dart';

@freezed
class WithdrawLimitModel with _$WithdrawLimitModel {
  const factory WithdrawLimitModel({
    @JsonKey(name: "data") required LimitData limitData,
    @JsonKey(name: "cached") required bool cached,
    @JsonKey(name: "timestamp") required DateTime timestamp,
  }) = _WithdrawLimitModel;

  factory WithdrawLimitModel.fromJson(Map<String, dynamic> json) =>
      _$WithdrawLimitModelFromJson(json);
}

@freezed
class LimitData with _$LimitData {
  const factory LimitData({
    @JsonKey(name: "uid") required String uid,
    @JsonKey(name: "isLimitWithdraw") required bool isLimitWithdraw,
  }) = _LimitData;

  factory LimitData.fromJson(Map<String, dynamic> json) =>
      _$LimitDataFromJson(json);
}
