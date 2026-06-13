import 'package:freezed_annotation/freezed_annotation.dart';

part 'cancel_all_order_request_model.freezed.dart';
part 'cancel_all_order_request_model.g.dart';

@freezed
class CancelAllOrderRequestModel with _$CancelAllOrderRequestModel {
  const factory CancelAllOrderRequestModel({required String market}) =
      _CancelAllOrderRequestModel;

  factory CancelAllOrderRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CancelAllOrderRequestModelFromJson(json);
}
