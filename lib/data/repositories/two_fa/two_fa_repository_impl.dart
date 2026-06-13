import 'package:alpha/data/models/enable_two_fa/two_fa_model.dart';
import 'package:alpha/data/repositories/two_fa/two_fa_repository.dart';
import 'package:alpha/data/services/home/home_api_service.dart';

import '../../models/enable_two_fa/verify_code_request.dart';

class TwoFaRepositoryImpl implements TwoFaRepository {
  final HomeApiService api;

  TwoFaRepositoryImpl(this.api);

  @override
  Future<TwoFAModel> generateQRCode() async {
    try {
      final response = await api.generateQRCode();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> enableTwoFA({required VerifyCodeRequest request}) async {
    try {
      await api.enableVerifyCode(request);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> disableTwoFA({required VerifyCodeRequest request}) async {
    try {
      await api.disableVerifyCode(request);
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
