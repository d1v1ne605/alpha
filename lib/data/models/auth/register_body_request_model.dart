import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_body_request_model.g.dart';
part 'register_body_request_model.freezed.dart';

@freezed
abstract class RegisterBodyRequest with _$RegisterBodyRequest {
  const factory RegisterBodyRequest({
    required String email,
    required String password,
    @JsonKey(includeIfNull: false) String? data,
    @JsonKey(includeIfNull: false) String? refid,
  }) = _RegisterBodyRequest;

  factory RegisterBodyRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterBodyRequestFromJson(json);
}
