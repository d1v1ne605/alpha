import 'dart:async';
import 'dart:collection';

import 'package:alpha/core/base/base_view_model.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/trading/trade/order_item_model.dart';
import 'package:alpha/data/models/trading/trade/order_socket_model.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:flutter/foundation.dart';

mixin OrderSocketManager on BaseViewModel {
  final Queue<OrderSocketModel> _orderMessageQueue = Queue<OrderSocketModel>();
  Queue<OrderSocketModel> get orderMessageQueue => _orderMessageQueue;
  Timer? _batchProcessingTimer;
  static const Duration _batchProcessingInterval = Duration(milliseconds: 100);

  final ValueNotifier<List<OrderItemModel>> _orderPendingItemNotifier =
      ValueNotifier([]);
  final ValueNotifier<List<OrderItemModel>> _orderItemNotifier = ValueNotifier(
    [],
  );
  ValueNotifier<List<OrderItemModel>> get orderPendingItemNotifier =>
      _orderPendingItemNotifier;

  ValueNotifier<List<OrderItemModel>> get orderItemNotifier =>
      _orderItemNotifier;

  bool isExecutingOrder = false; // Includes add new order, remove order
  bool? _statusExecutingOrder;
  bool? get statusExecutingOrder => _statusExecutingOrder;
  set statusExecutingOrder(bool? status) {
    _statusExecutingOrder = status;
    notifyListeners();
  }

  /**
   * Cursor used for pagination, based on `created_at`.
   * 
   * When a user deletes an order, the cursor will be updated to the `created_at`
   * of the last item in current page.
   * 
   * This ensures that when the user loads more, the query will start from
   * that cursor, and only orders created before this timestamp will be returned.
   */
  int? timeToLoadMore;

  void scheduleBatchProcessing() {
    _batchProcessingTimer?.cancel();
    _batchProcessingTimer = Timer(
      _batchProcessingInterval,
      _processBatchedMessages,
    );
  }

  void _processBatchedMessages() {
    if (_orderMessageQueue.isEmpty) return;

    final List<OrderSocketModel> messagesToProcess = [];
    while (_orderMessageQueue.isNotEmpty && messagesToProcess.length < 10) {
      messagesToProcess.add(_orderMessageQueue.removeFirst());
    }

    // Process batch
    for (final event in messagesToProcess) {
      switch (event.state) {
        case AppStorageKey.doneStatusOrder:
          {
            _handleOrderDone(event);
            break;
          }
        case AppStorageKey.waitStatusOrder:
          {
            _handleOrderWait(event);
            statusExecutingOrder = true;
            break;
          }
        case AppStorageKey.stopStatusOrder:
          {
            _handleOrderStop(event);
            break;
          }
        case AppStorageKey.rejectStatusOrder:
          {
            if (isExecutingOrder) {
              isExecutingOrder = false;
              setBusy(false);
            }
            setError(context?.appLocaleLanguage.yourOrderHasBeenRejected);
            statusExecutingOrder = false;
            break;
          }
        default:
          {
            if (isExecutingOrder) {
              isExecutingOrder = false;
              setBusy(false);
            }
            setError("Your order has been rejected.");
            statusExecutingOrder = false;
            break;
          }
      }
    }

    // Update UI once after batch processing
    _updateOrderNotifiers();

    // Continue processing if queue has more messages
    if (_orderMessageQueue.isNotEmpty) {
      scheduleBatchProcessing();
    }
  }

  void _updateOrderNotifiers() {
    _orderPendingItemNotifier.value = List.from(
      _orderPendingItemNotifier.value,
    );
    _orderItemNotifier.value = List.from(_orderItemNotifier.value);
  }

  void _handleOrderDone(OrderSocketModel event) {
    final orderIndex = _orderPendingItemNotifier.value.indexWhere(
      (item) => item.id == event.id,
    );
    if (orderIndex != -1) {
      timeToLoadMore = calculateCursor(orderIndex);
      final order = _orderPendingItemNotifier.value[orderIndex];
      _orderPendingItemNotifier.value.removeAt(orderIndex);
      _orderItemNotifier.value.insert(0, order);
      /**
       * 2 case:
       * - One is you add order to done list from mobile devices (need to notifyListeners)
       * - Another is receiving order update to done list from another platform (no notifyListeners)
       */
      if (isExecutingOrder) {
        isExecutingOrder = false;
        setBusy(false);
      }
    }
  }

  void _handleOrderWait(OrderSocketModel event) {
    final orderIndex = _orderPendingItemNotifier.value.indexWhere(
      (item) => item.id == event.id,
    );
    if (orderIndex != -1) {
      _orderPendingItemNotifier.value[orderIndex] = fromSocketToOrderItemModel(
        event,
      );
    } else {
      _orderPendingItemNotifier.value.insert(
        0,
        fromSocketToOrderItemModel(event),
      );
      if (isExecutingOrder) {
        isExecutingOrder = false;
        setBusy(false);
      }
    }
  }

  void _handleOrderStop(OrderSocketModel event) {
    final index = _orderPendingItemNotifier.value.indexWhere(
      (item) => item.id == event.id,
    );

    if (index != -1) {
      timeToLoadMore = calculateCursor(index);
      _orderPendingItemNotifier.value.removeAt(index);
    }

    _orderItemNotifier.value.insert(0, fromSocketToOrderItemModel(event));
    /**
     * 2 case:
     * - One is you remove order from waiting list from mobile devices (need to notifyListeners)
     * - Another is receiving order remove from waiting list from another platform (no notifyListeners)
     */
    if (isExecutingOrder) {
      isExecutingOrder = false;
      setBusy(false);
    }
  }

  int? calculateCursor(int position) {
    try {
      final maxLength = _orderPendingItemNotifier.value.length;
      final createdAt = position == maxLength - 1
          ? _orderItemNotifier.value[maxLength - 2].createdAt
          : _orderPendingItemNotifier.value[maxLength - 1].createdAt;
      return (createdAt.millisecondsSinceEpoch / 1000).toInt();
    } catch (e) {
      return null;
    }
  }

  void disposeOrderSocketManager() {
    super.dispose();
    _batchProcessingTimer?.cancel();
    _batchProcessingTimer = null;

    _orderMessageQueue.clear();

    _orderPendingItemNotifier.dispose();
    _orderItemNotifier.dispose();

    isExecutingOrder = false;
    timeToLoadMore = null;
  }
}
