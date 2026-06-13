import 'package:alpha/data/models/enable_two_fa/two_fa_model.dart';
import 'package:alpha/data/models/enable_two_fa/verify_code_request.dart';

abstract class TwoFaRepository {
  Future<TwoFAModel> generateQRCode();
  Future<bool> enableTwoFA({required VerifyCodeRequest request});
  Future<bool> disableTwoFA({required VerifyCodeRequest request});
}
