import 'package:alpha/data/models/auth/login_request_model.dart';
import 'package:alpha/data/models/auth/login_response_model.dart';
import 'package:alpha/data/repositories/auth/login/auth_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  Future<LoginResponseModel> call(LoginRequestModel request) {
    return authRepository.login(request);
  }
}
