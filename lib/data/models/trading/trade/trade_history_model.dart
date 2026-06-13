import 'package:alpha/data/models/home_market/coin_model/transaction_interface.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trade_history_model.freezed.dart';
part 'trade_history_model.g.dart';

@freezed
class TradeHistoryModel with _$TradeHistoryModel implements ITransaction {
  const factory TradeHistoryModel({
    required int id,
    required String price,
    required String amount,
    required String total,
    required String market,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'taker_type') required String takerType,
    @JsonKey(name: "fee_currency") required String feeCurrency,
    required String fee,
    @JsonKey(name: "fee_amount") required String feeAmount,
    required String side,
    @JsonKey(name: "order_id") required int orderId,
  }) = _TradeHistoryModel;

  factory TradeHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$TradeHistoryModelFromJson(json);
}
