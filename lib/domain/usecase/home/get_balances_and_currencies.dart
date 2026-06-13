import 'package:alpha/data/repositories/global/global_repository.dart';

class GetBalancesAndCurrencies {
  final GlobalRepository _globalRepository;
  GetBalancesAndCurrencies(this._globalRepository);

  Future<CurrencyBalanceData> call() async {
    return await _globalRepository.getCurrenciesAndBalancesData();
  }
}
