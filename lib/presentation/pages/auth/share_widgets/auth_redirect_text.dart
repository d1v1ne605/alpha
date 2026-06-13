import 'package:alpha/core/constants/app_size.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class AuthRedirectText extends StatelessWidget {
  final String prefixText;
  final String actionText;
  final VoidCallback onTap;

  const AuthRedirectText({
    Key? key,
    required this.prefixText,
    required this.actionText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppTextStyles.content4.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: AppSize.size16.sp,
        ),
        children: [
          TextSpan(text: prefixText),
          TextSpan(
            text: ' $actionText',
            style: AppTextStyles.content4.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
              fontSize: AppSize.size16.sp,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
