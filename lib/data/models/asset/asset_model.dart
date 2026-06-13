import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_model.freezed.dart';
part 'asset_model.g.dart';

@freezed
abstract class AssetModel with _$AssetModel {
  const factory AssetModel({
    required String id,
    required String symbol,
    required String name,
    required double spot,
    required double frozen,
    required String iconUrl,
    required double price,
    required String currency,
    required String address,
    required int precision,
  }) = _AssetModel;

  factory AssetModel.fromJson(Map<String, dynamic> json) => _$AssetModelFromJson(json);
}
