import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/presentation/pages/trading/chart/two_line_text_column.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class PriceInfoRowWidget extends StatelessWidget {
  final String mainPriceValue;
  final bool isUsdPrice;
  final String labelLeftTop;
  final String labelLeftBottom;
  final String valueRightTop;
  final String valueRightBottom;
  final Color color;
  final double size;

  const PriceInfoRowWidget({
    super.key,
    required this.mainPriceValue,
    required this.labelLeftTop,
    required this.labelLeftBottom,
    required this.valueRightTop,
    required this.valueRightBottom,
    this.isUsdPrice = false,
    this.size = AppSize.size20,
    this.color = AppColors.green,
  });

  @override
  Widget build(BuildContext context) {
    final formattedPrice = isUsdPrice ? '~\$${mainPriceValue}' : mainPriceValue;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: AppSize.size10.toInt(),
          child: Text(
            formattedPrice,
            style: AppTextStyles.title1.copyWith(color: color, fontSize: size),
          ),
        ),
        Expanded(
          flex: AppSize.size13.toInt(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TwoLineTextColumn(
                label: labelLeftTop,
                title: labelLeftBottom,
                alignment: CrossAxisAlignment.start,
              ),
              TwoLineTextColumn(
                color: AppColors.white,
                label: valueRightTop,
                title: valueRightBottom,
                alignment: CrossAxisAlignment.end,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
