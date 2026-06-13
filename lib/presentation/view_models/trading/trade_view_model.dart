import 'dart:async';

import 'package:alpha/core/constants/app_local_key.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/env/env.dart';
import 'package:alpha/core/mixins/listener_mixin/add_listener_mixin.dart';
import 'package:alpha/core/mixins/listener_mixin/remove_listener_mixin.dart';
import 'package:alpha/core/mixins/local_storage/local_storage_mixin.dart';
import 'package:alpha/core/network/app_exception.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_detail_wrapper.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_model.dart';
import 'package:alpha/data/models/trading/trade/order_form_request_model.dart';
import 'package:alpha/data/models/trading/trade/order_item_model.dart';
import 'package:alpha/data/models/trading/trade/ticker_data.dart';
import 'package:alpha/data/services/local/hive_service.dart';
import 'package:alpha/domain/usecase/trading/cancel_all_orders_usecases.dart';
import 'package:alpha/domain/usecase/trading/get_coin_detail_usecase.dart';
import 'package:alpha/domain/usecase/trading/get_order_book_usecase.dart';
import 'package:alpha/domain/usecase/trading/submit_order_usecase.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/view_models/trading/interface/base_tab_order.dart';
import 'package:alpha/presentation/view_models/trading/managers/order_book_manager.dart';
import 'package:alpha/presentation/view_models/trading/managers/order_form_manager.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TradeViewModel extends BaseTabOrder
    with
        LocalStorageMixin,
        OrderFormManager,
        OrderBookManager,
        RemoveListenerMixin,
        AddListenerMixin {
  final SubmitOrderUseCase submitOrderUseCase;
  final GetOrderBookUseCase getOrderBookUseCase;
  final CancelAllOrdersUseCases cancelAllOrdersUseCases =
      CancelAllOrdersUseCases(getIt());

  TradeViewModel(
    super._globalViewModel,
    this.getOrderBookUseCase,
    this.getCoinDetailUseCase,
    super.getTranscationUsecase,
    this.submitOrderUseCase,
    super.getOrdersUseCase,
    super.cancelOrderUseCase,
    super.getTradeHistoryUseCase,
  ) {}

  final GetCoinDetailUsecase getCoinDetailUseCase;

  void loadBalances() {
    if (globalViewModel.balances.isEmpty) {
      availableCoin = 0.0;
      availableQuoteBalance = 0.0;
      return;
    }

    final newQuoteBalance =
        double.tryParse(
          globalViewModel
                  .balances[currentCoin?.quote_unit.toLowerCase()]
                  ?.balance ??
              '0',
        ) ??
        0.0;
    final newCoinBalance =
        double.tryParse(
          globalViewModel
                  .balances[currentCoin?.base_unit.toLowerCase()]
                  ?.balance ??
              '0',
        ) ??
        0.0;
    if (newQuoteBalance != availableQuoteBalance ||
        newCoinBalance != availableCoin) {
      availableQuoteBalance = newQuoteBalance;
      availableCoin = newCoinBalance;
      Future.microtask(() => notifyListeners());
    }
  }

  // Update current coin info after 5s polling balances and currencies
  void updateCurrentCoinAfterPolling() {
    final baseUnit = currentCoin?.base_unit.toLowerCase();
    currentCoin = currentCoin?.copyWith(
      lastPriceCurrency:
          globalViewModel.currencies[baseUnit]?.price ??
          currentCoin?.lastPriceCurrency ??
          '0',
      withdrawal_enabled:
          globalViewModel.currencies[baseUnit]?.withdrawal_enabled ??
          currentCoin?.withdrawal_enabled ??
          false,
      deposit_enabled:
          globalViewModel.currencies[baseUnit]?.deposit_enabled ??
          currentCoin?.deposit_enabled ??
          false,
    );
    Future.microtask(() => notifyListeners());
  }

  double _approximatelyUSDPriceOfCoin = 0.0;

  double get approximatelyUSDPriceOfCoin {
    if (currentCoin == null) return 0.0;
    _approximatelyUSDPriceOfCoin =
        priceOfCoin * double.parse(currentCoin?.quote_price ?? '0');
    return _approximatelyUSDPriceOfCoin >= 0
        ? _approximatelyUSDPriceOfCoin
        : 0.0;
  }

  set approximatelyUSDPriceOfCoin(double value) {
    if (_approximatelyUSDPriceOfCoin != value && value >= 0) {
      _approximatelyUSDPriceOfCoin = value;
      notifyListeners();
    }
  }

  final StreamController<TickerData> _tickerDataController =
      StreamController<TickerData>.broadcast();

  Stream<TickerData> get tickerDataStream => _tickerDataController.stream;

  String _selectedFrame = '';

  String get selectedFrame => _selectedFrame;
  CoinDetailWrapper? _coinDetail;

  CoinDetailWrapper? get coinDetail => _coinDetail;

  bool _isReloadOrdersDisabled = false;

  bool get isReloadOrdersDisabled => _isReloadOrdersDisabled;

  set isReloadOrdersDisabled(bool value) {
    if (_isReloadOrdersDisabled != value) {
      _isReloadOrdersDisabled = value;
      notifyListeners();
    }
  }

  void onGlobalViewModelChanged() {
    if (currentCoin != null) {
      final updatedCoin = globalViewModel.coins.firstWhere(
        (coin) => coin.id == currentCoin!.id,
        orElse: () => currentCoin!,
      );
      currentCoin = updatedCoin;
      notifyListeners();
    }
    if (globalViewModel.isNotifyPollingBalancesAndCurrencies) {
      loadBalances();
      if (globalViewModel.isUpdatedCoins) {
        updateCurrentCoinAfterPolling();
      }
      globalViewModel.isNotifyPollingBalancesAndCurrencies = false;
      return;
    }
  }

  void onLatestOrderBookChanged() {
    if (!isOrderBookInitialized) return;
    final latestOrderBook = globalViewModel.latestOrderBookNotifier.value;
    if (latestOrderBook != null) {
      final currentCoinId = currentCoin?.id;
      if (currentCoinId != null && latestOrderBook.market == currentCoinId) {
        updateDepthOrderBook(latestOrderBook);
      }
    }
    coinGetStream();
  }

  void coinGetStream() {
    final coin = globalViewModel.latestedTickerNotifier.value;
    if (coin != null && currentCoin?.id == coin.coin) {
      _tickerDataController.add(coin.data);
      updateOrderValueWhenMarketPriceChanges(
        double.tryParse(coin.data.last) ?? 0.0,
      );
    }
  }

  Future<void> loadCoins() async {
    await globalViewModel.loadCoins();
  }

  Future<void> initializeCoin(CoinModel? newCoin) async {
    clearError();
    final hiveService = getIt<HiveService>();
    bool coinChanged = false;
    setBusy(true);
    if (newCoin != null) {
      if (currentCoin?.id != newCoin.id) {
        currentCoin = newCoin;
        coinChanged = true;
        orderPendingItemNotifier.value.clear();
        orderItemNotifier.value.clear();
        resetOrderBookData();
        unawaited(
          Future.wait([
            hiveService.put(
              key: AppLocalKey.lastTappedCoinId,
              value: newCoin.id,
              boxName: AppLocalKey.commonBox,
            ),
          ]),
        );
      }
    } else {
      if (globalViewModel.coins.isEmpty) {
        await globalViewModel.loadCoins();
      }

      final results = await Future.wait([
        hiveService.get(
          key: AppLocalKey.lastTappedCoinId,
          boxName: AppLocalKey.commonBox,
        ),
      ]);

      final lastId = results[0];

      if (globalViewModel.coins.isNotEmpty) {
        final coinById = globalViewModel.coins.firstWhere(
          (c) => c.id == lastId,
          orElse: () => globalViewModel.coins.first,
        );
        if (currentCoin?.id != coinById.id) {
          currentCoin = coinById;
          coinChanged = true;
          resetOrderBookData();
        }
      }
    }
    if (coinChanged && currentCoin != null) {
      _coinDetail = null;
      loadInitData();
      setSelectedFrame('15m', forceUpdate: true);
      unawaited(getOrderBook(currentCoin!.id));
    }
    setBusy(false);
  }

  void loadInitData() {
    try {
      pricePrecision = currentCoin?.price_precision ?? 0;
      quantityPrecision = currentCoin?.amount_precision ?? 0;
      final coinId = currentCoin?.base_unit;
      final market = currentCoin?.id ?? AppStorageKey.btcUsdt;
      if (coinId != null) {
        unawaited(getCoinDetail(coinId));
      }
      unawaited(getLastTransaction(market));
    } catch (e) {
      setError('${AppStorageKey.failedToLoadInitialData}: $e');
    }
  }

  void setOrderFormValues(double coinPrice, double amount) {
    approximatelyUSDPriceOfCoin =
        coinPrice * double.parse(currentCoin?.quote_price ?? '0');

    priceOfCoin = coinPrice >= 0 ? coinPrice : 0.0;
    priceOfCoinController.text = FormatterUtils.formatPrice(priceOfCoin);

    final safeAmount = amount >= 0 ? amount : 0.0;
    quantityController.text = FormatterUtils.formatPrice(
      safeAmount.truncateToDecimalPlaces(quantityPrecision),
    );
  }

  Future<void> submitOrder(String market) async {
    setBusy(true);
    final error = validateOrder();
    if (error != null) {
      setError(error);
      setBusy(false);
      statusExecutingOrder = false;
      return;
    }
    try {
      isExecutingOrder = true;
      await submitOrderUseCase.call(
        OrderFormRequestModel(
          market: market,
          side: orderFormType.value == OrderTypeEnum.buy
              ? AppStorageKey.orderSideBuy
              : AppStorageKey.orderSideSell,
          ordType: orderTypeKey,
          volume: FormatterUtils.formatPrice(
            quantity.truncateToDecimalPlaces(quantityPrecision),
          ),
          price: selectedOrderType == context?.appLocaleLanguage.limit
              ? FormatterUtils.formatPrice(priceOfCoin)
              : null,
        ),
        context,
      );
    } on ServerException catch (e) {
      setError(e.message);
      isExecutingOrder = false;
      setBusy(false);
    } catch (e) {
      isExecutingOrder = false;
      setBusy(false);
      setError('${AppStorageKey.failedToSubmitOrder}: $e');
    } finally {
      quantity = 0;
      sliderPercent = 0;
      quantityController.clear();
      orderValueController.clear();
      if (selectedOrderType == context?.appLocaleLanguage.market) {
        isExecutingOrder = false;
        setBusy(false);
      }
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  Future<void> getCoinDetail(String coinId) async {
    try {
      _coinDetail = await getCoinDetailUseCase.call(coinId);
      notifyListeners();
    } catch (e) {
      _coinDetail = null;
    }
  }

  String? _lastLoadedMarket;
  String? _lastLoadedTimeFrame;

  String? get lastLoadedMarket => _lastLoadedMarket;

  String? get lastLoadedTimeFrame => _lastLoadedTimeFrame;

  WebViewController _webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted);

  WebViewController get webViewController => _webViewController;

  void setSelectedFrame(String value, {bool forceUpdate = false}) {
    if (value != _selectedFrame || forceUpdate) {
      _selectedFrame = value;
      if (_lastLoadedMarket != currentCoin?.id ||
          _lastLoadedTimeFrame != value) {
        _lastLoadedMarket = currentCoin?.id;
        _lastLoadedTimeFrame = value;

        if (forceUpdate) {
          _webViewController = WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted);
        }

        _webViewController.loadRequest(
          Uri.parse(
            Env.webviewUrl +
                'app-chart?lang=en&market=$_lastLoadedMarket&chart_mode=trading_view&width=${double.infinity}&height=300px&time_frame=$_lastLoadedTimeFrame',
          ),
        );
      }
      Future.microtask(() => notifyListeners());
    }
  }

  void changeOrderFormType(OrderTypeEnum type) {
    if (type == orderFormType.value) return;
    orderFormType.value = type;
  }

  Future<void> toggleFavorite(String coinId) async {
    await globalViewModel.toggleGlobalFavorite(coinId);

    final updated = globalViewModel.coins.firstWhere(
      (e) => e.id == coinId,
      orElse: () => currentCoin!,
    );

    currentCoin = updated;
    notifyListeners();
  }

  void onOrderBookItemTapped(double targetPrice, OrderTypeEnum type) {
    double totalAmount = 0.0;
    final bool isAskSide = type == OrderTypeEnum.sell;

    final List<List<String>> list = isAskSide
        ? (depthOrderBook.asks)
        : (depthOrderBook.bids);

    for (var item in list) {
      if (item.length < 2) continue;

      final double itemPrice = FormatterUtils.parsePrice(item[0]);
      final double itemAmount = FormatterUtils.parsePrice(item[1]);
      bool shouldAccumulate = isAskSide
          ? (itemPrice <= targetPrice)
          : (itemPrice >= targetPrice);

      if (shouldAccumulate) {
        totalAmount += itemAmount;
        if (itemPrice == targetPrice) {
          break;
        }
      } else {
        break;
      }
    }
    setOrderFormValues(targetPrice, totalAmount);
    updateOrder(
      value: totalAmount.truncateToDecimalPlaces(quantityPrecision).toString(),
      type: UpdateOrderTradeEnum.quantity,
    );
  }

  Future<List<OrderItemModel>> cancelAllOrders(String market) async {
    try {
      if (orderPendingItemNotifier.value.isEmpty) {
        setError(context?.appLocaleLanguage.noPendingOrdersToCancel);
        return [];
      }
      setBusy(true);
      isExecutingOrder = true;
      final List<OrderItemModel> response = await cancelAllOrdersUseCases.call(
        market,
      );
      return response;
    } catch (e) {
      setError('${AppStorageKey.failedToCancelAllOrders}: $e');
      rethrow;
    } finally {}
  }

  Future<void> getOrderBook(String market, {isNotify = true}) async {
    isOrderBookInitialized = false;
    try {
      final response = await getOrderBookUseCase.call(market);

      asksMap.clear();
      bidsMap.clear();

      for (final ask in response.asks) {
        if (ask.length >= 2 && ask[0].isNotEmpty && ask[1].isNotEmpty) {
          final price = double.tryParse(ask[0]) ?? 0.0;
          if (price > 0) {
            asksMap[price] = ask;
          }
        }
      }

      for (final bid in response.bids) {
        if (bid.length >= 2 && bid[0].isNotEmpty && bid[1].isNotEmpty) {
          final price = double.tryParse(bid[0]) ?? 0.0;
          if (price > 0) {
            bidsMap[price] = bid;
          }
        }
      }

      depthOrderBook = response;
      orderBookController.add(depthOrderBook);
      isOrderBookInitialized = true;
    } catch (e) {
      setError('${AppStorageKey.failedToFetchOrderBook}: $e');
      rethrow;
    } finally {
      if (isNotify) {
        notifyListeners();
      }
    }
  }

  void setSelectedOrderType(String value) {
    if (selectedOrderType == value) return;
    final oldOrderType = selectedOrderType;
    final originalPriceOfCoin = priceOfCoin;
    selectedOrderType = value;
    if (!isLimitOrder) {
      lastPrice = _getLatestPrice() ?? lastPrice;
    } else if (oldOrderType != context?.appLocaleLanguage.limit) {
      priceOfCoinController.text = FormatterUtils.formatPrice(
        originalPriceOfCoin,
      );
    }
    updateOrderValueWhenChangeMarketType();
    notifyListeners();
  }

  double? _getLatestPrice() {
    final tickerPrice = globalViewModel.latestedTickerNotifier.value?.data.last;
    if (tickerPrice != null) {
      return double.tryParse(tickerPrice);
    }
    if (currentCoin?.lastPrice != null) {
      return double.tryParse(currentCoin!.lastPrice);
    }
    return null;
  }

  void updateOrderValueWhenMarketPriceChanges(double marketPrice) {
    if (!isLimitOrder) {
      lastPrice = marketPrice;
      orderValueController.text = lastPrice == 0
          ? ''
          : FormatterUtils.formatPrice(
              (lastPrice * quantity).truncateToDecimalPlaces(
                orderValuePrecision,
              ),
            );
    }
  }

  @override
  void dispose() {
    _tickerDataController.close();
    globalViewModel.removeListener(onGlobalViewModelChanged);
    globalViewModel.latestedTickerNotifier.addListener(coinGetStream);

    disposeOrderBook();
    orderFormTypeDispose();
    disposeResources();
    disposeOrderSocketManager();
    super.dispose();
  }
}
