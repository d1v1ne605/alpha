import 'package:alpha/data/models/auth/login_request_model.dart';
import 'package:alpha/data/models/auth/login_response_model.dart';
import 'package:alpha/data/repositories/auth/login/auth_repository.dart';
import 'package:alpha/data/services/auth/auth_api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _authApiService;

  AuthRepositoryImpl(this._authApiService);

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    return await _authApiService.login(request);
  }
}
