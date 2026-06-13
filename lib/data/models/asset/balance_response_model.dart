import 'package:alpha/data/models/asset/deposit_address_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'balance_response_model.freezed.dart';
part 'balance_response_model.g.dart';

@freezed
class BalanceResponseModel with _$BalanceResponseModel {
  const factory BalanceResponseModel({
    required String currency,
    required String balance,
    required String locked,
    @JsonKey(name: "deposit_address")
    required DepositAddressModel? depositAddress,
  }) = _BalanceResponseModel;

  factory BalanceResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BalanceResponseModelFromJson(json);
}
