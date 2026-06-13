import 'package:alpha/data/models/asset/withdraw/withdraw_fee_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_model.freezed.dart';
part 'network_model.g.dart';

@freezed
class NetworkModel with _$NetworkModel {
  const factory NetworkModel({
    required String id,
    required String blockchainName,
    required String withdrawFee,
    required String minWithdrawAmount,
    required String minDepositAmount,
    required String depositFee,
    required String iconUrl,
    required List<Fee> fees,
  }) = _NetworkModel;

  factory NetworkModel.fromJson(Map<String, dynamic> json) =>
      _$NetworkModelFromJson(json);
}
