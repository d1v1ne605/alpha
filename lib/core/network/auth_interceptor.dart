import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/network/auth_change_notifier.dart';
import 'package:alpha/injection/injector.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = getIt<AuthChangeNotifier>().token;
    if (token != null) {
      options.headers[AppStorageKey.headerAuthToken] = token;
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await getIt<AuthChangeNotifier>().clear();
    }
    handler.next(err);
  }
}
