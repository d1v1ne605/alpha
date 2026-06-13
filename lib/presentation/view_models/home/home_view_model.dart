import 'dart:async';

import 'package:alpha/core/constants/app_local_key.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/mixins/listener_mixin/add_listener_mixin.dart';
import 'package:alpha/core/mixins/listener_mixin/remove_listener_mixin.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/data/models/asset/asset_overview.dart';
import 'package:alpha/data/models/banner_models/translation_model.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_detail_model.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_detail_wrapper.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_model.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:alpha/data/services/local/hive_service.dart';
import 'package:alpha/domain/usecase/home/get_coin_crypto_usecase.dart';
import 'package:alpha/domain/usecase/trading/get_coin_detail_usecase.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/view_models/global_view_model.dart';
import 'package:flutter/material.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/mixins/local_storage/local_storage_mixin.dart';
import '../../../data/models/banner_models/banner_model.dart';
import '../../../data/models/banner_models/coin_price_model.dart';
import '../../../domain/usecase/home/home_banner_usecase.dart';

typedef CoinsListConfig = ({
  List<CoinModel> coins,
  void Function(String column)? onSort,
  String? sortedColumn,
});

class HomeViewModel extends BaseViewModel
    with LocalStorageMixin, RemoveListenerMixin, AddListenerMixin {
  final GlobalViewModel _basicViewModel;

  GlobalViewModel get globalViewModel => _basicViewModel;
  final HomeBannerUseCase homeBannerUseCase;
  final GetCoinDetailUsecase getCoinDetailUseCase;
  final GetCoinCryptoUsecase getCoinCryptoUseCase;
  Timer? _searchDebounce;

  HomeViewModel(
    this.homeBannerUseCase,
    this._basicViewModel,
    this.getCoinDetailUseCase,
    this.getCoinCryptoUseCase,
  ) {
    _searchController.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchDebounce?.cancel();
        _searchDebounce = Timer(const Duration(milliseconds: 300), () {
          notifyListeners();
        });
      });
    });
    initLocalStorage(_basicViewModel.hiveService);
  }

  void onGlobalViewModelChanged() {
    if (_basicViewModel.isUpdatedCoins &&
        _basicViewModel.currencies.isNotEmpty) {
      _basicViewModel.isNotifyPollingBalancesAndCurrencies = false;
    }
    Future.microtask(() {
      notifyListeners();
    });
  }

  List<CoinDetailModel> coinsCrypto = [];

  CoinDetailWrapper? _coinDetail;

  CoinDetailWrapper? get coinDetail => _coinDetail;

  List<CoinModel> get coins => _basicViewModel.coins;

  Map<String, CurrencyModel> get mapCurrencies => _basicViewModel.currencies;

  final TextEditingController _searchController = TextEditingController();

  TextEditingController get searchController => _searchController;

  List<BannerModel> get banners => _basicViewModel.banners;

  BannerModel? get currentBanner =>
      _basicViewModel.banners.isNotEmpty &&
          _currentIndexNotifier.value < _basicViewModel.banners.length
      ? _basicViewModel.banners[_currentIndexNotifier.value]
      : null;

  bool get hasError => errorMessage != null;

  bool get hasData => _basicViewModel.banners.isNotEmpty;
  List<CoinPriceModel> _coinPrices = List.generate(
    3,
    (_) => CoinPriceModel.empty(),
  );

  List<CoinPriceModel> get coinPrices => _coinPrices;

  AssetOverview? get assetOverview => _basicViewModel.assetOverview;

  double get changeAmount => _basicViewModel.changeAmount;

  double get percentageChange => _basicViewModel.percentageChange;
  bool _isBalanceVisible = false;

  bool get isBalanceVisible => _isBalanceVisible;

  final ValueNotifier<String> _selectedCategoryNotifier = ValueNotifier('');

  final filteredCoinsNotifier = ValueNotifier<List<CoinDetailModel>>([]);
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);
  final ValueNotifier<bool> _isBalanceVisibleNotifier = ValueNotifier(false);

  ValueNotifier<String> get selectedCategoryNotifier =>
      _selectedCategoryNotifier;

  ValueNotifier<int> get currentIndexNotifier => _currentIndexNotifier;

  ValueNotifier<bool> get isBalanceVisibleNotifier => _isBalanceVisibleNotifier;
  final ValueNotifier<int> selectedTabIndexDis = ValueNotifier<int>(0);
  final ValueNotifier<int> selectedTabIndexHome = ValueNotifier<int>(0);
  late TabController tabController;

  void initTabController(
    TickerProvider vsync,
    int initialIndex,
    int length,
    void Function(int index) onTabChanged,
  ) {
    tabController = TabController(
      length: length,
      vsync: vsync,
      initialIndex: initialIndex,
    );
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        onTabChanged(tabController.index);
      }
    });
  }

  void setSelectedTabIndexDis(int index) {
    selectedTabIndexDis.value = index;
  }

  void setSelectedTabIndexHome(int index) {
    selectedTabIndexHome.value = index;
  }

  void setSelectedCategory(String category, BuildContext context) {
    _selectedCategoryNotifier.value = category;
    _filterCoinsCrypto(category, context);
  }

  void initializeSelectedCategory(BuildContext context) {
    if (_selectedCategoryNotifier.value.isEmpty) {
      _selectedCategoryNotifier.value = context.appLocaleLanguage.all;
    }
  }

  void _filterCoinsCrypto(String category, BuildContext context) {
    List<CoinDetailModel> filtered = coinsCrypto;
    if (category != context.appLocaleLanguage.all) {
      if (category == context.appLocaleLanguage.favorites) {
        filtered = filtered.where((coin) => coin.ishar == true).toList();
      } else {
        filtered = filtered.where((coin) {
          return coin.currencyId.toUpperCase() == category.toUpperCase();
        }).toList();
      }
    }
    filteredCoinsNotifier.value = filtered;
  }

  void changeCoinSocket(String coinId) => _basicViewModel.changeCoin(coinId);

  Future<void> loadCoins() async {
    await _basicViewModel.loadCoins();
  }

  Future<void> loadCoinCrypto() async {
    final filterCoins = await getCoinCryptoUseCase();
    coinsCrypto = filterCoins;
    await _restoreFavoriteStates();
    _filterCoinsCrypto(_selectedCategoryNotifier.value, context!);
  }

  Future<void> toggleFavorite(String coinId) async {
    await _basicViewModel.toggleGlobalFavorite(coinId);
    notifyListeners();
  }

  Future<void> toggleFavoriteCrypto(String coinId) async {
    try {
      final hive = getIt<HiveService>();
      final coinIndex = coinsCrypto.indexWhere(
        (coin) => coin.currencyId == coinId,
      );
      if (coinIndex == -1) return;

      final currentCoin = coinsCrypto[coinIndex];
      final ids =
          await hive.get(
                key: AppLocalKey.hiveKeyCoinsCrypto,
                boxName: AppLocalKey.hiveBoxCoinsCrypto,
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
        key: AppLocalKey.hiveKeyCoinsCrypto,
        boxName: AppLocalKey.hiveBoxCoinsCrypto,
        value: ids,
      );

      coinsCrypto[coinIndex] = currentCoin.copyWith(ishar: !currentCoin.ishar);

      final currentCategory = selectedCategoryNotifier.value;

      if (currentCategory == context?.appLocaleLanguage.favorites) {
        filteredCoinsNotifier.value = coinsCrypto
            .where((c) => c.ishar)
            .toList();
      } else {
        filteredCoinsNotifier.value = List.from(coinsCrypto);
      }

      setCachedData(AppLocalKey.coinsListKey, coinsCrypto);
      selectiveNotify([AppLocalKey.coinsListKey]);
      notifyListeners();
    } catch (e) {
      setError('${context?.appLocaleLanguage.failedToToggleFavorite}: $e');
    }
  }

  Future<void> _restoreFavoriteStates() async {
    try {
      final hive = getIt<HiveService>();
      final favoriteIds =
          await hive.get(
                key: AppLocalKey.hiveKeyCoinsCrypto,
                boxName: AppLocalKey.hiveBoxCoinsCrypto,
              )
              as List<String>? ??
          [];

      for (int i = 0; i < coinsCrypto.length; i++) {
        final coin = coinsCrypto[i];
        final shouldBeFavorite = favoriteIds.contains(coin.currencyId);
        if (coin.ishar != shouldBeFavorite) {
          coinsCrypto[i] = coin.copyWith(ishar: shouldBeFavorite);
        }
      }
      notifyListeners();
    } catch (e) {
      setError('${AppStorageKey.failedToRestoreFavoriteStates}: $e');
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
    });
    _basicViewModel.removeListener(onGlobalViewModelChanged);
    _searchController.dispose();
    tabController.dispose();
    disposeResources();
    super.dispose();
  }

  List<CoinModel> get filteredCoins {
    if (_searchController.text.isEmpty) return List.from(coins);
    return coins.where((coin) {
      return coin.name.toLowerCase().contains(
        _searchController.text.toLowerCase(),
      );
    }).toList();
  }

  void onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(Duration(milliseconds: 300), () {
      selectiveNotify([AppLocalKey.filteredCoinsKey]);
    });
  }

  Future<void> fetchBanners() async {
    await _basicViewModel.fetchBanners();
  }

  void updateCurrentIndex(int index) {
    if (_currentIndexNotifier.value != index) {
      _currentIndexNotifier.value = index;
    }
  }

  void toggleBalanceVisibility() {
    _isBalanceVisibleNotifier.value = !_isBalanceVisibleNotifier.value;
  }

  Future<void> getCoinDetail(String coinId) async {
    try {
      _coinDetail = await getCoinDetailUseCase.call(coinId);
      notifyListeners();
    } catch (e) {
      setError('${AppStorageKey.failedToFetchCoinDetail}: $e');
    }
  }

  String get currentSortedColumn => _basicViewModel.currentSortedColumn;

  String get currentNewCoinsSortedColumn =>
      _basicViewModel.currentNewCoinsSortedColumn;

  String get currentTopVolumesSortedColumn =>
      _basicViewModel.currentTopVolumesSortedColumn;

  List<String> get targetNames => [
    AppStorageKey.BTCUSDT,
    AppStorageKey.ETHUSDT,
    AppStorageKey.alphaUSDT,
    AppStorageKey.BNBUSDT,
  ];

  List<CoinModel> get targetFavoriteCoins =>
      sortedData.where((coin) => targetNames.contains(coin.name)).toList();

  List<CoinModel> get sortedData => _basicViewModel.sortedData;

  List<CoinModel> get newCoinsData => _basicViewModel.newCoinsData;
  List<CoinModel> cryptoListCoin = [];

  void setCryptoCoin(String coinId) {
    cryptoListCoin = sortedData.where((c) => c.base_unit == coinId).toList();
  }

  List<dynamic> get topGainersData {
    return sortedData.where((coin) {
      final change = FormatterUtils.toDoubleCleaned(coin.priceChangePercent);
      return change >= 0.0;
    }).toList();
  }

  CoinDetailModel? getUpdatedCoin(CoinDetailModel? coin) {
    if (coin == null) return null;
    return coinsCrypto.firstWhere((c) => c.id == coin.id, orElse: () => coin);
  }

  List<CoinModel> get topVolumesData => _basicViewModel.topVolumesData;

  List<CoinModel> get sortedFavoriteCoins =>
      _basicViewModel.sortedFavoriteCoins;

  void onSort(String sortBy) => _basicViewModel.toggleSort(sortBy);

  void onNewCoinsSort(String sortBy) =>
      _basicViewModel.toggleNewCoinsSort(sortBy);

  void onTopVolumesSort(String sortBy) =>
      _basicViewModel.toggleTopVolumesSort(sortBy);

  Future<void> saveLastTappedCoinId(String coinId) async {
    final hiveService = getIt<HiveService>();
    await hiveService.put(
      key: AppLocalKey.lastTappedCoinId,
      value: coinId,
      boxName: AppLocalKey.commonBox,
    );
  }

  String getCurrentSortedColumn(String type) {
    switch (type) {
      case AppStorageKey.listNewKey:
        return currentNewCoinsSortedColumn;
      case AppStorageKey.listTopVolumesKey:
        return currentTopVolumesSortedColumn;
      case AppStorageKey.listCryptoKey:
      case AppStorageKey.listSpotKey:
      case AppStorageKey.listTopGainersKey:
      default:
        return currentSortedColumn;
    }
  }

  List<CoinModel> filteredCoinsAfterSorted({
    required List<CoinModel> coins,
    required String selectedCategory,
    required bool isCheckCategory,
  }) {
    List<CoinModel>? filteredCoins;
    if (selectedCategory != context?.appLocaleLanguage.all && isCheckCategory) {
      if (selectedCategory == context?.appLocaleLanguage.favorites) {
        filteredCoins = coins.where((coin) => coin.ishar == true).toList();
      } else {
        filteredCoins = coins.where((coin) {
          return coin.name.toUpperCase().contains(
            selectedCategory.toUpperCase(),
          );
        }).toList();
      }
    }
    return filteredCoins ?? coins;
  }

  // Default price currency is price currency in coins (List<CoinModel>)
  String checkPriceCurrency(String baseUnit, String defaultPriceCurrency) {
    if (mapCurrencies.isEmpty) {
      return defaultPriceCurrency;
    }
    return mapCurrencies[baseUnit]?.price ?? defaultPriceCurrency;
  }

  TranslationModel? getTranslationForLang(
    List<TranslationModel> translations,
    String langCode,
  ) {
    return translations.firstWhere((t) => t.language == langCode);
  }

  final hiveService = getIt<HiveService>();

  Future<TranslationModel?> getCurrentTranslation(BannerModel banner) async {
    final savedLocaleCode = await loadFromHive<String>(
      key: AppLocalKey.selectedLocale,
      boxName: AppLocalKey.commonBox,
    );
    final langCode = savedLocaleCode ?? 'en';
    return getTranslationForLang(banner.translations, langCode);
  }

  final ValueNotifier<String?> currentSortedColumnCryptoNotifier =
      ValueNotifier<String?>(null);

  String? get currentSortedColumnCrypto =>
      currentSortedColumnCryptoNotifier.value;
  bool isAscending = true;

  void onSortCrypto(String sortBy) {
    if (currentSortedColumnCrypto == sortBy) {
      isAscending = !isAscending;
    } else {
      currentSortedColumnCryptoNotifier.value = sortBy;
      isAscending = true;
    }
    sortFilteredCoinsCrypto(sortBy, isAscending);
  }

  void sortFilteredCoinsCrypto(String sortBy, bool isAscending) {
    final coins = List<CoinDetailModel>.from(filteredCoinsNotifier.value);
    coins.sort((a, b) {
      int comparison = 0;
      switch (sortBy) {
        case AppStorageKey.nameHeader:
          comparison = a.currencyId.compareTo(b.currencyId);
          break;
        case AppStorageKey.priceHeader:
          comparison = FormatterUtils.parsePrice(
            a.last ?? '0.0',
          ).compareTo(FormatterUtils.parsePrice(b.last ?? '0.0'));
          break;
        case AppStorageKey.changeHeader:
          comparison =
              FormatterUtils.parseChangePercent(
                a.price_change_percent ?? '0.0',
              ).compareTo(
                FormatterUtils.parseChangePercent(
                  b.price_change_percent ?? '0.0',
                ),
              );
          break;
        default:
          comparison = 0;
      }
      return isAscending ? comparison : -comparison;
    });

    filteredCoinsNotifier.value = coins;
  }
}
