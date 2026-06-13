import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:alpha/data/models/asset/asset_model.dart';
import 'package:alpha/data/models/asset/asset_overview.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_model.dart';

part 'asset_detail_model.freezed.dart';
part 'asset_detail_model.g.dart';

@freezed
class AssetDetailModel with _$AssetDetailModel {
  const factory AssetDetailModel({
    required AssetModel asset,
    required AssetOverview overview,
    List<CoinModel>? marketList,
    double? equivalent,
  }) = _AssetDetailModel;

  factory AssetDetailModel.fromJson(Map<String, dynamic> json) =>
      _$AssetDetailModelFromJson(json);
}
