import 'dart:async';
import 'package:alpha/core/base/base_view_model.dart';
import 'package:alpha/core/mixins/form/form_mixin.dart';
import 'package:alpha/domain/usecase/auth/register_usecase.dart';
import 'package:flutter/material.dart';
import 'package:alpha/core/constants/app_timers.dart';

class RegisterViewModel extends BaseViewModel with FormMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final referralController = TextEditingController();
  final RegisterUseCase registerUseCase;
  String debouncedPassword = '';

  Timer? _debounce;

  RegisterViewModel(this.registerUseCase) {
    passwordController.addListener(_onPasswordChanged);
  }

  void toggleObscurePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void toggleObscureConfirmPassword() {
    obscureConfirmPassword = !obscureConfirmPassword;
    notifyListeners();
  }

  void _onPasswordChanged() {
    _debounce?.cancel();
    _debounce = Timer(AppTimers.millis100, () {
      debouncedPassword = passwordController.text;
      notifyListeners();
    });
  }

  Future<bool> register() async {
    setBusy(true);
    if (validateForm()) {
      setBusy(false);
      return true;
    } else {
      setBusy(false);
      return false;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    referralController.dispose();
    super.dispose();
  }
}
