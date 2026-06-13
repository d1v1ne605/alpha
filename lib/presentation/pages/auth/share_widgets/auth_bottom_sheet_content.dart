import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthBottomSheetContent extends StatelessWidget {
  final Function()? onButtonPressed;

  const AuthBottomSheetContent({super.key, this.onButtonPressed});

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
          RichText(
            key: Key(AppStorageKey.btmSheetRichTextKey),
            text: TextSpan(
              children: [
                TextSpan(
                  text: context.appLocaleLanguage.btmSpan1,
                  style: AppTextStyles.content3.copyWith(
                    color: AppColors.textPrimary,
                    height: AppSize.size1_8.h,
                  ),
                ),
                TextSpan(
                  text: context.appLocaleLanguage.btmSpan2,
                  style: AppTextStyles.content3.copyWith(
                    color: AppColors.subtitleText,
                    height: AppSize.size1_8.h,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSize.size30.h),
          AppButton(
            text: context.appLocaleLanguage.btmSheetButton,
            fontWeight: FontWeight.w700,
            onPressed: () {
              onButtonPressed?.call();
            },
            size: AppButtonSizeEnum.medium,
          ),
        ],
      ),
    );
  }
}
