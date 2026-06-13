import 'package:another_flushbar/flushbar.dart';
import 'package:alpha/core/network/auth_change_notifier.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/presentation/pages/profile/change_pasword/handle_bar.dart';
import 'package:alpha/presentation/pages/profile/change_pasword/password_field_input.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/base/base_view.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_svg.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../injection/injector.dart';
import '../../../view_models/change_password/change_password_view_model.dart';

class ChangePasswordBottomSheet extends StatelessWidget {
  const ChangePasswordBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final bottonPading =
        MediaQuery.of(context).viewInsets.bottom + AppSize.size150.h;
    return BaseView<ChangePasswordViewModel>(
      viewModelBuilder: () => getIt<ChangePasswordViewModel>(),
      builder:
          (BuildContext context, ChangePasswordViewModel vm, Widget? child) {
            return Padding(
              padding: EdgeInsets.only(
                left: AppSize.size20.w,
                right: AppSize.size20.w,
                bottom: bottonPading,
                top: AppSize.size11.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HandleBar(),
                  SizedBox(height: AppSize.size20.h),
                  Center(
                    child: Text(
                      context.appLocaleLanguage.changePassword,
                      style: AppTextStyles.content4.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSize.size30.h),

                  // Old password
                  PasswordFieldInput(
                    controller: vm.oldPasswordController,
                    hintText: context.appLocaleLanguage.oldPassword,
                  ),
                  SizedBox(height: AppSize.size16.h),

                  // New password
                  PasswordFieldInput(
                    controller: vm.newPasswordController,
                    hintText: context.appLocaleLanguage.newPassword,
                    errorText: vm.passwordError,
                  ),
                  SizedBox(height: AppSize.size16.h),

                  // Confirm password
                  PasswordFieldInput(
                    controller: vm.confirmPasswordController,
                    hintText: context.appLocaleLanguage.confirmNewPassword,
                    errorText: vm.passwordError,
                  ),
                  SizedBox(height: AppSize.size30.h),

                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      text: context.appLocaleLanguage.changePassword,
                      fontWeight: FontWeight.w700,
                      borderRadius: AppSize.size8.r,
                      onPressed: vm.isFormValid && !vm.isBusy
                          ? () => executeChangePassword(vm, context)
                          : null,
                      size: AppButtonSizeEnum.medium,
                    ),
                  ),
                ],
              ),
            );
          },
    );
  }

  void executeChangePassword(
    ChangePasswordViewModel vm,
    BuildContext context,
  ) async {
    await vm.changePassword();
    if (vm.successMessage != null) {
      await Flushbar(
        message: context.appLocaleLanguage.resetPasswordLabel,
        icon: SvgPicture.asset(AppSvg.checkCircle),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.green,
        margin: const EdgeInsets.all(AppSize.size16),
        borderRadius: BorderRadius.circular(AppSize.size8.r),
        flushbarPosition: FlushbarPosition.BOTTOM,
      ).show(context);
      context.read<AuthChangeNotifier>().clear();
      context.go(RouterPath.login);
    }
    if (vm.errorMessage != null && vm.errorMessage!.isNotEmpty) {
      await Flushbar(
        message: context.appLocaleLanguage.failedChangePassword,
        icon: Icon(
          Icons.error,
          color: AppColors.background,
          size: AppSize.size28.w,
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.error,
        margin: const EdgeInsets.all(AppSize.size16),
        borderRadius: BorderRadius.circular(AppSize.size8.r),
        flushbarPosition: FlushbarPosition.BOTTOM,
      ).show(context);
    }
  }
}
