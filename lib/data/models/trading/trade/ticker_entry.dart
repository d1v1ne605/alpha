import 'package:alpha/data/models/trading/trade/ticker_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticker_entry.freezed.dart';
part 'ticker_entry.g.dart';

@freezed
class TickerEntry with _$TickerEntry {
  const factory TickerEntry({required String coin, required TickerData data}) =
      _TickerEntry;

  factory TickerEntry.fromJson(Map<String, dynamic> json) =>
      _$TickerEntryFromJson(json);
}
