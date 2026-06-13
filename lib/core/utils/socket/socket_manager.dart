import 'dart:async';
import 'dart:convert';

import 'package:alpha/core/constants/app_local_key.dart';
import 'package:alpha/core/network/auth_change_notifier.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/data/models/home_market/coin_model/transaction_socket_model.dart';
import 'package:alpha/data/models/trading/trade/order_book_entry.dart';
import 'package:alpha/data/models/trading/trade/order_socket_model.dart';
import 'package:alpha/data/models/trading/trade/ticker_data.dart';
import 'package:alpha/data/models/trading/trade/ticker_entry.dart';
import 'package:alpha/data/models/trading/trade/trade_socket_model.dart';
import 'package:alpha/data/services/local/hive_service.dart';
import 'package:alpha/data/services/local/secure_storage_service.dart';
import 'package:alpha/injection/injector.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/io.dart';

import '../../constants/app_storage_key.dart';
import '../../utils/enums.dart';

class SocketManager {
  IOWebSocketChannel? _channel;
  StreamSubscription? _subscription;
  final hiveService = getIt<HiveService>();
  String _currentCoinId = AppStorageKey.btcUsdt;

  bool _isPrivate = false;

  final SecureStorageService _secureStorageService = SecureStorageService();
  final StreamController<dynamic> _messageController =
      StreamController.broadcast();

  Stream<dynamic> get messages => _messageController.stream;

  SocketManager() {
    getIt<AuthChangeNotifier>().addListener(_handleAuthChange);
    _init();
  }

  bool _isConnected = false;
  bool get isConnected => _isConnected && _channel != null;

  Timer? _reconnectTimer;
  bool _shouldReconnect = true;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectDelay = Duration(seconds: 5);

  Future<void> _init() async {
    final lastCoinId = await hiveService.get(
      key: AppLocalKey.lastTappedCoinId,
      boxName: AppLocalKey.commonBox,
    );
    _currentCoinId = lastCoinId ?? "";
  }

  Future<void> _handleAuthChange() async {
    final newPrivate = await getIt<AuthChangeNotifier>().checkLogin;
    if (newPrivate != _isPrivate) {
      _isPrivate = newPrivate;
      _reconnect();
    }
  }

  Future<String?> _getCookie() async {
    final rawCookie = await _secureStorageService.readData(
      AppStorageKey.keyAuthCookie,
    );
    if (rawCookie?.isEmpty ?? true) return null;
    return rawCookie!.replaceAll('"', '').split(';').first.trim();
  }

  Future<String> _getBaseUrl() async {
    _isPrivate = await getIt<AuthChangeNotifier>().checkLogin;
    return _isPrivate
        ? "${dotenv.env[AppStorageKey.SOCKET_URL_PRIVATE]}"
        : "${dotenv.env[AppStorageKey.SOCKET_URL_PUBLIC]}";
  }

  List<String> _getInitialStreams() {
    if (_isPrivate) {
      return [
        "${AppStorageKey.KEY_GLOBAL_TICKET}",
        "$_currentCoinId${AppStorageKey.KEY_OB_INC}",
        "$_currentCoinId.${AppStorageKey.KEY_TRADES}",
        AppStorageKey.KEY_TRADE,
        AppStorageKey.KEY_ORDER,
      ];
    }
    return ["${AppStorageKey.KEY_GLOBAL_TICKET}"];
  }

  Future<void> connect({Map<String, dynamic>? headers}) async {
    if (_isConnected) return;
    try {
      final baseUrl = await _getBaseUrl();
      final cookie = await _getCookie() ?? '';
      final streams = _getInitialStreams();
      final queryString = streams.map((s) => "stream=$s").join("&");
      final socketUrl = "$baseUrl/?$queryString";
      final mergedHeaders = {
        if (cookie.isNotEmpty) "Cookie": cookie,
        ...?headers,
      };
      _channel = IOWebSocketChannel.connect(
        Uri.parse(socketUrl),
        headers: mergedHeaders,
      );

      _isConnected = true;
      _reconnectAttempts = 0;

      _listenToSocket();
    } catch (e, s) {
      _handleConnectionError(e, s);
    }
  }

