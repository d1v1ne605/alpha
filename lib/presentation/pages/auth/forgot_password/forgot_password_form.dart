import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/core/widgets/app_text_field.dart';
import 'package:alpha/presentation/pages/auth/forgot_password/forgot_password_warning.dart';
import 'package:alpha/presentation/view_models/auth/forgot_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ForgotPasswordViewModel>(
      builder: (context, vm, child) => Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.size20.w),
        child: Form(
          key: vm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSize.size16.h),
              const ForgotPasswordWarning(),
              SizedBox(height: AppSize.size15.h),
              AppTextField(
                label: context.appLocaleLanguage.emailTextFieldLabel,
                hintText: context.appLocaleLanguage.pleaseEnterYourEmail,
                controller: vm.emailController,
                validator: (value) {
                  return vm.validateEmail(value);
                },
                isRequire: true,
              ),
              SizedBox(height: AppSize.size30.h),
              AppButton(
                text: context.appLocaleLanguage.next,
                onPressed: () {
                  vm.handleForgotPasswordPressed(context);
                },
                size: AppButtonSizeEnum.medium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
