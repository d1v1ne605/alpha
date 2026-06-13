import 'package:alpha/core/base/base_view_model.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/mixins/form/form_mixin.dart';
import 'package:alpha/core/network/app_exception.dart';
import 'package:alpha/core/network/auth_change_notifier.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/auth/login_request_model.dart';
import 'package:alpha/data/models/auth/login_response_model.dart';
import 'package:alpha/data/services/local/secure_storage_service.dart';
import 'package:alpha/domain/usecase/auth/login_usecase.dart';
import 'package:alpha/domain/usecase/auth/verify_email_usecase.dart';
import 'package:alpha/injection/injector.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../global_view_model.dart';

class LoginViewModel extends BaseViewModel with FormMixin {
  final LoginUseCase loginUseCase;
  final VerifyEmailUsecase verifyEmailUsecase;
  bool needs2FA = false;

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  bool obscurePassword = true;
  bool showResendVerifySheet = false;
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginViewModel(this.loginUseCase, this.verifyEmailUsecase);

  void toggleObscurePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void triggerResendVerifySheet(bool isVisible) {
    showResendVerifySheet = isVisible;
    notifyListeners();
  }

  void init(String? emailFromRegister) {
    if (emailFromRegister != null) {
      emailController.text = emailFromRegister;
      triggerResendVerifySheet(true);
      notifyListeners();
    }
  }

  Future<void> login(
    BuildContext context, {
    String? email,
    String? password,
    String? code,
  }) async {
    setBusy(true);
    try {
      LoginResponseModel response = await loginUseCase.call(
        LoginRequestModel(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          otp_code: code,
        ),
      );
      final isPending = response.state == 'pending';
      if (isPending) {
        triggerResendVerifySheet(true);
        return;
      }

      final String token = response.csrf_token;
      response = response.copyWith(csrf_token: '');
      if (token.isEmpty) {
        throw Exception("Login failed");
      }

      final globalViewModel = getIt<GlobalViewModel>();
      await globalViewModel.saveUser(response);

      AuthChangeNotifier().token = token;
      await SecureStorageService().saveData(AppStorageKey.accessToken, token);
      globalViewModel.disconnectSocket();
      globalViewModel.startBalancesAndCurrenciesPolling();
      globalViewModel.connectSocket();
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data['errors'] is List) {
        final errors = (e.response!.data['errors'] as List).cast<String>();

        if (errors.contains('identity.session.missing_otp')) {
          needs2FA = true;
          notifyListeners();
        }
        if (errors.contains('identity.session.invalid_otp')) {
          needs2FA = true;

          setError('Login failed');
          notifyListeners();
        }
      }

      if (e.error is ValidationException) {
        setError((e.error as ValidationException).message);
      } else {
        setError('Login failed');
      }
    } on AppException catch (e) {
      print("Handled AppException: ${e.message}");
    } catch (e) {
      setError('Login failed');
    } finally {
      setBusy(false);
    }
  }

  Future<void> handleResendEmail(BuildContext context) async {
    setBusy(true);
    try {
      final email = emailController.text;
      await verifyEmailUsecase.call(email);
    } on DioException catch (e) {
      context.showErrorSnackBar(
        e.error is ValidationException
            ? (e.error as ValidationException).message
            : context.appLocaleLanguage.registerErrorMessage,
      );
    } finally {
      setBusy(false);
    }
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
