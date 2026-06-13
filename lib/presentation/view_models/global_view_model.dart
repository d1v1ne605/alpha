import 'dart:async';
import 'dart:math' as math;

import 'package:alpha/core/base/base_view_model.dart';
import 'package:alpha/core/constants/app_local_key.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/mixins/local_storage/local_storage_mixin.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/socket/socket_manager.dart';
import 'package:alpha/data/models/asset/asset_model.dart';
import 'package:alpha/data/models/asset/asset_overview.dart';
import 'package:alpha/data/models/asset/balance_response_model.dart';
import 'package:alpha/data/models/banner_models/banner_mock.dart';
import 'package:alpha/data/models/banner_models/banner_model.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_model.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:alpha/data/models/trading/trade/order_book_entry.dart';
import 'package:alpha/data/models/trading/trade/order_socket_model.dart';
import 'package:alpha/data/models/trading/trade/ticker_entry.dart';
import 'package:alpha/data/services/local/hive_service.dart';
import 'package:alpha/domain/usecase/asset/get_assets_usecase.dart';
import 'package:alpha/domain/usecase/asset/get_filter_coins_usecase.dart';
import 'package:alpha/domain/usecase/home/get_balances_and_currencies.dart';
import 'package:alpha/domain/usecase/home/get_coins_usecase.dart';
import 'package:alpha/domain/usecase/home/home_banner_usecase.dart';
import 'package:alpha/injection/injector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/utils/format_usdt.dart';
import '../../data/models/auth/login_response_model.dart';

class GlobalViewModel extends BaseViewModel with LocalStorageMixin {
  final SocketManager _socketManager;

  SocketManager get socketManager => _socketManager;
  final HomeBannerUseCase _homeBannerUseCase;
  final GetCoinsUsecase _getCoinsUsecase;
  final GetAssetsUseCase _getAssetsUsecase = getIt<GetAssetsUseCase>();
  final GetBalancesAndCurrencies _getBalancesAndCurrencies;

  final GetFilterCoinsUseCase _getFilterCoinsUseCase;

  GlobalViewModel(
    this._getCoinsUsecase,
    this._homeBannerUseCase,
    this._socketManager,
    this._getFilterCoinsUseCase,
    this._getBalancesAndCurrencies,
  ) {
    _currentInterval = Duration(seconds: defaultTimePolling);
    initLocalStorage(hiveService);
    initSortParameters();
    _listenToSocket();
    connectSocket();
    loadAssets();
    loadCoins();
    fetchBanners();
    getUser();
  }

  Map<String, BalanceResponseModel> _balances = {};

  Map<String, BalanceResponseModel> get balances => _balances;

  Map<String, CurrencyModel> _currencies = {};

  Map<String, CurrencyModel> get currencies => _currencies;

  Timer? _pollingBalanceAndCurrenciesTimer;
  bool _isUpdatingBalancesAndCurrencies = false;
  bool _isAppInForeground = true;
  int defaultTimePolling = 5;
  late Duration _currentInterval;
  int _consecutiveErrors = 0;
  bool isNotifyPollingBalancesAndCurrencies = false;

  AssetOverview? _assetOverview;
  AssetOverview? get assetOverview => _assetOverview;

  double _totalUSDT = 0.0;
  double get totalUSDT => _totalUSDT;
  double _changeAmount = 0.0;
  double get changeAmount => _changeAmount;
  double? _previousTotal;
  double _percentageChange = 0.0;
  double get percentageChange => _percentageChange;

  void initSortParameters() {
    setCachedData(AppLocalKey.sortByKey, _sortBy);
    setCachedData(AppLocalKey.isAscendingKey, _isAscending);
    setCachedData(AppLocalKey.newCoinsSortByKey, _newCoinsSortBy);
    setCachedData(AppLocalKey.newCoinsIsAscendingKey, _newCoinsIsAscending);
    setCachedData(AppLocalKey.topVolumesSortByKey, _topVolumesSortBy);
    setCachedData(AppLocalKey.topVolumesIsAscendingKey, _topVolumesIsAscending);
  }

  final ValueNotifier<TickerEntry?> _latestedTickerNotifier = ValueNotifier(
    null,
  );

