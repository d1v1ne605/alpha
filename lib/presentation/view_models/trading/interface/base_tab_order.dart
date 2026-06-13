import 'dart:async';

import 'package:alpha/core/base/base_view_model.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_model.dart';
import 'package:alpha/data/models/home_market/coin_model/transaction_interface.dart';
import 'package:alpha/data/models/home_market/coin_model/transaction_model.dart';
import 'package:alpha/data/models/home_market/coin_model/transaction_socket_model.dart';
import 'package:alpha/data/models/trading/trade/order_item_model.dart';
import 'package:alpha/data/models/trading/trade/order_socket_model.dart';
import 'package:alpha/data/models/trading/trade/trade_history_model.dart';
import 'package:alpha/data/models/trading/trade/trade_socket_model.dart';
import 'package:alpha/domain/usecase/trading/cancel_order_uuid_usecase.dart';
import 'package:alpha/domain/usecase/trading/get_orders_usecase.dart';
import 'package:alpha/domain/usecase/trading/get_trade_history_usecase.dart';
import 'package:alpha/domain/usecase/trading/get_transcation_usecase.dart';
import 'package:alpha/presentation/view_models/global_view_model.dart';
import 'package:alpha/presentation/view_models/trading/managers/order_socket_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class BaseTabOrder extends BaseViewModel with OrderSocketManager {
  final GetOrdersUseCase getOrdersUseCase;
  final CancelOrderUuidUseCase cancelOrderUseCase;
  final GetTranscationUsecase getTranscationUsecase;
  final GetTradeHistoryUseCase getTradeHistoryUseCase;

  final GlobalViewModel _globalViewModel;
  GlobalViewModel get globalViewModel => _globalViewModel;

  final List<StreamSubscription> _subscriptions = [];
  List<StreamSubscription> get subscriptions => _subscriptions;

  List<TradeHistoryModel> _tradeHistory = [];
  List<TradeHistoryModel> get tradeHistory => _tradeHistory;
  set tradeHistory(List<TradeHistoryModel> value) {
    _tradeHistory = value;
  }

  final ValueNotifier<List<ITransaction>> _transactionNotifier = ValueNotifier(
    [],
  );
  ValueListenable<List<ITransaction>> get transactionNotifier =>
      _transactionNotifier;

  List<TransactionModel> _lastTransaction = [];
  List<TransactionModel> get lastTransaction => _lastTransaction;
  set lastTransaction(List<TransactionModel> value) {
    _lastTransaction = value;
  }

  CoinModel? _currentCoin;
  CoinModel? get currentCoin => _currentCoin;
  set currentCoin(CoinModel? value) {
    _currentCoin = value;
  }

  List<CoinModel> get coins => globalViewModel.coins;

  BaseTabOrder(
    this._globalViewModel,
    this.getTranscationUsecase,
    this.getOrdersUseCase,
    this.cancelOrderUseCase,
    this.getTradeHistoryUseCase,
  ) {
    _listenOrderItem();
    _listenTransactionHistory();
  }

  void _listenOrderItem() async {
    final orderSubscription = _globalViewModel.socketManager.messages.listen(
      (event) {
        if (event is! OrderSocketModel) return;
        orderMessageQueue.add(event);
        scheduleBatchProcessing();
      },
      onError: (error) {
        setError('Something went wrong');
        if (isExecutingOrder) {
          isExecutingOrder = false;
          setBusy(false);
        }
      },
      onDone: () {
        if (isExecutingOrder) {
          isExecutingOrder = false;
          setBusy(false);
        }
      },
    );
    _subscriptions.add(orderSubscription);
  }

  void _listenTransactionHistory() {
    final transactionSubscription = _globalViewModel.socketManager.messages
        .listen((event) {
          if (event is TradeSocketModel) {
            final trade = fromSocketToTradeHistoryModel(event);

            _tradeHistory.insert(0, trade);
            _transactionNotifier.value = List.from(_tradeHistory);
          }

          if (event is List<TransactionSocketModel>) {
            final currentCoin = _currentCoin;
            if (currentCoin == null) return;

            final transactionList = event.map((e) {
              return fromSocketToTransactionModel(e, currentCoin.id);
            }).toList();

            _lastTransaction.insertAll(0, transactionList);
            if (_lastTransaction.length > 100) {
              _lastTransaction.removeRange(100, _lastTransaction.length);
            }
            _transactionNotifier.value = List.from(_lastTransaction);
          }
        });
    _subscriptions.add(transactionSubscription);
  }

  Future<void> getLastTransaction(String market, {bool isNotify = true}) async {
    try {
      final trades = await getTranscationUsecase.call(market);
      lastTransaction = trades.take(100).toList();
    } catch (e) {
      setError('${AppStorageKey.failedToFetchLastTransactions}: $e');
    } finally {
      if (isNotify) notifyListeners();
    }
  }

  Future<void> loadOrders({
    String? market,
    String? state,
    String? page,
    String? limit,
    int? timeTo,
    int? timeFrom,
    String? type,
    String? orderType,
    String? orderBy,
    bool isLoadMore = false,
    bool isNotify = false,
    bool isRefresh = false,
    bool forceReload = false,
  }) async {
    try {
      final isPending = state == AppStorageKey.waitStatusOrder;
      List<OrderItemModel> targetList = isPending
          ? orderPendingItemNotifier.value
          : orderItemNotifier.value;
      if ((targetList.isNotEmpty &&
          !isLoadMore &&
          !isRefresh &&
          !forceReload)) {
        return;
      }

      final List<OrderItemModel> response = await getOrdersUseCase.call(
        market: market,
        state: state,
        page: page,
        limit: limit,
        timeTo: timeTo,
        timeFrom: timeFrom,
        type: type,
        orderType: orderType,
        orderBy: orderBy,
      );
      if (isLoadMore) {
        if (isNotify) {
          if (isPending) {
            orderPendingItemNotifier.value = List<OrderItemModel>.from([
              ...targetList,
              ...response,
            ]);
          } else {
            orderItemNotifier.value = List<OrderItemModel>.from([
              ...targetList,
              ...response,
            ]);
          }
        } else {
          targetList.addAll(response);
        }
      } else {
        if (isPending) {
          orderPendingItemNotifier.value = response;
        } else {
          orderItemNotifier.value = response;
        }
      }
    } catch (e) {
      setError('${AppStorageKey.failedToLoadOrders}: $e');
      rethrow;
    }
  }

  Future<OrderItemModel> cancelOrderWithID({
    required String id,
    bool? cancelLoading,
  }) async {
    try {
      setBusy(true);
      isExecutingOrder = true;
      final OrderItemModel response = await cancelOrderUseCase.call(id);

      return response;
    } catch (e) {
      setError('${AppStorageKey.failedToCancelOrder}: $e');
      rethrow;
    } finally {
      if (cancelLoading == true) setBusy(false);
    }
  }

  bool hasMoreData({
    required int initialOrderCount,
    required int newOrderCount,
    int pageSize = AppStorageKey.orderPageSize,
    int currentPage = 1,
  }) {
    if (newOrderCount > initialOrderCount &&
        newOrderCount >= (pageSize * currentPage)) {
      if (newOrderCount - initialOrderCount < pageSize) {
        return false;
      }
    } else {
      return false;
    }
    return true;
  }

  Map<String, int> checkOverflowPendingItemForPagination({
    required int initialOrderCount,
    required int currentPage,
    String? statusOrder,
    int pageSize = AppStorageKey.orderPageSize,
    OrderPortalType orderPortalType = OrderPortalType.order,
  }) {
    if (statusOrder == null) {
      if (orderPortalType == OrderPortalType.orderHistory) {
        return <String, int>{
          AppStorageKey.keyInitialOrderCount: orderItemNotifier.value.length,
        };
      } else if (orderPortalType == OrderPortalType.tradeHistory) {
        return <String, int>{
          AppStorageKey.keyInitialOrderCount: tradeHistory.length,
        };
      } else {
        return <String, int>{
          AppStorageKey.keyInitialOrderCount:
              orderPendingItemNotifier.value.length,
        };
      }
    }

    // If the current page (limit) is less than the initial order count, we need to remove overflow items
    if (currentPage * AppStorageKey.orderPageSize < initialOrderCount &&
        statusOrder == AppStorageKey.waitStatusOrder) {
      final overflowCount =
          initialOrderCount - currentPage * AppStorageKey.orderPageSize;
      orderPendingItemNotifier.value.removeRange(
        orderPendingItemNotifier.value.length - overflowCount,
        orderPendingItemNotifier.value.length,
      );
    }
    // If the current page (limit) is greater than the initial order count, we need to check for overflow items
    else if (currentPage * AppStorageKey.orderPageSize > initialOrderCount &&
        statusOrder == AppStorageKey.waitStatusOrder) {
      final overflowCount =
          currentPage * AppStorageKey.orderPageSize - initialOrderCount;
      return <String, int>{
        AppStorageKey.keyInitialOrderCount:
            orderPendingItemNotifier.value.length,
        AppStorageKey.keyOverflowOrderLimit: overflowCount,
      };
    }
    return <String, int>{
      AppStorageKey.keyInitialOrderCount: orderPendingItemNotifier.value.length,
    };
  }

  Future<List<TradeHistoryModel>> getTradeHistory({
    String? page,
    String? limit,
    String? market,
    int? timeFrom,
    int? timeTo,
    String? type,
    bool isNotify = true,
  }) async {
    try {
      final trades = await getTradeHistoryUseCase.call(
        page: page,
        limit: limit,
        market: market,
        timeFrom: timeFrom,
        timeTo: timeTo,
        type: type,
      );
      tradeHistory = trades;
      if (isNotify) notifyListeners();
      return trades;
    } catch (e) {
      setError('${AppStorageKey.failedToFetchTradeHistory}: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
    _transactionNotifier.dispose();
    disposeOrderSocketManager();
  }
}
