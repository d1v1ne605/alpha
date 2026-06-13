import 'package:alpha/data/models/asset/Record/currency_decord_model.dart';
import 'package:alpha/data/models/asset/withdraw/currency_withdraw_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'record_model.freezed.dart';
part 'record_model.g.dart';

@freezed
class RecordResponse with _$RecordResponse {
  const factory RecordResponse({
    List<RecordData>? data,
    Pagination? pagination,
  }) = _RecordResponse;

  factory RecordResponse.fromJson(dynamic json) {
    if (json is List) {
      return RecordResponse(
        data: json
            .map((e) => RecordData.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    }
    if (json is Map<String, dynamic> && json["data"] != null) {
      return RecordResponse(
        data: (json["data"] as List<dynamic>)
            .map((e) => RecordData.fromJson(e as Map<String, dynamic>))
            .toList(),
        pagination: json["pagination"] != null
            ? Pagination.fromJson(json["pagination"] as Map<String, dynamic>)
            : null,
      );
    }
    return const RecordResponse();
  }
}

@freezed
class RecordData with _$RecordData {
  const factory RecordData({
    @JsonKey(name: "id") required dynamic id,
    @JsonKey(name: "tid") required String tid,
    @JsonKey(name: "rid") required String? rid,
    @JsonKey(name: "uid") required String? uid,
    @JsonKey(name: "txid") required String txid,
    @JsonKey(name: "blockchain_txid") required String? blockchainTxid,
    @JsonKey(name: "blockchain_key") required String? blockchainKey,
    @JsonKey(name: "blockchain_name") required String? blockchainName,
    @JsonKey(name: "withdraw_currency")
    required CurrencyDecordModel? withdrawCurrency,
    @JsonKey(name: "withdraw_amount") required String? withdrawAmount,
    @JsonKey(name: "fee_amount") required String? feeAmount,
    @JsonKey(name: "fee_currency") required CurrencyDecordModel? feeCurrency,
    @JsonKey(name: "fee") required String? fee,
    @JsonKey(name: "status") required String? status,
    @JsonKey(name: "currency") required String? currency,
    @JsonKey(name: "state") required String? state,
    @JsonKey(name: "transfer_type") required String? transferType,
    @JsonKey(name: "confirmations") required int? confirmations,
    @JsonKey(name: "amount") required String? amount,
    @JsonKey(name: "createdAt") required DateTime? createdAt,
    @JsonKey(name: "updatedAt") required DateTime? updatedAt,
    @JsonKey(name: "created_at") required DateTime? created_at,
    @JsonKey(name: "completed_at") required DateTime? completed_at,
    @JsonKey(includeFromJson: false, includeToJson: false) String? iconUrl,
  }) = _RecordData;

  factory RecordData.fromJson(Map<String, dynamic> json) =>
      _$RecordDataFromJson(json);
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