  void _reconnect() {
    if (!_shouldReconnect || _reconnectAttempts >= _maxReconnectAttempts) {
      return;
    }

    _reconnectAttempts++;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () {
      if (_shouldReconnect) {
        if (_subscription != null) {
          disconnect();
        }
        connect();
      }
    });
  }

  void _listenToSocket() {
    _subscription = _channel!.stream.listen(
      _handleMessage,
      onDone: () {
        _isConnected = false;
        _messageController.addError("Socket closed");
        _reconnect();
      },
      onError: (error) {
        _isConnected = false;
        _messageController.addError(error);
        _reconnect();
      },
    );
  }

  void disconnect() {
    _subscription?.cancel();
    _channel?.sink.close();
    _subscription = null;
    _channel = null;
    _shouldReconnect = false;
    _reconnectTimer?.cancel();
    _isConnected = false;
    _channel?.sink.close();
  }

  void _handleMessage(dynamic message) {
    try {
      final data = jsonDecode(message);

      if (data is! Map) return;

      _handleTickers(data);
      _handleOrderBook(data);
      _handleExecutedOrder(data);
      _handleTrade(data);
    } catch (e) {
      _messageController.addError("Parse error: $e");
    }
  }

  void _handleConnectionError(dynamic error, StackTrace stackTrace) {
    _isConnected = false;
    _reconnect();
  }

  void _handleTickers(Map data) {
    if (data.containsKey(AppStorageKey.KEY_GLOBAL_TICKET)) {
      final tickers = data[AppStorageKey.KEY_GLOBAL_TICKET];
      if (tickers is Map && tickers.containsKey(_currentCoinId)) {
        final tickerEntry = TickerEntry(
          coin: _currentCoinId,
          data: TickerData.fromJson(
            Map<String, dynamic>.from(tickers[_currentCoinId]),
          ),
        );
        _messageController.add(tickerEntry);
      }
    }
  }

  void _handleOrderBook(Map data) {
    final obKey = "$_currentCoinId${AppStorageKey.KEY_OB_INC}";
    if (!data.containsKey(obKey)) return;

    final obData = data[obKey];
    if (obData is! Map) return;

    final sidesMap = {
      AppStorageKey.orderBookBids: OrderbookSide.bid,
      AppStorageKey.orderBookAsks: OrderbookSide.ask,
    };
    sidesMap.forEach((key, side) {
      _emitOrderBookSide(obData, key, side);
    });
  }

  void _emitOrderBookSide(Map obData, String key, OrderbookSide side) {
    if (!obData.containsKey(key)) return;
    final sideData = obData[key];
    if (sideData is List && sideData.length >= 2) {
      final price = FormatterUtils.toDoubleSafe(sideData[0]);
      final amount = FormatterUtils.toDoubleSafe(sideData[1]);
      final sequence = FormatterUtils.toIntSafe(
        obData[AppStorageKey.orderBookSequence],
      );

      final orderBookEntry = OrderBookEntry(
        market: _currentCoinId,
        side: side,
        price: price,
        amount: amount,
        sequence: sequence,
      );
      _messageController.add(orderBookEntry);
    }
  }

  void _handleExecutedOrder(Map data) {
    if (data.containsKey(AppStorageKey.KEY_ORDER)) {
      final rawData = data[AppStorageKey.KEY_ORDER];
      final order = OrderSocketModel.fromJson(
        Map<String, dynamic>.from(rawData),
      );
      _messageController.add(order);
    }
  }

  void _handleTrade(Map data) {
    if (data.containsKey(AppStorageKey.KEY_TRADE)) {
      final rawData = data[AppStorageKey.KEY_TRADE];
      final trade = TradeSocketModel.fromJson(
        Map<String, dynamic>.from(rawData),
      );
      _messageController.add(trade);
    }
    if (data.containsKey("$_currentCoinId.${AppStorageKey.KEY_TRADES}")) {
      final tradesData = data["$_currentCoinId.${AppStorageKey.KEY_TRADES}"];
      final List<TransactionSocketModel> transactionList = [];

      if (tradesData is Map &&
          tradesData.containsKey(AppStorageKey.KEY_TRADES)) {
        final trades = tradesData[AppStorageKey.KEY_TRADES];
        if (trades is List) {
          for (var trade in trades) {
            final model = TransactionSocketModel.fromJson(
              Map<String, dynamic>.from(trade),
            );
            transactionList.add(model);
          }
        }
      }
      _messageController.add(transactionList);
    }
  }

  void changeCoinSocket(String newCoinId) {
    if (!_isPrivate || !isConnected || _currentCoinId == newCoinId) {
      return;
    }

    try {
      unsubscribe([
        "${_currentCoinId}${AppStorageKey.KEY_OB_INC}",
        "${_currentCoinId}${AppStorageKey.KEY_TRADE}",
      ]);
      Future.delayed(const Duration(milliseconds: 1));
      subscribe([
        "${newCoinId}${AppStorageKey.KEY_OB_INC}",
        "${newCoinId}${AppStorageKey.KEY_TRADE}",
      ]);
      _currentCoinId = newCoinId;
    } catch (e) {
      _messageController.addError("Change coin socket error: $e");
    }
  }

  void subscribe(List<String> streams) {
    _sendEvent(AppStorageKey.KEY_SUBSCRIBE, streams);
  }

  void unsubscribe(List<String> streams) {
    _sendEvent(AppStorageKey.KEY_UNSUBSCRIBE, streams);
  }

  void _sendEvent(String event, List<String> streams) {
    if (!isConnected) {
      return;
    }
    try {
      final msg = jsonEncode({"event": event, "streams": streams});
      _channel!.sink.add(msg);
    } catch (e) {
      _messageController.addError("Send event error: $e");
    }
  }

  void dispose() {
    getIt<AuthChangeNotifier>().removeListener(_handleAuthChange);
    disconnect();
    _messageController.close();
  }
}
