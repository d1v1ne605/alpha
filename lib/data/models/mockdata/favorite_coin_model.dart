import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_coin_model.freezed.dart';
part 'favorite_coin_model.g.dart';

@freezed
class FavoriteCoinModel with _$FavoriteCoinModel {
  const factory FavoriteCoinModel({
    required String name,
    required double price,
    required double change,
    @Default(false) bool favorite,
  }) = _FavoriteCoinModel;

  factory FavoriteCoinModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteCoinModelFromJson(json);
}
