import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_size.dart';

class AccountActivityItem extends StatelessWidget {
  final String deviceName;
  final String dateTime;
  final String ipAddress;
  final String status;

  const AccountActivityItem({
    super.key,
    required this.deviceName,
    required this.dateTime,
    required this.ipAddress,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                deviceName ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.content3.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSize.size3.h),
              Text(
                context.appLocaleLanguage.date,
                style: AppTextStyles.content1.copyWith(
                  color: AppColors.subtitleText,
                ),
              ),
              Text(
                dateTime,
                style: AppTextStyles.content2.copyWith(
                  color: AppColors.tertiary,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.size7.w,
                vertical: AppSize.size2.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.navBottom,
                borderRadius: BorderRadius.circular(AppSize.size4.r),
              ),
              child: Text(
                status,
                style: AppTextStyles.content1.copyWith(
                  color: AppColors.textGreenOnOrderBook,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: AppSize.size5.h),
            Text(
              context.appLocaleLanguage.ipAddress,
              style: AppTextStyles.content1.copyWith(
                color: AppColors.subtitleText,
              ),
            ),
            Text(
              ipAddress,
              style: AppTextStyles.content2.copyWith(color: AppColors.tertiary),
            ),
          ],
        ),
      ],
    );
  }
}
