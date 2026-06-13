import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'coin_price_model.freezed.dart';
part 'coin_price_model.g.dart';

@freezed
 abstract class CoinPriceModel with _$CoinPriceModel {
  const factory CoinPriceModel({
    required String pair,
    required double price,
    required double changePercentage,
  }) = _CoinPriceModel;

  factory CoinPriceModel.fromJson(Map<String, dynamic> json) =>
      _$CoinPriceModelFromJson(json);

  factory CoinPriceModel.empty() =>
      const CoinPriceModel(pair: '', price: 0.0, changePercentage: 0.0);
}

extension CoinPriceModelExtension on CoinPriceModel {
  Color get changeColor {
    if (changePercentage > 0) {
      return Colors.green;
    } else if (changePercentage < 0) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  String get formattedChange {
    final sign = changePercentage > 0 ? '+' : '';
    return '$sign${changePercentage.toStringAsFixed(2)}%';
  }

  String get formattedPrice => price.toStringAsFixed(1);
}
