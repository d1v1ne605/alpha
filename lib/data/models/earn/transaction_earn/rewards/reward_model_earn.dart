import 'package:freezed_annotation/freezed_annotation.dart';

part 'reward_model_earn.freezed.dart';
part 'reward_model_earn.g.dart';

@freezed
class RewardModelEarn with _$RewardModelEarn {
  const factory RewardModelEarn({
    required List<RewardData> data,
    required RewardMeta meta,
  }) = _RewardModelEarn;

  factory RewardModelEarn.fromJson(Map<String, dynamic> json) =>
      _$RewardModelEarnFromJson(json);
}

@freezed
class RewardData with _$RewardData {
  const factory RewardData({
    @JsonKey(name: "_id") required String id,
    required String uid,
    required String date,
    required String duration,
    required String amount,
    @JsonKey(name: "currency_id") required String currencyId,
    @JsonKey(name: "currency_name") required String currencyName,
    @JsonKey(name: "usdt_amount") required String usdtAmount,
    @JsonKey(name: "icon_url") required String iconUrl,
    @JsonKey(name: "product_type") required String productType,
  }) = _RewardData;

  factory RewardData.fromJson(Map<String, dynamic> json) =>
      _$RewardDataFromJson(json);
}

@freezed
class RewardMeta with _$RewardMeta {
  const factory RewardMeta({
    required int total,
    required int page,
    required int limit,
    required int totalPages,
    @JsonKey(name: "reward_currencies")
    required List<RewardCurrency> rewardCurrencies,
  }) = _RewardMeta;

  factory RewardMeta.fromJson(Map<String, dynamic> json) =>
      _$RewardMetaFromJson(json);
}

@freezed
class RewardCurrency with _$RewardCurrency {
  const factory RewardCurrency({
    @JsonKey(name: "currency_id") required String currencyId,
    @JsonKey(name: "currency_name") required String currencyName,
    @JsonKey(name: "icon_url") required String iconUrl,
  }) = _RewardCurrency;

  factory RewardCurrency.fromJson(Map<String, dynamic> json) =>
      _$RewardCurrencyFromJson(json);
}
