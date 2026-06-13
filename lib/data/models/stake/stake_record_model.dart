import 'package:freezed_annotation/freezed_annotation.dart';

part 'stake_record_model.freezed.dart';
part 'stake_record_model.g.dart';

@freezed
class StakeRecordModel with _$StakeRecordModel {
  const factory StakeRecordModel({
    required String id,
    required String status,
    required int lockDays,
    required String aprBase,
    required String currencyId,
    required String amount,
    dynamic reward,
    required String startedAt,
    required String unlockAt,
    required String timeRemaining,
    String? imgUrl,
  }) = _StakeRecordModel;

  factory StakeRecordModel.fromJson(Map<String, dynamic> json) =>
      _$StakeRecordModelFromJson(json);
}
