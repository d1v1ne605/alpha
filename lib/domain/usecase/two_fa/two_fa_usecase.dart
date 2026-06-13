import 'package:alpha/data/models/enable_two_fa/two_fa_model.dart';
import 'package:alpha/data/repositories/two_fa/two_fa_repository.dart';

import '../../../data/models/enable_two_fa/verify_code_request.dart';

class TwoFaUseCase {
  final TwoFaRepository repository;

  TwoFaUseCase(this.repository);

  Future<TwoFAModel> generateQRCode() async {
    return repository.generateQRCode();
  }

  Future<bool> enableTwoFA({required VerifyCodeRequest request}) async {
    return repository.enableTwoFA(request: request);
  }

  Future<bool> disableTwoFA({required VerifyCodeRequest request}) async {
    return repository.disableTwoFA(request: request);
  }
}
