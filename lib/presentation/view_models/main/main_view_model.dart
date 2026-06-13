import 'package:alpha/core/base/base_view_model.dart';
import 'package:alpha/core/constants/app_local_key.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/data/services/local/hive_service.dart';
import 'package:alpha/injection/injector.dart';

class MainViewModel extends BaseViewModel {
  final hiveService = getIt<HiveService>();

  Future<void> initDefaultCoin() async {
    final lastCoinId = await hiveService.get(
      key: AppLocalKey.lastTappedCoinId,
      boxName: AppLocalKey.commonBox,
    );
    if (lastCoinId == null) {
      await hiveService.put(
        key: AppLocalKey.lastTappedCoinId,
        value: AppStorageKey.btcUsdt,
        boxName: AppLocalKey.commonBox,
      );
    }
  }
}
