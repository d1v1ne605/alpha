import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/get_data_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TransactionItem extends StatefulWidget {
  final dynamic record;
  final TransactionType type;

  const TransactionItem({super.key, required this.record, required this.type});

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSize.size10.h,
          horizontal: AppSize.size15.w,
        ),
        decoration: BoxDecoration(
          color: AppColors.transparent,
          border: Border.all(
            color: AppColors.borderCard,
            width: AppSize.size1.r,
          ),
          borderRadius: BorderRadius.circular(AppSize.size8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: Image.network(
                        widget.record.iconUrl,
                        width: AppSize.size30.w,
                        height: AppSize.size30.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: AppSize.size10.w),
                    Text(
                      widget.type == TransactionType.reward
                          ? widget
                                .record
                                .currencyId // RewardData
                          : widget.record.coin, // WithdrawRecordData
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                widget.type == TransactionType.withdraw_records
                    ? Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.space7.w,
                              vertical: AppSpacing.space2.h,
                            ),
                            decoration: BoxDecoration(
                              color: RecordHelper.getStatusEarnWithdraw(
                                widget.record,
                                widget.type,
                                context,
                              ).getStatusBgColor(context),
                              borderRadius: BorderRadius.circular(
                                AppSize.size4.r,
                              ),
                            ),
                            child: Text(
                              RecordHelper.getStatusEarnWithdraw(
                                widget.record,
                                widget.type,
                                context,
                              ),
                              style: AppTextStyles.body.copyWith(
                                color: RecordHelper.getStatusEarnWithdraw(
                                  widget.record,
                                  widget.type,
                                  context,
                                ).getStatusColor(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
              ],
            ),
            SizedBox(height: AppSize.size10.h),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    spacing: AppSpacing.space10.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.record.date,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.record.duration,
                        style: AppTextStyles.content2.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    spacing: AppSpacing.space10.h,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.space7.w,
                          vertical: AppSpacing.space2.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSize.size4.r),
                        ),
                        child: Text(
                          "${double.parse(widget.record.amount).toStringAsFixed(8)} ${widget.type == TransactionType.reward ? widget.record.currencyId.toUpperCase() : widget.record.coin.toUpperCase()}",
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        "${context.appLocaleLanguage.prefixTilde}${double.parse(widget.record.usdtAmount).toStringAsFixed(8)} ${context.appLocaleLanguage.usd.toUpperCase()} ",
                        style: AppTextStyles.content2.copyWith(
                          color: AppColors.textFourth,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Visibility(
              visible:
                  widget.type == TransactionType.withdraw_records &&
                  widget.record.status.toLowerCase() == "denied",
              child: Column(
                children: [
                  SizedBox(height: AppSize.size10.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.space10.w,
                    ),
                    height: AppSize.size30.h,
                    decoration: BoxDecoration(
                      color: AppColors.red_40,
                      borderRadius: BorderRadius.circular(AppSize.size4.r),
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            AppSvg.warning,
                            width: AppSize.size16.r,
                            height: AppSize.size16.r,
                          ),
                          SizedBox(width: AppSize.size10.w),
                          Text(
                            context.appLocaleLanguage.insufficientBalance,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
