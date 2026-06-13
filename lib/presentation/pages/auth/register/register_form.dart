import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/core/widgets/app_text_field.dart';
import 'package:alpha/data/models/auth/register_body_request_model.dart';
import 'package:alpha/presentation/pages/auth/register/password_check.dart';
import 'package:alpha/presentation/view_models/auth/register_view_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  Future<void> _onRegisterPressed(
    BuildContext context,
    RegisterViewModel vm,
  ) async {
    final isValid = await vm.register();
    if (!context.mounted) return;
    if (isValid) {
      context.push(
        RouterPath.chooseLanguage,
        extra: RegisterBodyRequest(
          email: vm.emailController.text.trim(),
          password: vm.passwordController.text.trim(),
          refid: vm.referralController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterViewModel>(
      builder: (context, vm, child) => Form(
        key: vm.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: context.appLocaleLanguage.registerLabelEmail,
              hintText: context.appLocaleLanguage.registerHintEmail,
              controller: vm.emailController,
              validator: (value) {
                return vm.validateEmail(value);
              },
              isRequire: true,
            ),
            const SizedBox(height: AppSize.size15),
            AppTextField(
              label: context.appLocaleLanguage.registerLabelPassword,
              hintText: context.appLocaleLanguage.registerHintPassword,
              controller: vm.passwordController,
              obscureText: vm.obscurePassword,
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
              validator: (value) {
                return vm.validatePassword(value);
              },
              isRequire: true,
            ),
            if (vm.passwordController.text.isNotEmpty)
              Column(
                children: [
                  SizedBox(height: AppSize.size10.h),
                  PasswordStrengthChecker(password: vm.debouncedPassword),
                ],
              ),
            SizedBox(height: AppSize.size15.h),
            AppTextField(
              label: context.appLocaleLanguage.registerLabelConfirmPassword,
              hintText: context.appLocaleLanguage.registerHintConfirmPassword,
              controller: vm.confirmPasswordController,
              obscureText: vm.obscureConfirmPassword,
              suffixIcon: IconButton(
                icon: SvgPicture.asset(
                  vm.obscureConfirmPassword
                      ? AppSvg.obscurePassword
                      : AppSvg.showPassword,
                  color: AppColors.textTertiary,
                  width: AppSize.size18.w,
                  height: AppSize.size18.h,
                ),
                onPressed: vm.toggleObscureConfirmPassword,
              ),
              validator: (value) {
                return vm.validateConfirmPassword(
                  value,
                  vm.passwordController.text,
                );
              },
              isRequire: true,
            ),
            SizedBox(height: AppSize.size15.h),
            AppTextField(
              label: context.appLocaleLanguage.registerLabelReferral,
              hintText: context.appLocaleLanguage.registerHintReferral,
              controller: vm.referralController,
              validator: (value) => null,
              onChanged: (_) => vm.validateForm(),
            ),
            SizedBox(height: AppSize.size30.h),
            AppButton(
              text: context.appLocaleLanguage.next,
              fontWeight: FontWeight.w700,
              onPressed: () => _onRegisterPressed(context, vm),
              size: AppButtonSizeEnum.medium,
            ),
          ],
        ),
      ),
    );
  }
}
