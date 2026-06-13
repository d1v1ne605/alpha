import 'dart:io';

import 'package:alpha/core/network/auth_interceptor.dart';
import 'package:alpha/core/network/cookie_interceptor.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';

import 'error_interceptor.dart' show ErrorInterceptor;

class DioFactory {
  static Dio createDio(String baseUrl, {required GoRouter router}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {'Content-Type': 'application/json'},
      ),
    );
    dio.interceptors.add(AuthInterceptor());
    dio.interceptors.add(CookieInterceptor());
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    dio.interceptors.add(ErrorInterceptor(router: router));
    return dio;
  }
}
