import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_spacing.dart';

class CustomCardFavorites extends StatelessWidget {
  final String title;
  final double price;
  final double change;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const CustomCardFavorites({
    super.key,
    required this.title,
    required this.price,
    required this.change,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(
          color: isFavorite ? AppColors.primary : AppColors.stock,
          width: AppSize.size1.r,
        ),
        borderRadius: BorderRadius.circular(AppSize.size4.r),
      ),
      padding: const EdgeInsets.all(AppSpacing.space15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: title.split('/')[0],
                  style: AppTextStyles.title2.copyWith(color: AppColors.white),
                ),
                TextSpan(
                  text: '/${title.split('/')[1]}',
                  style: AppTextStyles.title2.copyWith(
                    color: AppColors.textFourth,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSize.size6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    FormatterUtils.formatTokenValue(
                      value: price,
                      locale: LocaleFormatEnum.en,
                    ),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    FormatterUtils.formatSignedPercentage(change),
                    style: AppTextStyles.caption.copyWith(
                      color: change >= 0 ? AppColors.green : AppColors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onFavoriteToggle,
                child: SvgPicture.asset(
                  isFavorite ? AppSvg.star : AppSvg.star_outline,
                  width: AppSize.size24.w,
                  height: AppSize.size24.h,
                  color: isFavorite ? AppColors.primary : AppColors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
