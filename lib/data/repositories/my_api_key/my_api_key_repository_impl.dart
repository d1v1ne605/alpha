import 'package:alpha/data/models/my_api_key/api_key_model.dart';
import 'package:alpha/data/models/my_api_key/update_api_key_request.dart';
import 'package:alpha/data/models/my_api_key/verify_api_key_request.dart';
import 'package:alpha/data/repositories/my_api_key/my_api_key_repository.dart';
import 'package:alpha/data/services/home/home_api_service.dart';

class MyApiKeyRepositoryImpl implements MyApiKeyRepository {
  final HomeApiService api;
  MyApiKeyRepositoryImpl(this.api);

  @override
  Future<List<ApiKeyModel>> getApiKeys() async {
    try {
      final response = await api.getApiKeys();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiKeyModel> createApiKey({
    required VerifyMyApiRequest request,
  }) async {
    try {
      final response = await api.createApiKey(request);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiKeyModel> updateApiKeyStatus({
    required String kid,
    required String state,
    required String otpCode,
  }) async {
    try {
      final request = UpdateApiKeyRequest(totpCode: otpCode, state: state);
      final response = await api.updateApiKeyStatus(kid, request);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteApiKey({
    required String kid,
    required String otpCode,
  }) async {
    try {
      await api.deleteApiKey(kid, otpCode);
    } catch (e) {
      rethrow;
    }
  }
}
