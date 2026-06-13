import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'currency_withdraw_model.freezed.dart';
part 'currency_withdraw_model.g.dart';

@freezed
class CurrencyWithdrawModel with _$CurrencyWithdrawModel {
  const factory CurrencyWithdrawModel({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "icon_url") String? iconUrl,
    @JsonKey(name: "precision") int? precision,
  }) = _CurrencyWithdrawModel;

  factory CurrencyWithdrawModel.fromJson(Map<String, dynamic> json) =>
      _$CurrencyWithdrawModelFromJson(json);
}
