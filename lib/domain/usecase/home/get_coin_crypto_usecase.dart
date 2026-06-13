import 'package:alpha/data/models/home_market/coin_model/coin_detail_model.dart';
import 'package:alpha/data/models/home_market/crypto_model/token_response.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:alpha/data/models/home_market/market_data_model.dart';
import 'package:alpha/data/models/home_market/market_model.dart';
import 'package:alpha/data/models/home_market/ticker_model.dart';
import 'package:alpha/data/repositories/home/home_reponsitory.dart';

class GetCoinCryptoUsecase {
  HomeReponsitory _homeReponsitory;

  GetCoinCryptoUsecase(this._homeReponsitory);

  Future<List<CoinDetailModel>> call() async {
    final response = await _homeReponsitory.getCoinCryptoAndMarket();
    final List<CurrencyModel> currencies = response['currencies'];
    final tickersRaw = response['tickers'] as Map<String, MarketDataModel>;
    final List<MarketModel> markets = response['markets'];
    final tickers = <String, TickerModel>{};
    tickersRaw.forEach((key, marketData) {
      tickers[key] = marketData.ticker;
    });
    final TokenResponse allCrypto = response['crypto'];
    final List<CoinDetailModel> childCryptoIds = allCrypto.data.tokens.toList();

    final updatedCoins = childCryptoIds.map((coin) {
      final coinMarkets = markets
          .where((m) => m.base_unit == coin.currencyId)
          .toList();
      if (coinMarkets.isEmpty) {
        return coin;
      }
      for (final market in coinMarkets) {
        final tickerData = tickers[market.id];
        if (tickerData != null) {
          return coin.copyWith(
            last: tickerData.last,
            volume: tickerData.volume,
            price_change_percent: tickerData.price_change_percent,
            high: tickerData.high,
            low: tickerData.low,
            open: tickerData.open,
            avg_price: tickerData.avg_price,
            amount: tickerData.amount,
            icon_url: currencies
                .firstWhere((c) => c.id == coin.currencyId)
                .icon_url,
          );
        } else {
          print("⚠️ Coin ${coin.id} has market ${market.id} but no ticker");
        }
      }
      return coin;
    }).toList();
    return updatedCoins;
  }
}
