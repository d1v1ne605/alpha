import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/format_usdt.dart';

class LastTradeInfo extends StatelessWidget {
  final String price;
  final String approximatelyPrice;
  final int pricePrecision;
  final Color color;

  const LastTradeInfo({
    super.key,
    required this.pricePrecision,
    required this.price,
    this.color = AppColors.textOnLastTradeInfo,
    required this.approximatelyPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          FormatterUtils.formatTokenValue(value: double.parse(price)),
          style: AppTextStyles.title2.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          '~${FormatterUtils.formatTokenValue(value: double.parse(approximatelyPrice).truncateToDecimalPlaces(pricePrecision))} ${context.appLocaleLanguage.usd.toUpperCase()}',
          style: AppTextStyles.content2.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
