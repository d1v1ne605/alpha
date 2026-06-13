import 'package:alpha/data/models/asset/asset_model.dart';
import 'package:alpha/data/models/asset/child_currencies_model.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:alpha/data/repositories/asset/asset_repository.dart';
import 'package:alpha/data/repositories/global/global_repository.dart';

class GetAssetsUseCase {
  final AssetRepository repository;
  final GlobalRepository globalRepository;

  GetAssetsUseCase(this.repository, this.globalRepository);

  Future<List<AssetModel>> call() async {
    try {
      final globalData = await globalRepository.getGlobalData();
      if (globalData.isEmpty) {
        return [];
      }

      final response = await repository.getAllChildCurrenciesAndCurrencies();
      final List<CurrencyModel> currencies = response['currencies'];
      final ChildCurrenciesModel allChildCurrencies =
          response['allChildCurrencies'];
      final balances = await repository.getBalances();
      final List<String> childCurrencyIds = allChildCurrencies
          .childCurrenciesData
          .map((e) => e.id)
          .toList();
      final filterCurrencies = currencies
          .where((coin) => !childCurrencyIds.contains(coin.id))
          .toList();
      final Map<String, CurrencyModel> currenciesMap = {
        for (var currency in filterCurrencies) currency.id: currency,
      };
      final assetResponse = balances
          .where((asset) => currenciesMap.containsKey(asset.currency))
          .map((asset) {
            final currencyData = currenciesMap[asset.currency]!;
            return AssetModel(
              symbol: asset.currency.split('-').first.toUpperCase(),
              name: currencyData.name ?? '',
              spot: double.tryParse(asset.balance) ?? 0.0,
              currency: asset.currency,
              frozen: double.tryParse(asset.locked) ?? 0.0,
              iconUrl: currencyData.icon_url ?? '',
              id: asset.currency,
              price:
                  double.tryParse(currencyData.price?.toString() ?? '0') ?? 0.0,
              precision: currencyData.precision ?? 0,
              address: asset.depositAddress?.address ?? '',
            );
          })
          .toList();

      return _sortAssetsBySpotDescending(assetResponse);
    } catch (e) {
      return [];
    }
  }

  List<AssetModel> _sortAssetsBySpotDescending(List<AssetModel> assets) {
    assets.sort((a, b) => b.spot.compareTo(a.spot));
    return assets;
  }
}
