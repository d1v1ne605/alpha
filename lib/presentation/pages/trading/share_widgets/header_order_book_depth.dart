import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderOrderBookDepth extends StatelessWidget {
  const HeaderOrderBookDepth({
    super.key,
    this.titleLeft,
    this.titleRight,
    this.titleColor = AppColors.textTertiary,
  });

  final String? titleLeft;
  final Color titleColor;
  final String? titleRight;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            titleLeft ?? context.appLocaleLanguage.price,
            style: AppTextStyles.content4.copyWith(
              fontSize: AppSize.size11.sp,
              color: titleColor,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        Expanded(
          child: Text(
            titleRight ?? context.appLocaleLanguage.amount,
            style: AppTextStyles.content4.copyWith(
              fontSize: AppSize.size11.sp,
              color: titleColor,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
