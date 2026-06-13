import 'package:freezed_annotation/freezed_annotation.dart';
import 'coin_detail_model.dart';

part 'coin_detail_wrapper.freezed.dart';
part 'coin_detail_wrapper.g.dart';

@freezed
class CoinDetailWrapper with _$CoinDetailWrapper {
  const factory CoinDetailWrapper({
    required int httpStatusCode,
    required CoinDetailModel data,
  }) = _CoinDetailWrapper;

  factory CoinDetailWrapper.fromJson(Map<String, dynamic> json) =>
      _$CoinDetailWrapperFromJson(json);
}
