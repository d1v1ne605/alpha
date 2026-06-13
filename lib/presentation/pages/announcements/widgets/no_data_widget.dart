import 'package:alpha/core/constants/app_png.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppPng.nodata,
              width: AppSize.size100.w,
              height: AppSize.size100.h,
            ),

            SizedBox(height: AppSpacing.space15.h),
            Text(
              context.appLocaleLanguage.noData,
              style: AppTextStyles.content2.copyWith(
                color: AppColors.borderInput,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
