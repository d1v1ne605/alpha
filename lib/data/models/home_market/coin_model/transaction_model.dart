import 'package:alpha/data/models/home_market/coin_model/transaction_interface.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
class TransactionModel with _$TransactionModel implements ITransaction {
  const factory TransactionModel({
    required int id,
    required double price,
    required double amount,
    required double total,
    required String market,
    @JsonKey(name: 'created_at') required int createdAt,
    @JsonKey(name: 'taker_type') required String takerType,
  }) = _TransactionModel;
  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}
