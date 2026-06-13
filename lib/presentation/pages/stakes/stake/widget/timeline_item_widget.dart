import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/validate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TimelineItemWidget extends StatelessWidget {
  final String label;
  final DateTime date;

  const TimelineItemWidget({
    super.key,
    required this.label,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.space8.h),
      child: Row(
        children: [
          SvgPicture.asset(AppSvg.circle),
          SizedBox(width: AppSpacing.space10.w),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: AppTextStyles.content2.copyWith(color: AppColors.grey),
                ),
                Text(
                  DateTimeUtils.formatToUTCZeroTime(date),
                  style: AppTextStyles.content3.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
