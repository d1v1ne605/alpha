import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CoinInfoWidget extends StatelessWidget {
  final String iconPath;
  final String symbol;
  final String name;
  final String date;
  final bool isStarred;
  final VoidCallback? onStarTap;

  const CoinInfoWidget({
    Key? key,
    required this.iconPath,
    required this.symbol,
    required this.name,
    required this.date,
    this.isStarred = false,
    this.onStarTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.network(
              iconPath,
              width: AppSize.size32.w,
              height: AppSize.size32.h,
            ),
            SizedBox(width: AppSize.size10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  symbol,
                  style: AppTextStyles.content4.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  name,
                  style: AppTextStyles.content2.copyWith(
                    color: AppColors.textFourth,
                  ),
                ),
              ],
            ),
            SizedBox(width: AppSize.size10.w),
            InkWell(
              onTap: onStarTap,
              child: SvgPicture.asset(
                isStarred ? AppSvg.star : AppSvg.star_outline,
                width: AppSize.size24.w,
                height: AppSize.size24.h,
                color: isStarred ? AppColors.primary : AppColors.grey,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              context.appLocaleLanguage.releaseDate,
              style: AppTextStyles.content2.copyWith(
                color: AppColors.textFourth,
              ),
            ),
            Text(
              date,
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
      ],
    );
  }
}
