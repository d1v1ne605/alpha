import 'package:alpha/core/base/base_view_model.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/mixins/local_storage/local_storage_mixin.dart';
import 'package:alpha/core/mixins/search/search_minxin.dart';
import 'package:alpha/core/mixins/two_fa_mixin/two_fa_mixin.dart';
import 'package:alpha/data/models/asset/balance_response_model.dart';
import 'package:alpha/data/models/asset/child_currencies_model.dart';
import 'package:alpha/data/models/asset/deposit_address_model.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:alpha/data/services/local/hive_service.dart';
import 'package:alpha/domain/usecase/deposit/get_child_currency_usecase.dart';
import 'package:alpha/domain/usecase/deposit/get_deposit_address_usecase.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/view_models/global_view_model.dart';
import 'package:flutter/cupertino.dart';

class DepositViewModel extends BaseViewModel
    with TwoFAMixin, SearchMixin<CurrencyModel>, LocalStorageMixin {
  final GlobalViewModel _globalViewModel = getIt<GlobalViewModel>();
  List<CurrencyModel> coins = [];
  ChildCurrenciesModel? _childCurrencies;

  ChildCurrenciesModel? get childCurrencies => _childCurrencies;

  List<CurrencyModel> get filterCoins => filteredItems;

  List<CurrencyModel> _networks = [];

  List<CurrencyModel> get networks => _networks;

  CurrencyModel? selectedCoin;
  CurrencyModel? selectedNetwork;

  bool get is2FAEnabled => currentUser?.otp ?? false;

  Map<String, BalanceResponseModel> get balance => _globalViewModel.balances;

  final hiveService = getIt<HiveService>();
  final GetChildCurrencyUsecase _childCurrencyUsecase;
  final GetDepositAddressUsecase _getDepositAddressUsecase;
  late final VoidCallback _globalListener;

  DepositViewModel({
    this.selectedCoin,
    required GetChildCurrencyUsecase childCurrencyUsecase,
    required GetDepositAddressUsecase getDepositAddressUsecase,
  }) : _childCurrencyUsecase = childCurrencyUsecase,
       _getDepositAddressUsecase = getDepositAddressUsecase {
    _globalListener = () {
      Future.microtask(() {
        notifyListeners();
      });
    };
    _globalViewModel.addListener(_globalListener);
  }

  List<CurrencyModel> get childCurrenciesData =>
      _childCurrencies?.childCurrenciesData ?? [];

  bool get selectedCoinHasAddress {
    try {
      final matchingBalance = balance[selectedNetwork!.id];
      return matchingBalance?.depositAddress?.address != null;
    } catch (e) {
      return false;
    }
  }

  Future<DepositAddressModel> getDepositAddress() async {
    return await _getDepositAddressUsecase(selectedNetwork!.id);
  }

  CurrencyModel? get selectedChildCurrency {
    if (selectedCoin == null) return null;
    try {
      return childCurrenciesData.firstWhere(
        (currency) =>
            currency.id.toLowerCase() == selectedCoin!.id.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  BalanceResponseModel? get selectedBalance {
    if (selectedCoin == null) return null;
    try {
      return balance[selectedNetwork!.id.toLowerCase()];
    } catch (e) {
      return null;
    }
  }

  bool get isChildCurrenciesLoaded {
    try {
      final matchingAsset = _childCurrencies!.childCurrenciesData.firstWhere(
        (child) => child.id == selectedNetwork!.id,
      );
      return matchingAsset.deposit_enabled == false;
    } catch (e) {
      return false;
    }
  }

  @override
  List<CurrencyModel> get allItems => coins;

  @override
  String getSearchField(CurrencyModel item) {
    return '${item.name.toLowerCase()} ${item.id.toLowerCase()}';
  }

  void init(String? currency) async {
    loadDeposit(currency);
    await loadChildCurrencies(currency ?? AppStorageKey.alpha);
  }

  Future<void> loadChildCurrencies(String currency) async {
    try {
      setBusy(true);
      final SelectCoinWithdrawData result = await _childCurrencyUsecase(
        currency: currency,
      );
      if (result != null) {
        _childCurrencies = result.childCurrencies;
        _networks = childCurrenciesData;
        notifyListeners();
      }
    } catch (e) {
      print('Error loading child currencies: $e');
    } finally {
      setBusy(false);
    }
  }

  Future<void> loadDeposit(String? currency) async {
    setBusy(true);
    try {
      coins = await _globalViewModel.filterCoinForDepositAndWithdraw();
      initializeSearch();
      _networks = childCurrenciesData;
      if (currency != null && currency.isNotEmpty) {
        selectedCoin = coins.firstWhere(
          (coin) => coin.id.toLowerCase() == currency.toLowerCase(),
          orElse: () => coins.first,
        );
      } else {
        selectedCoin ??= coins.isNotEmpty ? coins.first : null;
      }
      notifyListeners();
    } catch (e) {
      print('Error loading deposit: $e');
      notifyListeners();
    } finally {
      setBusy(false);
    }
  }

  void onCoinSelected(CurrencyModel coin) {
    selectedCoin = coin;
    loadChildCurrencies(coin.id.toUpperCase());
    selectedNetwork = null;
    notifyListeners();
  }

  void onNetworkSelected(CurrencyModel network) {
    selectedNetwork = network;
    final matchingBalance = balance[selectedNetwork!.id];
    if (matchingBalance?.depositAddress?.address == null) {
      getDepositAddress();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _globalViewModel.removeListener(_globalListener);
  }
}
