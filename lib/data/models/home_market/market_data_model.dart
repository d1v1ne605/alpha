import 'package:alpha/data/models/home_market/ticker_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'market_data_model.freezed.dart';
part 'market_data_model.g.dart';

@freezed
class MarketDataModel with _$MarketDataModel {
  const factory MarketDataModel({
    required String at,
    required TickerModel ticker,
  }) = _MarketDataModel;

  factory MarketDataModel.fromJson(Map<String, dynamic> json) =>
      _$MarketDataModelFromJson(json);
}
