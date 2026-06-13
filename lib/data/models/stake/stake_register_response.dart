import 'package:freezed_annotation/freezed_annotation.dart';

part 'stake_register_response.freezed.dart';
part 'stake_register_response.g.dart';

@freezed
class StakeRegisterResponse with _$StakeRegisterResponse {
  const factory StakeRegisterResponse({
    required String id,
    required String status,
    required int lockDays,
    required String aprBase,
    required String currencyId,
    required String amount,
    required String startedAt,
    required String unlockAt,
    required String timeRemaining,
  }) = _StakeRegisterResponse;

  factory StakeRegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$StakeRegisterResponseFromJson(json);
}
