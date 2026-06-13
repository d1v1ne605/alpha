import 'package:alpha/data/models/trading/trade/depth_response_model.dart';
import 'package:alpha/data/repositories/trading/trade/trade_repository.dart';

typedef OrderBookList = List<List<String>>; // Includes [price, amount]

class GetOrderBookUseCase {
  final TradeRepository tradeRepository;

  GetOrderBookUseCase(this.tradeRepository);

  Future<DepthResponseModel> call(String market, {int limit = 16}) async {
    DepthResponseModel orderBookResponse = await tradeRepository.getOrderBook(
      market,
    );

    final paddedBids = padOrderList(orderBookResponse.bids, limit);
    final paddedAsks = padOrderList(orderBookResponse.asks, limit);
    return DepthResponseModel(
      timestamp: orderBookResponse.timestamp,
      bids: paddedBids,
      asks: paddedAsks,
    );
  }

  // Pads the order list to ensure it has at least [targetLength] items.
  List<List<String>> padOrderList(OrderBookList orders, int targetLength) {
    final missing = targetLength - orders.length;
    if (missing > 0) {
      return orders + List.generate(missing, (_) => ["", ""]);
    }
    return orders;
  }
}
