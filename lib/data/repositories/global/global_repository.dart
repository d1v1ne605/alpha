import 'package:alpha/data/models/asset/balance_response_model.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';

typedef CurrencyBalanceData = ({
  Map<String, CurrencyModel> currencies,
  Map<String, BalanceResponseModel> balances,
});

abstract class GlobalRepository {
  Future<Map<String, dynamic>> getGlobalData();
  Future<CurrencyBalanceData> getCurrenciesAndBalancesData();
}
