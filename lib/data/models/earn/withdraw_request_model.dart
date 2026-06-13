import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdraw_request_model.freezed.dart';
part 'withdraw_request_model.g.dart';

@freezed
class WithdrawRequestModel with _$WithdrawRequestModel {
  const factory WithdrawRequestModel({
    required String currency,
    required double amount,
  }) = _WithdrawRequestModel;

  factory WithdrawRequestModel.fromJson(Map<String, dynamic> json) =>
      _$WithdrawRequestModelFromJson(json);
}
