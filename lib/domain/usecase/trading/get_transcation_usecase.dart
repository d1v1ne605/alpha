import 'package:alpha/data/models/home_market/coin_model/transaction_model.dart';
import 'package:alpha/data/repositories/trading/trade/trade_repository.dart';

class GetTranscationUsecase {
  TradeRepository _tradeRepository;

  GetTranscationUsecase(this._tradeRepository);
  Future<List<TransactionModel>> call(String market) async {
    return await _tradeRepository.getTranscation(market);
  }
}
