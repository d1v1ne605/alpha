import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import '../../models/account_log_model/account_log_model.dart';

part 'account_log_api_service.g.dart';

@RestApi()
abstract class AccountLogApiService {
  factory AccountLogApiService(Dio dio, {String baseUrl}) = _AccountLogApiService;

  @GET("/user/resource/users/activity/all")
  Future<List<AccountLogModel>> getAccountLogs();
}