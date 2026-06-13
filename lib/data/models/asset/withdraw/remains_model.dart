import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'remains_model.freezed.dart';
part 'remains_model.g.dart';

@freezed
class RemainsModel with _$RemainsModel {
  const factory RemainsModel({
    @JsonKey(name: "remains") required int remains,
    @JsonKey(name: "limit") required String limit,
  }) = _RemainsModel;

  factory RemainsModel.fromJson(Map<String, dynamic> json) =>
      _$RemainsModelFromJson(json);
}
