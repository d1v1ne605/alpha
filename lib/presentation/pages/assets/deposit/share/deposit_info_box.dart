import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DepositInfoBox extends StatelessWidget {
  final Widget prefix;
  final Widget postfix;
  final VoidCallback? onPostfixTap;
  final Color? backgroundColor;
  final Border? border;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const DepositInfoBox({
    Key? key,
    required this.prefix,
    required this.postfix,
    this.onPostfixTap,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          padding ??
          EdgeInsets.symmetric(
            horizontal: AppSpacing.space10.w,
            vertical: AppSpacing.space10.h,
          ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.transparent,
        borderRadius: BorderRadius.circular(borderRadius ?? AppSize.size4.r),
        border:
            border ??
            Border.all(color: AppColors.borderCard, width: AppSize.size0_3.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: prefix),
          GestureDetector(onTap: onPostfixTap, child: postfix),
        ],
      ),
    );
  }
}
