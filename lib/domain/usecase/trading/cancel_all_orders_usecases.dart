import 'package:alpha/data/models/trading/trade/cancel_all_order_request_model.dart';
import 'package:alpha/data/models/trading/trade/order_item_model.dart';
import 'package:alpha/data/repositories/trading/trade/trade_repository.dart';

class CancelAllOrdersUseCases {
  final TradeRepository _repository;

  CancelAllOrdersUseCases(this._repository);

  Future<List<OrderItemModel>> call(String market) async {
    final List<OrderItemModel> response = await _repository.cancelAllOrders(
      CancelAllOrderRequestModel(market: market),
    );
    return response.reversed.toList();
  }
}
