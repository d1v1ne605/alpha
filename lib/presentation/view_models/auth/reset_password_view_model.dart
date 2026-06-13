import 'package:alpha/core/base/base_view_model.dart';
import 'package:alpha/core/mixins/form/form_mixin.dart';
import 'package:flutter/material.dart';

class ResetPasswordViewModel extends BaseViewModel with FormMixin {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void toggleObscurePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void toggleObscureConfirmPassword() {
    obscureConfirmPassword = !obscureConfirmPassword;
    notifyListeners();
  }

  Future<void> resetPassword(BuildContext context) async {
    setBusy(true);
    if (validateForm()) {
      setBusy(false);
    } else {
      setBusy(false);
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
