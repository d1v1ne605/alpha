import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_book_response.freezed.dart';
part 'order_book_response.g.dart';

@freezed
abstract class OrderBookResponse with _$OrderBookResponse {
  const factory OrderBookResponse({
    required Map<String, dynamic> lastTradeInfo,
    required List<List<double>> bids,
    required List<List<double>> asks,
  }) = _OrderBookResponse;

  factory OrderBookResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderBookResponseFromJson(json);
}
