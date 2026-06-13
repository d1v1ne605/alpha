import 'dart:io';

import 'package:alpha/core/network/app_exception.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/asset/withdraw/delete_beneficiary_request_model.dart';
import 'package:alpha/data/repositories/asset/asset_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class DeleteBeneficiaryWithdrawUseCase {
  final AssetRepository _assetRepository;

  DeleteBeneficiaryWithdrawUseCase(this._assetRepository);

  Future<bool> call(
    String id,
    DeleteBeneficiaryRequestModel request,
    BuildContext? context,
  ) async {
    try {
      await _assetRepository.deleteBeneficiary(id, request);
      return true;
    } on DioException catch (e) {
      String errorMessage =
          context!.appLocaleLanguage.failedToDeleteBeneficiary;
      if (e.response?.data['statusCode'] == HttpStatus.badRequest) {
        errorMessage = context.appLocaleLanguage.theAddressIsAlreadyWithdrawing;
        throw ServerException(errorMessage);
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception(context!.appLocaleLanguage.failedToDeleteBeneficiary);
    }
  }
}
