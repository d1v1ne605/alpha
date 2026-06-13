import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticker_model.freezed.dart';
part 'ticker_model.g.dart';

@freezed
class TickerModel with _$TickerModel {
  const factory TickerModel({
    required String at,
    required String avg_price,
    required String high,
    required String last,
    required String low,
    required String open,
    required String price_change_percent,
    required String volume,
    required String amount,
  }) = _TickerModel;

  factory TickerModel.fromJson(Map<String, dynamic> json) =>
      _$TickerModelFromJson(json);
}
