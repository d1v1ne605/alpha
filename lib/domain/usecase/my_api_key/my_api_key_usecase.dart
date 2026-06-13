import 'package:alpha/data/models/my_api_key/api_key_model.dart';
import 'package:alpha/data/models/my_api_key/verify_api_key_request.dart';
import 'package:alpha/data/repositories/my_api_key/my_api_key_repository.dart';

class MyApiKeyUsecase {
  final MyApiKeyRepository repository;
  MyApiKeyUsecase(this.repository);

  Future<ApiKeyModel> createApiKey({
    required VerifyMyApiRequest request,
  }) async {
    return repository.createApiKey(request: request);
  }

  Future<List<ApiKeyModel>> getApiKey() {
    return repository.getApiKeys();
  }

  Future<void> deleteApiKey({required String kid, required String otpCode}) {
    return repository.deleteApiKey(kid: kid, otpCode: otpCode);
  }

  Future<bool> updateApiKeyStatus({
    required String kid,
    required String state,
    required String otpCode,
  }) async {
    try {
      await repository.updateApiKeyStatus(
        kid: kid,
        state: state,
        otpCode: otpCode,
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
