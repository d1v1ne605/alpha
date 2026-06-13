import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response_model.freezed.dart';
part 'login_response_model.g.dart';

LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) =>
    json.encode(data.toJson());

@freezed
abstract class LoginResponseModel with _$LoginResponseModel {
  const factory LoginResponseModel({
    required String email,
    required String uid,
    required String role,
    required int level,
    required bool otp,
    required String state,
    required dynamic referral_uid,
    required String data,
    required String csrf_token,
    required dynamic username,
    required List<dynamic> labels,
    required List<dynamic> phones,
    required List<dynamic> profiles,
    required List<dynamic> data_storages,
    required DateTime created_at,
    required DateTime updated_at,
  }) = _LoginResponseModel;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);
}
