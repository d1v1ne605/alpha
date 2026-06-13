import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/presentation/view_models/trading/trade_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class TradingPairSelector extends StatelessWidget {
  final String tradingPair;
  final double? priceChangePercent;
  final Widget? suffixIcon;
  final Function()? onTap;
  final Function()? onTapSuffixIcon;
  final bool isFavorite;

  const TradingPairSelector({
    super.key,
    required this.tradingPair,
    this.priceChangePercent,
    this.onTap,
    this.onTapSuffixIcon,
    this.isFavorite = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              SvgPicture.asset(
                AppSvg.pairSelector,
                width: AppSize.size16.w,
                height: AppSize.size15.h,
              ),
              SizedBox(width: AppSpacing.space12.w),
              Text(
                tradingPair,
                style: AppTextStyles.title2.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(width: AppSpacing.space4.w),
              StreamBuilder(
                stream: context.read<TradeViewModel>().tickerDataStream,
                builder: (context, snapshot) {
                  final tickerData = snapshot.data;
                  final rawPriceChange =
                      tickerData?.priceChangePercent ??
                      priceChangePercent ??
                      0.0;
                  final parsedPriceChange = rawPriceChange is String
                      ? FormatterUtils.parseChangePercent(rawPriceChange)
                      : (rawPriceChange as num).toDouble();
                  final changeColor = parsedPriceChange >= 0.0
                      ? AppColors.changeButton
                      : AppColors.red;
                  final changeText = FormatterUtils.formatSignedPercentage(
                    parsedPriceChange,
                  );
                  return Text(
                    changeText,
                    style: AppTextStyles.caption.copyWith(color: changeColor),
                  );
                },
              ),
            ],
          ),
        ),
        suffixIcon != null
            ? suffixIcon!
            : GestureDetector(
                onTap: onTapSuffixIcon,
                child: SvgPicture.asset(
                  isFavorite ? AppSvg.starChart : AppSvg.starChartOut,
                  width: AppSize.size14.w,
                  height: AppSize.size13.h,
                ),
              ),
      ],
    );
  }
}
