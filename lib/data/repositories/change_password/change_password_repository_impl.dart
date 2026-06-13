import 'package:alpha/core/utils/extension.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../models/change_password_model/change_password_model.dart';
import '../../services/auth/auth_api_service.dart';
import 'change_password_repository.dart';

class ChangePasswordRepositoryImpl implements ChangePasswordRepository {
  final AuthApiService api;

  ChangePasswordRepositoryImpl(this.api);

  @override
  Future<bool> changePassword({
    required ChangePasswordModel request,
    BuildContext? context,
  }) async {
    try {
      final response = await api.changePassword(request);
      return response.response.statusCode == 201;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            context?.appLocaleLanguage.failedChangePassword,
      );
    }
  }
}
