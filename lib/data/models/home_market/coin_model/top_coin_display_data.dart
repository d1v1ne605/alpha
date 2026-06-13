class TopCoinDisplayData {
  final String name;
  final String lastPriceCurrency;
  final String priceChangePercent;
  final dynamic coinObject; // Original coin object for navigation

  TopCoinDisplayData({
    required this.name,
    required this.lastPriceCurrency,
    required this.priceChangePercent,
    required this.coinObject,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopCoinDisplayData &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          lastPriceCurrency == other.lastPriceCurrency &&
          priceChangePercent == other.priceChangePercent;

  @override
  int get hashCode =>
      name.hashCode ^ lastPriceCurrency.hashCode ^ priceChangePercent.hashCode;
}
