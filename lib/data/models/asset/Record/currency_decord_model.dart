import 'package:freezed_annotation/freezed_annotation.dart';

part 'currency_decord_model.freezed.dart';
part 'currency_decord_model.g.dart';

@freezed
class CurrencyDecordModel with _$CurrencyDecordModel {
  const factory CurrencyDecordModel({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "iconUrl") String? iconUrl,
    @JsonKey(name: "precision") int? precision,
  }) = _CurrencyDecordModel;

  factory CurrencyDecordModel.fromJson(Map<String, dynamic> json) =>
      _$CurrencyDecordModelFromJson(json);
}
