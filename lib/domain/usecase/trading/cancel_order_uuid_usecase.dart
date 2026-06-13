import 'package:alpha/data/models/trading/trade/order_item_model.dart';
import 'package:alpha/data/repositories/trading/trade/trade_repository.dart';

class CancelOrderUuidUseCase {
  final TradeRepository _tradeRepository;

  CancelOrderUuidUseCase(this._tradeRepository);

  Future<OrderItemModel> call(String id) async {
    return await _tradeRepository.cancelOrderWithID(id);
  }
}
