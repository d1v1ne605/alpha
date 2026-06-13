import 'package:alpha/data/models/auth/login_request_model.dart';
import 'package:alpha/data/models/auth/login_response_model.dart';

abstract class AuthRepository {
  Future<LoginResponseModel> login(LoginRequestModel request);
}
