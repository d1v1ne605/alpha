import 'package:freezed_annotation/freezed_annotation.dart';

part 'depth_response_model.freezed.dart';
part 'depth_response_model.g.dart';

@freezed
abstract class DepthResponseModel with _$DepthResponseModel {
  const factory DepthResponseModel({
    required int timestamp,
    required List<List<String>> bids,
    required List<List<String>> asks,
  }) = _DepthResponseModel;

  factory DepthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DepthResponseModelFromJson(json);
}
