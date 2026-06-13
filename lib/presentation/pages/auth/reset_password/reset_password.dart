import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/core/widgets/app_header.dart';
import 'package:alpha/core/widgets/app_text_field.dart';
import 'package:alpha/presentation/view_models/auth/reset_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return BaseView(
      viewModelBuilder: () => ResetPasswordViewModel(),
      builder: (context, vm, child) => Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              AppHeader(
                textTitle: context.appLocaleLanguage.resetPasswordHeading,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSize.size20.h),
                child: Form(
                  key: vm.formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppSize.size20.h),
                      AppTextField(
                        label: context.appLocaleLanguage.resetPasswordLabel,
                        hintText: context.appLocaleLanguage.resetPasswordHint,
                        controller: vm.passwordController,
                        suffixIcon: IconButton(
                          icon: Icon(
                            vm.obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.iconPrimary,
                          ),
                          onPressed: () {
                            vm.toggleObscurePassword();
                          },
                        ),
                        validator: (value) {
                          return vm.validatePassword(value);
                        },
                        isRequire: true,
                        obscureText: vm.obscurePassword,
                      ),
                      SizedBox(height: AppSize.size15.h),
                      AppTextField(
                        label: context.appLocaleLanguage.resetPasswordLabel,
                        hintText: context.appLocaleLanguage.resetPasswordHint,
                        controller: vm.confirmPasswordController,
                        suffixIcon: IconButton(
                          icon: Icon(
                            vm.obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.iconPrimary,
                          ),
                          onPressed: () {
                            vm.toggleObscureConfirmPassword();
                          },
                        ),
                        validator: (value) {
                          return vm.validateConfirmPassword(
                            value,
                            vm.passwordController.text,
                          );
                        },
                        isRequire: true,
                        obscureText: vm.obscureConfirmPassword,
                      ),

                      SizedBox(height: AppSize.size30.h),
                      AppButton(
                        text: context.appLocaleLanguage.resetPasswordButton,
                        fontWeight: FontWeight.w700,
                        onPressed: () {
                          vm.resetPassword(context);
                        },
                        size: AppButtonSizeEnum.medium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
