import 'package:alpha/data/models/home_market/coin_model/coin_detail_wrapper.dart';
import 'package:alpha/data/models/home_market/coin_model/transaction_model.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_detail_wrapper.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_detail_wrapper.dart';
import 'package:alpha/data/models/trading/trade/cancel_all_order_request_model.dart';
import 'package:alpha/data/models/trading/trade/depth_response_model.dart';
import 'package:alpha/data/models/trading/trade/order_form_request_model.dart';
import 'package:alpha/data/models/trading/trade/order_item_model.dart';
import 'package:alpha/data/models/trading/trade/trade_history_model.dart';
import 'package:alpha/data/repositories/trading/trade/trade_repository.dart';
import 'package:alpha/data/services/home/home_api_service.dart';

class TradeRepositoryImpl implements TradeRepository {
  final HomeApiService _homeApiService;

  TradeRepositoryImpl(this._homeApiService);

  @override
  Future<DepthResponseModel> getOrderBook(String market) async {
    return await _homeApiService.getOrderBook(market);
  }

  @override
  Future<CoinDetailWrapper> getCoinDetail(String coinId) {
    return _homeApiService.getCoinDetail(coinId);
  }

  @override
  Future<List<TransactionModel>> getTranscation(String market) {
    return _homeApiService.getTranscation(market);
  }

  @override
  Future<OrderItemModel> submitOrder(OrderFormRequestModel request) async {
    return await _homeApiService.submitOrder(request);
  }

  @override
  Future<List<OrderItemModel>> getOrders({
    String? market,
    String? state,
    String? page,
    String? limit,
    int? timeTo,
    int? timeFrom,
    String? type,
    String? orderType,
    String? orderBy,
  }) {
    return _homeApiService.getOrders(
      market,
      state,
      page,
      limit,
      timeTo,
      timeFrom,
      type,
      orderType,
      orderBy,
    );
  }

  @override
  Future<OrderItemModel> cancelOrderWithID(String id) async {
    return _homeApiService.cancelOrderWithID(id);
  }

  @override
  Future<List<OrderItemModel>> cancelAllOrders(
    CancelAllOrderRequestModel body,
  ) {
    return _homeApiService.cancelAllOrders(body);
  }

  @override
  Future<List<TradeHistoryModel>> getTradeHistory({
    String? page,
    String? limit,
    String? market,
    int? timeTo,
    int? timeFrom,
    String? type,
  }) {
    return _homeApiService.getTradeHistory(
      page,
      limit,
      market,
      timeTo,
      timeFrom,
      type,
    );
  }
}