  ValueNotifier<TickerEntry?> get latestedTickerNotifier =>
      _latestedTickerNotifier;

  TickerEntry? get latestedTicker => _latestedTickerNotifier.value;
  final ValueNotifier<OrderBookEntry?> _latestOrderBookNotifier = ValueNotifier(
    null,
  );

  ValueNotifier<OrderBookEntry?> get latestOrderBookNotifier =>
      _latestOrderBookNotifier;

  OrderBookEntry? get latestOrderBook => _latestOrderBookNotifier.value;

  String _sortBy = AppStorageKey.nameTitle;
  bool _isAscending = true;

  String _newCoinsSortBy = AppStorageKey.positionTitle;
  bool _newCoinsIsAscending = false;

  String _topVolumesSortBy = AppStorageKey.volumeTitle;
  bool _topVolumesIsAscending = false;

  String get sortBy => _sortBy;

  bool get isAscending => _isAscending;

  String get newCoinsSortBy => _newCoinsSortBy;

  bool get newCoinsIsAscending => _newCoinsIsAscending;

  String get topVolumesSortBy => _topVolumesSortBy;

  bool get topVolumesIsAscending => _topVolumesIsAscending;

  String get currentSortedColumn => _sortBy;

  String get currentNewCoinsSortedColumn => _newCoinsSortBy;

  String get currentTopVolumesSortedColumn => _topVolumesSortBy;

  List<AssetModel> _filteredAssets = [];

  List<AssetModel> get filteredAssets => _filteredAssets;

  OrderSocketModel? _latestOrder;

  OrderSocketModel? get latestOrder => _latestOrder;
  final hiveService = getIt<HiveService>();

  List<CoinModel> get coins =>
      getCachedData<List<CoinModel>>(AppLocalKey.coinsListKey) ?? _coins;
  List<CoinModel> _coins = [];

  Future<void> loadCoins() async {
    final cached = getCachedData<List<CoinModel>>(AppLocalKey.coinsListKey);
    if (cached != null) {
      _coins = cached;
      selectiveNotify([AppLocalKey.coinsListKey]);
      return;
    }
    setBusy(true);
    try {
      _coins = await _getCoinsUsecase();
      setCachedData(
        AppLocalKey.coinsListKey,
        _coins,
        expiry: Duration(minutes: 5),
      );
      selectiveNotify([AppLocalKey.coinsListKey]);
    } catch (e) {
      setError('Failed to load coins: $e');
    } finally {
      setBusy(false);
    }
  }

  // List<BannerModel> get banners =>
  //     getCachedData<List<BannerModel>>(AppLocalKey.bannersKey) ?? _banners;
  List<BannerModel> get banners => BannerMock.banners;
  List<BannerModel> _banners = [];

  Future<void> fetchBanners() async {
    final cached = getCachedData<List<BannerModel>>(AppLocalKey.bannersKey);
    if (cached != null) {
      _banners = cached;
      selectiveNotify([AppLocalKey.bannersKey]);
      return;
    }
    setBusy(true);
    clearError();
    try {
      _banners = await _homeBannerUseCase();
      setCachedData(
        AppLocalKey.bannersKey,
        _banners,
        expiry: Duration(minutes: 30),
      );
      selectiveNotify([AppLocalKey.bannersKey]);
    } catch (e) {
      _banners = [];
      setError('${context?.appLocaleLanguage.failedBanner}: ${e.toString()}');
    } finally {
      setBusy(false);
    }
  }

  LoginResponseModel? _currentUser;

  LoginResponseModel? get currentUser =>
      getCachedData<LoginResponseModel>(AppLocalKey.currentUserKey) ??
      _currentUser;

  Future<void> saveUser(LoginResponseModel user) async {
    _currentUser = user;
    setCachedData(
      AppLocalKey.currentUserKey,
      user,
      expiry: Duration(minutes: 10),
    );
    selectiveNotify([AppLocalKey.currentUserKey]);

    await saveToHive<String>(
      key: AppLocalKey.hiveKeyMainUser,
      boxName: AppLocalKey.hiveBoxNameUser,
      value: loginResponseModelToJson(user),
    );
  }

