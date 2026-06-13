import 'package:freezed_annotation/freezed_annotation.dart';

part 'earn_wallets.freezed.dart';
part 'earn_wallets.g.dart';

@freezed
class EarnWalletsResponse with _$EarnWalletsResponse {
  const factory EarnWalletsResponse({
    required List<EarnWalletItem> wallets,
    @JsonKey(name: 'estimated_total_assets')
    required EarnEstimatedTotalAssets estimatedTotalAssets,
  }) = _EarnWalletsResponse;

  factory EarnWalletsResponse.fromJson(Map<String, dynamic> json) =>
      _$EarnWalletsResponseFromJson(json);
}

@freezed
class EarnWalletItem with _$EarnWalletItem {
  const factory EarnWalletItem({
    required String id,
    required EarnWalletData wallet,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _EarnWalletItem;

  factory EarnWalletItem.fromJson(Map<String, dynamic> json) =>
      _$EarnWalletItemFromJson(json);
}

@freezed
class EarnWalletData with _$EarnWalletData {
  const factory EarnWalletData({
    required String balance,
    @JsonKey(name: 'usdt_balance') required String usdtBalance,
    required String locked,
    @JsonKey(name: 'currency_id') required String currencyId,
    @JsonKey(name: 'currency_name') required String currencyName,
    @JsonKey(name: 'icon_url') required String iconUrl,
  }) = _EarnWalletData;

  factory EarnWalletData.fromJson(Map<String, dynamic> json) =>
      _$EarnWalletDataFromJson(json);
}

@freezed
class EarnEstimatedTotalAssets with _$EarnEstimatedTotalAssets {
  const factory EarnEstimatedTotalAssets({
    required double usdt,
    required double btc,
    required double eth,
  }) = _EarnEstimatedTotalAssets;

  factory EarnEstimatedTotalAssets.fromJson(Map<String, dynamic> json) =>
      _$EarnEstimatedTotalAssetsFromJson(json);
}
