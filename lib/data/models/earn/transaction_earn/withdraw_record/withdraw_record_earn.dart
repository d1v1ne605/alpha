import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdraw_record_earn.freezed.dart';
part 'withdraw_record_earn.g.dart';

@freezed
class WithdrawRecordEarn with _$WithdrawRecordEarn {
  const factory WithdrawRecordEarn({
    required List<WithdrawRecordData> data,
    required WithdrawRecordMeta meta,
  }) = _WithdrawRecordEarn;

  factory WithdrawRecordEarn.fromJson(Map<String, dynamic> json) =>
      _$WithdrawRecordEarnFromJson(json);
}

@freezed
class WithdrawRecordData with _$WithdrawRecordData {
  const factory WithdrawRecordData({
    required String date,
    required String duration,
    required String amount,
    required String coin,
    @JsonKey(name: 'usdt_amount') required String usdtAmount,
    required String status,
    @JsonKey(name: 'icon_url') required String iconUrl,
    String? error,
  }) = _WithdrawRecordData;

  factory WithdrawRecordData.fromJson(Map<String, dynamic> json) =>
      _$WithdrawRecordDataFromJson(json);
}

@freezed
class WithdrawRecordMeta with _$WithdrawRecordMeta {
  const factory WithdrawRecordMeta({
    required int total,
    required String page,
    required String limit,
    required int totalPages,
  }) = _WithdrawRecordMeta;

  factory WithdrawRecordMeta.fromJson(Map<String, dynamic> json) =>
      _$WithdrawRecordMetaFromJson(json);
}
