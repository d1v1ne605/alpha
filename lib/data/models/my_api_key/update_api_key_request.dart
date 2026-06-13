import 'package:json_annotation/json_annotation.dart';

part 'update_api_key_request.g.dart';

@JsonSerializable()
class UpdateApiKeyRequest {
  @JsonKey(name: "totp_code")
  final String totpCode;
  final String state;

  UpdateApiKeyRequest({
    required this.totpCode,
    required this.state,
  });

  factory UpdateApiKeyRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateApiKeyRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateApiKeyRequestToJson(this);
}
