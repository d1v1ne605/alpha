import 'package:freezed_annotation/freezed_annotation.dart';

part 'deposit_address_model.freezed.dart';
part 'deposit_address_model.g.dart';

@freezed
class DepositAddressModel with _$DepositAddressModel {
  const factory DepositAddressModel({
    required List<String> currencies,
    String? address,
    required String state,
  }) = _DepositAddressModel;

  factory DepositAddressModel.fromJson(Map<String, dynamic> json) =>
      _$DepositAddressModelFromJson(json);
}
