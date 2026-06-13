import 'package:alpha/data/models/auth/forgot_password_request_model.dart';
import 'package:alpha/data/repositories/auth/forgot_password/forgot_password_repository.dart';
import 'package:alpha/data/services/auth/auth_api_service.dart';

class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  final AuthApiService api;

  ForgotPasswordRepositoryImpl(this.api);

  @override
  Future<dynamic> forgotPassword(String email) {
    return api.forgotPassword(ForgotPasswordRequestModel(email: email));
  }
}
