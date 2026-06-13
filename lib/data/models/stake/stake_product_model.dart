import 'package:freezed_annotation/freezed_annotation.dart';

part 'stake_product_model.freezed.dart';
part 'stake_product_model.g.dart';

@freezed
class StakeProductResponse with _$StakeProductResponse {
  const factory StakeProductResponse({
    required String currencyId,
    required List<StakeProduct> products,
    bool? isExpanded,
  }) = _StakeProductResponse;

  factory StakeProductResponse.fromJson(Map<String, dynamic> json) =>
      _$StakeProductResponseFromJson(json);
}

@freezed
class StakeProduct with _$StakeProduct {
  const factory StakeProduct({
    required String id,
    required String code,
    required String currencyId,
    required String kind,
    required int lockDays,
    required double aprBase,
    required int isLocked,
    required int minAmount,
    required dynamic maxAmount,
    required String status,
    required double poolFilled,
    required double poolSize,
    dynamic metadata,
    required DateTime createdAt,
    required DateTime updatedAt,
    required dynamic tablePosition,
    String? iconUrl,
  }) = _StakeProduct;

  factory StakeProduct.fromJson(Map<String, dynamic> json) =>
      _$StakeProductFromJson(json);
}
