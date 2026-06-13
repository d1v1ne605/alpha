import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'execute_withdraw_response_model.freezed.dart';
part 'execute_withdraw_response_model.g.dart';

@freezed
class ExecuteWithdrawResponseModel with _$ExecuteWithdrawResponseModel {
  const factory ExecuteWithdrawResponseModel({
    @JsonKey(name: "code") String? code,
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "data") Data? data,
  }) = _ExecuteWithdrawResponseModel;

  factory ExecuteWithdrawResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExecuteWithdrawResponseModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "new_withdraw_balance") required String newWithdrawBalance,
    @JsonKey(name: "new_fee_balance") required String? newFeeBalance,
    @JsonKey(name: "withdraw_history_id") required int withdrawHistoryId,
    @JsonKey(name: "peatio_withdraw_id") required int peatioWithdrawId,
    @JsonKey(name: "total_time") required int totalTime,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}
