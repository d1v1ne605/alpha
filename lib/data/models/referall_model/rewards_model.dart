import 'package:freezed_annotation/freezed_annotation.dart';

part 'rewards_model.freezed.dart';
part 'rewards_model.g.dart';

@freezed
class RewardsModel with _$RewardsModel {
  const factory RewardsModel({
    required int top,
    required String reward_amount,
    required String currency_id,
    required String season,
    required String date,
    required String status,
  }) = _RewardsModel;
  factory RewardsModel.fromJson(Map<String, dynamic> json) =>
      _$RewardsModelFromJson(json);
}
