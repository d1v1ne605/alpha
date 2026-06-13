import 'package:alpha/data/models/asset/balance_response_model.dart';
import 'package:alpha/data/models/asset/beneficiaries_model.dart';
import 'package:alpha/core/constants/app_storage_key.dart';

mixin Trade {
  Map<String, String> getCoinAndQuoteUnitByCoinName(String coinName) {
    if (coinName.isEmpty) {
      return {
        AppStorageKey.keyBaseCoinUnit: '',
        AppStorageKey.keyQuoteCoinUnit: '',
      };
    }
    final List<String> parts = coinName.split('/');
    return {
      AppStorageKey.keyBaseCoinUnit: parts[0],
      AppStorageKey.keyQuoteCoinUnit: parts[1],
    };
  }
}

mixin AssetsMixin {
  List<BeneficiariesModel> filterBeneficiariesByCurrency({
    required List<BeneficiariesModel> beneficiaries,
    required String currency,
  }) {
    return beneficiaries.where((b) => b.currency == currency).toList();
  }

  BalanceResponseModel filterBalancesByCurrency({
    required List<BalanceResponseModel> balances,
    required String currency,
  }) {
    final balance = balances.firstWhere(
      (b) => b.currency == currency.toLowerCase(),
      orElse: () =>
          throw Exception('Balance not found for currency: $currency'),
    );
    return balance;
  }

  List<BalanceResponseModel> getAllBalances({
    required List<BalanceResponseModel> balances,
  }) {
    return balances;
  }
}
