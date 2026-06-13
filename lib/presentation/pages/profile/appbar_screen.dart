import 'package:alpha/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_size.dart';
import '../../../core/constants/app_svg.dart';
import '../../../core/constants/app_text_styles.dart';

class AppBarScreen extends StatelessWidget {
  final String? title;
  final bool showScan;
  final bool showNotification;
  final EdgeInsetsGeometry? padding;
  final bool? showLayer;

  const AppBarScreen({
    Key? key,
    this.title,
    this.showScan = true,
    this.showNotification = true,
    this.padding,
    this.showLayer = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.size56.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              context.pop();
            },
            child: Container(
              padding: EdgeInsets.all(AppSpacing.space8.w),
              color: AppColors.transparent,
              child: SvgPicture.asset(
                AppSvg.back,
                width: AppSize.size16.w,
                height: AppSize.size14.h,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: title != null
                  ? Text(
                      title ?? '',
                      style: AppTextStyles.content5.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.tertiary,
                      ),
                    )
                  : const SizedBox(),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showLayer ?? false)
                GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset(
                    AppSvg.layer,
                    width: AppSize.size24.w,
                    height: AppSize.size24.h,
                  ),
                ),
              if (showNotification)
                GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset(
                    AppSvg.notifi,
                    width: AppSize.size24.w,
                    height: AppSize.size24.h,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
