import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/pages/auth/register/register_form.dart';
import 'package:alpha/presentation/pages/auth/register/register_heading.dart';
import 'package:alpha/presentation/pages/auth/share_widgets/auth_header.dart';
import 'package:alpha/presentation/pages/auth/share_widgets/auth_redirect_text.dart';
import 'package:alpha/presentation/view_models/auth/register_view_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<RegisterViewModel>(
      viewModelBuilder: () => getIt<RegisterViewModel>(),
      builder: (context, vm, child) => Scaffold(
        body: SizedBox.expand(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: AppSpacing.space20.w,
                  right: AppSpacing.space20.w,
                  top: AppSpacing.space15.h,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: AppSpacing.space15.h),
                    AuthHeader(
                      textAction: context.appLocaleLanguage.backLabel,
                      onTap: () {
                        context.go(RouterPath.home);
                      },
                    ),
                    RegisterHeading(),
                    RegisterForm(),
                    SizedBox(height: AppSpacing.space30.h),
                    AuthRedirectText(
                      prefixText:
                          context.appLocaleLanguage.registerRedirectLabel,
                      actionText:
                          context.appLocaleLanguage.registerRedirectAction,
                      onTap: () {
                        context.go(RouterPath.login);
                      },
                    ),
                  ],
                ),
              ),
              if (vm.isBusy)
                Positioned.fill(
                  child: Container(
                    color: AppColors.background.withOpacity(AppSize.size0_4),
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
      ),
    );
  }
}
