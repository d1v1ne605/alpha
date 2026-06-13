import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class InfoRowWidget extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const InfoRowWidget({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.content2.copyWith(color: AppColors.grey),
        ),
        Text(
          value,
          style: AppTextStyles.content2.copyWith(
            color: valueColor ?? AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
