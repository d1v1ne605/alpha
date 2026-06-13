import 'package:alpha/core/utils/mixins.dart';
import 'package:alpha/data/models/asset/balance_response_model.dart';
import 'package:alpha/data/models/asset/beneficiaries_model.dart';
import 'package:alpha/data/models/asset/child_currencies_model.dart';
import 'package:alpha/data/models/asset/withdraw/remains_model.dart';
import 'package:alpha/data/models/asset/withdraw/withdraw_limit_model.dart';
import 'package:alpha/data/repositories/asset/asset_repository.dart';

typedef SelectCoinWithdrawData = ({
  RemainsModel remains,
  ChildCurrenciesModel childCurrencies,
  List<BeneficiariesModel> beneficiaries,
  WithdrawLimitModel withdrawLimit,
  BalanceResponseModel balances,
});

class SelectCoinWithdrawUseCase with AssetsMixin {
  final AssetRepository _assetsRepository;

  SelectCoinWithdrawUseCase(this._assetsRepository);

  Future<SelectCoinWithdrawData> call({
    required String withdrawCurrency,
  }) async {
    try {
      final results = await Future.wait([
        _assetsRepository.getRemainsWithdraw(),
        _assetsRepository.getChildCurrencies(withdrawCurrency),
        _assetsRepository.getBeneficiaries(),
        _assetsRepository.getWithdrawLimit(),
        _assetsRepository.getBalances(),
      ]);

      final List<BeneficiariesModel> beneficiaries =
          results[2] as List<BeneficiariesModel>;
      final List<BalanceResponseModel> balances =
          results[4] as List<BalanceResponseModel>;

      return (
        remains: results[0] as RemainsModel,
        childCurrencies: results[1] as ChildCurrenciesModel,
        beneficiaries: beneficiaries,
        withdrawLimit: results[3] as WithdrawLimitModel,
        balances: filterBalancesByCurrency(
          balances: balances,
          currency: withdrawCurrency,
        ),
      );
    } catch (e) {
      throw Exception('Failed to load withdraw data: $e');
    }
  }
}
