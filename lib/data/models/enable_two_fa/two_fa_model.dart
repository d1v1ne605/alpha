import 'package:freezed_annotation/freezed_annotation.dart';

part 'two_fa_model.freezed.dart';
part 'two_fa_model.g.dart';

@freezed
class TwoFAModel with _$TwoFAModel {
  const factory TwoFAModel({
    required TwoFAData data,
    dynamic auth,
    dynamic metadata,
    @JsonKey(name: 'lease_duration') required int leaseDuration,
    @JsonKey(name: 'lease_id') required String leaseId,
    required bool renewable,
    dynamic warnings,
    @JsonKey(name: 'wrap_info') dynamic wrapInfo,
  }) = _TwoFAModel;

  factory TwoFAModel.fromJson(Map<String, dynamic> json) =>
      _$TwoFAModelFromJson(json);
}

@freezed
class TwoFAData with _$TwoFAData {
  const factory TwoFAData({
    required String barcode,
    required String url,
  }) = _TwoFAData;

  factory TwoFAData.fromJson(Map<String, dynamic> json) =>
      _$TwoFADataFromJson(json);
}
