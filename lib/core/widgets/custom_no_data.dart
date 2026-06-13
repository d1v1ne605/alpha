import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_image.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomNoData extends StatelessWidget {
  const CustomNoData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppImage.noData,
            width: AppSize.size100.w,
            height: AppSize.size100.h,
          ),
          SizedBox(height: AppSize.size16.h),
          Text(
            context.appLocaleLanguage.noData,
            style: AppTextStyles.body.copyWith(color: AppColors.textNoData),
          ),
        ],
      ),
    );
  }
}
