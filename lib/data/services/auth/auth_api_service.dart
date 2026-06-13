import 'package:alpha/data/models/auth/forgot_password_request_model.dart';
import 'package:alpha/data/models/auth/login_request_model.dart';
import 'package:alpha/data/models/auth/login_response_model.dart';
import 'package:alpha/data/models/auth/verify_email_request_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/change_password_model/change_password_model.dart';
part 'auth_api_service.g.dart';

@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String baseUrl}) = _AuthApiService;

  @POST('/user/identity/sessions')
  Future<LoginResponseModel> login(@Body() LoginRequestModel request);

  @POST('/user/identity/users')
  Future<dynamic> register(@Body() Map<String, dynamic> body);

  @POST('/user/identity/users/email/generate_code')
  Future<dynamic> verifyEmail(@Body() VerifyEmailRequestModel body);

  @POST('/user/identity/users/password/generate_code')
  Future<dynamic> forgotPassword(@Body() ForgotPasswordRequestModel body);

  @PUT('/user/resource/users/password')
  @Extra({'withCsrf': true})
  Future<HttpResponse<void>> changePassword(@Body() ChangePasswordModel body);
}
