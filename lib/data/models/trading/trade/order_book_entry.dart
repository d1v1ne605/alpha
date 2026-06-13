import 'package:alpha/core/utils/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_book_entry.freezed.dart';
part 'order_book_entry.g.dart';

@freezed
class OrderBookEntry with _$OrderBookEntry {
  const factory OrderBookEntry({
    String? market,
    required OrderbookSide side,
    required double price,
    required double amount,
    required int sequence,
  }) = _OrderBookEntry;

  factory OrderBookEntry.fromJson(Map<String, dynamic> json) =>
      _$OrderBookEntryFromJson(json);
}
