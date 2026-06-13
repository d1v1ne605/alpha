import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShareButtonBar extends StatelessWidget {
  final void Function(ShareButtonType type)? onButtonTap;

  const ShareButtonBar({Key? key, this.onButtonTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttons = [
      _shareButton(
        AppSvg.facebook,
        context.appLocaleLanguage.facebook,
        ShareButtonType.facebook,
      ),
      _shareButton(
        AppSvg.telegram,
        context.appLocaleLanguage.telegram,
        ShareButtonType.telegram,
      ),
      _shareButton(AppSvg.x, context.appLocaleLanguage.x, ShareButtonType.x),
      _shareButton(
        AppSvg.qrCode,
        context.appLocaleLanguage.qrCode,
        ShareButtonType.qrCode,
      ),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: buttons,
    );
  }

  Widget _shareButton(String icon, String label, ShareButtonType type) =>
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(AppSpacing.space15.r),
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.space8.r),
          ),
        ),
        onPressed: () => onButtonTap?.call(type),
        child: Column(
          children: [
            SvgPicture.asset(
              icon,
              color: AppColors.tertiary,
              width: AppSize.size24.w,
              height: AppSize.size24.h,
            ),
            Text(
              label,
              style: AppTextStyles.content2.copyWith(
                fontWeight: FontWeight.w300,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      );
}
