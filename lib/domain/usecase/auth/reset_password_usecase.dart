import 'package:alpha/data/repositories/auth/forgot_password/forgot_password_repository.dart';

class ForgotPasswordUsecase {
  final ForgotPasswordRepository repository;
  ForgotPasswordUsecase(this.repository);

  Future<dynamic> call(String email) {
    return repository.forgotPassword(email);
  }
}
