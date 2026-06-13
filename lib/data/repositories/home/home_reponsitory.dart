import 'package:alpha/data/models/banner_models/banner_model.dart';

abstract class HomeReponsitory {
  Future<List<BannerModel>> fetchBanners({int limit = 5});

  Future<Map<String, dynamic>> getCoinCryptoAndMarket();

  Future<List<BannerModel>> fetchAnnouncements();
}
