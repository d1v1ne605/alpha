import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_key_model.freezed.dart';
part 'api_key_model.g.dart';

@freezed
class ApiKeyModel with _$ApiKeyModel {
const factory ApiKeyModel({
required String kid,
required String algorithm,
required List<String> scope,
required String state,
String? secret,
@JsonKey(name: 'created_at') required DateTime createdAt,
@JsonKey(name: 'updated_at') required DateTime updatedAt,
}) = _ApiKeyModel;

factory ApiKeyModel.fromJson(Map<String, dynamic> json) =>
_$ApiKeyModelFromJson(json);
}

