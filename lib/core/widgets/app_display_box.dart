import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CodeDisplayBox extends StatelessWidget {
  final String code;
  final VoidCallback? onCopy;
  final TextStyle? textStyle;
  final Color? backgroundColor;

  const CodeDisplayBox({
    Key? key,
    required this.code,
    this.onCopy,
    this.textStyle,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.space15.w,
        vertical: AppSpacing.space12.h,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.space8.w),
        border: Border.all(color: AppColors.borderCard),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              code,
              style:
                  textStyle ??
                  AppTextStyles.content2.copyWith(color: AppColors.textPrimary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: onCopy,
            child: SvgPicture.asset(
              AppSvg.copy,
              width: AppSpacing.space16.w,
              height: AppSpacing.space16.h,
            ),
          ),
        ],
      ),
    );
  }
}
