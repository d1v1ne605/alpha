import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/data/models/trading/trade/order_item_model.dart';
import 'package:alpha/data/models/trading/trade/trade_history_model.dart';
import 'package:alpha/presentation/view_models/trading/interface/base_tab_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class _OrderPortalStateManager {
  bool isLoadingMore = false;
  bool isMoreData = true;
  int currentPage = 1;
  String? selectedType;
  String? selectedPair;
  String? selectedSide;
  DateTime? fromDate;
  DateTime? toDate;
  bool fromDateError = false;
  bool toDateError = false;
  ScrollController scrollController = ScrollController();
  VoidCallback? scrollListener;
  bool hasInitialLoaded = false;

  void reset() {
    isLoadingMore = false;
    isMoreData = true;
    currentPage = 1;
    fromDateError = false;
    toDateError = false;
  }

  void resetFilters() {
    selectedType = null;
    selectedPair = null;
    selectedSide = null;
    fromDate = null;
    toDate = null;
    fromDateError = false;
    toDateError = false;
  }
}

class OrderViewModel extends BaseTabOrder {
  final Map<OrderPortalType, _OrderPortalStateManager> _stateManagers = {
    OrderPortalType.order: _OrderPortalStateManager(),
    OrderPortalType.orderHistory: _OrderPortalStateManager(),
    OrderPortalType.tradeHistory: _OrderPortalStateManager(),
  };

  _OrderPortalStateManager getStateManager(OrderPortalType type) =>
      _stateManagers[type]!;

  List<OrderItemModel> _filteredPendingOrders = [];
  List<OrderItemModel> _filteredOrders = [];
  List<TradeHistoryModel> _filteredTradeHistory = [];
  final typeOptions = [
    AppStorageKey.all,
    AppStorageKey.limit,
    AppStorageKey.market,
  ];
  final sideOptions = [
    AppStorageKey.all,
    AppStorageKey.buy,
    AppStorageKey.sell,
  ];
  final List<dynamic> pairOptions = [];
  String? orderIdBeDeleted;

  bool canFilter(OrderPortalType type) {
    final stateManager = getStateManager(type);
    return !stateManager.fromDateError &&
        !stateManager.toDateError &&
        stateManager.fromDate != null &&
        stateManager.toDate != null;
  }