  Future<void> getUser() async {
    final cached = getCachedData<LoginResponseModel>(
      AppLocalKey.currentUserKey,
    );
    if (cached != null) {
      _currentUser = cached;
      selectiveNotify([AppLocalKey.currentUserKey]);
      return;
    }
    final jsonString = await hiveService.get(
      key: AppLocalKey.hiveKeyMainUser,
      boxName: AppLocalKey.hiveBoxNameUser,
    );
    if (jsonString is String) {
      _currentUser = loginResponseModelFromJson(jsonString);
      setCachedData(
        AppLocalKey.currentUserKey,
        _currentUser,
        expiry: Duration(minutes: 30),
      );
      selectiveNotify([AppLocalKey.currentUserKey]);
    }
  }

  void updateUser(LoginResponseModel user) async {
    await saveUser(user);
  }

  List<AssetModel> get allAssets =>
      getCachedData<List<AssetModel>>(AppLocalKey.allAssetsKey) ?? _allAssets;
  List<AssetModel> _allAssets = [];

  Future<void> loadAssets() async {
    final cached = getCachedData<List<AssetModel>>(AppLocalKey.allAssetsKey);
    if (cached != null && cached.isNotEmpty) {
      _allAssets = cached;
      selectiveNotify([AppLocalKey.allAssetsKey]);
      return;
    }
    setBusy(true);
    try {
      _allAssets = await _getAssetsUsecase();
      setCachedData(
        AppLocalKey.allAssetsKey,
        _allAssets,
        expiry: Duration(minutes: 5),
      );
      _calculateAssetOverview();
      selectiveNotify([AppLocalKey.allAssetsKey]);
    } catch (e) {
      setError(context?.appLocaleLanguage.failAsset);
    } finally {
      setBusy(false);
    }
  }

  BalanceResponseModel? _balanceResponseModel;

  BalanceResponseModel? get balanceResponseModel => _balanceResponseModel;

  set balanceResponseModel(BalanceResponseModel? value) {
    _balanceResponseModel = value;
    notifyListeners();
  }

  void _listenToSocket() {
    _socketManager.messages.listen(
      (event) {
        if (event is TickerEntry) {
          _latestedTickerNotifier.value = event;
        } else if (event is OrderBookEntry) {
          _latestOrderBookNotifier.value = event;
        }
      },
      onError: (err) {
        print("❌ Socket error in ViewModel: $err");
      },
    );
  }

  void connectSocket() {
    _socketManager.connect();
  }

  void disconnectSocket() {
    _socketManager.disconnect();
  }

  void changeCoin(String coinId) => _socketManager.changeCoinSocket(coinId);

  Future<void> toggleGlobalFavorite(String coinId) async {
    try {
      final hive = getIt<HiveService>();
      final coinIndex = coins.indexWhere((coin) => coin.id == coinId);
      if (coinIndex == -1) return;

      final currentCoin = coins[coinIndex];

      final ids =
          await hive.get(
                key: AppLocalKey.hiveKeyCoinBox,
                boxName: AppLocalKey.hiveBoxCoinBox,
              )
              as List<String>? ??
          [];

      if (currentCoin.ishar) {
        ids.remove(coinId);
      } else {
        if (!ids.contains(coinId)) {
          ids.add(coinId);
        }
      }

      await hive.put(
        key: AppLocalKey.hiveKeyCoinBox,
        boxName: AppLocalKey.hiveBoxCoinBox,
        value: ids,
      );

      coins[coinIndex] = currentCoin.copyWith(ishar: !currentCoin.ishar);
      setCachedData(AppLocalKey.coinsListKey, coins);
      selectiveNotify([AppLocalKey.coinsListKey]);
      notifyListeners();
    } catch (e) {
      setError('${context?.appLocaleLanguage.failedToToggleFavorite}: $e');
    }
  }

  Future<List<CurrencyModel>> filterCoinForDepositAndWithdraw() async {
    try {
      final filterCoins = await _getFilterCoinsUseCase();
      return filterCoins;
    } catch (e) {
      setError('${context?.appLocaleLanguage.failedToFilterCoins}: $e');
      return [];
    }
  }

