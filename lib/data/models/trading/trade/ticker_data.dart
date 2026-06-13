import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticker_data.freezed.dart';
part 'ticker_data.g.dart';

@freezed
class TickerData with _$TickerData {
  const factory TickerData({
    required String amount,
    required String at,
    @JsonKey(name: 'avg_price') required String avgPrice,
    required String high,
    required String last,
    required String low,
    required String open,
    @JsonKey(name: 'price_change_percent') required String priceChangePercent,
    required String volume,
  }) = _TickerData;

  factory TickerData.fromJson(Map<String, dynamic> json) =>
      _$TickerDataFromJson(json);
}