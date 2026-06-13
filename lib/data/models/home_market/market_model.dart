import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_model.freezed.dart';
part 'market_model.g.dart';

@freezed
class MarketModel with _$MarketModel {
  const factory MarketModel({
    required String id,
    required String name,
    required String base_unit,
    required String quote_unit,
    required String min_price,
    required String max_price,
    required String min_amount,
    required int amount_precision,
    required int price_precision,
    required String state,
  }) = _MarketModel;

  factory MarketModel.fromJson(Map<String, dynamic> json) =>
      _$MarketModelFromJson(json);
}
