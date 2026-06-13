import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_log_model.freezed.dart';
part 'account_log_model.g.dart';

@freezed
abstract class AccountLogModel with _$AccountLogModel {
  const factory AccountLogModel({
    required int id,
    @JsonKey(name: 'user_ip') required String userIp,
    @JsonKey(name: 'user_ip_country') required String userIpCountry,
    @JsonKey(name: 'user_agent') required String userAgent,
    required String topic,
    required String action,
    required String result,
    String? data,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _AccountLogModel;

  factory AccountLogModel.fromJson(Map<String, dynamic> json) =>
      _$AccountLogModelFromJson(json);
}