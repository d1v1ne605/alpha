import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordWarning extends StatelessWidget {
  const ForgotPasswordWarning({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSize.size12.r),
      decoration: BoxDecoration(
        color: AppColors.backgroundWarning,
        borderRadius: BorderRadius.circular(AppSize.size4.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_rounded,
            color: AppColors.textWarning,
            size: AppSize.size20.r,
          ),
          SizedBox(width: AppSize.size8.w),
          Expanded(
            child: Text(
              context.appLocaleLanguage.forgotPasswordWarning,
              style: AppTextStyles.content2.copyWith(
                color: AppColors.textWarning,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
