import 'package:alpha/data/models/referall_model/ranking_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'top_ranking_response_model.freezed.dart';
part 'top_ranking_response_model.g.dart';

@freezed
class TopRankingResponseModel with _$TopRankingResponseModel {
  const factory TopRankingResponseModel({
    required bool cached,
    required List<RankingModel> data,
  }) = _TopRankingResponseModel;

  factory TopRankingResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TopRankingResponseModelFromJson(json);
}
