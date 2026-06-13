import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoColumn extends StatelessWidget {
  final String title;
  final String value;

  const InfoColumn({Key? key, required this.title, required this.value})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.content2.copyWith(color: AppColors.textTertiary),
        ),
        SizedBox(height: AppSpacing.space4.h),
        Text(
          value,
          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