  OrderViewModel(
    super._basicViewModel,
    super.getTranscationUsecase,
    super.getOrdersUseCase,
    super.cancelOrderUseCase,
    super.getTradeHistoryUseCase,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupNotifierListeners();
    });
  }

  void _setupNotifierListeners() {
    orderPendingItemNotifier.addListener(() {
      final stateManager = getStateManager(OrderPortalType.order);
      if (stateManager.hasInitialLoaded == false) return;
      if (stateManager.isLoadingMore) return;
      int overflowCount = countDiffItemsOriginalVsFiltered(
        orderPendingItemNotifier.value,
        _filteredPendingOrders,
      );
      for (int i = 0; i < overflowCount; i++) {
        checkNewOrderIsMatchWithFilter(
          orderPendingItemNotifier.value[i],
          OrderPortalType.order,
        );
      }
      _filteredPendingOrders = List.from(orderPendingItemNotifier.value);

      // Delete an order that you manually removed from the filter list
      if (timeToLoadMore != null && orderIdBeDeleted != null) {
        _filteredPendingOrders.removeWhere(
          (order) => order.id.toString() == orderIdBeDeleted,
        );
        orderIdBeDeleted = null;
      }
      notifyListeners();
    });

    orderItemNotifier.addListener(() {
      final stateManager = getStateManager(OrderPortalType.orderHistory);
      if (stateManager.isLoadingMore) return;
      if (stateManager.hasInitialLoaded == false) return;
      int overflowCount = countDiffItemsOriginalVsFiltered(
        orderItemNotifier.value,
        _filteredOrders,
      );
      for (int i = 0; i < overflowCount; i++) {
        checkNewOrderIsMatchWithFilter(
          orderItemNotifier.value[i],
          OrderPortalType.orderHistory,
        );
      }
      _filteredOrders = List.from(orderItemNotifier.value);
      notifyListeners();
    });
  }

  void checkNewOrderIsMatchWithFilter(
    OrderItemModel newOrder,
    OrderPortalType type,
  ) {
    final stateManager = getStateManager(type);

    final selectedType = stateManager.selectedType;
    final selectedPair = stateManager.selectedPair;
    final selectedSide = stateManager.selectedSide;
    final fromDate = stateManager.fromDate;
    final toDate = stateManager.toDate;
    final matchesType =
        selectedType == null ||
        selectedType == AppStorageKey.all ||
        (newOrder.ordType.toLowerCase() == selectedType.toLowerCase());
    final matchesPair =
        selectedPair == null ||
        selectedPair == AppStorageKey.all ||
        (newOrder.market.toLowerCase() == selectedPair.toLowerCase());
    final matchesSide =
        selectedSide == null ||
        selectedSide == AppStorageKey.all ||
        (newOrder.side.toLowerCase() == selectedSide.toLowerCase());
    final matchesFromDate =
        fromDate == null ||
        FormatterUtils.isSameOrAfter(newOrder.createdAt, fromDate);
    final matchesToDate =
        toDate == null ||
        FormatterUtils.isSameOrBefore(newOrder.createdAt, toDate);
    final matchesAll =
        matchesType &&
        matchesPair &&
        matchesSide &&
        matchesFromDate &&
        matchesToDate;
    switch (type) {
      case OrderPortalType.order:
        if (matchesAll) return;
        orderPendingItemNotifier.value.removeWhere(
          (order) => order.id.toString() == newOrder.id.toString(),
        );
        break;
      case OrderPortalType.orderHistory:
        if (matchesAll) return;
        orderItemNotifier.value.removeWhere(
          (order) => order.id.toString() == newOrder.id.toString(),
        );
        break;
      default:
        return;
    }
  }

  int countDiffItemsOriginalVsFiltered<T>(
    List<T> originalList,
    List<T> filteredList,
  ) {
    return originalList.length - filteredList.length;
  }

  void init(String? state, OrderPortalType type) async {
    final stateManager = getStateManager(type);
    stateManager.reset();
    setBusy(true);
    final controller = stateManager.scrollController;

    if (stateManager.scrollListener != null) {
      controller.removeListener(stateManager.scrollListener!);
    }
    stateManager.scrollListener = () => _onScroll(type, state);
    controller.addListener(stateManager.scrollListener!);

    await _loadInitData(type: type);
    stateManager.hasInitialLoaded = true;
    setBusy(false);

    _updatePairOptions();
    notifyListeners();
  }

  List<dynamic> getOrdersByType(OrderPortalType type) {
    switch (type) {
      case OrderPortalType.order:
        return List.from(_filteredPendingOrders);
      case OrderPortalType.orderHistory:
        return List.from(_filteredOrders);
      case OrderPortalType.tradeHistory:
        return List.from(_filteredTradeHistory);
    }
  }

  Future<void> _loadInitData({
    required OrderPortalType type,
    int currentPage = 1,
    bool isRefresh = false,
  }) async {
    final stateManager = getStateManager(type);
    final pageSize = type == OrderPortalType.order
        ? AppStorageKey.orderPageSize
        : AppStorageKey.orderHistoryLimit;
    final state = type == OrderPortalType.order
        ? AppStorageKey.waitStatusOrder
        : null;

    if (type == OrderPortalType.tradeHistory) {
      await getTradeHistory(
        limit: AppStorageKey.transactionHistoryLimit.toString(),
        page: currentPage.toString(),
      );
      _filteredTradeHistory = tradeHistory;
    } else {
      await loadOrders(
        state: state,
        limit: pageSize.toString(),
        page: currentPage.toString(),
        isRefresh: isRefresh,
        isNotify: true,
        forceReload: true,
      );
      if (type == OrderPortalType.order) {
        _filteredPendingOrders = List.from(orderPendingItemNotifier.value);
        stateManager.isMoreData =
            orderPendingItemNotifier.value.length >= pageSize;
      } else if (type == OrderPortalType.orderHistory) {
        _filteredOrders = List.from(orderItemNotifier.value);
        stateManager.isMoreData = orderItemNotifier.value.length >= pageSize;
      }
    }
    notifyListeners();
  }

  Future<void> refresh(OrderPortalType type) async {
    final stateManager = getStateManager(type);
    stateManager.reset();
    _applyFilters(type, isFilterAll: true);
  }

  void _onScroll(OrderPortalType type, String? state) {
    final stateManager = getStateManager(type);
    final controller = stateManager.scrollController;
    if (!controller.hasClients) return;

    final maxScrollExtent = controller.position.maxScrollExtent;
    final currentScroll = controller.offset;

    final isNearBottom = currentScroll >= maxScrollExtent * 0.8;
    final isScrollingDown =
        controller.position.userScrollDirection == ScrollDirection.reverse;
    final pageSize = type == OrderPortalType.order
        ? AppStorageKey.orderPageSize
        : AppStorageKey.orderHistoryLimit;
    if (isNearBottom &&
        (isScrollingDown || getOrdersByType(type).length <= 10) &&
        !stateManager.isLoadingMore &&
        stateManager.isMoreData &&
        stateManager.hasInitialLoaded) {
      _loadMoreData(type, pageSize, state);
    }
  }

  Future<void> _loadMoreData(
    OrderPortalType type,
    int pageSize,
    String? state,
  ) async {
    final stateManager = getStateManager(type);
    final currentPage = stateManager.currentPage;
    if (stateManager.isLoadingMore || !stateManager.isMoreData) return;
    stateManager.isLoadingMore = true;

    int initialOrderCount = getOrdersByType(type).length;
    final Map<String, int> dataOverflow = checkOverflowPendingItemForPagination(
      initialOrderCount: initialOrderCount,
      currentPage: currentPage,
      statusOrder: type == OrderPortalType.order
          ? AppStorageKey.waitStatusOrder
          : null,
      pageSize: pageSize,
      orderPortalType: type,
    );
    final int overflowCount =
        dataOverflow[AppStorageKey.keyOverflowOrderLimit] ?? 0;
    initialOrderCount =
        dataOverflow[AppStorageKey.keyInitialOrderCount] ?? initialOrderCount;
    // load more with timeTo and limit
    int? timeTo;
    final limit = overflowCount > 0 ? pageSize + overflowCount : pageSize;
    int page = overflowCount > 0 ? 1 : currentPage + 1;
    if (overflowCount > 0) {
      timeTo = timeToLoadMore;
    }

    final selectedType = stateManager.selectedType?.toLowerCase();
    final selectedPair = stateManager.selectedPair?.toLowerCase();
    final selectedSide = stateManager.selectedSide?.toLowerCase();
    final fromDate = stateManager.fromDate != null
        ? (stateManager.fromDate!.millisecondsSinceEpoch / 1000).round()
        : null;
    final toDate = stateManager.toDate != null
        ? (stateManager.toDate!.millisecondsSinceEpoch / 1000).round()
        : null;

    if (type == OrderPortalType.tradeHistory) {
      final response = await getTradeHistoryUseCase.call(
        limit: limit.toString(),
        page: page.toString(),
        market: selectedPair,
        timeFrom: fromDate,
        timeTo: timeTo,
      );
      tradeHistory.addAll(response);
      _filteredTradeHistory = tradeHistory;
    } else {
      await loadOrders(
        state: state,
        limit: limit.toString(),
        page: page.toString(),
        market: selectedPair,
        orderType: selectedType,
        type: selectedSide,
        timeFrom: fromDate,
        timeTo: toDate ?? timeTo,
        isNotify: true,
        isLoadMore: true,
      );
      if (type == OrderPortalType.order) {
        _filteredPendingOrders = orderPendingItemNotifier.value;
      } else {
        _filteredOrders = orderItemNotifier.value;
      }
    }

    final newOrderCount = getOrdersByType(type).length;
    timeToLoadMore = null;
    stateManager.isMoreData = hasMoreData(
      initialOrderCount: initialOrderCount,
      newOrderCount: newOrderCount,
      pageSize: type == OrderPortalType.order
          ? AppStorageKey.orderPageSize
          : AppStorageKey.orderHistoryLimit,
      currentPage: page,
    );

    stateManager.currentPage = currentPage + 1;
    stateManager.isLoadingMore = false;
    setBusy(false);
    notifyListeners();
  }

  List<T> _filterList<T>(List<T> source, OrderPortalType type) {
    var filteredList = List<T>.from(source);
    final stateManager = getStateManager(type);
    final selectedType = stateManager.selectedType;
    final selectedPair = stateManager.selectedPair;
    final selectedSide = stateManager.selectedSide;
    final fromDate = stateManager.fromDate;
    final toDate = stateManager.toDate;

    if (selectedType != null && selectedType != AppStorageKey.all) {
      filteredList = filteredList.where((e) {
        final value = _getCompareField(e, OrderFilterType.Type);
        return value?.toLowerCase() == selectedType.toLowerCase();
      }).toList();
    }

    if (selectedPair != null && selectedPair != AppStorageKey.all) {
      filteredList = filteredList.where((e) {
        final value = _getCompareField(e, OrderFilterType.Pair);
        return value?.toLowerCase() == selectedPair.toLowerCase();
      }).toList();
    }

    if (selectedSide != null && selectedSide != AppStorageKey.all) {
      filteredList = filteredList.where((e) {
        final value = _getCompareField(e, OrderFilterType.Side);
        return value?.toLowerCase() == selectedSide.toLowerCase();
      }).toList();
    }

    if (fromDate != null || toDate != null) {
      filteredList = filteredList.where((e) {
        var date = (e as dynamic)?.createdAt ?? (e as dynamic)?.created_at;
        if (date is String) {
          date = DateTime.tryParse(date);
        }
        if (date == null || date is! DateTime) return false;
        return (fromDate == null ||
                FormatterUtils.isSameOrAfter(date, fromDate)) &&
            (toDate == null || FormatterUtils.isSameOrBefore(date, toDate));
      }).toList();
    }
    return filteredList;
  }

  void _applyFilters(OrderPortalType type, {bool isFilterAll = false}) {
    final stateManager = getStateManager(type);
    if (stateManager.isLoadingMore) {
      return;
    }
    switch (type) {
      case OrderPortalType.order:
        {
          if (!isFilterAll) {
            _filteredPendingOrders = _filterList(
              orderPendingItemNotifier.value,
              type,
            );
          }
          loadDataAfterFilter(
            _filteredPendingOrders,
            type,
            isFilterAll: isFilterAll,
          );
          break;
        }
      case OrderPortalType.orderHistory:
        {
          if (!isFilterAll) {
            _filteredOrders = _filterList(orderItemNotifier.value, type);
          }
          loadDataAfterFilter(_filteredOrders, type, isFilterAll: isFilterAll);
          break;
        }
      case OrderPortalType.tradeHistory:
        {
          if (!isFilterAll) {
            _filteredTradeHistory = _filterList(tradeHistory, type);
          }
          loadDataAfterFilter(
            _filteredTradeHistory,
            type,
            isFilterAll: isFilterAll,
          );
          break;
        }
    }
    notifyListeners();
  }

  void loadDataAfterFilter<T>(
    List<T> filteredData,
    OrderPortalType type, {
    bool isFilterAll = false,
  }) async {
    final pageSize = type == OrderPortalType.order
        ? AppStorageKey.orderPageSize
        : AppStorageKey.orderHistoryLimit;
    final stateManager = getStateManager(type);

    stateManager.isMoreData = true;
    stateManager.isLoadingMore = true;

    int page = (filteredData.length / pageSize).floor() == 0 || isFilterAll
        ? 1
        : (filteredData.length / pageSize).floor();
    final defaultNumOfOrdersInCurrentPage = page * pageSize;

    // ---- TRADE HISTORY ----
    if (type == OrderPortalType.tradeHistory) {
      await _handleTradeHistoryFilter(
        filteredData: filteredData.cast<TradeHistoryModel>(),
        page: page,
        pageSize: pageSize,
        defaultNumOfOrdersInCurrentPage: defaultNumOfOrdersInCurrentPage,
        isFilterAll: isFilterAll,
        stateManager: stateManager,
        type: type,
      );
    }
    // ---- ORDER / ORDER HISTORY ----
    else {
      await _handleOrderFilter(
        filteredData: filteredData.cast<OrderItemModel>(),
        type: type,
        page: page,
        pageSize: pageSize,
        defaultNumOfOrdersInCurrentPage: defaultNumOfOrdersInCurrentPage,
        isFilterAll: isFilterAll,
        stateManager: stateManager,
      );
    }

    stateManager.isLoadingMore = false;
    timeToLoadMore = null;
    notifyListeners();
  }

  Future<void> _handleTradeHistoryFilter({
    required List<TradeHistoryModel> filteredData,
    required int page,
    required int pageSize,
    required int defaultNumOfOrdersInCurrentPage,
    required bool isFilterAll,
    required _OrderPortalStateManager stateManager,
    required OrderPortalType type,
  }) async {
    final selectedPair = stateManager.selectedPair?.toLowerCase();
    final selectedSide = stateManager.selectedSide?.toLowerCase();
    final fromDate = stateManager.fromDate;
    final toDate = stateManager.toDate;
    if (_shouldLoadNextPage(
      filteredData.length,
      defaultNumOfOrdersInCurrentPage,
      isFilterAll,
    )) {
      stateManager.currentPage = ++page;

      final response = await getTradeHistory(
        page: page.toString(),
        limit: pageSize.toString(),
        market: selectedPair,
        type: selectedSide,
        timeFrom: fromDate != null
            ? (fromDate.millisecondsSinceEpoch / 1000).round()
            : null,
        timeTo: toDate != null
            ? (toDate.millisecondsSinceEpoch / 1000).round()
            : null,
        isNotify: false,
      );

      if (response.isEmpty || response.length < pageSize) {
        stateManager.isMoreData = false;
      }

      _updateWithNextPageAfterFilter<TradeHistoryModel>(
        type: type,
        defaultNumOfOrdersInCurrentPage: defaultNumOfOrdersInCurrentPage,
        response: response,
      );
    } else if (_isExactPageMatch(
      filteredData.length,
      defaultNumOfOrdersInCurrentPage,
      isFilterAll,
    )) {
      _updateOrdersForExactMatch(
        type: type,
        filteredData: filteredData.cast<TradeHistoryModel>(),
      );
      stateManager.currentPage = page;
      stateManager.isLoadingMore = false;
      return;
    } else {
      stateManager.currentPage = page;

      final response = await getTradeHistory(
        page: page.toString(),
        limit: pageSize.toString(),
        market: selectedPair,
        type: selectedSide,
        timeFrom: fromDate != null
            ? (fromDate.millisecondsSinceEpoch / 1000).round()
            : null,
        timeTo: toDate != null
            ? (toDate.millisecondsSinceEpoch / 1000).round()
            : null,
        isNotify: false,
      );

      if (response.isEmpty || response.length < pageSize) {
        stateManager.isMoreData = false;
      }

      _updateWithCurrentPageAfterFilter<TradeHistoryModel>(
        type: type,
        response: response,
      );
    }
  }

  Future<void> _handleOrderFilter({
    required List<OrderItemModel> filteredData,
    required OrderPortalType type,
    required int page,
    required int pageSize,
    required int defaultNumOfOrdersInCurrentPage,
    required bool isFilterAll,
    required _OrderPortalStateManager stateManager,
  }) async {
    final state = type == OrderPortalType.order
        ? AppStorageKey.waitStatusOrder
        : null;

    final selectedType = stateManager.selectedType?.toLowerCase();
    final selectedPair = stateManager.selectedPair?.toLowerCase();
    final selectedSide = stateManager.selectedSide?.toLowerCase();
    final fromDate = stateManager.fromDate;
    final toDate = stateManager.toDate;

    if (_shouldLoadNextPage(
      filteredData.length,
      defaultNumOfOrdersInCurrentPage,
      isFilterAll,
    )) {
      stateManager.currentPage = ++page;

      final response = await _fetchOrderPage(
        type: type,
        page: page,
        pageSize: pageSize,
        state: state,
        pair: selectedPair,
        side: selectedSide,
        orderType: selectedType,
        fromDate: fromDate,
        toDate: toDate,
      );

      if (response.isEmpty || response.length < pageSize) {
        stateManager.isMoreData = false;
      }

      _updateWithNextPageAfterFilter<OrderItemModel>(
        type: type,
        defaultNumOfOrdersInCurrentPage: defaultNumOfOrdersInCurrentPage,
        response: response,
      );
    } else if (_isExactPageMatch(
      filteredData.length,
      defaultNumOfOrdersInCurrentPage,
      isFilterAll,
    )) {
      _updateOrdersForExactMatch<OrderItemModel>(
        type: type,
        filteredData: filteredData.cast<OrderItemModel>(),
      );
      stateManager.currentPage = page;
      stateManager.isLoadingMore = false;
      return;
    } else {
      stateManager.currentPage = page;
      final response = await _fetchOrderPage(
        type: type,
        page: page,
        pageSize: pageSize,
        state: state,
        pair: selectedPair,
        side: selectedSide,
        orderType: selectedType,
        fromDate: fromDate,
        toDate: toDate,
      );

      if (response.isEmpty || response.length < pageSize) {
        stateManager.isMoreData = false;
      }

      _updateWithCurrentPageAfterFilter<OrderItemModel>(
        type: type,
        response: response,
      );
    }
  }

  bool _shouldLoadNextPage(
    int filteredDataLength,
    int defaultNumOfOrdersInCurrentPage,
    bool isFilterAll,
  ) {
    return filteredDataLength > defaultNumOfOrdersInCurrentPage && !isFilterAll;
  }

  bool _isExactPageMatch(
    int filteredDataLength,
    int defaultNumOfOrdersInCurrentPage,
    bool isFilterAll,
  ) {
    return filteredDataLength == defaultNumOfOrdersInCurrentPage &&
        !isFilterAll;
  }

  Future<List<OrderItemModel>> _fetchOrderPage({
    required OrderPortalType type,
    required int page,
    required int pageSize,
    String? state,
    String? pair,
    String? side,
    String? orderType,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    return await getOrdersUseCase.call(
      market: pair,
      state: state,
      page: page.toString(),
      limit: pageSize.toString(),
      type: side,
      orderType: orderType,
      timeFrom: fromDate != null
          ? (fromDate.millisecondsSinceEpoch / 1000).round()
          : null,
      timeTo: toDate != null
          ? (toDate.millisecondsSinceEpoch / 1000).round()
          : null,
    );
  }

  void _updateWithNextPageAfterFilter<T>({
    required OrderPortalType type,
    int defaultNumOfOrdersInCurrentPage = 0,
    required List<T> response,
  }) {
    if (type == OrderPortalType.order) {
      _filteredPendingOrders.removeRange(
        defaultNumOfOrdersInCurrentPage,
        _filteredPendingOrders.length,
      );
      _filteredPendingOrders.addAll(response as Iterable<OrderItemModel>);
      orderPendingItemNotifier.value = List.from(_filteredPendingOrders);
    } else if (type == OrderPortalType.orderHistory) {
      _filteredOrders.removeRange(
        defaultNumOfOrdersInCurrentPage,
        _filteredOrders.length,
      );
      _filteredOrders.addAll(response as Iterable<OrderItemModel>);
      _filteredOrders = _filterList(_filteredOrders, type);
      orderItemNotifier.value = List.from(_filteredOrders);
    } else if (type == OrderPortalType.tradeHistory) {
      _filteredTradeHistory.removeRange(
        defaultNumOfOrdersInCurrentPage,
        _filteredTradeHistory.length,
      );
      _filteredTradeHistory.addAll(response as Iterable<TradeHistoryModel>);
      tradeHistory = List.from(_filteredTradeHistory);
    }
  }

  void _updateWithCurrentPageAfterFilter<T>({
    required OrderPortalType type,
    required List<T> response,
  }) {
    if (type == OrderPortalType.order) {
      orderPendingItemNotifier.value = response.cast<OrderItemModel>();
      _filteredPendingOrders = List.from(orderPendingItemNotifier.value);
    } else if (type == OrderPortalType.orderHistory) {
      orderItemNotifier.value = _filterList(
        response.cast<OrderItemModel>(),
        type,
      );
      _filteredOrders = List.from(orderItemNotifier.value);
    } else if (type == OrderPortalType.tradeHistory) {
      tradeHistory = response.cast<TradeHistoryModel>();
      _filteredTradeHistory = List.from(tradeHistory);
    }
  }

  void _updateOrdersForExactMatch<T>({
    required OrderPortalType type,
    required List<T> filteredData,
  }) {
    if (type == OrderPortalType.order) {
      _filteredPendingOrders = filteredData as List<OrderItemModel>;
      orderPendingItemNotifier.value = List.from(_filteredPendingOrders);
    } else if (type == OrderPortalType.orderHistory) {
      _filteredOrders = filteredData as List<OrderItemModel>;
      orderItemNotifier.value = List.from(_filteredOrders);
    } else if (type == OrderPortalType.tradeHistory) {
      _filteredTradeHistory = filteredData as List<TradeHistoryModel>;
      tradeHistory = List.from(_filteredTradeHistory);
    }
  }

  String? _getCompareField(dynamic e, OrderFilterType option) {
    switch (option) {
      case OrderFilterType.Type:
        return e.ordType as String?;
      case OrderFilterType.Side:
        return e.side as String?;
      case OrderFilterType.Pair:
        return e.market as String?;
    }
  }

  void filter(OrderFilterType option, String? data, OrderPortalType type) {
    final stateManager = getStateManager(type);
    bool isFilterAll = false;
    switch (option) {
      case OrderFilterType.Side:
        {
          if (stateManager.selectedSide == data) return;
          if (stateManager.selectedSide != null && data == null) {
            isFilterAll = true;
          }
          stateManager.selectedSide = data;
          break;
        }
      case OrderFilterType.Type:
        {
          if (stateManager.selectedType == data) return;
          if (stateManager.selectedType != null && data == null) {
            isFilterAll = true;
          }
          stateManager.selectedType = data;
          break;
        }
      case OrderFilterType.Pair:
        {
          if (stateManager.selectedPair == data) return;
          if (stateManager.selectedPair != null && data == null) {
            isFilterAll = true;
          }
          stateManager.selectedPair = data;
          break;
        }
    }
    _applyFilters(type, isFilterAll: isFilterAll);
  }

  void filterByDate(OrderPortalType type) {
    _applyFilters(type);
    notifyListeners();
  }

  void setDate(bool isFrom, DateTime date, OrderPortalType type) {
    final stateManager = getStateManager(type);
    if (isFrom) {
      stateManager.fromDate = DateTime(
        date.year,
        date.month,
        date.day,
        0,
        0,
        0,
      );

      if (stateManager.toDate != null &&
          stateManager.fromDate!.isAfter(stateManager.toDate!)) {
        stateManager.fromDateError = true;
      } else {
        stateManager.fromDateError = false;
        stateManager.toDateError = false;
      }
    } else {
      stateManager.toDate = DateTime(
        date.year,
        date.month,
        date.day,
        23,
        59,
        59,
      );

      if (stateManager.fromDate != null &&
          stateManager.toDate!.isBefore(stateManager.fromDate!)) {
        stateManager.toDateError = true;
      } else {
        stateManager.toDateError = false;
        stateManager.fromDateError = false;
      }
    }
    notifyListeners();
  }

  void resetFilter(OrderPortalType type) {
    final stateManager = getStateManager(type);
    stateManager.resetFilters();

    if (type == OrderPortalType.order) {
      _filteredPendingOrders = List<OrderItemModel>.from(
        orderPendingItemNotifier.value,
      );
    } else if (type == OrderPortalType.orderHistory) {
      _filteredOrders = List<OrderItemModel>.from(orderItemNotifier.value);
    } else if (type == OrderPortalType.tradeHistory) {
      _filteredTradeHistory = List<TradeHistoryModel>.from(tradeHistory);
    }
    _applyFilters(type);
    notifyListeners();
  }

  void resetData(OrderPortalType type) {
    getStateManager(type).reset();
    getStateManager(type).hasInitialLoaded = false;
  }

  void resetFilterData(OrderPortalType type) {
    final stateManager = getStateManager(type);
    stateManager.resetFilters();
    _applyFilters(type);
    notifyListeners();
  }

  void _updatePairOptions() {
    pairOptions.clear();
    pairOptions.add((id: AppStorageKey.all, name: AppStorageKey.all));
    for (final coin in coins) {
      pairOptions.add((id: coin.id, name: coin.name));
    }
  }

  Future<void> deleteOrderById(String id) async {
    try {
      await cancelOrderWithID(id: id, cancelLoading: true);
      orderIdBeDeleted = id;
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }

  String getCoinName(dynamic e) {
    final market = e.market as String?;
    if (market != null) {
      final coin = coins.firstWhere(
        (coin) => coin.id.toLowerCase() == market.toLowerCase(),
      );
      return coin.name;
    }
    return '';
  }

  @override
  void dispose() {
    orderPendingItemNotifier.removeListener(() {});

    for (final stateManager in _stateManagers.values) {
      if (stateManager.scrollListener != null) {
        stateManager.scrollController.removeListener(
          stateManager.scrollListener!,
        );
      }
      stateManager.scrollController.dispose();
    }

    super.dispose();
  }
}
