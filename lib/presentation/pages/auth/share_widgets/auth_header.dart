import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_image.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_storage_key.dart';

class AuthHeader extends StatelessWidget {
  final VoidCallback? onTap;
  final String textAction;
  final double? logoWidth;
  final double? logoHeight;

  const AuthHeader({
    super.key,
    this.onTap,
    this.textAction = AppStorageKey.backLabel,
    this.logoWidth,
    this.logoHeight,
  });

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage(AppImage.logoAlpha), context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Image.asset(
            AppImage.logoAlpha,
            width: (logoWidth?.w ?? AppSize.size115.w),
            height: (logoHeight?.h ?? AppSize.size50.h),
            fit: BoxFit.contain,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onTap,
          child: Text(
            textAction,
            style: AppTextStyles.primaryLabel.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: AppSize.size16.sp,
            ),
          ),
        ),
      ],
    );
  }
}
