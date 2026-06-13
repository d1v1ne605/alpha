import 'package:alpha/core/constants/app_local_key.dart';
import 'package:alpha/data/models/my_api_key/api_key_model.dart';
import 'package:alpha/data/models/my_api_key/verify_api_key_request.dart';
import 'package:alpha/domain/usecase/my_api_key/my_api_key_usecase.dart';
import 'package:alpha/presentation/view_models/global_view_model.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/mixins/local_storage/local_storage_mixin.dart';
import '../../../core/mixins/two_fa_mixin/two_fa_mixin.dart';
import '../../../data/models/account_log_model/account_log_model.dart';
import '../../../domain/usecase/account_log/account_log_usecase.dart';

class ProfileViewModel extends BaseViewModel
    with TwoFAMixin, LocalStorageMixin {
  final AccountLogUseCase accountLogUseCase;
  final GlobalViewModel globalViewModel;
  final MyApiKeyUsecase _myApiKeyUsecase;

  List<AccountLogModel> _accountLogs = [];

  List<AccountLogModel> get accountLogs => _accountLogs;
  AccountLogModel? get currentDevice =>
      _accountLogs.isNotEmpty ? _accountLogs.first : null;
  List<AccountLogModel> get historyDevices =>
      _accountLogs.length > 1 ? _accountLogs.sublist(1) : [];

  ProfileViewModel(
    this.accountLogUseCase,
    this.globalViewModel,
    this._myApiKeyUsecase,
  ) {
    initLocalStorage(globalViewModel.hiveService);
  }
  final List<ApiKeyModel> _apiKeys = [];
  List<ApiKeyModel> get apiKeys => _apiKeys;

  bool get is2FAEnabled => currentUser?.otp ?? false;
  bool _isApiKeyCreatedSuccess = false;
  bool get isApiKeyCreatedSuccess => _isApiKeyCreatedSuccess;
  String? selectedApiKeyKid;
  bool _isUpdatingApiKey = false;
  bool _isDeletingApiKey = false;
  bool _isCreatingApiKey = false;

  bool get isUpdatingApiKey => _isUpdatingApiKey;
  bool get isDeletingApiKey => _isDeletingApiKey;
  bool get isCreatingApiKey => _isCreatingApiKey;

  Future<void> fetchAccountLogs() async {
    setBusy(true);
    clearError();
    try {
      _accountLogs = await accountLogUseCase.call();
      _accountLogs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      setCachedData(
        AppLocalKey.accountLogsKey,
        _accountLogs,
        expiry: Duration(minutes: 10),
      );
      selectiveNotify([AppLocalKey.accountLogsKey]);
    } catch (e) {
      setError('Failed to load account logs: ${e.toString()}');
    } finally {
      setBusy(false);
    }
  }

  Future<void> getUser() async {
    await globalViewModel.getUser();
  }

  Future<void> fetchApiKeys() async {
    setBusy(true);
    clearError();
    try {
      final keys = await _myApiKeyUsecase.getApiKey();
      _apiKeys.clear();
      _apiKeys.addAll(keys);
      setCachedData(
        AppLocalKey.apiKeysKey,
        _apiKeys,
        expiry: Duration(minutes: 10),
      );
      selectiveNotify([AppLocalKey.apiKeysKey]);
    } catch (e) {
      setError('Failed to load API keys: ${e.toString()}');
    } finally {
      setBusy(false);
    }
  }

  Future<void> updateApiKeyStatusWithOtp({
    required String kid,
    required String state,
    required String otpCode,
    Function(bool)? onComplete,
  }) async {
    if (_isUpdatingApiKey) return;

    _isUpdatingApiKey = true;
    notifyListeners();

    try {
      final result = await _myApiKeyUsecase.updateApiKeyStatus(
        kid: kid,
        state: state,
        otpCode: otpCode,
      );

      if (result) {
        final index = apiKeys.indexWhere((key) => key.kid == kid);
        if (index != -1) {
          apiKeys[index] = apiKeys[index].copyWith(state: state);
        }
      }

      onComplete?.call(result);
    } catch (error) {
      setError('Update API key failed: $error');
      onComplete?.call(false);
    } finally {
      _isUpdatingApiKey = false;
      notifyListeners();
    }
  }

  Future<void> deleteApiKeyWithOtp({
    required String kid,
    required String otpCode,
    Function(bool)? onComplete,
  }) async {
    if (_isDeletingApiKey) return;

    _isDeletingApiKey = true;
    notifyListeners();

    try {
      await _myApiKeyUsecase.deleteApiKey(kid: kid, otpCode: otpCode);
      _apiKeys.removeWhere((key) => key.kid == kid);
      onComplete?.call(true);
    } catch (error) {
      setError('Delete API key failed: $error');
      onComplete?.call(false);
    } finally {
      _isDeletingApiKey = false;
      notifyListeners();
    }
  }

  Future<void> createApiKey({
    required String totpCode,
    Function(ApiKeyModel?)? onComplete,
  }) async {
    if (_isCreatingApiKey) return;

    _isCreatingApiKey = true;
    setBusy(true);

    try {
      final request = VerifyMyApiRequest(totpCode: totpCode);
      final apiKey = await _myApiKeyUsecase.createApiKey(request: request);

      _apiKeys.insert(0, apiKey);
      _isApiKeyCreatedSuccess = true;

      onComplete?.call(apiKey);
    } catch (error) {
      setError("Create API key failed: $error");
      onComplete?.call(null);
    } finally {
      _isCreatingApiKey = false;
      setBusy(false);
      notifyListeners();
    }
  }

  void selectApiKey(String kid) {
    selectedApiKeyKid = kid;
    notifyListeners();
  }

  @override
  void dispose() {
    disposeResources();
    super.dispose();
  }
}
