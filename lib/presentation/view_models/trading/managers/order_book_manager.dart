import 'dart:async';
import 'dart:collection';

import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/data/models/trading/trade/depth_response_model.dart';
import 'package:alpha/data/models/trading/trade/order_book_entry.dart';
import 'package:alpha/domain/usecase/trading/get_order_book_usecase.dart';
import 'package:flutter/foundation.dart';

mixin OrderBookManager on ChangeNotifier {
  DepthResponseModel depthOrderBook = DepthResponseModel(
    timestamp: DateTime.now().millisecondsSinceEpoch,
    bids: List.generate(
      AppStorageKey.numberOfItemsOrderBookInLimit,
      (_) => ["", ""],
    ),
    asks: List.generate(
      AppStorageKey.numberOfItemsOrderBookInLimit,
      (_) => ["", ""],
    ),
  );

  OrderTypeEnum? _orderBookType;
  OrderTypeEnum? get orderBookType => _orderBookType;

  final StreamController<DepthResponseModel> _orderBookController =
      StreamController<DepthResponseModel>.broadcast();
  Stream<DepthResponseModel> get orderBookStream => _orderBookController.stream;
  StreamController<DepthResponseModel> get orderBookController =>
      _orderBookController;

  bool _isOrderBookInitialized = false;
  bool get isOrderBookInitialized => _isOrderBookInitialized;
  set isOrderBookInitialized(bool value) {
    _isOrderBookInitialized = value;
  }

  final SplayTreeMap<double, List<String>> _asksMap =
      SplayTreeMap<double, List<String>>(
        (a, b) => a.compareTo(b), // Ascending for asks
      );
  final SplayTreeMap<double, List<String>> _bidsMap =
      SplayTreeMap<double, List<String>>(
        (a, b) => b.compareTo(a), // Descending for bids
      );
  SplayTreeMap<double, List<String>> get asksMap => _asksMap;
  SplayTreeMap<double, List<String>> get bidsMap => _bidsMap;

  Timer? _orderBookUpdateTimer;
  bool _hasPendingOrderBookUpdates = false;
  final Duration _orderBookUpdateDelay = Duration(
    milliseconds: AppStorageKey.numberOfItemsOrderBookInLimit,
  );
  final Set<String> _pendingUpdates = {};

  void filterOrderBook([OrderTypeEnum? type]) {
    if (type == _orderBookType) return; // No change, do nothing
    if (type == null) {
      _orderBookType = null; // Reset to show both buy and sell
    } else {
      _orderBookType = type;
    }
    notifyListeners();
  }

  void updateDepthOrderBook(OrderBookEntry entry) {
    depthOrderBook = depthOrderBook.copyWith(timestamp: entry.sequence);

    if (entry.side == OrderbookSide.ask) {
      _updateOrderBookSide(entry, isAsk: true);
    } else if (entry.side == OrderbookSide.bid) {
      _updateOrderBookSide(entry, isAsk: false);
    }

    _scheduleOrderBookUpdate();
  }

  void _updateOrderBookSide(OrderBookEntry entry, {required bool isAsk}) {
    final price = double.tryParse(entry.price.toString()) ?? 0.0;
    final amount = double.tryParse(entry.amount.toString()) ?? 0.0;

    if (price <= 0) return;

    final targetMap = isAsk ? _asksMap : _bidsMap;

    if (amount > 0) {
      targetMap[price] = [entry.price.toString(), entry.amount.toString()];
    } else {
      targetMap.remove(price);
    }

    _pendingUpdates.add(isAsk ? 'asks' : 'bids');
  }

  void _scheduleOrderBookUpdate() {
    if (!_hasPendingOrderBookUpdates) {
      _hasPendingOrderBookUpdates = true;
      _orderBookUpdateTimer?.cancel();
      _orderBookUpdateTimer = Timer(_orderBookUpdateDelay, () {
        if (_hasPendingOrderBookUpdates) {
          _executeBatchOrderBookUpdate();
          _hasPendingOrderBookUpdates = false;
        }
      });
    }
  }

  void _executeBatchOrderBookUpdate() {
    if (_pendingUpdates.contains('asks')) {
      final asks = _asksMap.values
          .take(AppStorageKey.numberOfItemsOrderBookInLimit)
          .toList();
      // add empty entries if asks are less than the limit (add padding)
      while (asks.length < AppStorageKey.numberOfItemsOrderBookInLimit) {
        asks.add(["", ""]);
      }
      depthOrderBook = depthOrderBook.copyWith(asks: asks);
    }

    if (_pendingUpdates.contains('bids')) {
      final bids = _bidsMap.values
          .take(AppStorageKey.numberOfItemsOrderBookInLimit)
          .toList();
      // add empty entries if bids are less than the limit (add padding)
      while (bids.length < AppStorageKey.numberOfItemsOrderBookInLimit) {
        bids.add(["", ""]);
      }
      depthOrderBook = depthOrderBook.copyWith(bids: bids);
    }

    _pendingUpdates.clear();

    _orderBookController.add(depthOrderBook);
  }

  void resetOrderBookData() {
    _asksMap.clear();
    _bidsMap.clear();
    _pendingUpdates.clear();
    _orderBookUpdateTimer?.cancel();
    _hasPendingOrderBookUpdates = false;

    depthOrderBook = DepthResponseModel(
      timestamp: DateTime.now().millisecondsSinceEpoch,
      bids: List.generate(
        AppStorageKey.numberOfItemsOrderBookInLimit,
        (_) => ["", ""],
      ),
      asks: List.generate(
        AppStorageKey.numberOfItemsOrderBookInLimit,
        (_) => ["", ""],
      ),
    );
    _orderBookController.add(depthOrderBook);
    _isOrderBookInitialized = false;
  }

  void disposeOrderBook() {
    _orderBookUpdateTimer?.cancel();
    _orderBookController.close();
  }

  OrderBookList getReversedDisplayOrderBook(OrderBookList orders) {
    final List<List<String>> nonEmptyOrders = [];
    final List<List<String>> emptyOrders = [];
    for (int i = orders.length - 1; i >= 0; i--) {
      final order = orders[i];
      if (order[0].isNotEmpty && order[1].isNotEmpty) {
        nonEmptyOrders.add(order);
      } else {
        emptyOrders.add(order);
      }
    }
    final displayOrders = [...nonEmptyOrders, ...emptyOrders];
    return displayOrders;
  }
}
