import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:flutter/material.dart';

class CommissionInfo extends StatelessWidget {
  final String usdPrice;
  final String coinPrice;

  const CommissionInfo({
    Key? key,
    required this.usdPrice,
    required this.coinPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: context.appLocaleLanguage.prefixDollar,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              TextSpan(
                text: context.appLocaleLanguage.volume,
                style: AppTextStyles.body.copyWith(color: AppColors.primary),
              ),
              TextSpan(
                text: coinPrice,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: context.appLocaleLanguage.prefixTilde,
                style: AppTextStyles.content3.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              TextSpan(text: ' '), // khoảng cách
              TextSpan(
                text: usdPrice,
                style: AppTextStyles.content3.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
