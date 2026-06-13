import 'package:alpha/data/models/mockdata/favorite_coin_model.dart';

class MockFavoriteData {
  static final List<FavoriteCoinModel> coins = [
    FavoriteCoinModel(name: "BTC/USDT", price: 83511.0535, change: 1.06),
    FavoriteCoinModel(
      name: "ETH/USDT",
      price: 3.201,
      change: 0.85,
      favorite: true,
    ),
    FavoriteCoinModel(name: "alpha/USDT", price: 6.15, change: -0.75),
    FavoriteCoinModel(name: "BNB/USDT", price: 0.42, change: 2.15),
  ];
}
