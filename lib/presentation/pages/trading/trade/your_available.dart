import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class YourAvailable extends StatelessWidget {
  const YourAvailable({
    super.key,
    required this.available,
    required this.type,
    required this.quoteUnit,
    required this.coinUnit,
  });

  final String quoteUnit;
  final String coinUnit;

  final double available;
  final OrderTypeEnum type;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.appLocaleLanguage.available,
          style: AppTextStyles.content2.copyWith(color: AppColors.textTertiary),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              FormatterUtils.formatNumber(
                value: available.truncateToDecimalPlaces(6),
                symbol: type == OrderTypeEnum.buy ? quoteUnit : coinUnit,
                decimalDigits: 6,
              ),
              style: AppTextStyles.content2.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: AppSpacing.space3.w),
            SvgPicture.asset(
              AppSvg.addCircleYellowBg,
              width: AppSize.size11.w,
              height: AppSize.size11.h,
            ),
          ],
        ),
      ],
    );
  }
}
