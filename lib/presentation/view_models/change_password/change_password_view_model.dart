import 'package:alpha/core/utils/extension.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/utils/validate.dart';
import '../../../data/models/change_password_model/change_password_model.dart';
import '../../../domain/usecase/change_password/change_password_usecase.dart';

class ChangePasswordViewModel extends BaseViewModel {
  final ChangePasswordUsecase changePasswordUsecase;

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? _successMessage;

  String? get successMessage => _successMessage;

  bool _isFormValid = false;

  bool get isFormValid => _isFormValid;

  String? _passwordError;

  String? get passwordError => _passwordError;

  String? passwordValidator(String password) {
    if (!PasswordUtils.hasMinLength(password)) {
      return context?.appLocaleLanguage.registerErrorLengthPassword;
    }
    if (!PasswordUtils.hasUpperAndLowerCase(password)) {
      return context?.appLocaleLanguage.registerErrorUpperLowerPassword;
    }
    if (!PasswordUtils.hasNumber(password)) {
      return context?.appLocaleLanguage.registerErrorNumberPassword;
    }
    return null;
  }

  ChangePasswordViewModel(this.changePasswordUsecase) {
    _initListeners();
  }

  void _initListeners() {
    oldPasswordController.addListener(_onFormChanged);
    newPasswordController.addListener(_onFormChanged);
    confirmPasswordController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    final oldPass = oldPasswordController.text.trim();
    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    _successMessage = null;
    setError(null);

    String? validationError = passwordValidator(newPass);
    if (validationError == null && newPass != confirmPass) {
      validationError = context?.appLocaleLanguage.passwordConfirmation;
    }

    final isValid =
        oldPass.isNotEmpty &&
        newPass.isNotEmpty &&
        confirmPass.isNotEmpty &&
        validationError == null;

    final shouldNotify =
        _isFormValid != isValid || _passwordError != validationError;

    _isFormValid = isValid;
    _passwordError = validationError;

    if (shouldNotify) {
      notifyListeners();
    }
  }

  Future<void> changePassword() async {
    if (!_isFormValid) return;

    setBusy(true);
    _successMessage = null;
    setError(null);

    try {
      final request = ChangePasswordModel(
        oldPassword: oldPasswordController.text.trim(),
        newPassword: newPasswordController.text.trim(),
        confirmNewPassword: confirmPasswordController.text.trim(),
      );

      final isSuccess = await changePasswordUsecase(request: request);

      if (isSuccess) {
        _successMessage = context?.appLocaleLanguage.resetPasswordSuccess;
      } else {
        setError(context?.appLocaleLanguage.failedChangePassword);
        if (isBusy) {
          setBusy(false);
        }
      }
    } catch (e) {
      setError('${context?.appLocaleLanguage.failedChangePassword}: $e');
      if (isBusy) {
        setBusy(false);
      }
    } finally {}
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
