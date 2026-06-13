import 'package:alpha/data/models/asset/withdraw/currency_withdraw_model.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdraw_history_model.freezed.dart';
part 'withdraw_history_model.g.dart';

@freezed
class WithdrawHistoryModel with _$WithdrawHistoryModel {
  const factory WithdrawHistoryModel({
    @JsonKey(name: "data") required List<HistoryData> historyData,
    @JsonKey(name: "pagination") required Pagination pagination,
  }) = _WithdrawHistoryModel;

  factory WithdrawHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$WithdrawHistoryModelFromJson(json);
}

@freezed
class HistoryData with _$HistoryData {
  const factory HistoryData({
    @JsonKey(name: "id") required String id,
    @JsonKey(name: "tid") required String tid,
    @JsonKey(name: "rid") required String rid,
    @JsonKey(name: "uid") required String uid,
    @JsonKey(name: "txid") required String txid,
    @JsonKey(name: "blockchain_txid") required String blockchainTxid,
    @JsonKey(name: "blockchain_key") required String blockchainKey,
    @JsonKey(name: "blockchain_name") required String blockchainName,
    @JsonKey(name: "withdraw_currency")
    required CurrencyWithdrawModel withdrawCurrency,
    @JsonKey(name: "withdraw_amount") required String withdrawAmount,
    @JsonKey(name: "fee_amount") required String feeAmount,
    @JsonKey(name: "fee_currency") required CurrencyWithdrawModel feeCurrency,
    @JsonKey(name: "status") required String status,
    @JsonKey(name: "createdAt") required DateTime createdAt,
    @JsonKey(name: "updatedAt") required DateTime updatedAt,
  }) = _HistoryData;

  factory HistoryData.fromJson(Map<String, dynamic> json) =>
      _$HistoryDataFromJson(json);
}

@freezed
class Pagination with _$Pagination {
  const factory Pagination({
    @JsonKey(name: "total") required int total,
    @JsonKey(name: "page") required int page,
    @JsonKey(name: "limit") required int limit,
    @JsonKey(name: "totalPages") required int totalPages,
  }) = _Pagination;

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);
}
