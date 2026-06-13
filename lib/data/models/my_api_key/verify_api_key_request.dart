import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_api_key_request.freezed.dart';
part 'verify_api_key_request.g.dart';

@freezed
class VerifyMyApiRequest with _$VerifyMyApiRequest {
  const factory VerifyMyApiRequest({
    @Default("HS256")
    @JsonKey(name: 'algorithm') String algorithm,
    @JsonKey(name: 'totp_code') required String totpCode,
  }) = _VerifyMyApiRequest;

  factory VerifyMyApiRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyMyApiRequestFromJson(json);
}
