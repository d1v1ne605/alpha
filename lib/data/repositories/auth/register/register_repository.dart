import 'package:alpha/data/models/auth/register_body_request_model.dart';

abstract class RegisterRepository {
  Future<dynamic> register(RegisterBodyRequest body);
  Future<dynamic> verifyEmail(String email);
}
