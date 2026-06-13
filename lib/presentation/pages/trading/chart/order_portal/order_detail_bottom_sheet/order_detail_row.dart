import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class OrderDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const OrderDetailRow({
    Key? key,
    required this.label,
    required this.value,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.body.copyWith(
            color: color ?? AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
