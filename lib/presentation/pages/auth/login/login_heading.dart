import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginHeading extends StatelessWidget {
  const LoginHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Text(
            context.appLocaleLanguage.welcomeLoginPage,
            style: AppTextStyles.title1.copyWith(
              fontSize: AppSize.size22.sp,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.space10.h),
          Text(
            context.appLocaleLanguage.pleaseLogin,
            style: AppTextStyles.subBody.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
