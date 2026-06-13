import 'package:alpha/data/models/auth/register_body_request_model.dart';
import 'package:alpha/data/models/auth/verify_email_request_model.dart';
import 'package:alpha/data/services/auth/auth_api_service.dart';

import 'register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final AuthApiService api;

  RegisterRepositoryImpl(this.api);

  @override
  Future<dynamic> register(RegisterBodyRequest body) {
    return api.register(body.toJson());
  }

  @override
  Future<dynamic> verifyEmail(String email) {
    return api.verifyEmail(VerifyEmailRequestModel(email: email));
  }
}
