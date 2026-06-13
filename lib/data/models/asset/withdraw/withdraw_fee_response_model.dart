import 'package:alpha/data/models/asset/withdraw/currency_withdraw_model.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdraw_fee_response_model.freezed.dart';
part 'withdraw_fee_response_model.g.dart';

@freezed
class WithdrawFeeResponseModel with _$WithdrawFeeResponseModel {
  const factory WithdrawFeeResponseModel({
    @JsonKey(name: "data") required WithdrawFeeData withdrawFeeData,
    @JsonKey(name: "cached") required bool cached,
    @JsonKey(name: "timestamp") required DateTime timestamp,
  }) = _WithdrawFeeResponseModel;

  factory WithdrawFeeResponseModel.fromJson(Map<String, dynamic> json) =>
      _$WithdrawFeeResponseModelFromJson(json);
}

@freezed
class WithdrawFeeData with _$WithdrawFeeData {
  const factory WithdrawFeeData({
    @JsonKey(name: "currency_id") required String currencyId,
    @JsonKey(name: "currency_info") required CurrencyWithdrawModel currencyInfo,
    @JsonKey(name: "fees") required List<Fee> fees,
    @JsonKey(name: "total") required int total,
  }) = _WithdrawFeeData;

  factory WithdrawFeeData.fromJson(Map<String, dynamic> json) =>
      _$WithdrawFeeDataFromJson(json);
}

@freezed
class Fee with _$Fee {
  const factory Fee({
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "fee_currency") required String feeCurrency,
    @JsonKey(name: "fee_amount") required double feeAmount,
    @JsonKey(name: "fee_currency_info")
    required CurrencyWithdrawModel feeCurrencyInfo,
    @JsonKey(name: "created_at") required DateTime createdAt,
    @JsonKey(name: "updated_at") required DateTime updatedAt,
  }) = _Fee;

  factory Fee.fromJson(Map<String, dynamic> json) => _$FeeFromJson(json);
}
