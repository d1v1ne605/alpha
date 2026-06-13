import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/pages/auth/login/forgot_password_btn.dart';
import 'package:alpha/presentation/pages/auth/login/login_form.dart';
import 'package:alpha/presentation/pages/auth/login/login_heading.dart';
import 'package:alpha/presentation/pages/auth/login/verification_2FA.dart';
import 'package:alpha/presentation/pages/auth/share_widgets/auth_bottom_sheet.dart';
import 'package:alpha/presentation/pages/auth/share_widgets/auth_bottom_sheet_content.dart';
import 'package:alpha/presentation/pages/auth/share_widgets/auth_header.dart';
import 'package:alpha/presentation/pages/auth/share_widgets/auth_redirect_text.dart';
import 'package:alpha/presentation/view_models/auth/login_view_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final String? emailFromRegister;

  const LoginScreen({super.key, this.emailFromRegister});

  Future<void> _handleLoginPressed(
    BuildContext context,
    LoginViewModel vm,
  ) async {
    await vm.login(context);
    if (!context.mounted) return;
    if (vm.errorMessage != null) {
      context.showErrorSnackBar(vm.errorMessage!);
      vm.clearError();
    }
  }

  Future<void> show2FAVerification(
    BuildContext context,
    LoginViewModel vm, {
    required Function(String code) onSubmit,
  }) async {
    vm.emailFocusNode.unfocus();
    vm.passwordFocusNode.unfocus();
    await Future.delayed(const Duration(milliseconds: 100));
    if (!context.mounted) return;

    await AuthBottomSheetWidget.show(
      context: context,
      child: ChangeNotifierProvider.value(
        value: vm,
        child: Verification2FAWidget(
          autoFocus: true,
          onSubmit: (code) {
            onSubmit(code);
          },
        ),
      ),
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSize.size16),
        ),
      ),
    );
    if (context.mounted) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      viewModelBuilder: () {
        final vm = getIt<LoginViewModel>();
        vm.init(emailFromRegister);
        return vm;
      },
      builder: (context, vm, child) {
        if (vm.needs2FA) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await show2FAVerification(
              context,
              vm,
              onSubmit: (otp) async {
                await vm.login(context, code: otp);
              },
            );
          });
          vm.needs2FA = false;
        }
        if (vm.showResendVerifySheet) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            vm.triggerResendVerifySheet(false);
            await AuthBottomSheetWidget.show(
              context: context,
              child: AuthBottomSheetContent(
                onButtonPressed: () =>
                    vm.verifyEmailUsecase.call(vm.emailController.text),
              ),
              backgroundColor: AppColors.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSize.size16),
                ),
              ),
            );
          });
        }
        return Scaffold(
          body: SizedBox.expand(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: AppSpacing.space20.w,
                    right: AppSpacing.space20.w,
                    top: AppSpacing.space15.h,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: AppSpacing.space15.h),
                        AuthHeader(
                          textAction: context.appLocaleLanguage.backLabel,
                          onTap: () {
                            context.go(RouterPath.home);
                          },
                        ),
                        SizedBox(height: AppSpacing.space25.h),
                        const LoginHeading(),
                        SizedBox(height: AppSpacing.space25.h),
                        const LoginForm(),
                        SizedBox(height: AppSpacing.space15.h),
                        const ForgotPasswordBtn(),
                        SizedBox(height: AppSpacing.space30.h),
                        AppButton(
                          text: context.appLocaleLanguage.loginButton,
                          onPressed: () {
                            if (vm.validateForm()) {
                              _handleLoginPressed(context, vm);
                            }
                          },
                          size: AppButtonSizeEnum.medium,
                        ),
                        SizedBox(height: AppSpacing.space30.h),
                        AuthRedirectText(
                          prefixText:
                              context.appLocaleLanguage.dontHaveAnAccount,
                          actionText: context.appLocaleLanguage.registerButton,
                          onTap: () {
                            context.go(RouterPath.register);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                if (vm.isBusy)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.4),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
