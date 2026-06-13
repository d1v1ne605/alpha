import 'package:alpha/data/models/home_market/coin_model/coin_detail_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_response.freezed.dart';
part 'token_response.g.dart';

@freezed
class TokenResponse with _$TokenResponse {
  const factory TokenResponse({
    @JsonKey(name: "httpStatusCode") required int httpStatusCode,
    @JsonKey(name: "data") required TokenData data,
  }) = _TokenResponse;

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(json);
}

@freezed
class TokenData with _$TokenData {
  const factory TokenData({
    @JsonKey(name: "tokens") required List<CoinDetailModel> tokens,
    @JsonKey(name: "page") required int page,
    @JsonKey(name: "totalItemCount") required int totalItemCount,
    @JsonKey(name: "totalPageCount") required int totalPageCount,
  }) = _TokenData;

  factory TokenData.fromJson(Map<String, dynamic> json) =>
      _$TokenDataFromJson(json);
}
