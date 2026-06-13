import 'package:alpha/data/models/home_market/coin_model/coin_detail_wrapper.dart';
import 'package:alpha/data/repositories/trading/trade/trade_repository.dart';

class GetCoinDetailUsecase {
  final TradeRepository _tradeRepository;

  GetCoinDetailUsecase(this._tradeRepository);
  Future<CoinDetailWrapper> call(String coinId) async {
    return await _tradeRepository.getCoinDetail(coinId);
  }
}
