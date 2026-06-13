import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordBottomSheetContent extends StatelessWidget {
  const ForgotPasswordBottomSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSize.size20.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              context.appLocaleLanguage.btmSheetTitle,
              style: AppTextStyles.content5.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(height: AppSize.size15.h),

          Text(
            context.appLocaleLanguage.btmSheetContent,
            style: AppTextStyles.content3.copyWith(
              color: AppColors.textPrimary,
              height: AppSize.size1_8.h,
            ),
          ),
          SizedBox(height: AppSize.size30.h),
          AppButton(
            text: context.appLocaleLanguage.loginButton,
            fontWeight: FontWeight.w700,
            onPressed: () {
              context.go(RouterPath.login);
            },
            size: AppButtonSizeEnum.medium,
          ),
        ],
      ),
    );
  }
}
