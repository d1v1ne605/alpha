import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomItemWidget extends StatelessWidget {
  final dynamic wallet;
  final VoidCallback onTap;
  bool isCheckEarn;

  CustomItemWidget({
    super.key,
    required this.wallet,
    required this.onTap,
    this.isCheckEarn = false,
  });

  @override
  Widget build(BuildContext context) {
    final flexName = isCheckEarn ? 4 : 3;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.transparent,
          borderRadius: BorderRadius.circular(AppSize.size4.r),
          border: Border.all(
            color: AppColors.borderCard,
            width: AppSize.size1.w,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.space10.h,
            horizontal: AppSpacing.space15.h,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: flexName,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: AppSize.size16.r,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: Image.network(
                          wallet.iconUrl,
                          width: AppSize.size32.r,
                          height: AppSize.size32.r,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.space9.w),
                    Expanded(
                      child: Text(
                        !isCheckEarn
                            ? wallet.symbol
                            : wallet.currencyId.toUpperCase(),
                        style: AppTextStyles.content4.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    !isCheckEarn
                        ? Text(
                            context.appLocaleLanguage.spot,
                            style: AppTextStyles.content2.copyWith(
                              color: AppColors.subtitleText,
                            ),
                          )
                        : FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              wallet.balance,
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                    SizedBox(height: AppSpacing.space5.h),
                    !isCheckEarn
                        ? FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              FormatterUtils.formatNumber(
                                value: (wallet.spot as double)
                                    .truncateToDecimalPlaces(wallet.precision),
                                decimalDigits: wallet.precision,
                              ),
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          )
                        : FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "≈${wallet.usdtBalance} ${context.appLocaleLanguage.usd.toUpperCase()}",
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.space8.w),
              !isCheckEarn
                  ? Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.appLocaleLanguage.frozen,
                            style: AppTextStyles.content2.copyWith(
                              color: AppColors.subtitleText,
                            ),
                          ),
                          SizedBox(height: AppSpacing.space5.h),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              FormatterUtils.formatNumber(
                                value: (wallet.frozen as double)
                                    .truncateToDecimalPlaces(wallet.precision),
                                decimalDigits: wallet.precision,
                              ),
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [SizedBox.shrink()],
                      ),
                    ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.iconPrimary,
                size: AppSize.size16.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
