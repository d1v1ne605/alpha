import 'dart:async';
import 'package:alpha/core/base/base_view_model.dart';
import 'package:alpha/core/mixins/form/form_mixin.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/domain/usecase/auth/reset_password_usecase.dart';
import 'package:alpha/injection/injector.dart';
import 'package:flutter/material.dart';

class ForgotPasswordViewModel extends BaseViewModel with FormMixin {
  final emailController = TextEditingController();
  final ForgotPasswordUsecase forgotPasswordUsecase =
      getIt<ForgotPasswordUsecase>();
  bool showSheet = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void triggerOpenSheet(bool isVisible) {
    showSheet = isVisible;
    notifyListeners();
  }

  Future<void> handleForgotPasswordPressed(BuildContext context) async {
    if (validateForm()) {
      try {
        setBusy(true);
        await forgotPasswordUsecase.call(emailController.text.trim());
        triggerOpenSheet(true);
        setBusy(false);
      } catch (e) {
        setBusy(false);
        context.showErrorSnackBar('Failed to send reset link: $e');
      }
    }
  }
}
