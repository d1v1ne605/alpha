import 'package:alpha/data/models/asset/child_currencies_model.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:alpha/data/repositories/asset/asset_repository.dart';

class GetFilterCoinsUseCase {
  final AssetRepository _assetRepository;

  GetFilterCoinsUseCase(this._assetRepository);

  Future<List<CurrencyModel>> call() async {
    try {
      final response = await _assetRepository
          .getAllChildCurrenciesAndCurrencies();
      final List<CurrencyModel> currencies = response['currencies'];
      final ChildCurrenciesModel allChildCurrencies =
          response['allChildCurrencies'];
      final List<String> childCurrencyIds = allChildCurrencies
          .childCurrenciesData
          .map((e) => e.id)
          .toList();
      final filterCoins = currencies.where(
        (coin) => !childCurrencyIds.contains(coin.id),
      );
      return filterCoins.toList();
    } catch (e) {
      throw Exception('Failed to fetch child currencies: $e');
    }
  }
}
