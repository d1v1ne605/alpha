import 'package:alpha/data/models/home_market/coin_model/top_coin_display_data.dart';

class ListTopCoin {
  final List<TopCoinDisplayData> coins;

  ListTopCoin({required this.coins});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListTopCoin &&
          runtimeType == other.runtimeType &&
          _listEquals(coins, other.coins);

  @override
  int get hashCode => Object.hashAll(coins);

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    if (identical(a, b)) return true;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}
