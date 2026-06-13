import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'execute_withdraw_request_model.freezed.dart';
part 'execute_withdraw_request_model.g.dart';

@freezed
class ExecuteWithdrawRequestModel with _$ExecuteWithdrawRequestModel {
  const factory ExecuteWithdrawRequestModel({
    @JsonKey(name: "uid") required String uid,
    @JsonKey(name: "fee_currency") required String feeCurrency,
    @JsonKey(name: "fee") required String fee,
    @JsonKey(name: "amount") required double amount,
    @JsonKey(name: "currency") required String currency,
    @JsonKey(name: "otp") required String otp,
    @JsonKey(name: "beneficiary_id") required String beneficiaryId,
  }) = _ExecuteWithdrawRequestModel;

  factory ExecuteWithdrawRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ExecuteWithdrawRequestModelFromJson(json);
}
