import 'package:alpha/data/models/home_market/coin_model/coin_detail_wrapper.dart';
import 'package:alpha/data/models/home_market/coin_model/transaction_model.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_detail_wrapper.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_detail_wrapper.dart';
import 'package:alpha/data/models/trading/trade/cancel_all_order_request_model.dart';
import 'package:alpha/data/models/trading/trade/depth_response_model.dart';
import 'package:alpha/data/models/trading/trade/order_form_request_model.dart';
import 'package:alpha/data/models/trading/trade/order_item_model.dart';
import 'package:alpha/data/models/trading/trade/trade_history_model.dart';

abstract class TradeRepository {
  Future<List<TransactionModel>> getTranscation(String market);
  Future<CoinDetailWrapper> getCoinDetail(String coinId);
  Future<DepthResponseModel> getOrderBook(String market);
  Future<OrderItemModel> submitOrder(OrderFormRequestModel request);
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
  });
  Future<OrderItemModel> cancelOrderWithID(String id);
  Future<List<OrderItemModel>> cancelAllOrders(CancelAllOrderRequestModel body);
  Future<List<TradeHistoryModel>> getTradeHistory({
    String? page,
    String? limit,
    String? market,
    int? timeTo,
    int? timeFrom,
    String? type,
  });
}
