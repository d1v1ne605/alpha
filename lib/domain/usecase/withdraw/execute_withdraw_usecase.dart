import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/network/app_exception.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/asset/withdraw/execute_withdraw_request_model.dart';
import 'package:alpha/data/models/asset/withdraw/execute_withdraw_response_model.dart';
import 'package:alpha/data/models/asset/withdraw/remains_model.dart';
import 'package:alpha/data/repositories/asset/asset_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

typedef ExecuteWithdrawResult = ({
  ExecuteWithdrawResponseModel executeWithdrawResponse,
  RemainsModel remains,
});

class ExecuteWithdrawUseCase {
  final AssetRepository _assetRepository;

  ExecuteWithdrawUseCase(this._assetRepository);

  Future<ExecuteWithdrawResult> call({
    String lang = 'en',
    required ExecuteWithdrawRequestModel request,
    BuildContext? context,
  }) async {
    try {
      final ExecuteWithdrawResponseModel response = await _assetRepository
          .executeWithdraw(lang, request);
      final RemainsModel remains = await _assetRepository.getRemainsWithdraw();
      return (executeWithdrawResponse: response, remains: remains);
    } on DioException catch (e) {
      String errorMessage = context!.appLocaleLanguage.failedToExecuteWithdraw;
      if (e.response?.data['code'] ==
          AppStorageKey.codeInvalidOtpExecuteWithdrawError) {
        errorMessage = context.appLocaleLanguage.invalidOtp;
        throw ServerException(errorMessage);
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception(
        '${context!.appLocaleLanguage.failedToExecuteWithdraw}: $e',
      );
    }
  }
}
