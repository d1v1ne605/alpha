import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/network/app_exception.dart';
import 'package:alpha/data/models/asset/beneficiaries_model.dart';
import 'package:alpha/data/models/asset/withdraw/active_beneficiary_request_model.dart';
import 'package:alpha/data/repositories/asset/asset_repository.dart';
import 'package:dio/dio.dart';

class ActiveBeneficiaryWithdrawUseCase {
  final AssetRepository _assetRepository;

  ActiveBeneficiaryWithdrawUseCase(this._assetRepository);

  Future<BeneficiariesModel> call(
    int id,
    ActiveBeneficiaryRequestModel request,
  ) async {
    try {
      return await _assetRepository.activeBeneficiary(id.toString(), request);
    } on DioException catch (e) {
      if (e.error is ValidationException) {
        final validation = e.error as ValidationException;
        if (validation.errors.isNotEmpty &&
            validation.errors.first ==
                AppStorageKey.keyInvalidPinBeneficiaryWithdrawError) {
          throw ValidationException('Invalid PIN for beneficiary');
        }
      }
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to activate beneficiary: $e');
    }
  }
}
