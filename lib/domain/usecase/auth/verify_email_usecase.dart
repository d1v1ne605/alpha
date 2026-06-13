import 'package:alpha/data/repositories/auth/register/register_repository.dart';

class VerifyEmailUsecase {
  final RegisterRepository repository;
  VerifyEmailUsecase(this.repository);

  Future<dynamic> call(String email) {
    return repository.verifyEmail(email);
  }
}
