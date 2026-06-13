import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/core/widgets/app_bottom_sheet.dart';
import 'package:alpha/data/models/stake/stake_product_model.dart';
import 'package:alpha/presentation/pages/profile/change_pasword/handle_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'widget/info_row_widget.dart';
import 'widget/timeline_item_widget.dart';

Future<void> showStakeSuccessBottomSheet(
  BuildContext context, {
  required StakeProduct stake,
  required double stakedAmount,
  required String estimatedRewardString,
}) async {
  await AppBottomSheetWidget.show(
    context: context,
    isSingleChildScrollView: true,
    minChildSize: AppSize.size0_6,
    maxChildSize: AppSize.size0_9,
    child: _StakeSuccessContent(
      stake: stake,
      stakedAmount: stakedAmount,
      estimatedRewardString: estimatedRewardString,
    ),
  );
}

class _StakeSuccessContent extends StatelessWidget {
  final StakeProduct stake;
  final double stakedAmount;
  final String estimatedRewardString;

  const _StakeSuccessContent({
    required this.stake,
    required this.stakedAmount,
    required this.estimatedRewardString,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.space20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: AppSpacing.space10.h),
          const HandleBar(),
          SizedBox(height: AppSpacing.space18.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(AppSvg.check_green),
              SizedBox(width: AppSpacing.space10.w),
              Text(
                "${context.appLocaleLanguage.successfullyStaked}".toUpperCase(),
                style: AppTextStyles.content5.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.space20.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.space16.w,
              vertical: AppSpacing.space14.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSize.size6.r),
              border: Border.all(color: AppColors.stock),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoRowWidget(
                  label: "${context.appLocaleLanguage.stakedAmount}",
                  value:
                      "${FormatterUtils.formatWithDecimalsNoRound(stakedAmount, 0)} ${stake.currencyId.toUpperCase()}",
                ),
                SizedBox(height: AppSpacing.space14.h),
                InfoRowWidget(
                  label: "${context.appLocaleLanguage.lockPeriod}",
                  value: "${stake.lockDays} ${context.appLocaleLanguage.days}",
                ),
                SizedBox(height: AppSpacing.space14.h),
                InfoRowWidget(
                  label: "${context.appLocaleLanguage.apr}",
                  value: "${stake.aprBase.toStringAsFixed(2)}%",
                  valueColor: AppColors.green,
                ),
                SizedBox(height: AppSpacing.space14.h),
                InfoRowWidget(
                  label: "${context.appLocaleLanguage.estimatedReward}",
                  value:
                      "${estimatedRewardString} ${stake.currencyId.toUpperCase()}",
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.space20.h),
          TimelineItemWidget(
            label: "${context.appLocaleLanguage.stakeDate}",
            date: stake.createdAt,
          ),
          TimelineItemWidget(
            label: "${context.appLocaleLanguage.profitDistribution}",
            date: stake.updatedAt,
          ),
          SizedBox(height: AppSpacing.space30.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.space4.w),
            child: Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: "${context.appLocaleLanguage.viewOrder}",
                    onPressed: () => context.pop(),
                    size: AppButtonSizeEnum.small,
                    backgroundColor: Colors.transparent,
                    borderColor: AppColors.primary,
                    textColor: AppColors.textPrimary,
                  ),
                ),
                SizedBox(width: AppSpacing.space16.w),
                Expanded(
                  child: AppButton(
                    text: "${context.appLocaleLanguage.stakeMore}",
                    onPressed: () => context.pop(),
                    size: AppButtonSizeEnum.small,
                    backgroundColor: AppColors.primary,
                    textColor: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.space12.h),
        ],
      ),
    );
  }
}
