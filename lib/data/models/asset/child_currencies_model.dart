import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'child_currencies_model.freezed.dart';
part 'child_currencies_model.g.dart';

@freezed
class ChildCurrenciesModel with _$ChildCurrenciesModel {
  const factory ChildCurrenciesModel({
    @JsonKey(name: "data") required List<CurrencyModel> childCurrenciesData,
    @JsonKey(name: "cached") required bool cached,
    @JsonKey(name: "timestamp") required DateTime timestamp,
  }) = _ChildCurrenciesModel;
  factory ChildCurrenciesModel.fromJson(Map<String, dynamic> json) =>
      _$ChildCurrenciesModelFromJson(json);
}
