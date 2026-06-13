import 'package:freezed_annotation/freezed_annotation.dart';

part 'coin_model.freezed.dart';
part 'coin_model.g.dart';

@freezed
class CoinModel with _$CoinModel {
  const factory CoinModel({
    required String id,
    required String name,
    required String lastName,
    required String base_unit,
    required String quote_unit,
    required bool withdrawal_enabled,
    required bool deposit_enabled,
    required String iconUrl,
    required String lastPrice,
    required String lastPriceCurrency,
    required String usdPrice,
    required String volume,
    required String priceChangePercent,
    required int position,
    required int amount_precision,
    required int price_precision,
    required String high,
    required String low,
    required String amount,
    required String quote_price,
    int? min_confirmations,
    String? min_deposit_amount,
    String? min_withdraw_amount,
    String? deposit_fee,
    String? withdraw_fee,
    @Default(false) bool ishar,
  }) = _CoinModel;

  factory CoinModel.fromJson(Map<String, dynamic> json) =>
      _$CoinModelFromJson(json);
}
