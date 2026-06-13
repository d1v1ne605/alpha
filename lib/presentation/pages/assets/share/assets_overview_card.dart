import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/data/models/asset/asset_overview.dart';
import 'package:alpha/presentation/view_models/earn/earn_view_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class AssetsOverviewCard<T> extends StatelessWidget {
  final bool showActions;
  final bool isShowAssets;
  final T assetOverview;
  final void Function() showAssets;
  final bool isEarn;

  const AssetsOverviewCard({
    super.key,
    this.showActions = true,
    this.isShowAssets = false,
    required this.showAssets,
    required this.assetOverview,
    this.isEarn = false,
  });

  @override
  Widget build(BuildContext context) {
    final totalAssets = assetOverview is AssetOverview
        ? (assetOverview as AssetOverview).totalAssets
        : assetOverview is EarnViewModel
        ? (assetOverview as EarnViewModel).getEstimatedUsdt()
        : '0.0';

    final unit = assetOverview is AssetOverview
        ? (assetOverview as AssetOverview).unit
        : assetOverview is EarnViewModel
        ? AppStorageKey.usdt
        : '0.0';

    final convertedValue = assetOverview is AssetOverview
        ? (assetOverview as AssetOverview).convertedValue
        : assetOverview is EarnViewModel
        ? (assetOverview as EarnViewModel).getEstimatedUsdt()
        : '0.0';

    return Container(
      width: AppSize.fullSize.w,
      decoration: BoxDecoration(
        color: AppColors.backgroundAssetsCard,
        borderRadius: BorderRadius.circular(AppSize.size4.r),
        border: Border.all(
          color: AppColors.borderCard,
          width: AppSize.size0_3.w,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.space15.w,
              right: AppSpacing.space15.w,
              top: AppSpacing.space0.h,
              bottom: AppSpacing.space10.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          context.appLocaleLanguage.assetsCardTitle,
                          style: AppTextStyles.content2.copyWith(
                            color: AppColors.subtitleText,
                          ),
                        ),
                        IconButton(
                          onPressed: showAssets,
                          icon: !isShowAssets
                              ? Icon(
                                  Icons.visibility_off_outlined,
                                  color: AppColors.iconPrimary,
                                  size: AppSize.size16.w,
                                )
                              : Icon(
                                  Icons.visibility_outlined,
                                  color: AppColors.iconPrimary,
                                  size: AppSize.size16.w,
                                ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        showActions
                            ? context.push(
                                RouterPath.record,
                                extra: RecordType.deposit,
                              )
                            : isEarn
                            ? context.push(
                                RouterPath.transaction,
                                extra: TransactionType.reward,
                              )
                            : context.push(
                                RouterPath.record,
                                extra: RecordType.deposit,
                              );
                      },
                      child: SvgPicture.asset(
                        AppSvg.historyIcon,
                        width: AppSize.size24.w,
                        height: AppSize.size24.h,
                      ),
                    ),
                  ],
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: isShowAssets
                            ? totalAssets.toString()
                            : context.appLocaleLanguage.assetsPlaceHolder *
                                  (totalAssets.toString().length),
                        style: AppTextStyles.title1.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      WidgetSpan(child: SizedBox(width: AppSpacing.space8.w)),
                      TextSpan(
                        text: unit,
                        style: AppTextStyles.title1.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.space8.h),
                Text(
                  isShowAssets
                      ? '${context.appLocaleLanguage.prefixConvert}$convertedValue'
                      : context.appLocaleLanguage.assetsPlaceHolder *
                            (convertedValue.toString().length),
                  style: AppTextStyles.subBody.copyWith(
                    color: AppColors.subtitleText,
                  ),
                ),
              ],
            ),
          ),
          // Actions
          Visibility(
            visible: showActions,
            child: Column(
              children: [
                Divider(
                  color: AppColors.borderCard,
                  thickness: AppSize.size0_3.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.space19.w,
                    vertical: AppSpacing.space13.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppButton(
                        icon: SvgPicture.asset(
                          AppSvg.receiveMoneyIcon,
                          width: AppSize.size24.w,
                          height: AppSize.size24.h,
                        ),
                        text: context.appLocaleLanguage.assetsButtonDeposit,
                        fontWeight: FontWeight.w400,
                        onPressed: () => context.push(RouterPath.deposit),
                        size: AppButtonSizeEnum.small,
                        width: AppSize.size165.w,
                        height: AppSize.size35.h,
                      ),
                      AppButton(
                        icon: SvgPicture.asset(
                          AppSvg.sendMoneyIcon,
                          width: AppSize.size24.w,
                          height: AppSize.size24.h,
                        ),
                        text: context.appLocaleLanguage.assetsButtonWithdraw,
                        fontWeight: FontWeight.w400,
                        onPressed: () => context.push(RouterPath.withdraw),
                        size: AppButtonSizeEnum.small,
                        backgroundColor: AppColors.tertiaryButton,
                        width: AppSize.size165.w,
                        height: AppSize.size35.h,
                      ),
                    ],
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
