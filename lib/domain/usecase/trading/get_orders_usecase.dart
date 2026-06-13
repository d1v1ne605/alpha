import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/data/models/trading/trade/order_item_model.dart';
import 'package:alpha/data/repositories/trading/trade/trade_repository.dart';

class GetOrdersUseCase {
  final TradeRepository _tradeRepository;

  GetOrdersUseCase(this._tradeRepository);

  Future<List<OrderItemModel>> call({
    String? market,
    String? state,
    String? page,
    String? limit,
    int? timeTo,
    int? timeFrom,
    String? type,
    String? orderType,
    String? orderBy,
  }) async {
    final response = await _tradeRepository.getOrders(
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
    return getOrdersByState(orders: response, state: state);
  }

  List<OrderItemModel> getOrdersByState({
    required List<OrderItemModel> orders,
    String? state,
  }) {
    if (state == null && orders.isNotEmpty) {
      return orders
          .where((order) => order.state != AppStorageKey.waitStatusOrder)
          .toList();
    }
    return orders;
  }
}
