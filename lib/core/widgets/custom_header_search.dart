import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../routers/router_name.dart';

class CustomHeaderSearch extends StatelessWidget {
  final Color? backgroundColor;
  final Widget? leftIcon;
  final Widget? btnMoney;
  final Widget? titleWidget;
  final Widget? rightIcon;

  final bool isChecked;

  const CustomHeaderSearch({
    super.key,
    this.backgroundColor,
    this.leftIcon,
    this.titleWidget,
    this.rightIcon,
    this.btnMoney,
    this.isChecked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: AppSpacing.space10.h,
        bottom: AppSpacing.space18.h,
        left: AppSize.size20,
        right: AppSize.size20,
      ),
      color: backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leftIcon != null) ...[
            leftIcon!,
            SizedBox(width: AppSize.size20.w),
          ],
          Expanded(child: titleWidget ?? const SizedBox()),
          if (isChecked) ...[
            SizedBox(width: AppSize.size20.w),
            GestureDetector(
              onTap: () {
                context.push(RouterPath.deposit);
              },
              child: Container(
                padding: EdgeInsets.all(AppSpacing.space10.w),
                height: AppSize.size38.h,
                width: AppSize.size38.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSize.size4.r),
                ),
                child: SvgPicture.asset(
                  AppSvg.money,
                  width: AppSize.size16_67.w,
                  height: AppSize.size18.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
          if (rightIcon != null) ...[
            SizedBox(width: AppSize.size20.w),
            rightIcon!,
          ],
        ],
      ),
    );
  }
}
