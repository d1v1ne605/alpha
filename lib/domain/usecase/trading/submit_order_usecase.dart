import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/network/app_exception.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/trading/trade/order_form_request_model.dart';
import 'package:alpha/data/models/trading/trade/order_item_model.dart';
import 'package:alpha/data/repositories/trading/trade/trade_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SubmitOrderUseCase {
  final TradeRepository _tradeRepository;

  SubmitOrderUseCase(this._tradeRepository);

  Future<OrderItemModel> call(
    OrderFormRequestModel request,
    BuildContext? context,
  ) async {
    try {
      return await _tradeRepository.submitOrder(request);
    } on DioException catch (e) {
      String errorMessage = context!.appLocaleLanguage.failedToSubmitOrder;
      if (e.response?.data['errors'][0] ==
          AppStorageKey.keyInsufficientOrderError) {
        errorMessage = context.appLocaleLanguage.insufficientMarketLiquidity;
        throw ServerException(errorMessage);
      }
      print('========DioException: ${e.response?.data['errors'][0]}');
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception(': $e');
    }
  }
}
