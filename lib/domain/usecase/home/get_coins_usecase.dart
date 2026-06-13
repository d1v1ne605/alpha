import 'package:alpha/core/constants/app_local_key.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_model.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:alpha/data/models/home_market/market_data_model.dart';
import 'package:alpha/data/models/home_market/market_model.dart';
import 'package:alpha/data/models/home_market/ticker_model.dart';
import 'package:alpha/data/repositories/global/global_repository.dart';
import 'package:alpha/data/services/local/hive_service.dart';
import 'package:alpha/injection/injector.dart';

class GetCoinsUsecase {
  final GlobalRepository _globalRepository;

  GetCoinsUsecase(this._globalRepository);

  Future<List<CoinModel>> call() async {
    try {
      final result = await _globalRepository.getGlobalData();
      final coins = <CoinModel>[];
      final hive = getIt<HiveService>();

      final favoriteIds =
          await hive.get(
                key: AppLocalKey.hiveKeyCoinBox,
                boxName: AppLocalKey.hiveBoxCoinBox,
              )
              as List<String>? ??
          [];

      final marker = result[AppStorageKey.markets] as List<MarketModel>;
      final currencies =
          result[AppStorageKey.currencies] as List<CurrencyModel>;
      final tickersRaw =
          result[AppStorageKey.tickers] as Map<String, MarketDataModel>;
      final tickers = <String, TickerModel>{};
      tickersRaw.forEach((key, marketData) {
        tickers[key] = marketData.ticker;
      });
      final allMarket = marker.toList();
      for (final market in allMarket) {
        try {
          final currency = currencies.firstWhere(
            (currency) => currency.id == market.base_unit,
          );
          final quoteCurrency = currencies.firstWhere(
            (currency) => currency.id == market.quote_unit,
          );
          final ticker = tickers[market.id];

          final lastPrice = FormatterUtils.toDoubleOrZero(ticker?.last);

          final quotePrice = FormatterUtils.toDoubleOrZero(quoteCurrency.price);

          final usdPrice =
              lastPrice *
              quotePrice *
              FormatterUtils.toDoubleOrZero(
                currencies
                    .firstWhere(
                      (element) =>
                          element.id == AppStorageKey.usdt.toLowerCase(),
                    )
                    .price,
              );
          final coin = CoinModel(
            id: market.id,
            name: market.name,
            lastName: currency.name,
            lastPriceCurrency: currency.price,
            base_unit: market.base_unit,
            quote_unit: market.quote_unit,
            quote_price: quotePrice.toString(),
            withdrawal_enabled: currency.withdrawal_enabled,
            deposit_enabled: currency.deposit_enabled,
            iconUrl: currency.icon_url,
            lastPrice: FormatterUtils.toFixed(
              FormatterUtils.toDoubleOrZero(lastPrice.toString()),
              market.price_precision,
            ),
            usdPrice: FormatterUtils.toFixed(
              FormatterUtils.toDoubleOrZero(usdPrice.toString()),
              market.price_precision,
            ),
            volume: ticker?.volume ?? '0.0',
            priceChangePercent: ticker?.price_change_percent ?? '0.0',
            position: currency.position + quoteCurrency.position,
            ishar: favoriteIds.contains(market.id),
            high: FormatterUtils.toFixed(
              FormatterUtils.toDoubleOrZero(ticker?.high ?? '0.0'),
              market.price_precision,
            ),
            low: FormatterUtils.toFixed(
              FormatterUtils.toDoubleOrZero(ticker?.low ?? '0.0'),
              market.price_precision,
            ),
            amount: ticker?.amount ?? '0.0',
            amount_precision: market.amount_precision,
            price_precision: market.price_precision,
            deposit_fee: currency.deposit_fee,
            withdraw_fee: currency.withdraw_fee,
            min_deposit_amount: currency.min_deposit_amount,
            min_withdraw_amount: currency.min_withdraw_amount,
            min_confirmations: currency.min_confirmations,
          );
          coins.add(coin);
        } catch (e) {
          continue;
        }
      }

      return coins;
    } catch (e) {
      print("getCoins error: $e");
      return [];
    }
  }
}
