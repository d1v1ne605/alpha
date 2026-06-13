import 'package:alpha/data/models/trading/trade/order_item_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_socket_model.freezed.dart';
part 'order_socket_model.g.dart';

OrderItemModel fromSocketToOrderItemModel(OrderSocketModel socketModel) {
  return OrderItemModel(
    id: socketModel.id,
    uuid: '',
    side: socketModel.side,
    ordType: socketModel.ordType,
    price: socketModel.price,
    avgPrice: socketModel.avgPrice,
    state: socketModel.state,
    market: socketModel.market,
    createdAt: DateTime.fromMillisecondsSinceEpoch(socketModel.createdAt),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(socketModel.updatedAt),
    originVolume: socketModel.originVolume,
    remainingVolume: socketModel.remainingVolume,
    executedVolume: socketModel.executedVolume,
    makerFee: null,
    takerFee: null,
    tradesCount: socketModel.tradesCount,
  );
}

@freezed
class OrderSocketModel with _$OrderSocketModel {
  const factory OrderSocketModel({
    @JsonKey(name: "at") required int at,
    @JsonKey(name: "avg_price") required String avgPrice,
    @JsonKey(name: "created_at") required int createdAt,
    @JsonKey(name: "executed_volume") required String executedVolume,
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "kind") required String kind,
    @JsonKey(name: "market") required String market,
    @JsonKey(name: "ord_type") required String ordType,
    @JsonKey(name: "origin_volume") required String originVolume,
    @JsonKey(name: "price") String? price,
    @JsonKey(name: "remaining_volume") required String remainingVolume,
    @JsonKey(name: "side") required String side,
    @JsonKey(name: "state") required String state,
    @JsonKey(name: "trades_count") required int tradesCount,
    @JsonKey(name: "updated_at") required int updatedAt,
  }) = _OrderSocketModel;

  factory OrderSocketModel.fromJson(Map<String, dynamic> json) =>
      _$OrderSocketModelFromJson(json);
}
