import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/data/models/asset/asset_model.dart';
import 'package:alpha/data/models/asset/asset_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllocationSection extends StatelessWidget {
  final AssetModel asset;
  final AssetOverview overview;
  final double? equivalent;

  const AllocationSection({
    super.key,
    required this.asset,
    required this.overview,
    required this.equivalent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          context.appLocaleLanguage.allocation,
          style: AppTextStyles.content4.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: AppSize.size15.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.appLocaleLanguage.walletBalance,
              style: AppTextStyles.content2.copyWith(
                color: AppColors.subtitleText,
              ),
            ),
            Text(
              FormatterUtils.formatNumber(
                value: asset.spot + asset.frozen,
                decimalDigits: asset.spot.currentFractionalDigits,
              ),
              style: AppTextStyles.content2.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSize.size15.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.appLocaleLanguage.availableBalance,
              style: AppTextStyles.content2.copyWith(
                color: AppColors.subtitleText,
              ),
            ),
            Text(
              FormatterUtils.formatNumber(
                value: asset.spot,
                decimalDigits: asset.spot.currentFractionalDigits,
              ),
              style: AppTextStyles.content2.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSize.size15.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.appLocaleLanguage.frozenAmount,
              style: AppTextStyles.content2.copyWith(
                color: AppColors.subtitleText,
              ),
            ),
            Text(
              FormatterUtils.formatNumber(
                value: asset.frozen,
                decimalDigits: asset.frozen.currentFractionalDigits,
              ),
              style: AppTextStyles.content2.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSize.size15.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.appLocaleLanguage.value,
              style: AppTextStyles.content2.copyWith(
                color: AppColors.subtitleText,
              ),
            ),
            Text(
              '${FormatterUtils.formatCompact(equivalent)} ${context.appLocaleLanguage.usd.toUpperCase()}',
              style: AppTextStyles.content2.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
