import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_password_model.freezed.dart';
part 'change_password_model.g.dart';

@freezed
abstract class ChangePasswordModel with _$ChangePasswordModel {
  const factory ChangePasswordModel({
    @JsonKey(name: "old_password") required String oldPassword,
    @JsonKey(name: "new_password") required String newPassword,
    @JsonKey(name: "confirm_password") required String confirmNewPassword,
  }) = _ChangePasswordModel;

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordModelFromJson(json);
}
