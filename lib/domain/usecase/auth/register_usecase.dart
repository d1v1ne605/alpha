import 'package:alpha/data/models/auth/register_body_request_model.dart';
import 'package:alpha/data/repositories/auth/register/register_repository.dart';

class RegisterUseCase {
  final RegisterRepository repository;
  RegisterUseCase(this.repository);

  Future<dynamic> call(RegisterBodyRequest body) {
    return repository.register(body);
  }
}
