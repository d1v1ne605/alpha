import 'package:alpha/data/models/asset/balance_response_model.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:alpha/data/models/home_market/market_data_model.dart';
import 'package:alpha/data/repositories/global/global_repository.dart';
import 'package:alpha/data/services/home/home_api_service.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:flutter/foundation.dart';

class GlobalRepositoryImpl implements GlobalRepository {
  HomeApiService api;
  GlobalRepositoryImpl(this.api);

  @override
  Future<Map<String, dynamic>> getGlobalData() async {
    final result = await Future.wait([
      api.getMarkets(),
      api.getCurrencies(),
      api.getTickers(),
    ]);
    return {
      AppStorageKey.markets: result[0] as List,
      AppStorageKey.currencies: result[1] as List,
      AppStorageKey.tickers: result[2] as Map<String, MarketDataModel>,
    };
  }

  @override
  Future<CurrencyBalanceData> getCurrenciesAndBalancesData() async {
    final result = await Future.wait([
      api.getCurrencies(),
      api.getBalances(1000, null, null),
    ]);
    final currencies = result[0] as List<CurrencyModel>;
    final balances = result[1] as List<BalanceResponseModel>;

    final currenciesMap = await compute((List<CurrencyModel> list) {
      return {for (var c in list) c.id: c};
    }, currencies);
    final balancesMap = await compute((List<BalanceResponseModel> list) {
      return {for (var b in list) b.currency: b};
    }, balances);

    return (currencies: currenciesMap, balances: balancesMap);
  }
}
