import 'dart:convert';

import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/data/services/local/secure_storage_service.dart';
import 'package:dio/dio.dart';

class CookieInterceptor extends Interceptor {
  final SecureStorageService _secureStorageService;
  CookieInterceptor() : _secureStorageService = SecureStorageService();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final cookie = await _secureStorageService.readData(
        AppStorageKey.keyAuthCookie,
      );
      if (cookie != null && cookie.isNotEmpty) {
        options.headers[AppStorageKey.headerAuthCookie] = jsonDecode(cookie);
      }
      handler.next(options);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'Failed to read cookie: $e',
        ),
      );
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    try {
      final setCookie = response.headers[AppStorageKey.headerSetCookie];
      if (setCookie != null && setCookie.isNotEmpty) {
        final cookieData = setCookie.join('; ');

        await _secureStorageService.saveData(
          AppStorageKey.keyAuthCookie,
          jsonEncode(cookieData),
        );
      }
      handler.next(response);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          error: 'Failed to process cookies: $e',
        ),
      );
    }
  }
}
