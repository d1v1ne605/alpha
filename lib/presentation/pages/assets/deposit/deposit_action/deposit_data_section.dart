import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DepositDataSection extends StatelessWidget {
  final String minimum;
  final String minimumId;
  final int confirmation;
  final bool isShow;

  DepositDataSection({
    Key? key,
    required this.minimum,
    required this.minimumId,
    required this.confirmation,
    this.isShow = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.space15.h,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.appLocaleLanguage.minimum,
              style: AppTextStyles.content2.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              "${isShow ? '$minimum' : ''}${minimumId.toUpperCase()}",
              style: AppTextStyles.content2.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.appLocaleLanguage.depositArrival,
              style: AppTextStyles.content2.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              "${isShow ? confirmation : ''} ${context.appLocaleLanguage.confirmation}",
              style: AppTextStyles.content2.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
