import 'package:alpha/core/utils/validate.dart';
import 'package:alpha/data/models/asset/network_model.dart';
import 'package:alpha/data/repositories/asset/asset_repository.dart';

class GetFilterNetworkUseCase {
  final AssetRepository _assetRepository;

  GetFilterNetworkUseCase(this._assetRepository);

  Future<List<NetworkModel>> call(String coinId) async {
    try {
      final childCurrenciesResponse = await _assetRepository.getChildCurrencies(
        coinId,
      );
      final childCurrencies = childCurrenciesResponse.childCurrenciesData;

      final feeResponses = await Future.wait(
        childCurrencies.map((currency) async {
          final withdrawFeeResponse = await _assetRepository.getWithdrawFee(
            currency.id,
          );
          return MapEntry(
            currency.id,
            withdrawFeeResponse.withdrawFeeData.fees,
          );
        }),
      );

      final feeMap = Map<String, dynamic>.fromEntries(feeResponses);

      final networks = childCurrencies.map((currency) {
        final rawBlockchainName =
            currency.blockchainName ?? currency.blockchain_key;
        final networkName = ExtractUtilsNetwork.extractNetworkName(
          rawBlockchainName,
        );

        return NetworkModel(
          id: currency.id,
          blockchainName: networkName,
          withdrawFee: currency.withdraw_fee,
          minWithdrawAmount: currency.min_withdraw_amount,
          minDepositAmount: currency.min_deposit_amount,
          depositFee: currency.deposit_fee,
          iconUrl: currency.icon_url,
          fees: feeMap[currency.id] ?? [],
        );
      }).toList();
      return networks;
    } catch (e) {
      throw Exception('NewVersion failed for $coinId: $e');
    }
  }
}
