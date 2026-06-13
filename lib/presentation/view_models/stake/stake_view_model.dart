import 'package:alpha/core/base/base_view_model.dart';
import 'package:alpha/core/mixins/search/search_minxin.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/data/models/asset/balance_response_model.dart';
import 'package:alpha/data/models/stake/stake_product_model.dart';
import 'package:alpha/data/models/stake/stake_register_request.dart';
import 'package:alpha/data/models/stake/stake_register_response.dart';
import 'package:alpha/domain/usecase/stake/get_stake_product_usecase.dart';
import 'package:alpha/presentation/view_models/global_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:alpha/data/models/stake/stake_record_model.dart';
import 'package:alpha/domain/usecase/stake/get_stake_records_usecase.dart';

class StakeViewModel extends BaseViewModel
    with SearchMixin<StakeProductResponse> {
  final GetStakeProductUsecase getStakeProductUsecase;
  final GetStakeRecordsUseCase getStakeRecordsUseCase;
  final GlobalViewModel _globalViewModel;

  StakeProduct? selectedOption;
  double _stakedAmount = 0;
  BalanceResponseModel? coindBalance;
  String get availableBalance => coindBalance?.balance ?? '0.0';

  double get stakedAmount => _stakedAmount;
  final TextEditingController amountController = TextEditingController();

  StakeViewModel(
    this.getStakeProductUsecase,
    this.getStakeRecordsUseCase,
    this._globalViewModel,
  ) {
    _globalViewModel.addListener(_onGlobalViewModelUpdate);
    loadStakeList();
    loadBalanceForSelectedCoin();
  }

  void _onGlobalViewModelUpdate() {
    if (_globalViewModel.isNotifyPollingBalancesAndCurrencies) {
      _globalViewModel.isNotifyPollingBalancesAndCurrencies = false;
      notifyListeners();
      _globalViewModel.removeListener(_onGlobalViewModelUpdate);
      return;
    }
  }

  bool get isCurrenciesEmpty => _globalViewModel.currencies.isEmpty;
  List<StakeProductResponse> _stakeProducts = [];
  List<StakeProduct> _allProducts = [];

  double get estimatedReward => _stakedAmount / 1000;
  String get estimatedRewardString =>
      FormatterUtils.formatWithDecimalsNoRound(estimatedReward, 8);

  @override
  List<StakeProductResponse> get allItems => _stakeProducts;

  List<StakeProductResponse> get stakeProducts => _stakeProducts;

  List<StakeProduct> get allProducts => _allProducts;

  Future<void> loadStakeList() async {
    setBusy(true);
    try {
      final response = await getStakeProductUsecase();
      _stakeProducts = response;
      _allProducts = response.expand((e) => e.products).toList();
      initializeSearch();
    } catch (e) {
      rethrow;
    } finally {
      setBusy(false);
    }
  }

  @override
  String getSearchField(StakeProductResponse item) {
    return item.currencyId.toLowerCase();
  }

  int _recordSelectedCurrencyIndex = -1;

  int get recordSelectedCurrencyIndex => _recordSelectedCurrencyIndex;

  set recordSelectedCurrencyIndex(int value) {
    _recordSelectedCurrencyIndex = value;
    notifyListeners();
  }

  int _recordSelectedFilterIndex = 0;

  int get recordSelectedFilterIndex => _recordSelectedFilterIndex;

  set recordSelectedFilterIndex(int value) {
    _recordSelectedFilterIndex = value;
    notifyListeners();
  }

  late List<String> recordFilterTypes = [
    context!.appLocaleLanguage.all.toCapitalized(),
    context!.appLocaleLanguage.staked.toCapitalized(),
    context!.appLocaleLanguage.pending.toCapitalized(),
    context!.appLocaleLanguage.redeemed.toCapitalized(),
    context!.appLocaleLanguage.canceled.toCapitalized(),
  ];

  List<StakeRecordModel> stakeRecords = [];
  final Map<String, CurrencyModel> recordFilterableCurrenciesMap = {};
  List<CurrencyModel> get recordFilterableCurrencies =>
      recordFilterableCurrenciesMap.values.toList();

  void toggleProductExpansion(int index) {
    final list = filteredItemsNotifier.value;

    if (index < 0 || index >= list.length) return;
    final current = list[index].isExpanded ?? false;
    list[index] = list[index].copyWith(isExpanded: !current);
    final globalIndex = _stakeProducts.indexWhere(
      (p) => p.currencyId == list[index].currencyId,
    );
    if (globalIndex != -1) {
      _stakeProducts[globalIndex] = list[index];
    }
    filteredItemsNotifier.value = List.from(list);
  }

  String getAprRange(StakeProductResponse product) {
    if (product.products.isEmpty) return '0%';
    final sorted = List<StakeProduct>.from(product.products)
      ..sort((a, b) => a.aprBase.compareTo(b.aprBase));
    final minApr = sorted.first.aprBase;
    return '$minApr%';
  }

  List<StakeProduct> getSortedOptions(StakeProductResponse product) {
    final sorted = List<StakeProduct>.from(product.products);
    sorted.sort((a, b) => a.aprBase.compareTo(b.aprBase));
    return sorted;
  }

  String getProgressText(StakeProduct option, String currencyId) {
    final current = FormatterUtils.formatNumberPrice(option.poolFilled);
    final total = FormatterUtils.formatNumberPrice(option.poolSize);
    return '$current / $total ${currencyId.toUpperCase()}';
  }

  double getProgressValue(StakeProduct option) {
    if (option.poolSize == 0) return 0.0;
    return option.poolFilled / option.poolSize;
  }

  set stakedAmount(double value) {
    _stakedAmount = value;
    notifyListeners();
  }

  void selectOption(StakeProduct option) async {
    selectedOption = option;
    amountController.clear();
    stakedAmount = 0;
    await loadBalanceForSelectedCoin();
    notifyListeners();
  }

  void onAmountChanged(String value) {
    stakedAmount = double.tryParse(value) ?? 0;
  }

  List<StakeProduct> get currentOptions {
    if (selectedOption == null) return _allProducts;
    final options = _allProducts
        .where((p) => p.currencyId == selectedOption!.currencyId)
        .toList();
    options.sort((a, b) => a.aprBase.compareTo(b.aprBase));

    return options;
  }

  void stakeAll() {
    if (selectedOption == null) return;
    amountController.text = availableBalance;
    stakedAmount = double.tryParse(availableBalance) ?? 0.0;
    notifyListeners();
  }

  bool get canStake {
    if (selectedOption == null) return false;
    final minAmount = selectedOption!.minAmount ?? 0.0;
    return stakedAmount >= minAmount && stakedAmount > 0;
  }

  Future<void> loadBalanceForSelectedCoin() async {
    if (selectedOption == null) return;

    final selectedCoin = selectedOption!.currencyId.toLowerCase();
    setBusy(true);
    try {
      coindBalance = _globalViewModel.balances[selectedCoin];
    } catch (e) {
      print(' Error getting balance for $selectedCoin: $e');
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  Future<StakeRegisterResponse?> registerStake() async {
    if (selectedOption == null || stakedAmount <= 0) return null;

    final request = StakeRegisterRequest(
      productId: selectedOption!.id,
      amount: stakedAmount.toString(),
    );

    try {
      final response = await getStakeProductUsecase.registerStake(request);
      return response;
    } catch (e) {
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  String getLogoUrl(StakeProductResponse product) {
    final currencyId = product.currencyId.toLowerCase();
    final currencies = _globalViewModel.currencies;
    final currency = currencies[currencyId];
    return currency?.icon_url ?? '';
  }

  getStakeRecords() async {
    try {
      if (stakeRecords.isNotEmpty) return;
      final response = await getStakeRecordsUseCase.call();
      stakeRecords = response;

      // Get imgUrl for each stake record based on currencyId
      for (var (index, record) in response.indexed) {
        if (!recordFilterableCurrenciesMap.containsKey(record.currencyId)) {
          recordFilterableCurrenciesMap[record.currencyId] =
              _globalViewModel.currencies[record.currencyId.toLowerCase()]!;
        }
        stakeRecords[index] = stakeRecords[index].copyWith(
          imgUrl: recordFilterableCurrenciesMap[record.currencyId]?.icon_url,
        );
      }
    } catch (e) {
      setError(context!.appLocaleLanguage.failed);
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  String? get selectedCurrencyIdForFilterRecord {
    final selectedIndex = recordSelectedCurrencyIndex - 1;
    final selectedCurrency =
        (selectedIndex >= 0 &&
            selectedIndex < recordFilterableCurrencies.length)
        ? recordFilterableCurrencies[selectedIndex]
        : null;
    return selectedCurrency?.id.toUpperCase();
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }
}
