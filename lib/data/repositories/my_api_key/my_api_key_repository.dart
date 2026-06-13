import 'package:alpha/data/models/my_api_key/api_key_model.dart';
import 'package:alpha/data/models/my_api_key/verify_api_key_request.dart';

abstract class MyApiKeyRepository {
  Future<List<ApiKeyModel>> getApiKeys();
  Future<ApiKeyModel> createApiKey({required VerifyMyApiRequest request});

  Future<ApiKeyModel> updateApiKeyStatus({
    required String kid,
    required String state,
    required String otpCode,
  });

  Future<void> deleteApiKey({required String kid, required String otpCode});
}
