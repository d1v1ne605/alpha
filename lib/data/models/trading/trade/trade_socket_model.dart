import 'package:alpha/data/models/trading/trade/trade_history_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trade_socket_model.freezed.dart';
part 'trade_socket_model.g.dart';

TradeHistoryModel fromSocketToTradeHistoryModel(
  TradeSocketModel tradeSocketModel,
) {
  return TradeHistoryModel(
    id: tradeSocketModel.id,
    price: tradeSocketModel.price,
    amount: tradeSocketModel.amount,
    total: tradeSocketModel.total,
    market: tradeSocketModel.market,
    createdAt: DateTime.fromMillisecondsSinceEpoch(
      tradeSocketModel.createdAt,
    ).toIso8601String(),
    takerType: tradeSocketModel.takerType,
    feeCurrency: '',
    fee: '',
    feeAmount: '',
    side: tradeSocketModel.side,
    orderId: tradeSocketModel.orderId,
  );
}

@freezed
class TradeSocketModel with _$TradeSocketModel {
  const factory TradeSocketModel({
    required String amount,
    @JsonKey(name: "created_at") required int createdAt,
    required int id,
    required String market,
    @JsonKey(name: "order_id") required int orderId,
    required String price,
    required String side,
    @JsonKey(name: "taker_type") required String takerType,
    required String total,
  }) = _TradeSocketModel;

  factory TradeSocketModel.fromJson(Map<String, dynamic> json) =>
      _$TradeSocketModelFromJson(json);
}
