import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_earn_model.freezed.dart';
part 'product_earn_model.g.dart';

@freezed
class ProductEarnResponse with _$ProductEarnResponse {
  const factory ProductEarnResponse({
    required List<ProductEarnData> data,
    required ProductEarnMeta meta,
    required bool cache,
    required ProductEarnProfit profit,
  }) = _ProductEarnResponse;

  factory ProductEarnResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductEarnResponseFromJson(json);
}

@freezed
class ProductEarnData with _$ProductEarnData {
  const factory ProductEarnData({
    required String id,
    required String hostUid,
    required String hostMemberId,
    required double minAmount,
    required String currencyId,
    required String name,
    required String type,
    required String description,
    required int lockPeriod,
    required String annualRate,
    required String status,
    required String createdAt,
    required String updatedAt,
    required String iconUrl,
    required String hourlyRate,
    required int position,
    required String productType,
  }) = _ProductEarnData;

  factory ProductEarnData.fromJson(Map<String, dynamic> json) =>
      _$ProductEarnDataFromJson(json);
}

@freezed
class ProductEarnMeta with _$ProductEarnMeta {
  const factory ProductEarnMeta({
    required int total,
    required int page,
    required int limit,
    required int totalPages,
  }) = _ProductEarnMeta;

  factory ProductEarnMeta.fromJson(Map<String, dynamic> json) =>
      _$ProductEarnMetaFromJson(json);
}

@freezed
class ProductEarnProfit with _$ProductEarnProfit {
  const factory ProductEarnProfit({
    @JsonKey(name: 'total_usd') required double totalUsd,
    @JsonKey(name: 'today_usd') required double todayUsd,
    required ProductEarnProfitCache cache,
  }) = _ProductEarnProfit;

  factory ProductEarnProfit.fromJson(Map<String, dynamic> json) =>
      _$ProductEarnProfitFromJson(json);
}

@freezed
class ProductEarnProfitCache with _$ProductEarnProfitCache {
  const factory ProductEarnProfitCache({
    required bool totalAmount,
    required bool todayAmount,
  }) = _ProductEarnProfitCache;

  factory ProductEarnProfitCache.fromJson(Map<String, dynamic> json) =>
      _$ProductEarnProfitCacheFromJson(json);
}
