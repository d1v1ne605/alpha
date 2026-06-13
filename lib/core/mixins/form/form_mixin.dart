import 'package:alpha/core/base/base_view_model.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/validate.dart';
import 'package:flutter/material.dart';

mixin FormMixin on BaseViewModel {
  final formKey = GlobalKey<FormState>();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void resetForm() {
    formKey.currentState?.reset();
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return context?.appLocaleLanguage.registerErrorLengthPassword;
    }
    if (!PasswordUtils.hasMinLength(value)) {
      return context?.appLocaleLanguage.registerErrorLengthPassword;
    }
    if (!PasswordUtils.hasUpperAndLowerCase(value)) {
      return context?.appLocaleLanguage.registerErrorUpperLowerPassword;
    }
    if (!PasswordUtils.hasNumber(value)) {
      return context?.appLocaleLanguage.registerErrorNumberPassword;
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return context?.appLocaleLanguage.registerErrorNullEmail;
    }
    if (!EmailUtils.isValidEmail(value)) {
      return context?.appLocaleLanguage.registerErrorInvalidEmail;
    }
    return null;
  }

  String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return context?.appLocaleLanguage.registerErrorNullConfirmPassword;
    }
    if (value != password) {
      return context?.appLocaleLanguage.registerErrorMatchConfirmPassword;
    }
    return null;
  }
}
