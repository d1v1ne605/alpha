import 'package:alpha/data/models/asset/deposit_address_model.dart';
import 'package:alpha/data/repositories/asset/asset_repository.dart';

class GetDepositAddressUsecase {
  final AssetRepository _assetRepository;

  GetDepositAddressUsecase(this._assetRepository);

  Future<DepositAddressModel> call(String currencyId) async {
    return await _assetRepository.getDepositAddress(currencyId);
  }
}
