import 'package:alpha/domain/usecase/two_fa/two_fa_usecase.dart';
import '../../../data/models/auth/login_response_model.dart';
import '../../../data/models/enable_two_fa/two_fa_model.dart';
import '../../../data/models/enable_two_fa/verify_code_request.dart';
import '../../../data/services/local/hive_service.dart';
import '../../../injection/injector.dart';
import '../../../presentation/view_models/global_view_model.dart';
import '../../base/base_view_model.dart';
import '../../constants/app_local_key.dart';

mixin TwoFAMixin on BaseViewModel {
  final TwoFaUseCase _twoFaUseCase = getIt<TwoFaUseCase>();
  final GlobalViewModel _globalVm = getIt<GlobalViewModel>();

  TwoFAData? twoFAData;
  LoginResponseModel? get currentUser => _globalVm.currentUser;
  bool get isTwoFAEnabled => currentUser?.otp ?? false;
  String get barcode => twoFAData?.barcode ?? '';
  String get url => twoFAData?.url ?? '';

  Future<void> generateQRCode() async {
    setBusy(true);
    clearError();
    try {
      final response = await _twoFaUseCase.generateQRCode();
      twoFAData = response.data;
      notifyListeners();
    } catch (e) {
      setError('Generate QR Error: ${e.toString()}');
    } finally {
      setBusy(false);
    }
  }

  Future<bool> toggleTwoFA({
    required String twoFACode,
    required bool isEnable,
  }) async {
    setBusy(true);
    clearError();
    try {
      final request = VerifyCodeRequest(code: twoFACode);
      final success = isEnable
          ? await _twoFaUseCase.enableTwoFA(request: request)
          : await _twoFaUseCase.disableTwoFA(request: request);
      if (!success) return false;
      if (currentUser != null) {
        final updatedUser = currentUser!.copyWith(otp: isEnable);
        _globalVm.updateUser(updatedUser);
        _globalVm.setCachedData(
          AppLocalKey.currentUserKey,
          updatedUser,
          expiry: Duration(minutes: 30),
        );
        _globalVm.selectiveNotify([
          AppLocalKey.currentUserKey,
          AppLocalKey.twoFAStatusKey,
        ]);
      }
      return true;
    } catch (e) {
      setError('Toggle 2FA Error: ${e.toString()}');
      return false;
    } finally {
      setBusy(false);
    }
  }
}