  List<CoinModel> _computeSortedCoins(String sortBy, bool isAscending) {
    final coins =
        getCachedData<List<CoinModel>>(AppLocalKey.coinsListKey) ?? [];
    final sorted = List<CoinModel>.from(coins);
    sorted.sort((a, b) {
      int comparison = 0;
      switch (sortBy) {
        case AppStorageKey.nameHeader:
          comparison = a.name.compareTo(b.name);
          break;
        case AppStorageKey.priceHeader:
          comparison = FormatterUtils.parsePrice(
            a.lastPriceCurrency,
          ).compareTo(FormatterUtils.parsePrice(b.lastPriceCurrency));
          break;
        case AppStorageKey.changeHeader:
          comparison = FormatterUtils.parseChangePercent(
            a.priceChangePercent,
          ).compareTo(FormatterUtils.parseChangePercent(b.priceChangePercent));
          break;
        case AppStorageKey.positionTitle:
          comparison = a.position.compareTo(b.position);
          break;
        case AppStorageKey.volumeTitle:
          final volumeA = double.tryParse(a.volume) ?? 0.0;
          final volumeB = double.tryParse(b.volume) ?? 0.0;
          comparison = volumeA.compareTo(volumeB);
          break;
        default:
          comparison = 0;
      }
      return isAscending ? comparison : -comparison;
    });
    return sorted;
  }

  List<CoinModel> get sortedFavoriteCoins => getComputedData<List<CoinModel>>(
    '${AppLocalKey.sortedFavoriteCoins}_${_sortBy}_$_isAscending',
    () => _computeSortedCoins(
      _sortBy,
      _isAscending,
    ).where((coin) => coin.ishar).toList(),
    dependencies: [
      AppLocalKey.coinsListKey,
      AppLocalKey.sortByKey,
      AppLocalKey.isAscendingKey,
    ],
  );

  List<CoinModel> get sortedData => getComputedData<List<CoinModel>>(
    '${AppLocalKey.sortedDataKey}_${_sortBy}_$_isAscending',
    () => _computeSortedCoins(_sortBy, _isAscending),
    dependencies: [
      AppLocalKey.coinsListKey,
      AppLocalKey.sortByKey,
      AppLocalKey.isAscendingKey,
    ],
  );

  List<CoinModel> get newCoinsData => getComputedData<List<CoinModel>>(
    '${AppLocalKey.newCoinsDataKey}_${_newCoinsSortBy}_$_newCoinsIsAscending',
    () => _computeSortedCoins(_newCoinsSortBy, _newCoinsIsAscending),
    dependencies: [
      AppLocalKey.coinsListKey,
      AppLocalKey.newCoinsSortByKey,
      AppLocalKey.newCoinsIsAscendingKey,
    ],
  );

  List<CoinModel> get topVolumesData => getComputedData<List<CoinModel>>(
    '${AppLocalKey.topVolumesDataKey}_${_topVolumesSortBy}_$_topVolumesIsAscending',
    () => _computeSortedCoins(_topVolumesSortBy, _topVolumesIsAscending),
    dependencies: [
      AppLocalKey.coinsListKey,
      AppLocalKey.topVolumesSortByKey,
      AppLocalKey.topVolumesIsAscendingKey,
    ],
  );

  void toggleSort(String sortBy) {
    if (_sortBy == sortBy) {
      _isAscending = !_isAscending;
    } else {
      _sortBy = sortBy;
      _isAscending = true;
    }
    setCachedData(AppLocalKey.sortByKey, _sortBy);
    setCachedData(AppLocalKey.isAscendingKey, _isAscending);
    invalidateDependency(AppLocalKey.sortByKey);
    invalidateDependency(AppLocalKey.isAscendingKey);
    notifyListeners();
  }

