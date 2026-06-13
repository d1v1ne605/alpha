import 'package:alpha/data/models/trading/trade/trade_history_model.dart';
import 'package:alpha/data/repositories/trading/trade/trade_repository.dart';

class GetTradeHistoryUseCase {
  final TradeRepository tradeRepository;

  GetTradeHistoryUseCase(this.tradeRepository);

  Future<List<TradeHistoryModel>> call({
    String? page,
    String? limit,
    String? market,
    int? timeFrom,
    int? timeTo,
    String? type,
  }) async {
    final response = await tradeRepository.getTradeHistory(
      page: page,
      limit: limit,
      market: market,
      timeFrom: timeFrom,
      timeTo: timeTo,
      type: type,
    );
    return response;
  }
}
