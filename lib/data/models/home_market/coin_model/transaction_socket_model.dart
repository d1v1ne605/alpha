import 'package:alpha/data/models/home_market/coin_model/transaction_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_socket_model.freezed.dart';
part 'transaction_socket_model.g.dart';

TransactionModel fromSocketToTransactionModel(
  TransactionSocketModel transactionSocketModel,
  String currentCoinId,
) {
  return TransactionModel(
    id: transactionSocketModel.tid,
    price: double.parse(transactionSocketModel.price),
    amount: double.parse(transactionSocketModel.amount),
    total: 0,
    market: currentCoinId,
    createdAt: transactionSocketModel.date,
    takerType: transactionSocketModel.takerType,
  );
}

@freezed
class TransactionSocketModel with _$TransactionSocketModel {
  const factory TransactionSocketModel({
    required String amount,
    required int date,
    required String price,
    @JsonKey(name: "taker_type") required String takerType,
    required int tid,
  }) = _TransactionSocketModel;

  factory TransactionSocketModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionSocketModelFromJson(json);
}
