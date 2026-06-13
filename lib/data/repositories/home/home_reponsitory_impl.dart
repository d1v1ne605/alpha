import 'package:alpha/data/models/banner_models/banner_model.dart';
import 'package:alpha/data/services/home/home_api_service.dart';

import 'home_reponsitory.dart';

class HomeRepositoryImpl implements HomeReponsitory {
  final HomeApiService _homeApiService;

  HomeRepositoryImpl(this._homeApiService);

  @override
  Future<List<BannerModel>> fetchBanners({int limit = 5}) {
    return _homeApiService.getBanners(limit);
  }

  @override
  Future<Map<String, dynamic>> getCoinCryptoAndMarket() async {
    try {
      final results = await Future.wait([
        _homeApiService.getCoinCrypto(),
        _homeApiService.getCurrencies(),
        _homeApiService.getTickers(),
        _homeApiService.getMarkets(),
      ]);
      return {
        'crypto': results[0],
        'currencies': results[1],
        'tickers': results[2],
        'markets': results[3],
      };
    } catch (e) {
      print("Error fetching CoinCrypto: $e");
      rethrow;
    }
  }

  @override
  Future<List<BannerModel>> fetchAnnouncements() {
    return _homeApiService.getAnnouncements();
  }
}
