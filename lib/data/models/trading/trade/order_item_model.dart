import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_item_model.freezed.dart';
part 'order_item_model.g.dart';

@freezed
class OrderItemModel with _$OrderItemModel {
  const factory OrderItemModel({
    required int id,
    required String uuid,
    required String side,
    @JsonKey(name: "ord_type") required String ordType,
    String? price,
    @JsonKey(name: "avg_price") required String avgPrice,
    required String state,
    required String market,
    @JsonKey(name: "created_at") required DateTime createdAt,
    @JsonKey(name: "updated_at") required DateTime updatedAt,
    @JsonKey(name: "origin_volume") required String originVolume,
    @JsonKey(name: "remaining_volume") required String remainingVolume,
    @JsonKey(name: "executed_volume") required String executedVolume,
    @JsonKey(name: "maker_fee", defaultValue: "0") String? makerFee,
    @JsonKey(name: "taker_fee", defaultValue: "0") String? takerFee,
    @JsonKey(name: "trades_count") required int tradesCount,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => _$OrderItemModelFromJson(json);
}
