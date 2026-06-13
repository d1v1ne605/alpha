import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_image.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_size.dart';
import '../../constants/app_spacing.dart';
import '../../utils/enums.dart';
import '../app_button.dart';

class TopSectionView extends StatelessWidget {
  const TopSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.space20.w,
          right: AppSpacing.space20.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AppImage.flatform),
            SizedBox(height: AppSpacing.space14.h),
            Text(
              context.appLocaleLanguage.titleSafe,
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.space8.h),
            Text(
              context.appLocaleLanguage.descriptionSafe,
              style: AppTextStyles.content5.copyWith(color: AppColors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.space14.h),
            AppButton(
              width: AppSize.size320.w,
              text: context.appLocaleLanguage.loginRegister,
              onPressed: () {
                context.go(RouterPath.login);
              },
              size: AppButtonSizeEnum.medium,
            ),
          ],
        ),
      ),
    );
  }
}
