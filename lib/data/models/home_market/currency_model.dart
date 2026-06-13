import 'package:freezed_annotation/freezed_annotation.dart';

part 'currency_model.freezed.dart';
part 'currency_model.g.dart';

@freezed
class CurrencyModel with _$CurrencyModel {
  const factory CurrencyModel({
    required String id,
    required String name,
    String? description,
    String? homepage,
    required String price,
    required String blockchain_key,
    String? explorer_transaction,
    String? explorer_address,
    required String type,
    required bool deposit_enabled,
    required bool withdrawal_enabled,
    required String deposit_fee,
    required String min_deposit_amount,
    required String withdraw_fee,
    required String min_withdraw_amount,
    required String withdraw_limit_24h,
    required String withdraw_limit_72h,
    required int? base_factor,
    required int precision,
    required int position,
    required String icon_url,
    required int min_confirmations,
    String? volume,
    String? change,
    String? last,
    @JsonKey(name: "blockchain_name") String? blockchainName,
    bool? visible,
    @JsonKey(name: "parent_id") String? parentId,
    String? avg_price,
    String? high,
    String? low,
    String? open,
    String? price_change_percent,
    String? ticker_volume,
    String? amount,
    @Default(false) bool ishar,
  }) = _CurrencyModel;

  factory CurrencyModel.fromJson(Map<String, dynamic> json) =>
      _$CurrencyModelFromJson(json);
}
