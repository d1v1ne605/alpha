import 'package:freezed_annotation/freezed_annotation.dart';

part 'stake_register_request.freezed.dart';
part 'stake_register_request.g.dart';

@freezed
class StakeRegisterRequest with _$StakeRegisterRequest {
  const factory StakeRegisterRequest({
    required String productId,
    required String amount,
  }) = _StakeRegisterRequest;

  factory StakeRegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$StakeRegisterRequestFromJson(json);
}
