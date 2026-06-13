import 'package:freezed_annotation/freezed_annotation.dart';
import 'translation_model.dart';

part 'banner_model.freezed.dart';
part 'banner_model.g.dart';

@freezed
abstract class BannerModel with _$BannerModel {
  const factory BannerModel({
    required int id,
    String? state,
    int? priority,
    @JsonKey(name: 'photo_url') required String photoUrl,
    @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
    List<String>? tags,
    String? category,
    @JsonKey(name: 'show_banner') bool? showBanner,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'published_at') DateTime? publishedAt,
    required List<TranslationModel> translations,
    String? headline,
    String? description,
    String? body,
  }) = _BannerModel;

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);
}
