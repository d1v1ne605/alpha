import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/stake/stake_record_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StakeRecordItem extends StatefulWidget {
  final StakeRecordModel record;
  const StakeRecordItem({super.key, required this.record});

  @override
  State<StakeRecordItem> createState() => _StakeRecordItemState();
}

class _StakeRecordItemState extends State<StakeRecordItem> {
  @override
  Widget build(BuildContext context) {
    double amount = double.tryParse(widget.record.amount) ?? 0.0;
    double aprValue = double.tryParse(widget.record.aprBase) ?? 0.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.network(
                  widget.record.imgUrl ?? '',
                  width: AppSize.size24.w,
                  height: AppSize.size24.h,
                ),
                SizedBox(width: AppSize.size10.w),
                Text(
                  widget.record.currencyId.toUpperCase(),
                  style: AppTextStyles.content3.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.size15.w,
                vertical: AppSize.size2.h,
              ),
              decoration: BoxDecoration(
                color:
                    widget.record.status.toLowerCase() == AppStorageKey.pending
                    ? AppColors.backgroundMain
                    : AppColors.green_36,
                borderRadius: BorderRadius.circular(AppSize.size4.r),
              ),
              child: Text(
                widget.record.status,
                style: AppTextStyles.content2.copyWith(
                  fontWeight: FontWeight.w500,
                  color:
                      widget.record.status.toLowerCase() ==
                          AppStorageKey.pending
                      ? AppColors.textSecondary
                      : AppColors.green,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSize.size10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.appLocaleLanguage.amount,
                  style: AppTextStyles.content2.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                SizedBox(height: AppSize.size2.h),
                Text(
                  amount
                      .truncateToDecimalPlaces(amount.currentFractionalDigits)
                      .toString(),
                  style: AppTextStyles.content3.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.appLocaleLanguage.apr,
                  style: AppTextStyles.content2.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                SizedBox(height: AppSize.size2.h),
                Text(
                  '${aprValue.truncateToDecimalPlaces(aprValue.currentFractionalDigits).toString()}%',
                  style: AppTextStyles.content3.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.green,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  context.appLocaleLanguage.lockPeriod,
                  style: AppTextStyles.content2.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                SizedBox(height: AppSize.size2.h),
                Text(
                  '${widget.record.lockDays.toString()} ${context.appLocaleLanguage.days}',
                  style: AppTextStyles.content3.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
