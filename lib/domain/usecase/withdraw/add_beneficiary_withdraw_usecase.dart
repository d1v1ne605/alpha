import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/network/app_exception.dart';
import 'package:alpha/data/models/asset/beneficiaries_model.dart';
import 'package:alpha/data/models/asset/withdraw/add_beneficiaries_request_model.dart';
import 'package:alpha/data/repositories/asset/asset_repository.dart';
import 'package:dio/dio.dart';

class AddBeneficiaryWithdrawUseCase {
  final AssetRepository _assetRepository;

  AddBeneficiaryWithdrawUseCase(this._assetRepository);

  Future<BeneficiariesModel> call(AddBeneficiariesRequestModel request) async {
    try {
      final response = await _assetRepository.addBeneficiaries(request);
      return response;
    } on DioException catch (e) {
      if (e.error is ValidationException) {
        final validation = e.error as ValidationException;
        if (validation.errors.isNotEmpty &&
            validation.errors.first ==
                AppStorageKey.keyDuplicateAddressWithdrawError) {
          throw ValidationException('Duplicate address for withdrawal');
        }
      }
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to add new address for withdrawal: $e');
    }
  }
}
