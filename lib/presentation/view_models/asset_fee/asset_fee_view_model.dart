import 'package:alpha/core/base/base_view_model.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/mixins/loading/loading_state_mixin.dart';
import 'package:alpha/core/mixins/local_storage/local_storage_mixin.dart';
import 'package:alpha/core/mixins/search/search_minxin.dart';
import 'package:alpha/data/models/asset/network_model.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:alpha/domain/usecase/asset/get_filter_network_usecase.dart';
import 'package:alpha/presentation/view_models/global_view_model.dart';

import '../../../data/models/home_market/coin_model/coin_model.dart';

class AssetFeeViewModel extends BaseViewModel
    with LocalStorageMixin, SearchMixin<CurrencyModel>, LoadingStateMixin {
  final GlobalViewModel _globalVM;
  final GetFilterNetworkUseCase _getFilterNetworkUseCase;

  static const String loadingSelectNetworkKey =
      AppStorageKey.loadingSelectNetworkKey;
  bool get isSelectNetwork => isLoading(loadingSelectNetworkKey);

  AssetFeeViewModel(this._globalVM, this._getFilterNetworkUseCase) {
    initLocalStorage(_globalVM.hiveService);
    initializeSearch();
    loadCoins();
  }

  CurrencyModel? selectedCoin;
  List<CurrencyModel> allCoins = [];

  List<CurrencyModel> get filteredCoins => filteredItemsNotifier.value;
  List<CoinModel> get sortedData => _globalVM.sortedData;
  List<CoinModel> cryptoListCoin = [];
  List<NetworkModel> networks = [];

  NetworkModel? selectedNetwork;

  List<CurrencyModel> get _cryptoCoins =>
      allCoins.where((c) => c.type == AppStorageKey.coin).toList();

  List<CurrencyModel> get _fiatCoins =>
      allCoins.where((c) => c.type != AppStorageKey.coin).toList();

  void setCryptoCoin(String coinId) {
    cryptoListCoin = sortedData.where((c) => c.base_unit == coinId).toList();
  }

  Future<void> loadCoins() async {
    setBusy(true);
    try {
      final coins = await _globalVM.filterCoinForDepositAndWithdraw();
      allCoins = List.from(coins);
      filteredItemsNotifier.value = List.from(allCoins);
    } catch (e) {
      setError('Failed to load coins: $e');
    } finally {
      setBusy(false);
    }
  }

  void onCoinSelected(CurrencyModel coin) {
    selectedCoin = coin;
    filteredItemsNotifier.value = [coin];
    loadNetworks(coin.id);
  }

  void resetCoins() {
    selectedCoin = null;
    clearSearch();
    filteredItemsNotifier.value = List.from(allCoins);
  }

  @override
  String getSearchField(CurrencyModel item) {
    return '${item.name.toLowerCase()} ${item.id.toLowerCase()}';
  }

  @override
  List<CurrencyModel> get allItems => allCoins;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadNetworks(String currencyId) async {
    try {
      await withLoading(AppStorageKey.loadingSelectNetworkKey, () async {
        networks = await _getFilterNetworkUseCase.call(currencyId);
        selectedNetwork = networks.isNotEmpty ? networks.first : null;
      }, () {});
    } catch (e) {
      setError('Failed to load networks: $e');
    }
  }

  void selectNetwork(NetworkModel network) {
    selectedNetwork = network;
    notifyListeners();
  }

  void loadFiatCoins() => filteredItemsNotifier.value = _fiatCoins;
  void loadCryptoCoins() => filteredItemsNotifier.value = _cryptoCoins;
}
