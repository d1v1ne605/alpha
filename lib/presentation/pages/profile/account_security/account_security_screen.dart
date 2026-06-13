import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/network/auth_change_notifier.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/base/base_view.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../injection/injector.dart';
import '../../../view_models/profile/profile_view_model.dart';
import '../appbar_screen.dart';
import 'body_account_security_screen.dart';
import 'header_account_security_screen.dart';

class AccountSecurityScreen extends StatelessWidget {
  const AccountSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileViewModel>(
      autoDispose: false,
      padding: false,
      viewModelBuilder: () => getIt<ProfileViewModel>(),
      onModelReady: (vm) => vm.getUser(),
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.space20.w,
                right: AppSpacing.space20.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBarScreen(
                    title: context.appLocaleLanguage.accountSecurity,
                    showNotification: false,
                    showScan: false,
                  ),
                  SizedBox(height: AppSize.size15.h),
                  HeaderAccountSecurityScreen(),
                  SizedBox(height: AppSize.size15.h),
                  Text(
                    context.appLocaleLanguage.accountActivity,
                    style: AppTextStyles.content4.copyWith(
                      color: AppColors.tertiary,
                    ),
                  ),
                  SizedBox(height: AppSize.size15.h),
                  Expanded(child: BodyAccountSecurityScreen()),
                  SizedBox(height: AppSize.size30.h),
                  Consumer<AuthChangeNotifier>(
                    builder: (context, authNotifier, child) {
                      return AppButton(
                        text: context.appLocaleLanguage.logoutButton,
                        fontWeight: FontWeight.w700,
                        height: AppSize.size40.h,
                        onPressed: () {
                          authNotifier.clear();
                          context.go(RouterPath.home);
                        },
                        borderColor: AppColors.primary,
                        backgroundColor: AppColors.transparent,
                        size: AppButtonSizeEnum.small,
                      );
                    },
                  ),
                  SizedBox(height: AppSize.size100.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
