import 'package:alpha/core/constants/app_local_key.dart';
import 'package:alpha/data/models/asset/member_levels_response_model.dart';
import 'package:alpha/data/models/asset/withdraw/remains_model.dart';
import 'package:alpha/data/models/asset/withdraw/withdraw_fee_response_model.dart';
import 'package:alpha/data/repositories/asset/asset_repository.dart';
import 'package:alpha/data/services/local/hive_service.dart';
import 'package:alpha/injection/injector.dart';

typedef SelectNetworkWithdrawData = ({
  WithdrawFeeResponseModel withdrawFee,
  RemainsModel remains,
});

class SelectNetworkWithdrawUseCase {
  final AssetRepository _assetRepository;

  SelectNetworkWithdrawUseCase(this._assetRepository);

  Future<SelectNetworkWithdrawData> call(String network) async {
    try {
      final result = await Future.wait([
        _assetRepository.getWithdrawFee(network),
        _assetRepository.getMemberLevels(),
        _assetRepository.getRemainsWithdraw(),
      ]);

      final memberLevels = result[1] as MemberLevelsResponseModel;
      await getIt<HiveService>().put(
        key: AppLocalKey.hiveKeyMemberLevels,
        boxName: AppLocalKey.hiveBoxNameWithdraw,
        value: memberLevelsResponseModelToJson(memberLevels),
      );

      return (
        withdrawFee: result[0] as WithdrawFeeResponseModel,
        remains: result[2] as RemainsModel,
      );
    } catch (e) {
      throw Exception('Failed to select network for withdraw: $e');
    }
  }
}