  void toggleNewCoinsSort(String sortBy) {
    if (_newCoinsSortBy == sortBy) {
      _newCoinsIsAscending = !_newCoinsIsAscending;
    } else {
      _newCoinsSortBy = sortBy;
      _newCoinsIsAscending = true;
    }
    setCachedData(AppLocalKey.newCoinsSortByKey, _newCoinsSortBy);
    setCachedData(AppLocalKey.newCoinsIsAscendingKey, _newCoinsIsAscending);
    invalidateDependency(AppLocalKey.newCoinsSortByKey);
    invalidateDependency(AppLocalKey.newCoinsIsAscendingKey);
    notifyListeners();
  }

  void toggleTopVolumesSort(String sortBy) {
    if (_topVolumesSortBy == sortBy) {
      _topVolumesIsAscending = !_topVolumesIsAscending;
    } else {
      _topVolumesSortBy = sortBy;
      _topVolumesIsAscending = true;
    }
    setCachedData(AppLocalKey.topVolumesSortByKey, _topVolumesSortBy);
    setCachedData(AppLocalKey.topVolumesIsAscendingKey, _topVolumesIsAscending);
    invalidateDependency(AppLocalKey.topVolumesSortByKey);
    invalidateDependency(AppLocalKey.topVolumesIsAscendingKey);
    notifyListeners();
  }

  void startBalancesAndCurrenciesPolling({isInitPolling = false}) {
    if (isInitPolling) {
      if (_pollingBalanceAndCurrenciesTimer != null) {
        return;
      }
    }
    _pollingBalanceAndCurrenciesTimer?.cancel();
    Duration oldInterval = _currentInterval;

    _pollingBalanceAndCurrenciesTimer = Timer.periodic(_currentInterval, (
      timer,
    ) async {
      if (!_isAppInForeground) return;
      try {
        await getBalancesAndCurrencies();
        _onPollSuccess();
      } catch (e) {
        _onPollError();
      } finally {
        if (oldInterval != _currentInterval) {
          startBalancesAndCurrenciesPolling();
        }
      }
    });
  }

  void _onPollSuccess() {
    _consecutiveErrors = 0;
    if (_currentInterval.inSeconds > defaultTimePolling) {
      _currentInterval = Duration(seconds: defaultTimePolling);
    }
  }

  void _onPollError() {
    _consecutiveErrors++;
    _currentInterval = Duration(
      seconds: math.min(
        defaultTimePolling * math.pow(2, _consecutiveErrors).toInt(),
        20,
      ),
    );
  }

  void stopBalancesAndCurrenciesPolling() {
    _pollingBalanceAndCurrenciesTimer?.cancel();
    _pollingBalanceAndCurrenciesTimer = null;
  }

