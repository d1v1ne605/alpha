import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_form_request_model.freezed.dart';
part 'order_form_request_model.g.dart';

@freezed
class OrderFormRequestModel with _$OrderFormRequestModel {
  const factory OrderFormRequestModel({
    required String market,
    required String side,
    required String volume,
    @JsonKey(name: 'ord_type') required String ordType,
    @JsonKey(includeIfNull: false) String? price,
  }) = _OrderFormRequestModel;

  factory OrderFormRequestModel.fromJson(Map<String, dynamic> json) =>
      _$OrderFormRequestModelFromJson(json);
}
