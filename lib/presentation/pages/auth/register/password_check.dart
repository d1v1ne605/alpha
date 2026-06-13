import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/validate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordStrengthChecker extends StatelessWidget {
  final String password;

  const PasswordStrengthChecker({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final hasMinLength = PasswordUtils.hasMinLength(password);
    final hasUpperLower = PasswordUtils.hasUpperAndLowerCase(password);
    final hasNumber = PasswordUtils.hasNumber(password);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.appLocaleLanguage.tooWeak,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.checkPasswordMedium,
            fontSize: AppSize.size14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: AppSize.size4.h),
        _buildCriteria(
          hasMinLength,
          context.appLocaleLanguage.checkLengthPassword,
        ),
        _buildCriteria(
          hasUpperLower,
          context.appLocaleLanguage.checkUpperLowerPassword,
        ),
        _buildCriteria(
          hasNumber,
          context.appLocaleLanguage.checkNumberPassword,
        ),
      ],
    );
  }

  Widget _buildCriteria(bool met, String text) {
    return Row(
      children: [
        Icon(
          met ? Icons.check_outlined : Icons.close_outlined,
          color: met ? AppColors.iconSuccess : AppColors.iconError,
          size: AppSize.size12.sp,
        ),
        SizedBox(width: AppSize.size10.w),
        Text(
          text,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textTertiary,
            fontSize: AppSize.size12.sp,
          ),
        ),
      ],
    );
  }
}
