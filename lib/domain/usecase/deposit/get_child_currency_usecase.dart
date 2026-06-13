import 'package:alpha/core/utils/mixins.dart';
import 'package:alpha/data/models/asset/balance_response_model.dart';
import 'package:alpha/data/models/asset/child_currencies_model.dart';
import 'package:alpha/data/repositories/asset/asset_repository.dart';
import 'package:http/http.dart';

typedef SelectCoinWithdrawData = ({
  ChildCurrenciesModel childCurrencies,
  List<BalanceResponseModel> balances,
});

class GetChildCurrencyUsecase with AssetsMixin {
  final AssetRepository _assetsRepository;
  GetChildCurrencyUsecase(this._assetsRepository);

  Future<SelectCoinWithdrawData> call({required String currency}) async {
    final results = await Future.wait([
      _assetsRepository.getChildCurrencies(currency),
      _assetsRepository.getBalances(),
    ]);
    return (
      childCurrencies: results[0] as ChildCurrenciesModel,
      balances: getAllBalances(
        balances: results[1] as List<BalanceResponseModel>,
      ),
    );
  }
}
