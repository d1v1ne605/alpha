import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
class Order with _$Order {
  const factory Order({
    required String baseSymbol,
    required String quoteSymbol,
    required String side,
    required double price,
    required int filled,
    required int total,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
