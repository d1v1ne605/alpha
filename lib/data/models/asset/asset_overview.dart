import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_overview.freezed.dart';
part 'asset_overview.g.dart';

@freezed
abstract class AssetOverview with _$AssetOverview {
  const factory AssetOverview({
    required String totalAssets,
    required String unit,
    required String convertedValue,
  }) = _AssetOverview;

  factory AssetOverview.fromJson(Map<String, dynamic> json) =>
      _$AssetOverviewFromJson(json);
}
