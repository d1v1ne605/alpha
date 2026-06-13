import 'package:freezed_annotation/freezed_annotation.dart';

part 'ranking_model.g.dart';
part 'ranking_model.freezed.dart';

@freezed
class RankingModel with _$RankingModel {
  const factory RankingModel({
    required int top,
    required String uid,
    required String total_trade_amount,
    required String reward,
    required String currency_icon,
    required String currency_alt,
    required String distribute_date,
  }) = _RankingModel;

  factory RankingModel.fromJson(Map<String, dynamic> json) =>
      _$RankingModelFromJson(json);
}
