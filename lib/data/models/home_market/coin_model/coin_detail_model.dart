import 'package:freezed_annotation/freezed_annotation.dart';

part 'coin_detail_model.freezed.dart';
part 'coin_detail_model.g.dart';

@freezed
class CoinDetailModel with _$CoinDetailModel {
  const factory CoinDetailModel({
    required int id,
    required String currencyId,
    required String title,
    required String information,
    required String officialWebsite,
    DateTime? releaseDate,
    int? maximumSupply,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? position,
    required String blockchainType,
    required String blockchainExplorerDisplay,
    required String blockchainExplorerUrl,
    @Default([]) List<TokenSocial> tokenSocials,
    String? last,
    String? volume,
    String? price_change_percent,
    String? avg_price,
    String? high,
    String? low,
    String? open,
    String? amount,
    String? icon_url,
    String? price,
    @Default(false) bool ishar,
  }) = _CoinDetailModel;

  factory CoinDetailModel.fromJson(Map<String, dynamic> json) => _$CoinDetailModelFromJson(json);
}

@freezed
class TokenSocial with _$TokenSocial {
  const factory TokenSocial({
    required int id,
    required String tokenId,
    required String url,
    required String? socialType,
  }) = _TokenSocial;

  factory TokenSocial.fromJson(Map<String, dynamic> json) => _$TokenSocialFromJson(json);
}