  void setAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _isAppInForeground = true;
        _currentInterval = Duration(seconds: defaultTimePolling);
        break;
      case AppLifecycleState.paused:
        _isAppInForeground = false;
        _currentInterval = Duration(seconds: 20);
        break;
      case AppLifecycleState.detached:
        stopBalancesAndCurrenciesPolling();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        break;
    }
  }

  bool isUpdatedAssets = false;
  bool isUpdatedCoins = false;

  Future<void> getBalancesAndCurrencies() async {
    if (_isUpdatingBalancesAndCurrencies) {
      return;
    }
    _isUpdatingBalancesAndCurrencies = true;
    try {
      final result = await _getBalancesAndCurrencies.call();

      _currencies = result.currencies;
      _balances = result.balances;

      final record = await compute(_updateBalancesAndCurrenciesInIsolate, (
        _coins,
        _currencies,
        _balances,
        _allAssets,
        isUpdatedCoins,
        isUpdatedAssets,
      ));

      _coins = record.updatedCoins;
      _allAssets = record.updatedAssets;
      isUpdatedCoins = record.isUpdatedCoins;
      isUpdatedAssets = record.isUpdatedAssets;
      setCachedData(
        AppLocalKey.allAssetsKey,
        _allAssets,
        expiry: Duration(minutes: 5),
      );
      setCachedData(
        AppLocalKey.coinsListKey,
        _coins,
        expiry: Duration(minutes: 5),
      );
      _calculateAssetOverview();
      isNotifyPollingBalancesAndCurrencies = true;
      notifyListeners();
    } catch (e) {
      setError('${AppStorageKey.failedToGetData}: $e');
    } finally {
      isUpdatedAssets = false;
      isUpdatedCoins = false;
      _isUpdatingBalancesAndCurrencies = false;
    }
  }

  static ({
    List<CoinModel> updatedCoins,
    List<AssetModel> updatedAssets,
    bool isUpdatedCoins,
    bool isUpdatedAssets,
  })
  _updateBalancesAndCurrenciesInIsolate(
    (
      List<CoinModel>,
      Map<String, CurrencyModel>,
      Map<String, BalanceResponseModel>,
      List<AssetModel>,
      bool isUpdatedCoins,
      bool isUpdatedAssets,
    )
    params,
  ) {
    final coins = params.$1;
    final currencies = params.$2;
    final balances = params.$3;
    final allAssets = params.$4;
    bool isUpdatedCoins = params.$5;
    bool isUpdatedAssets = params.$6;

    final updatedCoins = coins.map((coin) {
      final currency = currencies[coin.base_unit];
      if (currency != null) {
        if (coin.lastPriceCurrency != currency.price ||
            coin.deposit_enabled != currency.deposit_enabled ||
            coin.withdrawal_enabled != currency.withdrawal_enabled) {
          isUpdatedCoins = true;
        }
      }
      return coin.copyWith(
        lastPriceCurrency: currency!.price,
        deposit_enabled: currency.deposit_enabled,
        withdrawal_enabled: currency.withdrawal_enabled,
      );
    }).toList();

    final updatedAssets = allAssets.map((asset) {
      final balance = balances[asset.id];
      if (balance != null) {
        if (asset.spot != double.tryParse(balance.balance) ||
            asset.frozen != double.tryParse(balance.locked)) {
          isUpdatedAssets = true;
        }
      }
      return asset.copyWith(
        spot: double.tryParse(balance?.balance ?? '0') ?? 0.0,
        frozen: double.tryParse(balance?.locked ?? '0') ?? 0.0,
      );
    }).toList();
    return (
      updatedCoins: updatedCoins,
      updatedAssets: updatedAssets,
      isUpdatedCoins: isUpdatedCoins,
      isUpdatedAssets: isUpdatedAssets,
    );
  }

  @override
  void dispose() {
    stopBalancesAndCurrenciesPolling();
    _socketManager.disconnect();
    disposeResources();
    super.dispose();
  }

  void _calculateAssetOverview() {
    if (allAssets.isEmpty) {
      _assetOverview = null;
      _totalUSDT = 0.0;
      _percentageChange = 0.0;
      _previousTotal = null;
      setCachedData(AppLocalKey.assetOverviewKey, null);
      return;
    }

    final usdtAsset = _getUsdtAsset();
    final total = _calculateTotalUSDT();

    if (_previousTotal != null && _previousTotal != 0) {
      _changeAmount = total - _previousTotal!;
      _percentageChange = (_changeAmount / _previousTotal!) * 100;
    } else {
      _changeAmount = 0.0;
      _percentageChange = 0.0;
    }

    _previousTotal = total;
    _totalUSDT = total;

    _assetOverview = AssetOverview(
      totalAssets: FormatterUtils.formatNumber(
        value: total.truncateToDecimalPlaces(usdtAsset.precision),
        decimalDigits: usdtAsset.precision,
      ),
      unit: AppStorageKey.usdt,
      convertedValue: FormatterUtils.formatNumber(
        value: convertUsdtToUsd(
          total,
          usdtAsset.price,
        ).truncateToDecimalPlaces(usdtAsset.precision),
        decimalDigits: usdtAsset.precision,
      ),
    );

    setCachedData(AppLocalKey.assetOverviewKey, _assetOverview);
    selectiveNotify([AppLocalKey.assetOverviewKey]);
  }

  AssetModel _getUsdtAsset() {
    return allAssets.firstWhere((asset) => asset.symbol == AppStorageKey.usdt);
  }

  double _calculateTotalUSDT() {
    return allAssets.fold(
      0.0,
      (sum, asset) => sum + (asset.spot + asset.frozen) * asset.price,
    );
  }

  double convertUsdtToUsd(double usdtAmount, double usdtPriceInUsd) {
    return usdtAmount * usdtPriceInUsd;
  }
}
