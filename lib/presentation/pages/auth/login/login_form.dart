import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_text_field.dart';
import 'package:alpha/presentation/view_models/auth/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, vm, child) {
        return Form(
          key: vm.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                focusNode: vm.emailFocusNode,
                hintText: context.appLocaleLanguage.pleaseEnterYourEmail,
                isRequire: true,
                controller: vm.emailController,
                label: context.appLocaleLanguage.emailTextFieldLabel,
                validator: (value) {
                  return vm.validateEmail(value);
                },
              ),
              SizedBox(height: AppSpacing.space15.h),
              AppTextField(
                focusNode: vm.passwordFocusNode,
                hintText: context.appLocaleLanguage.pleaseEnterYourPassword,
                isRequire: true,
                controller: vm.passwordController,
                label: context.appLocaleLanguage.passwordTextFieldLabel,
                obscureText: vm.obscurePassword,
                validator: (value) {
                  return vm.validatePassword(value);
                },
                suffixIcon: IconButton(
                  icon: SvgPicture.asset(
                    vm.obscurePassword
                        ? AppSvg.obscurePassword
                        : AppSvg.showPassword,
                    color: AppColors.textTertiary,
                    width: AppSize.size18.w,
                    height: AppSize.size18.h,
                  ),
                  onPressed: vm.toggleObscurePassword,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
